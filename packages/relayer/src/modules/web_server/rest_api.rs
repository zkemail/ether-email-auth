use crate::*;
use anyhow::Result;
use axum::{response::IntoResponse, Json};
use reqwest::StatusCode;
use serde::{Deserialize, Serialize};
use uuid::Uuid;

#[derive(Serialize, Deserialize)]
pub struct RequestStatusRequest {
    pub request_id: String,
}

#[derive(Serialize, Deserialize)]
pub enum RequestStatus {
    NotExist = 0,
    Pending = 1,
    Processed = 2,
}

#[derive(Serialize, Deserialize)]
pub struct RequestStatusResponse {
    pub request_id: String,
    pub status: RequestStatus,
    pub is_success: bool,
    pub email_nullifier: Option<String>,
    pub account_salt: Option<String>,
}

#[derive(Serialize, Deserialize)]
pub struct AcceptanceRequest {
    pub wallet_eth_addr: String,
    pub guardian_email_addr: String,
    pub account_code: String,
    pub template_idx: u64,
    pub subject: String,
}

#[derive(Serialize, Deserialize)]
pub struct AcceptanceResponse {
    pub request_id: String,
    pub subject_params: Vec<String>,
}

#[derive(Serialize, Deserialize)]
pub struct RecoveryRequest {
    pub wallet_eth_addr: String,
    pub guardian_email_addr: String,
    pub template_idx: u64,
    pub subject: String,
}

#[derive(Serialize, Deserialize)]
pub struct RecoveryResponse {
    pub request_id: String,
    pub subject_params: Vec<String>,
}

// Create request status API
pub async fn request_status_api(payload: RequestStatusRequest) -> Result<RequestStatusResponse> {
    let row = DB.get_request(payload.request_id.clone()).await?;
    let status = if let Some(ref row) = row {
        if row.is_processed {
            RequestStatus::Processed
        } else {
            RequestStatus::Pending
        }
    } else {
        RequestStatus::NotExist
    };
    Ok(RequestStatusResponse {
        request_id: payload.request_id,
        status,
        is_success: row
            .as_ref()
            .map_or(false, |r| r.is_success.unwrap_or(false)),
        email_nullifier: row.clone().and_then(|r| r.email_nullifier),
        account_salt: row.clone().and_then(|r| r.account_salt),
    })
}

pub async fn handle_acceptance_request(
    Json(payload): Json<AcceptanceRequest>,
    db: Arc<Database>,
    email_sender: EmailForwardSender,
    chain_client: Arc<ChainClient>,
) -> impl IntoResponse {
    if !chain_client
        .is_wallet_deployed(&payload.wallet_eth_addr)
        .await
    {
        return (StatusCode::BAD_REQUEST, "Contract not deployed").into_response();
    }

    let subject_template = chain_client
        .get_subject_template(payload.template_idx)
        .await
        .unwrap();

    let (is_valid, subject_params) =
        parse_subject_with_template(&payload.subject, subject_template);

    if !is_valid {
        return (StatusCode::BAD_REQUEST, "Invalid subject").into_response();
    }

    if let Ok(Some(creds)) = db.get_credentials(&payload.account_code).await {
        return (StatusCode::BAD_REQUEST, "Account code already exists").into_response();
    }

    let mut request_id = Uuid::new_v4().to_string();
    while let Ok(Some(request)) = db.get_request(&request_id).await {
        request_id = Uuid::new_v4().to_string(); // Regenerate request_id if it already exists
    }

    if db
        .is_guardian_set(&payload.wallet_eth_addr, &payload.guardian_email_addr)
        .await
    {
        db.insert_request(&Request {
            request_id: request_id.clone(),
            wallet_eth_addr: payload.wallet_eth_addr.clone(),
            guardian_email_addr: payload.guardian_email_addr.clone(),
            is_for_recovery: false,
            template_idx: payload.template_idx,
            is_processed: false,
            is_success: None,
            email_nullifier: None,
            account_salt: None,
        })
        .await;
        send_error_email(
            &email_sender,
            &payload.guardian_email_addr,
            &payload.wallet_eth_addr,
        )
        .await;
    } else {
        db.insert_credentials(&Credentials {
            account_code: payload.account_code.clone(),
            wallet_eth_addr: payload.wallet_eth_addr.clone(),
            guardian_email_addr: payload.guardian_email_addr.clone(),
            is_set: false,
        })
        .await;

        db.insert_request(&Request {
            request_id: request_id.clone(),
            wallet_eth_addr: payload.wallet_eth_addr.clone(),
            guardian_email_addr: payload.guardian_email_addr.clone(),
            is_for_recovery: false,
            template_idx: payload.template_idx,
            is_processed: false,
            is_success: None,
            email_nullifier: None,
            account_salt: None,
        });

        send_guardian_email(&email_sender, &payload, &request_id).await;
    }

    (
        StatusCode::OK,
        Json(AcceptanceResponse {
            request_id,
            subject_params,
        }),
    )
        .into_response()
}

fn parse_subject_with_template(subject: &str, template: Vec<String>) -> (bool, Vec<String>) {
    let mut parsed_values = Vec::new();
    let subject_parts: Vec<&str> = subject.split_whitespace().collect();
    let mut template_index = 0;
    let mut subject_index = 0;

    while template_index < template.len() && subject_index < subject_parts.len() {
        if template[template_index].starts_with('{') && template[template_index].ends_with('}') {
            // Extract the parameter value and add it to the vector
            parsed_values.push(subject_parts[subject_index].to_string());
            template_index += 1;
            subject_index += 1;
        } else if template[template_index] == subject_parts[subject_index] {
            template_index += 1;
            subject_index += 1;
        } else {
            // If a non-parameter part of the template doesn't match the subject part, return false
            return (false, Vec::new());
        }
    }

    // If we've matched all parts of the template and the subject, return true and the parsed values
    if template_index == template.len() && subject_index == subject_parts.len() {
        (true, parsed_values)
    } else {
        (false, Vec::new())
    }
}
