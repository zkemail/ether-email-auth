#![allow(clippy::upper_case_acronyms)]
#![allow(clippy::identity_op)]

use crate::abis::email_account_recovery::{EmailAuthMsg, EmailProof};
use crate::*;

use ethers::{
    abi::{encode, Token},
    utils::keccak256,
};
use relayer_utils::{extract_substr_idxes, generate_email_circuit_input, EmailCircuitParams, LOG};

const DOMAIN_FIELDS: usize = 9;
const COMMAND_FIELDS: usize = 20;
const EMAIL_ADDR_FIELDS: usize = 9;

pub async fn handle_email(email: String) -> Result<EmailAuthEvent, EmailError> {
    let parsed_email = ParsedEmail::new_from_raw_email(&email).await?;
    trace!(LOG, "email: {}", email);
    let guardian_email_addr = parsed_email.get_from_addr()?;
    let padded_from_addr = PaddedEmailAddr::from_email_addr(&guardian_email_addr);
    trace!(LOG, "From address: {}", guardian_email_addr);
    let email_body = parsed_email.get_cleaned_body()?;

    let request_decomposed_def =
        serde_json::from_str(include_str!("./regex_json/request_def.json"))
            .map_err(|e| EmailError::Parse(e.to_string()))?;
    let request_idxes = extract_substr_idxes(&email, &request_decomposed_def)?;
    if request_idxes.is_empty() {
        return Err(EmailError::Body(WRONG_COMMAND_FORMAT.to_string()));
    }
    info!(LOG, "Request idxes: {:?}", request_idxes);
    let request_id = &email[request_idxes[0].0..request_idxes[0].1];
    let request_id_u32 = request_id
        .parse::<u32>()
        .map_err(|e| anyhow!("Failed to parse request_id to u64: {}", e))?;
    let request_record = DB.get_request(request_id_u32).await?;
    let request = match request_record {
        Some(r) => r,
        None => {
            return Ok(EmailAuthEvent::Error {
                email_addr: guardian_email_addr,
                error: format!("Request {} not found", request_id),
            });
        }
    };
    if request.guardian_email_addr != guardian_email_addr {
        return Err(EmailError::EmailAddress(format!(
            "Guardian email address in the request {} is not equal to the one in the email {}",
            request.guardian_email_addr, guardian_email_addr
        )));
    }
    let account_code_str = DB
        .get_account_code_from_wallet_and_email(&request.account_eth_addr, &guardian_email_addr)
        .await?
        .ok_or(anyhow!(
            "The user of the wallet address {} and the email address {} is not registered.",
            request.account_eth_addr,
            guardian_email_addr
        ))?;
    check_and_update_dkim(
        &email,
        &parsed_email,
        &request.controller_eth_addr,
        &request.account_eth_addr,
        request.account_salt.as_deref().unwrap_or_default(),
    )
    .await?;

    if let Ok(invitation_code) = parsed_email.get_invitation_code(false) {
        if !request.is_for_recovery {
            trace!(LOG, "Email with account code");

            if account_code_str != invitation_code {
                return Err(anyhow!(
                    "Stored account code is not equal to one in the email. Stored: {}, Email: {}",
                    account_code_str,
                    invitation_code
                ));
            }

            let command_template = CLIENT
                .get_acceptance_command_templates(
                    &request.controller_eth_addr,
                    request.template_idx,
                )
                .await?;

            let command_params =
                match extract_template_vals_from_command_template(&email_body, command_template) {
                    Ok(command_params) => command_params,
                    Err(e) => {
                        return Ok(EmailAuthEvent::Error {
                            email_addr: guardian_email_addr,
                            error: format!("Invalid Command, {}", e),
                        });
                    }
                };

            let command_params_encoded: Vec<Bytes> = command_params
                .iter()
                .map(|param| param.abi_encode(None).unwrap())
                .collect();

            let tokens = vec![
                Token::Uint((*EMAIL_ACCOUNT_RECOVERY_VERSION_ID.get().unwrap()).into()),
                Token::String("ACCEPTANCE".to_string()),
                Token::Uint(request.template_idx.into()),
            ];

            let template_id = keccak256(encode(&tokens));

            let circuit_input = generate_email_circuit_input(
                &email,
                &AccountCode::from(hex_to_field(&format!("0x{}", &account_code_str))?),
                Some(EmailCircuitParams {
                    max_header_length: Some(1024),
                    max_body_length: Some(1024),
                    sha_precompute_selector: Some(SHA_PRECOMPUTE_SELECTOR.to_string()),
                    ignore_body_hash_check: Some(false),
                }),
            )
            .await?;

            let (proof, public_signals) =
                generate_proof(&circuit_input, "email_auth", PROVER_ADDRESS.get().unwrap()).await?;

            info!(LOG, "Public signals: {:?}", public_signals);

            let account_salt = u256_to_bytes32(&public_signals[COMMAND_FIELDS + DOMAIN_FIELDS + 3]);
            let is_code_exist = public_signals[COMMAND_FIELDS + DOMAIN_FIELDS + 4] == 1u8.into();
            let masked_command = get_masked_command(public_signals.clone(), DOMAIN_FIELDS + 3)?;

            let email_proof = EmailProof {
                proof: proof,
                domain_name: parsed_email.get_email_domain()?,
                public_key_hash: u256_to_bytes32(&public_signals[DOMAIN_FIELDS + 0]),
                timestamp: u256_to_bytes32(&public_signals[DOMAIN_FIELDS + 2]).into(),
                masked_command,
                email_nullifier: u256_to_bytes32(&public_signals[DOMAIN_FIELDS + 1]),
                account_salt,
                is_code_exist,
            };

            let email_auth_msg = EmailAuthMsg {
                template_id: template_id.into(),
                command_params: command_params_encoded,
                skipped_command_prefix: U256::zero(),
                proof: email_proof.clone(),
            };

            info!(LOG, "Email Auth Msg: {:?}", email_auth_msg);
            info!(LOG, "Request: {:?}", request);

            match CLIENT
                .handle_acceptance(
                    &request.controller_eth_addr,
                    email_auth_msg,
                    request.template_idx,
                )
                .await
            {
                Ok(true) => {
                    let creds = Credentials {
                        account_code: invitation_code,
                        account_eth_addr: request.account_eth_addr.clone(),
                        guardian_email_addr: guardian_email_addr.clone(),
                        is_set: true,
                    };

                    DB.update_credentials_of_account_code(&creds).await?;

                    let updated_request = Request {
                        account_eth_addr: request.account_eth_addr.clone(),
                        controller_eth_addr: request.controller_eth_addr.clone(),
                        guardian_email_addr: guardian_email_addr.clone(),
                        template_idx: request.template_idx,
                        is_for_recovery: request.is_for_recovery,
                        is_processed: true,
                        request_id: request.request_id,
                        is_success: Some(true),
                        email_nullifier: Some(field_to_hex(
                            &bytes32_to_fr(&email_proof.email_nullifier).unwrap(),
                        )),
                        account_salt: Some(bytes32_to_hex(&account_salt)),
                    };

                    DB.update_request(&updated_request).await?;

                    Ok(EmailAuthEvent::AcceptanceSuccess {
                        account_eth_addr: request.account_eth_addr,
                        guardian_email_addr,
                        request_id: request_id_u32,
                    })
                }
                Ok(false) => {
                    let updated_request = Request {
                        account_eth_addr: request.account_eth_addr.clone(),
                        controller_eth_addr: request.controller_eth_addr.clone(),
                        guardian_email_addr: guardian_email_addr.clone(),
                        template_idx: request.template_idx,
                        is_for_recovery: request.is_for_recovery,
                        is_processed: true,
                        request_id: request.request_id,
                        is_success: Some(false),
                        email_nullifier: Some(field_to_hex(
                            &bytes32_to_fr(&email_proof.email_nullifier).unwrap(),
                        )),
                        account_salt: Some(bytes32_to_hex(&account_salt)),
                    };

                    DB.update_request(&updated_request).await?;

                    Ok(EmailAuthEvent::Error {
                        email_addr: guardian_email_addr,
                        error: "Failed to handle acceptance".to_string(),
                    })
                }
                Err(e) => Err(anyhow!("Failed to handle acceptance: {}", e)),
            }
        } else {
            return Ok(EmailAuthEvent::Error {
                email_addr: guardian_email_addr,
                error: "Account code found and for recovery".to_string(),
            });
        }
    } else {
        if request.is_for_recovery {
            let command_template = CLIENT
                .get_recovery_command_templates(&request.controller_eth_addr, request.template_idx)
                .await?;

            let command_params =
                match extract_template_vals_from_command_template(&email_body, command_template) {
                    Ok(command_params) => command_params,
                    Err(e) => {
                        return Ok(EmailAuthEvent::Error {
                            email_addr: guardian_email_addr,
                            error: format!("Invalid Command, {}", e),
                        });
                    }
                };

            let command_params_encoded: Vec<Bytes> = command_params
                .iter()
                .map(|param| param.abi_encode(None).unwrap())
                .collect();

            let tokens = vec![
                Token::Uint((*EMAIL_ACCOUNT_RECOVERY_VERSION_ID.get().unwrap()).into()),
                Token::String("RECOVERY".to_string()),
                Token::Uint(request.template_idx.into()),
            ];

            let template_id = keccak256(encode(&tokens));

            let circuit_input = generate_email_circuit_input(
                &email,
                &AccountCode::from(hex_to_field(&format!("0x{}", &account_code_str))?),
                Some(EmailCircuitParams {
                    max_header_length: Some(1024),
                    max_body_length: Some(1024),
                    sha_precompute_selector: Some(SHA_PRECOMPUTE_SELECTOR.to_string()),
                    ignore_body_hash_check: Some(false),
                }),
            )
            .await?;

            let (proof, public_signals) =
                generate_proof(&circuit_input, "email_auth", PROVER_ADDRESS.get().unwrap()).await?;

            let account_salt = u256_to_bytes32(&public_signals[COMMAND_FIELDS + DOMAIN_FIELDS + 3]);
            let is_code_exist = public_signals[COMMAND_FIELDS + DOMAIN_FIELDS + 4] == 1u8.into();
            let masked_command = get_masked_command(public_signals.clone(), DOMAIN_FIELDS + 3)?;

            let email_proof = EmailProof {
                proof: proof,
                domain_name: parsed_email.get_email_domain()?,
                public_key_hash: u256_to_bytes32(&public_signals[DOMAIN_FIELDS + 0]),
                timestamp: u256_to_bytes32(&public_signals[DOMAIN_FIELDS + 2]).into(),
                masked_command,
                email_nullifier: u256_to_bytes32(&public_signals[DOMAIN_FIELDS + 1]),
                account_salt,
                is_code_exist,
            };

            let email_auth_msg = EmailAuthMsg {
                template_id: template_id.into(),
                command_params: command_params_encoded,
                skipped_command_prefix: U256::zero(),
                proof: email_proof.clone(),
            };

            println!("Email Auth Msg: {:?}", email_auth_msg);

            match CLIENT
                .handle_recovery(
                    &request.controller_eth_addr,
                    email_auth_msg,
                    request.template_idx,
                )
                .await
            {
                Ok(true) => {
                    let updated_request = Request {
                        account_eth_addr: request.account_eth_addr.clone(),
                        controller_eth_addr: request.controller_eth_addr.clone(),
                        guardian_email_addr: guardian_email_addr.clone(),
                        template_idx: request.template_idx,
                        is_for_recovery: request.is_for_recovery,
                        is_processed: true,
                        request_id: request.request_id,
                        is_success: Some(true),
                        email_nullifier: Some(field_to_hex(
                            &bytes32_to_fr(&email_proof.email_nullifier).unwrap(),
                        )),
                        account_salt: Some(bytes32_to_hex(&account_salt)),
                    };

                    DB.update_request(&updated_request).await?;

                    Ok(EmailAuthEvent::RecoverySuccess {
                        account_eth_addr: request.account_eth_addr,
                        guardian_email_addr,
                        request_id: request_id_u32,
                    })
                }
                Ok(false) => {
                    let updated_request = Request {
                        account_eth_addr: request.account_eth_addr.clone(),
                        controller_eth_addr: request.controller_eth_addr.clone(),
                        guardian_email_addr: guardian_email_addr.clone(),
                        template_idx: request.template_idx,
                        is_for_recovery: request.is_for_recovery,
                        is_processed: true,
                        request_id: request.request_id,
                        is_success: Some(false),
                        email_nullifier: Some(field_to_hex(
                            &bytes32_to_fr(&email_proof.email_nullifier).unwrap(),
                        )),
                        account_salt: Some(bytes32_to_hex(&account_salt)),
                    };

                    DB.update_request(&updated_request).await?;

                    Ok(EmailAuthEvent::Error {
                        email_addr: guardian_email_addr,
                        error: "Failed to handle recovery".to_string(),
                    })
                }
                Err(e) => Err(anyhow!("Failed to handle recovery: {}", e)),
            }
        } else {
            return Ok(EmailAuthEvent::Error {
                email_addr: guardian_email_addr,
                error: "No account code found and not for recovery".to_string(),
            });
        }
    }
}

pub fn get_masked_command(public_signals: Vec<U256>, start_idx: usize) -> Result<String> {
    // Gather signals from start_idx to start_idx + COMMAND_FIELDS
    let mut command_bytes = Vec::new();
    for i in start_idx..start_idx + COMMAND_FIELDS {
#[named]
async fn get_verified_request(
    email: &String,
    guardian_email_addr: String,
) -> Result<(Option<Request>, String), EmailError> {
    let request_decomposed_def =
        serde_json::from_str(include_str!("./regex_json/request_def.json"))
            .map_err(|e| EmailError::Parse(format!("Failed to parse request_def.json: {}", e)))?;
    println!("request_decomposed_def: {:?}", request_decomposed_def);
    let request_idxes = extract_substr_idxes(email, &request_decomposed_def)?;
    println!("request_idxes: {:?}", request_idxes);
    if request_idxes.is_empty() {
        return Err(EmailError::Subject(WRONG_SUBJECT_FORMAT.to_string()));
    }
    info!(LOG, "Request idxes: {:?}", request_idxes; "func" => function_name!());
    let request_id = &email[request_idxes[0].0..request_idxes[0].1];
    println!("request_id: {:?}", request_id);
    let request_id_u32 = request_id
        .parse::<u32>()
        .map_err(|e| EmailError::Parse(format!("Failed to parse request_id to u64: {}", e)))?;
    println!("request_id_u32: {:?}", request_id_u32);
    let request_record = DB.get_request(request_id_u32).await?;
    println!("request_record: {:?}", request_record);
    let request = match request_record {
        Some(req) => req,
        None => return Ok((None, request_id.to_string())),
    let invitation_code = match parsed_email.get_invitation_code(false) {
        Ok(code) => Some(code),
        Err(_) => None,
    };

    let params = EmailRequestContext {
        request,
        email_body,
        account_code_str,
        email,
        parsed_email,
    };

    handle_email_request(params, invitation_code).await
}

async fn handle_email_request(
    params: EmailRequestContext,
    invitation_code: Option<String>,
) -> Result<EmailAuthEvent, EmailError> {
    match (invitation_code, params.request.is_for_recovery) {
        (Some(invitation_code), is_for_recovery) if !is_for_recovery => {
            if params.account_code_str != invitation_code {
                return Err(EmailError::Body(format!(
                    "Stored account code is not equal to one in the email. Stored: {}, Email: {}",
                    params.account_code_str, invitation_code
                )));
            };
            trace!(LOG, "Email with account code");
            accept(params, invitation_code).await
        }
        (None, is_for_recovery) if is_for_recovery => recover(params).await,
        (Some(_), _) => Ok(EmailAuthEvent::Error {
            email_addr: params.request.guardian_email_addr,
            error: "Account code found and for recovery".to_string(),
        }),
        (None, _) => Ok(EmailAuthEvent::Error {
            email_addr: params.request.guardian_email_addr,
            error: "No account code found and not for recovery".to_string(),
        }),
    }
}

async fn accept(
    params: EmailRequestContext,
    invitation_code: String,
) -> Result<EmailAuthEvent, EmailError> {
    let (email_auth_msg, email_proof, account_salt) = get_email_auth_msg(&params).await?;

    info!(LOG, "Email Auth Msg: {:?}", email_auth_msg);
    info!(LOG, "Request: {:?}", params.request);

    let is_accepted = CLIENT
        .handle_acceptance(
            &params.request.controller_eth_addr,
            email_auth_msg,
            params.request.template_idx,
        )
        .await?;

    update_request(
        &params,
        is_accepted,
        email_proof.email_nullifier,
        account_salt,
    )
    .await?;

    if is_accepted {
        let creds = Credentials {
            account_code: invitation_code,
            account_eth_addr: params.request.account_eth_addr.clone(),
            guardian_email_addr: params.request.guardian_email_addr.clone(),
            is_set: true,
        };
        DB.update_credentials_of_account_code(&creds).await?;

        Ok(EmailAuthEvent::AcceptanceSuccess {
            account_eth_addr: params.request.account_eth_addr,
            guardian_email_addr: params.request.guardian_email_addr,
            request_id: params.request.request_id,
        })
    } else {
        Ok(EmailAuthEvent::Error {
            email_addr: params.request.guardian_email_addr,
            error: "Failed to handle acceptance".to_string(),
        })
    }
}

async fn recover(params: EmailRequestContext) -> Result<EmailAuthEvent, EmailError> {
    let (email_auth_msg, email_proof, account_salt) = get_email_auth_msg(&params).await?;

    info!(LOG, "Email Auth Msg: {:?}", email_auth_msg);
    info!(LOG, "Request: {:?}", params.request);

    let is_success = CLIENT
        .handle_recovery(
            &params.request.controller_eth_addr,
            email_auth_msg,
            params.request.template_idx,
        )
        .await?;

    update_request(
        &params,
        is_success,
        email_proof.email_nullifier,
        account_salt,
    )
    .await?;

    if is_success {
        Ok(EmailAuthEvent::RecoverySuccess {
            account_eth_addr: params.request.account_eth_addr,
            guardian_email_addr: params.request.guardian_email_addr,
            request_id: params.request.request_id,
        })
    } else {
        Ok(EmailAuthEvent::Error {
            email_addr: params.request.guardian_email_addr,
            error: "Failed to handle recovery".to_string(),
        })
    }
}

fn get_masked_command(public_signals: Vec<U256>, start_idx: usize) -> Result<String> {
    // Gather signals from start_idx to start_idx + COMMAND_FIELDS
    let mut command_bytes = Vec::new();
    for i in start_idx..start_idx + COMMAND_FIELDS {
        let signal = public_signals[i as usize];
        if signal == U256::zero() {
            break;
        }
        let bytes = u256_to_bytes32_little(&signal);
        command_bytes.extend_from_slice(&bytes);
    }

    // Bytes to string, removing null bytes
    let command = String::from_utf8(command_bytes.into_iter().filter(|&b| b != 0u8).collect())
        .map_err(|e| anyhow!("Failed to convert bytes to string: {}", e))?;

    Ok(command)
}

async fn update_request(
    params: &EmailRequestContext,
    is_success: bool,
    email_nullifier: [u8; 32],
    account_salt: [u8; 32],
) -> Result<(), EmailError> {
    let updated_request = Request {
        account_eth_addr: params.request.account_eth_addr.clone(),
        controller_eth_addr: params.request.controller_eth_addr.clone(),
        guardian_email_addr: params.request.guardian_email_addr.clone(),
        template_idx: params.request.template_idx,
        is_for_recovery: params.request.is_for_recovery,
        is_processed: true,
        request_id: params.request.request_id,
        is_success: Some(is_success),
        email_nullifier: Some(field_to_hex(&bytes32_to_fr(&email_nullifier)?)),
        account_salt: Some(bytes32_to_hex(&account_salt)),
    };
    println!("updated_request: {:?}", updated_request);

    let update_request_result = DB.update_request(&updated_request).await?;
    println!("update_request_result: {:?}", update_request_result);
    Ok(())
}

async fn generate_email_proof(
    params: &EmailRequestContext,
) -> Result<(EmailProof, [u8; 32]), EmailError> {
    let circuit_input = generate_email_circuit_input(
        &params.email,
        &AccountCode::from(hex_to_field(&format!("0x{}", &params.account_code_str))?),
        Some(EmailCircuitParams {
            max_header_length: Some(1024),
            max_body_length: Some(1024),
            sha_precompute_selector: Some(SHA_PRECOMPUTE_SELECTOR.to_string()),
            ignore_body_hash_check: Some(false),
        }),
    )
    .await?;

    let (proof, public_signals) =
        generate_proof(&circuit_input, "email_auth", PROVER_ADDRESS.get().unwrap()).await?;

    info!(LOG, "Public signals: {:?}", public_signals);

    let account_salt = u256_to_bytes32(&public_signals[COMMAND_FIELDS + DOMAIN_FIELDS + 3]);
    let is_code_exist = public_signals[COMMAND_FIELDS + DOMAIN_FIELDS + 4] == 1u8.into();
    let masked_command = get_masked_command(public_signals.clone(), DOMAIN_FIELDS + 3)?;

    let email_proof = EmailProof {
        proof,
        domain_name: params.parsed_email.get_email_domain()?,
        public_key_hash: u256_to_bytes32(&public_signals[DOMAIN_FIELDS + 0]),
        timestamp: u256_to_bytes32(&public_signals[DOMAIN_FIELDS + 2]).into(),
        masked_command,
        email_nullifier: u256_to_bytes32(&public_signals[DOMAIN_FIELDS + 1]),
        account_salt,
        is_code_exist,
    };

    Ok((email_proof, account_salt))
}

fn get_template_id(params: &EmailRequestContext) -> [u8; 32] {
    let action = if params.request.is_for_recovery {
        "RECOVERY".to_string()
    } else {
        "ACCEPTANCE".to_string()
    };

    let tokens = vec![
        Token::Uint((*EMAIL_ACCOUNT_RECOVERY_VERSION_ID.get().unwrap()).into()),
        // TODO: Continue here
        Token::String(action),
        Token::Uint(params.request.template_idx.into()),
    ];

    let template_id = keccak256(encode(&tokens));
    template_id
}

async fn get_encoded_command_params(
    params: &EmailRequestContext,
) -> Result<Vec<Bytes>, EmailError> {
    let command_template = if params.request.is_for_recovery {
        CLIENT
            .get_recovery_command_templates(
                &params.request.controller_eth_addr,
                params.request.template_idx,
            )
            .await?
    } else {
        CLIENT
            .get_acceptance_command_templates(
                &params.request.controller_eth_addr,
                params.request.template_idx,
            )
            .await?
    };

    let command_params =
        extract_template_vals_from_command_template(&params.email_body, command_template)
            .map_err(|e| EmailError::Body(format!("Invalid commad: {}", e)))?;

    // let command_params_encoded: Vec<Bytes> = command_params
    //     .iter()
    //     .map(|param| param.abi_encode(None).unwrap())
    //     .collect();

    let command_params_encoded = command_params
        .iter()
        .map(|param| {
            param
                .abi_encode(None)
                .map_err(|e| EmailError::AbiError(e.to_string()))
        })
        .collect::<Result<Vec<Bytes>, EmailError>>()?;

    Ok(command_params_encoded)
}

async fn get_email_auth_msg(
    params: &EmailRequestContext,
) -> Result<(EmailAuthMsg, EmailProof, [u8; 32]), EmailError> {
    let command_params_encoded = get_encoded_command_params(params).await?;
    let template_id = get_template_id(params);
    let (email_proof, account_salt) = generate_email_proof(params).await?;
    let email_auth_msg = EmailAuthMsg {
        template_id: template_id.into(),
        command_params: command_params_encoded,
        proof: email_proof.clone(),
    };
    Ok((email_auth_msg, email_proof, account_salt))
}

#[derive(Debug, Clone)]
struct EmailRequestContext {
    request: Request,
    email_body: String,
    account_code_str: String,
    email: String,
    parsed_email: ParsedEmail,
}
