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
    let request_id = payload.request_id.clone();
    Ok(RequestStatusResponse {
        request_id,
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
) -> impl IntoResponse {
    // Step 2: Check if the contract is deployed
    if !is_contract_deployed(&payload.wallet_eth_addr).await {
        return (StatusCode::BAD_REQUEST, "Contract not deployed").into_response();
    }

    // Steps 3 and 4: Validate subject with template
    let subject_template =
        get_subject_template(&payload.wallet_eth_addr, payload.template_idx as usize).await;
    if payload.subject != subject_template {
        return (StatusCode::BAD_REQUEST, "Subject does not match template").into_response();
    }

    // Assume subject_params parsing happens here
    let subject_params = vec![]; // Placeholder for actual parsing logic

    // Step 5: Check for existing account_code
    if db.codes_table_contains(&payload.account_code).await {
        return (StatusCode::BAD_REQUEST, "Account code already exists").into_response();
    }

    // Steps 6-11: Main logic for handling the request
    let mut request_id = Uuid::new_v4().to_string();
    while db.requests_table_contains(&request_id).await {
        request_id = Uuid::new_v4().to_string(); // Regenerate request_id if it already exists
    }

    if db
        .codes_table_contains_guardian(&payload.wallet_eth_addr, &payload.guardian_email_addr, true)
        .await
    {
        // Step 7: Handle existing guardian
        db.insert_into_requests(&request_id, &payload, false).await;
        send_error_email(
            &email_sender,
            &payload.guardian_email_addr,
            &payload.wallet_eth_addr,
        )
        .await;
    } else {
        // Steps 8 and 9: Insert into codes and requests tables
        db.insert_into_codes(&payload.account_code, &payload).await;
        db.insert_into_requests(&request_id, &payload, true).await; // Note: Corrected the last parameter based on your instructions

        // Step 10: Send email
        send_guardian_email(&email_sender, &payload, &request_id).await;
    }

    // Step 11: Return response
    (
        StatusCode::OK,
        Json(AcceptanceResponse {
            request_id,
            subject_params,
        }),
    )
        .into_response()
}

// Placeholder functions for database checks, email sending, etc.
// You'll need to implement these based on your application's specific requirements
async fn is_contract_deployed(wallet_eth_addr: &str) -> bool {
    // Implement contract check logic
    true
}

async fn get_subject_template(wallet_eth_addr: &str, template_idx: usize) -> String {
    // Fetch the subject template based on wallet_eth_addr and template_idx
    "Your subject template".to_string()
}

async fn send_error_email(
    email_sender: &EmailForwardSender,
    guardian_email_addr: &String,
    wallet_eth_addr: &String,
) {
    // Implement email sending logic for error case
}

async fn send_guardian_email(
    email_sender: &EmailForwardSender,
    payload: &AcceptanceRequest,
    request_id: &String,
) {
    // Implement email sending logic for guardian case
}
