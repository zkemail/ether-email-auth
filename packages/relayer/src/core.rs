#![allow(clippy::upper_case_acronyms)]
#![allow(clippy::identity_op)]

use crate::*;

use ethers::utils::keccak256;
use relayer_utils::*;

const DOMAIN_FIELDS: usize = 9;
const SUBJECT_FIELDS: usize = 20;
const EMAIL_ADDR_FIELDS: usize = 9;

#[named]
pub async fn handle_email<P: EmailsPool>(
    email: String,
    db: Arc<Database>,
    chain_client: Arc<ChainClient>,
    emails_pool: P,
) -> Result<EmailAuthEvent> {
    let parsed_email = ParsedEmail::new_from_raw_email(&email).await?;
    trace!(LOG, "email: {}", email; "func" => function_name!());
    let guardian_email_addr = parsed_email.get_from_addr()?;
    let padded_from_addr = PaddedEmailAddr::from_email_addr(&guardian_email_addr);
    trace!(LOG, "From address: {}", guardian_email_addr; "func" => function_name!());
    let subject = parsed_email.get_subject_all()?;
    
    let account_key_str = db
        .get_invitation_code_from_email_addr(&guardian_email_addr)
        .await?
        .ok_or(anyhow!(
            "The user of email address {} is not registered.",
            guardian_email_addr
        ))?;
    let account_key = AccountKey(hex2field(&format!("0x{}", account_key_str))?);
    let wallet_salt = WalletSalt::new(&padded_from_addr, account_key)?;

    let request_decomposed_def =
        serde_json::from_str(include_str!("./regex_json/request_def.json"))?;
    let request_idxes = extract_substr_idxes(&email, &request_decomposed_def)?;
    if request_idxes.is_empty() {
        bail!(WRONG_SUBJECT_FORMAT);
    }
    info!(LOG, "Request idxes: {:?}", request_idxes; "func" => function_name!());
    let request_id = &email[request_idxes[0].0..request_idxes[0].1];
    let request_id_u64 = request_id
        .parse::<u64>()
        .map_err(|e| anyhow!("Failed to parse request_id to u64: {}", e))?;
    let request_record = db.get_request(request_id_u64).await?;
    if request_record.is_none() {
        return Ok(EmailAuthEvent::Error {
            email_addr: guardian_email_addr,
            error: format!("Request {} not found", request_id),
        });
    }
    let request = request_record.unwrap();
    check_and_update_dkim(&email, &parsed_email, &chain_client, &request.wallet_eth_addr).await?;
    let subject_template = chain_client
        .get_acceptance_subject_templates(&request.wallet_eth_addr, request.template_idx)
        .await?;

    let result = extract_template_vals_and_skipped_subject_idx(&subject, subject_template);
    let (subject_params, skipped_subject_prefix) = match result {
        Ok((subject_params, skipped_subject_prefix)) => (subject_params, skipped_subject_prefix),
        Err(_) => {
            return Ok(EmailAuthEvent::Error {
                email_addr: guardian_email_addr,
                error: format!("Invalid Subject"),
            });
        }
    };
    let subject_params_encoded: Vec<Bytes> = subject_params
        .iter()
        .map(|param| param.abi_encode(None).unwrap())
        .collect();

    if let Ok(invitation_code) = parsed_email.get_invitation_code() {
        trace!(LOG, "Email with account code"; "func" => function_name!());
        let account_key = AccountKey::from(hex2field(&format!("0x{}", invitation_code))?);
        let stored_account_key = db
            .get_invitation_code_from_email_addr(&guardian_email_addr)
            .await?;
        if let Some(stored_account_key) = stored_account_key.as_ref() {
            if stored_account_key != &field2hex(&account_key.0) {
                return Err(anyhow!(
                    "Stored account key is not equal to one in the email: {} != {}",
                    stored_account_key,
                    field2hex(&account_key.0)
                ));
            }
        }
        if !request.is_for_recovery {
            let template_id = keccak256(
                &[
                    EMAIL_ACCOUNT_RECOVERY_VERSION_ID.as_bytes(),
                    b"ACCEPTANCE",
                    request.template_idx.to_string().as_bytes(),
                ]
                .concat(),
            );

            let circuit_input = generate_email_auth_input(&email, &invitation_code).await?;

            let (proof, public_signals) =
                generate_proof(&circuit_input, "email_auth", PROVER_ADDRESS.get().unwrap()).await?;

            let is_code_exist = public_signals[SUBJECT_FIELDS + DOMAIN_FIELDS + 4] == 1u8.into();
            let (masked_subject, num_recipient_email_addr_bytes) = get_masked_subject(&subject)?;

            let email_proof = EmailProof {
                proof: proof,
                domain_name: parsed_email.get_email_domain()?,
                public_key_hash: u256_to_bytes32(&public_signals[DOMAIN_FIELDS + 0]),
                timestamp: u256_to_bytes32(&public_signals[DOMAIN_FIELDS + 2]).into(),
                masked_subject,
                email_nullifier: u256_to_bytes32(&public_signals[DOMAIN_FIELDS + 1]),
                account_salt: fr_to_bytes32(&wallet_salt.0)?,
                is_code_exist,
            };

            let email_auth_msg = EmailAuthMsg {
                template_id: template_id.into(),
                subject_params: subject_params_encoded,
                skiped_subject_prefix: skipped_subject_prefix.into(),
                proof: email_proof.clone(),
            };

            match chain_client
                .handle_acceptance(
                    &request.wallet_eth_addr,
                    email_auth_msg,
                    request.template_idx,
                )
                .await
            {
                Ok(true) => {
                    let creds = Credentials {
                        account_code: invitation_code,
                        wallet_eth_addr: request.wallet_eth_addr.clone(),
                        guardian_email_addr: guardian_email_addr.clone(),
                        is_set: true,
                    };

                    db.update_credentials(&creds).await?;

                    let updated_request = Request {
                        wallet_eth_addr: request.wallet_eth_addr.clone(),
                        guardian_email_addr: guardian_email_addr.clone(),
                        template_idx: request.template_idx,
                        is_for_recovery: request.is_for_recovery,
                        is_processed: true,
                        request_id: request.request_id,
                        is_success: Some(true),
                        email_nullifier: Some(field2hex(
                            &bytes32_to_fr(&email_proof.email_nullifier).unwrap(),
                        )),
                        account_salt: Some(field2hex(&wallet_salt.0)),
                    };

                    db.update_request(&updated_request).await?;

                    Ok(EmailAuthEvent::AcceptanceSuccess {
                        wallet_eth_addr: request.wallet_eth_addr,
                        guardian_email_addr,
                        request_id: request_id_u64,
                    })
                }
                Ok(false) => {
                    let updated_request = Request {
                        wallet_eth_addr: request.wallet_eth_addr.clone(),
                        guardian_email_addr: guardian_email_addr.clone(),
                        template_idx: request.template_idx,
                        is_for_recovery: request.is_for_recovery,
                        is_processed: true,
                        request_id: request.request_id,
                        is_success: Some(false),
                        email_nullifier: Some(field2hex(
                            &bytes32_to_fr(&email_proof.email_nullifier).unwrap(),
                        )),
                        account_salt: Some(field2hex(&wallet_salt.0)),
                    };

                    db.update_request(&updated_request).await?;

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
                error: "Request is for recovery".to_string(),
            });
        }
    } else {
        if request.is_for_recovery {
            let template_id = keccak256(
                &[
                    EMAIL_ACCOUNT_RECOVERY_VERSION_ID.as_bytes(),
                    b"RECOVERY",
                    request.template_idx.to_string().as_bytes(),
                ]
                .concat(),
            );

            let circuit_input = generate_email_auth_input(&email, &account_key_str).await?;

            let (proof, public_signals) =
                generate_proof(&circuit_input, "email_auth", PROVER_ADDRESS.get().unwrap()).await?;

            let is_code_exist = public_signals[SUBJECT_FIELDS + DOMAIN_FIELDS + 4] == 1u8.into();
            let (masked_subject, num_recipient_email_addr_bytes) = get_masked_subject(&subject)?;

            let email_proof = EmailProof {
                proof: proof,
                domain_name: parsed_email.get_email_domain()?,
                public_key_hash: u256_to_bytes32(&public_signals[DOMAIN_FIELDS + 0]),
                timestamp: u256_to_bytes32(&public_signals[DOMAIN_FIELDS + 2]).into(),
                masked_subject,
                email_nullifier: u256_to_bytes32(&public_signals[DOMAIN_FIELDS + 1]),
                account_salt: fr_to_bytes32(&wallet_salt.0)?,
                is_code_exist,
            };

            let email_auth_msg = EmailAuthMsg {
                template_id: template_id.into(),
                subject_params: subject_params_encoded,
                skiped_subject_prefix: skipped_subject_prefix.into(),
                proof: email_proof.clone(),
            };

            match chain_client
                .handle_recovery(
                    &request.wallet_eth_addr,
                    email_auth_msg,
                    request.template_idx,
                )
                .await
            {
                Ok(true) => {
                    let updated_request = Request {
                        wallet_eth_addr: request.wallet_eth_addr.clone(),
                        guardian_email_addr: guardian_email_addr.clone(),
                        template_idx: request.template_idx,
                        is_for_recovery: request.is_for_recovery,
                        is_processed: true,
                        request_id: request.request_id,
                        is_success: Some(true),
                        email_nullifier: Some(field2hex(
                            &bytes32_to_fr(&email_proof.email_nullifier).unwrap(),
                        )),
                        account_salt: Some(field2hex(&wallet_salt.0)),
                    };

                    db.update_request(&updated_request).await?;

                    Ok(EmailAuthEvent::RecoverySuccess {
                        wallet_eth_addr: request.wallet_eth_addr,
                        guardian_email_addr,
                        request_id: request_id_u64,
                    })
                }
                Ok(false) => {
                    let updated_request = Request {
                        wallet_eth_addr: request.wallet_eth_addr.clone(),
                        guardian_email_addr: guardian_email_addr.clone(),
                        template_idx: request.template_idx,
                        is_for_recovery: request.is_for_recovery,
                        is_processed: true,
                        request_id: request.request_id,
                        is_success: Some(false),
                        email_nullifier: Some(field2hex(
                            &bytes32_to_fr(&email_proof.email_nullifier).unwrap(),
                        )),
                        account_salt: Some(field2hex(&wallet_salt.0)),
                    };

                    db.update_request(&updated_request).await?;

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
                error: "No account code found".to_string(),
            });
        }
    }
}

#[named]
pub fn get_masked_subject(subject: &str) -> Result<(String, usize)> {
    match extract_email_addr_idxes(subject) {
        Ok(extracts) => {
            if extracts.len() != 1 {
                return Err(anyhow!(
                    "Recipient address in the subject must appear only once."
                ));
            }
            let (start, end) = extracts[0];
            info!(LOG, "start: {}, end: {}", start, end; "func" => function_name!());
            if end == subject.len() {
                Ok((subject[0..start].to_string(), 0))
            } else {
                let mut masked_subject_bytes = subject.as_bytes().to_vec();
                masked_subject_bytes[start..end].copy_from_slice(vec![0u8; end - start].as_ref());
                Ok((String::from_utf8(masked_subject_bytes)?, end - start))
            }
        }
        Err(err) => {
            info!(LOG, "Recipient address not found in the subject: {}", err; "func" => function_name!());
            Ok((subject.to_string(), 0))
        }
    }
}
