use std::sync::Arc;

use axum::{extract::State, http::StatusCode, response::IntoResponse, Json};
use regex::Regex;
use relayer_utils::{field_to_hex, ParsedEmail, LOG};
use serde_json::{json, Value};
use slog::info;
use uuid::Uuid;

use crate::{
    mail::handle_email_event,
    model::{create_request, update_request, RequestStatus},
    schema::EmailTxAuthSchema,
    utils::parse_command_template,
    RelayerState,
};

pub async fn health_checker_handler() -> impl IntoResponse {
    const MESSAGE: &str = "Hello from ZK Email!";

    let json_response = serde_json::json!({
        "status": "success",
        "message": MESSAGE
    });

    Json(json_response)
}

pub async fn submit_handler(
    State(relayer_state): State<Arc<RelayerState>>,
    Json(body): Json<EmailTxAuthSchema>,
) -> Result<impl IntoResponse, (StatusCode, Json<Value>)> {
    info!(LOG, "Payload: {:?}", body);

    let uuid = create_request(&relayer_state.db).await.map_err(|e| {
        (
            axum::http::StatusCode::INTERNAL_SERVER_ERROR,
            axum::Json(json!({"error": e.to_string()})),
        )
    })?;

    let command = parse_command_template(&body.command_template, &body.command_params);

    let account_code = if body.code_exists_in_email {
        let hex_code = field_to_hex(&body.account_code.clone().0);
        Some(hex_code.trim_start_matches("0x").to_string())
    } else {
        None
    };

    handle_email_event(
        crate::mail::EmailEvent::Command {
            request_id: uuid,
            email_address: body.email_address.clone(),
            command,
            account_code,
            subject: body.subject.clone(),
            body: body.body.clone(),
        },
        (*relayer_state).clone(),
    )
    .await
    .map_err(|e| {
        // Convert the error to the desired type
        (
            reqwest::StatusCode::INTERNAL_SERVER_ERROR,
            axum::Json(json!({"error": e.to_string()})),
        )
    })?;

    let response = json!({
        "status": "success",
        "message": "email sent",
        "request_id": uuid
    });

    return Ok((StatusCode::OK, Json(response)));
}

pub async fn receive_email_handler(
    State(relayer_state): State<Arc<RelayerState>>,
    body: String,
) -> Result<impl IntoResponse, (StatusCode, Json<Value>)> {
    // Define the regex pattern for UUID
    let uuid_regex = Regex::new(
        r"\b[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}\b",
    )
    .unwrap();

    // Attempt to find a UUID in the body
    let request_id = uuid_regex.find(&body).map(|m| m.as_str());

    match request_id {
        Some(request_id) => {
            info!(LOG, "Extracted UUID: {:?}", request_id);
        }
        None => {
            info!(LOG, "No UUID found in the body");
            // Handle the case where no UUID is found
            let response = json!({
                "status": "error",
                "message": "No UUID found in the email body",
            });
            return Ok((StatusCode::BAD_REQUEST, Json(response)));
        }
    }

    let request_id = request_id
        .ok_or_else(|| {
            (
                reqwest::StatusCode::BAD_REQUEST,
                axum::Json(json!({"error": "Request ID is None"})),
            )
        })
        .and_then(|id| {
            id.parse::<Uuid>().map_err(|_| {
                (
                    reqwest::StatusCode::BAD_REQUEST,
                    axum::Json(json!({"error": "Failed to parse request ID"})),
                )
            })
        })?;

    update_request(
        &relayer_state.db,
        request_id,
        RequestStatus::EmailResponseReceived,
    )
    .await
    .map_err(|e| {
        // Convert the error to the expected type
        (
            reqwest::StatusCode::INTERNAL_SERVER_ERROR,
            axum::Json(json!({"error": e.to_string()})),
        )
    })?;

    // Log the received body
    info!(LOG, "Received email body: {:?}", body);

    let parsed_email = ParsedEmail::new_from_raw_email(&body).await.map_err(|e| {
        // Convert the error to the expected type
        (
            reqwest::StatusCode::INTERNAL_SERVER_ERROR,
            axum::Json(json!({"error": e.to_string()})),
        )
    })?;

    // Process the body as needed
    // For example, you might want to parse it or pass it to another function

    let response = json!({
        "status": "success",
        "message": "email received",
    });

    Ok((StatusCode::OK, Json(response)))
}
