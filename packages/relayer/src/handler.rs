use std::sync::Arc;

use axum::{
    extract::State,
    http::{request, StatusCode},
    response::IntoResponse,
    Json,
};
use regex::Regex;
use relayer_utils::{field_to_hex, ParsedEmail, LOG};
use serde_json::{json, Value};
use slog::{error, info, trace};
use uuid::Uuid;

use crate::{
    command::parse_command_template,
    mail::{handle_email, handle_email_event, EmailEvent},
    model::{create_request, get_request, update_request, RequestStatus},
    schema::EmailTxAuthSchema,
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

    let uuid = create_request(&relayer_state.db, &body)
        .await
        .map_err(|e| {
            (
                axum::http::StatusCode::INTERNAL_SERVER_ERROR,
                axum::Json(json!({"error": e.to_string()})),
            )
        })?;

    let command = parse_command_template(&body.command_template, body.command_params);

    let account_code = if body.code_exists_in_email {
        let hex_code = field_to_hex(&body.account_code.clone().0);
        Some(hex_code.trim_start_matches("0x").to_string())
    } else {
        None
    };

    handle_email_event(
        EmailEvent::Command {
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
        r"(Your request ID is )([0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12})",
    )
    .unwrap();

    // Attempt to find a UUID in the body
    let captures = uuid_regex.captures(&body);

    let request_id = captures
        .and_then(|caps| caps.get(2).map(|m| m.as_str()))
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

    info!(LOG, "Request ID received: {}", request_id);

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
    let from_addr = match parsed_email.get_from_addr() {
        Ok(addr) => addr,
        Err(e) => {
            return Err((
                reqwest::StatusCode::INTERNAL_SERVER_ERROR,
                axum::Json(json!({"error": e.to_string()})),
            ))
        }
    };
    let original_subject = match parsed_email.get_subject_all() {
        Ok(subject) => subject,
        Err(e) => {
            return Err((
                reqwest::StatusCode::INTERNAL_SERVER_ERROR,
                axum::Json(json!({"error": e.to_string()})),
            ))
        }
    };

    // Send acknowledgment email
    match handle_email_event(
        EmailEvent::Ack {
            email_addr: from_addr.clone(),
            command: parsed_email.get_command(false).unwrap_or_default(),
            original_message_id: parsed_email.get_message_id().ok(),
            original_subject,
        },
        (*relayer_state).clone(),
    )
    .await
    {
        Ok(_) => {
            trace!(LOG, "Ack email event sent");
        }
        Err(e) => {
            error!(LOG, "Error handling email event: {:?}", e);
        }
    }

    let request = get_request(&relayer_state.db, request_id)
        .await
        .map_err(|e| {
            // Convert the error to the expected type
            (
                reqwest::StatusCode::INTERNAL_SERVER_ERROR,
                axum::Json(json!({"error": e.to_string()})),
            )
        })?;

    // Process the email
    match handle_email(body, request, (*relayer_state).clone()).await {
        Ok(event) => match handle_email_event(event, (*relayer_state).clone()).await {
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
            match handle_email_event(
                EmailEvent::Error {
                    email_addr: from_addr,
                    error: e.to_string(),
                    original_subject,
                    original_message_id: parsed_email.get_message_id().ok(),
                },
                (*relayer_state).clone(),
            )
            .await
            {
                Ok(_) => {}
                Err(e) => {
                    error!(LOG, "Error handling email event: {:?}", e);
                }
            }
        }
    }

    let response = json!({
        "status": "success",
        "message": "email received",
    });

    Ok((StatusCode::OK, Json(response)))
}

pub async fn get_status_handler(
    State(relayer_state): State<Arc<RelayerState>>,
    request: request::Parts,
) -> Result<impl IntoResponse, (StatusCode, Json<Value>)> {
    let request_id = request
        .uri
        .path()
        .trim_start_matches("/api/status/")
        .parse::<Uuid>()
        .map_err(|_| {
            (
                reqwest::StatusCode::BAD_REQUEST,
                axum::Json(json!({"error": "Failed to parse request ID"})),
            )
        })?;

    let request = get_request(&relayer_state.db, request_id)
        .await
        .map_err(|e| {
            (
                reqwest::StatusCode::INTERNAL_SERVER_ERROR,
                axum::Json(json!({"error": e.to_string()})),
            )
        })?;

    let response = json!({
        "status": "success",
        "message": "request status",
        "request": request,
    });

    Ok((StatusCode::OK, Json(response)))
}
