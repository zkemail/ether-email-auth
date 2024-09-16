use crate::*;
use anyhow::Result;
use axum::Json;
use hex::decode;
use rand::Rng;
use relayer_utils::LOG;
use serde::{Deserialize, Serialize};
use std::str;

// Create request status API
pub async fn request_status_api(
    Json(payload): Json<RequestStatusRequest>,
) -> Result<Json<RequestStatusResponse>, ApiError> {
    println!("requesting status");
    let row = DB.get_request(payload.request_id).await?;
    let status = if let Some(ref row) = row {
        if row.is_processed {
            RequestStatus::Processed
        } else {
            RequestStatus::Pending
        }
    } else {
        RequestStatus::NotExist
    };
    Ok(Json(RequestStatusResponse {
        request_id: payload.request_id,
        status,
        is_success: row
            .as_ref()
            .map_or(false, |r| r.is_success.unwrap_or(false)),
        email_nullifier: row.clone().and_then(|r| r.email_nullifier),
        account_salt: row.clone().and_then(|r| r.account_salt),
    }))
}

pub async fn handle_acceptance_request(
    Json(payload): Json<AcceptanceRequest>,
) -> Result<Json<AcceptanceResponse>, ApiError> {
    println!("handle_acceptance_request");
    let command_template = CLIENT
        .get_acceptance_command_templates(&payload.controller_eth_addr, payload.template_idx)
        .await?;

    let command_params = extract_template_vals(&payload.command, command_template)
        .map_err(|_| ApiError::Validation("Invalid command".to_string()))?;

    let account_eth_addr = CLIENT
        .get_recovered_account_from_acceptance_command(
            &payload.controller_eth_addr,
            command_params.clone(),
            payload.template_idx,
        )
        .await?;

    let account_eth_addr = format!("0x{:x}", account_eth_addr);

    if !CLIENT.is_wallet_deployed(&account_eth_addr).await? {
        return Err(ApiError::Validation("Wallet not deployed".to_string()));
    }

    // Check if hash of bytecode of proxy contract is equal or not
    let bytecode = CLIENT.get_bytecode(&account_eth_addr).await?;
    let bytecode_hash = format!("0x{}", hex::encode(keccak256(bytecode.as_ref())));

    // let permitted_wallets: Vec<PermittedWallet> =
    //     serde_json::from_str(include_str!("../../permitted_wallets.json")).unwrap();
    // let permitted_wallet = permitted_wallets
    //     .iter()
    //     .find(|w| w.hash_of_bytecode_of_proxy == bytecode_hash);

    // if let Some(permitted_wallet) = permitted_wallet {
    //     let slot_location = permitted_wallet.slot_location.parse::<u64>().unwrap();
    //     let impl_contract_from_proxy = {
    //         let raw_hex = hex::encode(
    //             CLIENT
    //                 .get_storage_at(&account_eth_addr, slot_location)
    //                 .await
    //                 .unwrap(),
    //         );
    //         format!("0x{}", &raw_hex[24..])
    //     };

    //     if !permitted_wallet
    //         .impl_contract_address
    //         .eq_ignore_ascii_case(&impl_contract_from_proxy)
    //     {
    //         return Response::builder()
    //             .status(StatusCode::BAD_REQUEST)
    //             .body(Body::from(
    //                 "Invalid bytecode, impl contract address mismatch",
    //             ))
    //             .unwrap();
    //     }

    //     if !permitted_wallet
    //         .controller_eth_addr
    //         .eq_ignore_ascii_case(&payload.controller_eth_addr)
    //     {
    //         return Response::builder()
    //             .status(StatusCode::BAD_REQUEST)
    //             .body(Body::from("Invalid controller eth addr"))
    //             .unwrap();
    //     }
    // } else {
    //     return Response::builder()
    //         .status(StatusCode::BAD_REQUEST)
    //         .body(Body::from("Wallet not permitted"))
    //         .unwrap();
    // }

    if let Ok(Some(creds)) = DB.get_credentials(&payload.account_code).await {
        return Err(ApiError::Validation(
            "Account code already used".to_string(),
        ));
    }

    let mut request_id = rand::thread_rng().gen::<u32>();
    while let Ok(Some(request)) = DB.get_request(request_id).await {
        request_id = rand::thread_rng().gen::<u32>();
    }

    let account_salt = calculate_account_salt(&payload.guardian_email_addr, &payload.account_code);

    DB.insert_request(&Request {
        request_id,
        account_eth_addr: account_eth_addr.clone(),
        controller_eth_addr: payload.controller_eth_addr.clone(),
        guardian_email_addr: payload.guardian_email_addr.clone(),
        is_for_recovery: false,
        template_idx: payload.template_idx,
        is_processed: false,
        is_success: None,
        email_nullifier: None,
        account_salt: Some(account_salt.clone()),
    })
    .await?;

    if DB
        .is_guardian_set(&account_eth_addr, &payload.guardian_email_addr)
        .await?
    {
        handle_email_event(EmailAuthEvent::GuardianAlreadyExists {
            account_eth_addr,
            guardian_email_addr: payload.guardian_email_addr.clone(),
        })
        .await
        // TODO: Add custom errors for handle_email_events and map_err
        .expect("Failed to send GuardianAlreadyExists event");
    } else if DB
        .is_wallet_and_email_registered(&account_eth_addr, &payload.guardian_email_addr)
        .await?
    {
        // In this case, the relayer sent a request email to the same guardian before, but it has not been replied yet.
        // Therefore, the relayer will send an email to the guardian again with a fresh account code.
        DB.update_credentials_of_wallet_and_email(&Credentials {
            account_code: payload.account_code.clone(),
            account_eth_addr: account_eth_addr.clone(),
            guardian_email_addr: payload.guardian_email_addr.clone(),
            is_set: false,
        })
        .await?;

        handle_email_event(EmailAuthEvent::AcceptanceRequest {
            account_eth_addr,
            guardian_email_addr: payload.guardian_email_addr.clone(),
            request_id,
            command: payload.command.clone(),
            account_code: payload.account_code.clone(),
        })
        .await?;
    } else {
        DB.insert_credentials(&Credentials {
            account_code: payload.account_code.clone(),
            account_eth_addr: account_eth_addr.clone(),
            guardian_email_addr: payload.guardian_email_addr.clone(),
            is_set: false,
        })
        .await?;

        handle_email_event(EmailAuthEvent::AcceptanceRequest {
            account_eth_addr,
            guardian_email_addr: payload.guardian_email_addr.clone(),
            request_id,
            command: payload.command.clone(),
            account_code: payload.account_code.clone(),
        })
        .await?;
    }

    Ok(Json(AcceptanceResponse {
        request_id,
        command_params,
    }))
}

pub async fn handle_recovery_request(
    Json(payload): Json<RecoveryRequest>,
) -> Result<Json<RecoveryResponse>, ApiError> {
    println!("handle_recovery_request: {:?}", payload);
    let command_template = CLIENT
        .get_recovery_command_templates(&payload.controller_eth_addr, payload.template_idx)
        .await?;
    println!("command_template: {:?}", command_template);

    let command_params = extract_template_vals(&payload.command, command_template)
        .map_err(|_| ApiError::Validation("Invalid command".to_string()))?;
    println!("command_params");

    let account_eth_addr = CLIENT
        .get_recovered_account_from_recovery_command(
            &payload.controller_eth_addr,
            command_params.clone(),
            payload.template_idx,
        )
        .await?;

    println!("account_eth_addr");

    let account_eth_addr = format!("0x{:x}", account_eth_addr);
    println!("account_eth_addr");

    if !CLIENT.is_wallet_deployed(&account_eth_addr).await? {
        return Err(ApiError::Validation("Wallet not deployed".to_string()));
    }

    println!("wallet is deployed");

    // Check if hash of bytecode of proxy contract is equal or not
    let bytecode = CLIENT.get_bytecode(&account_eth_addr).await?;
    println!("bytecode");
    let bytecode_hash = format!("0x{}", hex::encode(keccak256(bytecode.as_ref())));
    println!("bytecode_hash");

    // let permitted_wallets: Vec<PermittedWallet> =
    //     serde_json::from_str(include_str!("../../permitted_wallets.json")).unwrap();
    // let permitted_wallet = permitted_wallets
    //     .iter()
    //     .find(|w| w.hash_of_bytecode_of_proxy == bytecode_hash);

    // if let Some(permitted_wallet) = permitted_wallet {
    //     let slot_location = permitted_wallet.slot_location.parse::<u64>().unwrap();
    //     let impl_contract_from_proxy = {
    //         let raw_hex = hex::encode(
    //             CLIENT
    //                 .get_storage_at(&account_eth_addr, slot_location)
    //                 .await
    //                 .unwrap(),
    //         );
    //         format!("0x{}", &raw_hex[24..])
    //     };

    //     if !permitted_wallet
    //         .impl_contract_address
    //         .eq_ignore_ascii_case(&impl_contract_from_proxy)
    //     {
    //         return Response::builder()
    //             .status(StatusCode::BAD_REQUEST)
    //             .body(Body::from(
    //                 "Invalid bytecode, impl contract address mismatch",
    //             ))
    //             .unwrap();
    //     }

    //     if !permitted_wallet
    //         .controller_eth_addr
    //         .eq_ignore_ascii_case(&payload.controller_eth_addr)
    //     {
    //         return Response::builder()
    //             .status(StatusCode::BAD_REQUEST)
    //             .body(Body::from("Invalid controller eth addr"))
    //             .unwrap();
    //     }
    // } else {
    //     return Response::builder()
    //         .status(StatusCode::BAD_REQUEST)
    //         .body(Body::from("Wallet not permitted"))
    //         .unwrap();
    // }

    let mut request_id = rand::thread_rng().gen::<u32>();
    println!("got request_id");
    while let Ok(Some(request)) = DB.get_request(request_id).await {
        request_id = rand::thread_rng().gen::<u32>();
    }

    println!("got request: {:?}", request_id);
    println!("account_eth_addr: {:?}", account_eth_addr);
    println!(
        "payload.guardian_email_addr: {:?}",
        payload.guardian_email_addr
    );

    let account = DB
        .get_credentials_from_wallet_and_email(&account_eth_addr, &payload.guardian_email_addr)
        .await?;

    println!("got account: {:?}", account);

    let account_salt = if let Some(account_details) = account {
        calculate_account_salt(&payload.guardian_email_addr, &account_details.account_code)
    } else {
        return Err(ApiError::Validation("Wallet not deployed".to_string()));
    };

    println!("got account_salt");

    if !DB
        .is_wallet_and_email_registered(&account_eth_addr, &payload.guardian_email_addr)
        .await?
    {
        println!("email and wallet are not registered");
        DB.insert_request(&Request {
            request_id,
            account_eth_addr: account_eth_addr.clone(),
            controller_eth_addr: payload.controller_eth_addr.clone(),
            guardian_email_addr: payload.guardian_email_addr.clone(),
            is_for_recovery: true,
            template_idx: payload.template_idx,
            is_processed: false,
            is_success: None,
            email_nullifier: None,
            account_salt: Some(account_salt.clone()),
        })
        .await?;

        handle_email_event(EmailAuthEvent::GuardianNotRegistered {
            account_eth_addr,
            guardian_email_addr: payload.guardian_email_addr.clone(),
            command: payload.command.clone(),
            request_id,
        })
        .await?;

        return Ok(Json(RecoveryResponse {
            request_id,
            command_params,
        }));
    }

    DB.insert_request(&Request {
        request_id,
        account_eth_addr: account_eth_addr.clone(),
        controller_eth_addr: payload.controller_eth_addr.clone(),
        guardian_email_addr: payload.guardian_email_addr.clone(),
        is_for_recovery: true,
        template_idx: payload.template_idx,
        is_processed: false,
        is_success: None,
        email_nullifier: None,
        account_salt: Some(account_salt.clone()),
    })
    .await?;

    println!("inserted request");

    if DB
        .is_guardian_set(&account_eth_addr, &payload.guardian_email_addr)
        .await?
    {
        println!("guardian is set");
        handle_email_event(EmailAuthEvent::RecoveryRequest {
            account_eth_addr,
            guardian_email_addr: payload.guardian_email_addr.clone(),
            request_id,
            command: payload.command.clone(),
        })
        .await
        // TODO: Add custom error for handle_email_event
        .expect("Failed to send Recovery event");
    } else {
        println!("guardian is not set");
        handle_email_event(EmailAuthEvent::GuardianNotSet {
            account_eth_addr,
            guardian_email_addr: payload.guardian_email_addr.clone(),
        })
        .await
        // TODO: Add error handling
        .expect("Failed to send Recovery event");
    }

    println!("all done");

    Ok(Json(RecoveryResponse {
        request_id,
        command_params,
    }))
}

pub async fn handle_complete_recovery_request(
    Json(payload): Json<CompleteRecoveryRequest>,
) -> Result<String, ApiError> {
    println!("handle_complete_recovery_request");
    if !CLIENT.is_wallet_deployed(&payload.account_eth_addr).await? {
        return Err(ApiError::Validation("Wallet not deployed".to_string()));
    }
    println!("wallet is deployed");

    match CLIENT
        .complete_recovery(
            &payload.controller_eth_addr,
            &payload.account_eth_addr,
            &payload.complete_calldata,
        )
        .await
    {
        Ok(true) => Ok("Recovery completed".to_string()),
        Ok(false) => Err(ApiError::Validation("Recovery failed".to_string())),
        Err(e) => {
            // Parse the error message if it follows the known format
            let error_message = if e
                .to_string()
                .starts_with("Contract call reverted with data:")
            {
                parse_error_message(e.to_string())
            } else {
                "Internal server error".to_string()
            };
            // Remove all non printable characters
            let error_message = error_message
                .chars()
                .filter(|c| c.is_ascii())
                .collect::<String>();
            Err(ApiError::Internal(error_message))
        }
    }
}

pub async fn get_account_salt(
    Json(payload): Json<GetAccountSaltRequest>,
) -> Result<String, ApiError> {
    println!("get_account_salt");
    let account_salt = calculate_account_salt(&payload.email_addr, &payload.account_code);
    Ok(account_salt)
}

pub async fn inactive_guardian(
    Json(payload): Json<InactiveGuardianRequest>,
) -> Result<String, ApiError> {
    println!("inactive_guardian");
    let is_activated = CLIENT
        .get_is_activated(&payload.controller_eth_addr, &payload.account_eth_addr)
        .await?;

    if is_activated {
        return Ok("Wallet is activated".to_string());
    }

    trace!(LOG, "Inactive guardian"; "is_activated" => is_activated);
    let account_eth_addr: Address = payload
        .account_eth_addr
        .parse()
        .map_err(|e| ApiError::Validation(format!("Failed to parse account_eth_addr: {}", e)))?;
    let account_eth_addr = format!("0x{:x}", &account_eth_addr);
    trace!(LOG, "Inactive guardian"; "account_eth_addr" => &account_eth_addr);
    DB.update_credentials_of_inactive_guardian(false, &account_eth_addr)
        .await?;

    Ok("Guardian inactivated".to_string())
}

fn parse_error_message(error_data: String) -> String {
    // Attempt to extract and decode the error message
    if let Some(hex_error) = error_data.split(" ").last() {
        if hex_error.len() > 138 {
            // Check if the length is sufficient for a message
            let error_bytes = decode(&hex_error[138..]).unwrap_or_else(|_| vec![]);
            if let Ok(message) = str::from_utf8(&error_bytes) {
                return message.to_string();
            }
        }
    }
    format!("Failed to parse contract error: {}", error_data)
}

pub async fn receive_email_api_fn(email: String) -> Result<(), ApiError> {
    println!("receive_email_api_fn");
    let parsed_email = ParsedEmail::new_from_raw_email(&email).await?;
    let from_addr = parsed_email.get_from_addr()?;
    let original_subject = parsed_email.get_subject_all()?;
    tokio::spawn(async move {
        match handle_email_event(EmailAuthEvent::Ack {
            email_addr: from_addr.clone(),
            command: parsed_email.get_command(false).unwrap_or_default(),
            original_message_id: parsed_email.get_message_id().ok(),
            original_subject,
        })
        .await
        {
            Ok(_) => {
                trace!(LOG, "Ack email event sent");
            }
            Err(e) => {
                error!(LOG, "Error handling email event: {:?}", e);
            }
        }
        match handle_email(email.clone()).await {
            Ok(event) => match handle_email_event(event).await {
                Ok(_) => {}
                Err(e) => {
                    error!(LOG, "Error handling email event: {:?}", e);
                }
            },
            Err(e) => {
                error!(LOG, "Error handling email: {:?}", e);
                let original_subject = parsed_email
                    .get_subject_all()
                    .unwrap_or("Unknown Error".to_string());
                match handle_email_event(EmailAuthEvent::Error {
                    email_addr: from_addr,
                    error: e.to_string(),
                    original_subject,
                    original_message_id: parsed_email.get_message_id().ok(),
                })
                .await
                {
                    Ok(_) => {}
                    Err(e) => {
                        error!(LOG, "Error handling email event: {:?}", e);
                    }
                }
            }
        }
    });
    Ok(())
}

#[derive(Serialize, Deserialize)]
pub struct RequestStatusRequest {
    pub request_id: u32,
}

#[derive(Serialize, Deserialize)]
pub enum RequestStatus {
    NotExist = 0,
    Pending = 1,
    Processed = 2,
}

#[derive(Serialize, Deserialize)]
pub struct RequestStatusResponse {
    pub request_id: u32,
    pub status: RequestStatus,
    pub is_success: bool,
    pub email_nullifier: Option<String>,
    pub account_salt: Option<String>,
}

#[derive(Serialize, Deserialize)]
pub struct AcceptanceRequest {
    pub controller_eth_addr: String,
    pub guardian_email_addr: String,
    pub account_code: String,
    pub template_idx: u64,
    pub command: String,
}

#[derive(Serialize, Deserialize)]
pub struct AcceptanceResponse {
    pub request_id: u32,
    pub command_params: Vec<TemplateValue>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct RecoveryRequest {
    pub controller_eth_addr: String,
    pub guardian_email_addr: String,
    pub template_idx: u64,
    pub command: String,
}

#[derive(Serialize, Deserialize)]
pub struct RecoveryResponse {
    pub request_id: u32,
    pub command_params: Vec<TemplateValue>,
}

#[derive(Serialize, Deserialize)]
pub struct CompleteRecoveryRequest {
    pub account_eth_addr: String,
    pub controller_eth_addr: String,
    pub complete_calldata: String,
}

#[derive(Serialize, Deserialize)]
pub struct GetAccountSaltRequest {
    pub account_code: String,
    pub email_addr: String,
}

#[derive(Deserialize)]
struct PermittedWallet {
    wallet_name: String,
    controller_eth_addr: String,
    hash_of_bytecode_of_proxy: String,
    impl_contract_address: String,
    slot_location: String,
}

#[derive(Serialize, Deserialize)]
pub struct InactiveGuardianRequest {
    pub account_eth_addr: String,
    pub controller_eth_addr: String,
}
