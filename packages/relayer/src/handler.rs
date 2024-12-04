use std::sync::Arc;

use anyhow::Result;
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
    abis::EmailAuthMsg,
    command::parse_command_template,
    constants::REQUEST_ID_REGEX,
    mail::{handle_email, handle_email_event, EmailEvent},
    model::{create_request, get_request, update_request, RequestStatus},
    schema::{AccountSaltSchema, EmailTxAuthSchema},
    RelayerState,
};
use serde::Serialize;

use crate::abis::EmailProof;
use sqlx::PgPool;

/// Represents an email authentication message with associated proof and parameters.
/// This implementation provides database persistence capabilities.
impl EmailAuthMsg {
    /// Saves the email authentication message to the database.
    ///
    /// # Arguments
    /// * `pool` - PostgreSQL connection pool
    /// * `request_id` - Unique identifier for the request
    ///
    /// # Returns
    /// * `Result<()>` - Success or error during database operation
    pub async fn save(&self, pool: &PgPool, request_id: Uuid) -> Result<()> {
        sqlx::query!(
            "INSERT INTO email_auth_messages (request_id, response) VALUES ($1, $2)",
            request_id.to_string(),
            serde_json::to_value(self)?
        )
        .execute(pool)
        .await?;
        Ok(())
    }
}

/// Custom serialization implementation for EmailAuthMsg.
/// Ensures consistent JSON output format for the authentication message.
impl Serialize for EmailAuthMsg {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: serde::Serializer,
    {
        use serde::ser::SerializeStruct;

        let mut state = serializer.serialize_struct("EmailAuthMsg", 4)?;
        state.serialize_field("templateId", &self.template_id)?;
        state.serialize_field("commandParams", &self.command_params)?;
        state.serialize_field(
            "skippedCommandPrefix",
            &self.skipped_command_prefix.as_u128(),
        )?;
        state.serialize_field("proof", &self.proof)?;
        state.end()
    }
}

/// Custom serialization implementation for EmailProof.
/// Formats fields with proper hexadecimal encoding and '0x' prefixes.
impl Serialize for EmailProof {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: serde::Serializer,
    {
        use serde::ser::SerializeStruct;

        // Helper function to format hex values consistently
        fn format_hex(bytes: &[u8]) -> String {
            format!("0x{}", ethers::utils::hex::encode(bytes))
        }

        let mut state = serializer.serialize_struct("EmailProof", 8)?;

        // Basic fields
        state.serialize_field("domainName", &self.domain_name)?;
        state.serialize_field("publicKeyHash", &format_hex(&self.public_key_hash))?;
        state.serialize_field("timestamp", &self.timestamp.as_u64())?;
        state.serialize_field("maskedCommand", &self.masked_command)?;

        // Proof fields
        state.serialize_field("emailNullifier", &format_hex(&self.email_nullifier))?;
        state.serialize_field("accountSalt", &format_hex(&self.account_salt))?;
        state.serialize_field("isCodeExist", &self.is_code_exist)?;
        state.serialize_field("proof", &format_hex(&self.proof))?;

        state.end()
    }
}

/// Checks the health of the service and returns a JSON response.
///
/// This asynchronous handler function is used to verify that the service is running successfully.
///
/// # Returns
///
/// A JSON response with a status message indicating the service is operational.
pub async fn health_checker_handler() -> impl IntoResponse {
    // A constant message to be included in the response
    const MESSAGE: &str = "Hello from ZK Email!";

    // Create a JSON response with a success status and the message
    let json_response = serde_json::json!({
        "status": "success",
        "message": MESSAGE
    });

    // Return the JSON response
    Json(json_response)
}

/// Submits email transaction authentication requests.
///
/// This asynchronous handler function processes the incoming request, creates a new request ID,
/// parses the command, and handles the email event. It returns a JSON response indicating the
/// success or failure of the operation.
///
/// # Arguments
///
/// * `relayer_state` - The state of the relayer, encapsulated in an `Arc` for thread-safe access.
/// * `body` - The JSON body of the request, deserialized into an `EmailTxAuthSchema`.
///
/// # Returns
///
/// A `Result` containing:
/// - `Ok`: A JSON response with a success status, message, and request ID.
/// - `Err`: A tuple with a `StatusCode` and a JSON error message if an error occurs.
pub async fn submit_handler(
    State(relayer_state): State<Arc<RelayerState>>,
    Json(body): Json<EmailTxAuthSchema>,
) -> Result<impl IntoResponse, (StatusCode, Json<Value>)> {
    // Log the received payload
    info!(LOG, "Payload: {:?}", body);

    // Create a new request in the database and obtain a UUID
    let uuid = create_request(&relayer_state.db, &body)
        .await
        .map_err(|e| {
            (
                axum::http::StatusCode::INTERNAL_SERVER_ERROR,
                axum::Json(json!({"error": e.to_string()})),
            )
        })?;

    // Log the created request ID
    info!(LOG, "Request ID created: {}", uuid);

    // Parse the command template with the provided parameters
    let command = parse_command_template(&body.command_template, body.command_params);

    // Log the parsed command
    info!(LOG, "Command: {:?}", command);

    // Determine the account code if it exists in the email
    let account_code = if body.code_exists_in_email {
        let hex_code = field_to_hex(&body.account_code.0);
        Some(hex_code.trim_start_matches("0x").to_string())
    } else {
        None
    };

    // Handle the email event by sending a command email
    handle_email_event(
        EmailEvent::Command {
            request_id: uuid,
            email_address: body.email_address.clone(),
            command,
            account_code,
            subject: format!("[Reply Needed] {}", body.subject.clone()),
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

    // Create a JSON response indicating success
    let response = json!({
        "status": "success",
        "message": "email sent",
        "id": uuid
    });

    // Return the success response
    Ok((StatusCode::OK, Json(response)))
}

/// Handles the reception of an email and processes it accordingly.
///
/// This asynchronous handler function extracts the request ID from the email body, updates the request status,
/// parses the email, and sends an acknowledgment. It processes the email and handles any resulting events.
///
/// # Arguments
///
/// * `relayer_state` - The state of the relayer, encapsulated in an `Arc` for thread-safe access.
/// * `body` - The raw email body as a `String`.
///
/// # Returns
///
/// A `Result` containing:
/// - `Ok`: A JSON response with a success status and message.
/// - `Err`: A tuple with a `StatusCode` and a JSON error message if an error occurs.
pub async fn receive_email_handler(
    State(relayer_state): State<Arc<RelayerState>>,
    body: String,
) -> Result<impl IntoResponse, (StatusCode, Json<Value>)> {
    // Define the regex pattern for UUID
    let uuid_regex = Regex::new(REQUEST_ID_REGEX).unwrap();

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

    // Update the request status in the database
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

    // Parse the email from the raw body
    let parsed_email = ParsedEmail::new_from_raw_email(&body).await.map_err(|e| {
        // Convert the error to the expected type
        (
            reqwest::StatusCode::INTERNAL_SERVER_ERROR,
            axum::Json(json!({"error": e.to_string()})),
        )
    })?;

    // Extract the sender's address
    let from_addr = match parsed_email.get_from_addr() {
        Ok(addr) => addr,
        Err(e) => {
            return Err((
                reqwest::StatusCode::INTERNAL_SERVER_ERROR,
                axum::Json(json!({"error": e.to_string()})),
            ))
        }
    };

    // Extract the original subject of the email
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

    // Retrieve the request from the database
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

    // Create a JSON response indicating success
    let response = json!({
        "status": "success",
        "message": "email received",
    });

    Ok((StatusCode::OK, Json(response)))
}

/// Retrieves the status of a specific request based on its ID.
///
/// This asynchronous handler function extracts the request ID from the URI, retrieves the request
/// from the database, and returns its status in a JSON response.
///
/// # Arguments
///
/// * `relayer_state` - The state of the relayer, encapsulated in an `Arc` for thread-safe access.
/// * `request` - The parts of the HTTP request, used to extract the request ID from the URI.
///
/// # Returns
///
/// A `Result` containing:
/// - `Ok`: A JSON response with the request status and details.
/// - `Err`: A tuple with a `StatusCode` and a JSON error message if an error occurs.
pub async fn get_status_handler(
    State(relayer_state): State<Arc<RelayerState>>,
    request: request::Parts,
) -> Result<impl IntoResponse, (StatusCode, Json<Value>)> {
    // Extract the request ID from the URI path
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

    // Retrieve the request from the database using the request ID
    let request = get_request(&relayer_state.db, request_id)
        .await
        .map_err(|e| {
            (
                reqwest::StatusCode::INTERNAL_SERVER_ERROR,
                axum::Json(json!({"error": e.to_string()})),
            )
        })?;

    let email_auth_msg = sqlx::query!(
        "SELECT response FROM email_auth_messages WHERE request_id = $1",
        request_id.to_string()
    )
    .fetch_optional(&relayer_state.db)
    .await
    .map_err(|e| {
        (
            reqwest::StatusCode::INTERNAL_SERVER_ERROR,
            axum::Json(json!({"error": e.to_string()})),
        )
    })?;
    let response = json!({
        "message": "request status",
        "request": request,
        "response": email_auth_msg.map(|msg| msg.response),
    });

    // Return the success response
    Ok((StatusCode::OK, Json(response)))
}

pub async fn account_salt_handler(
    State(_): State<Arc<RelayerState>>,
    Json(body): Json<AccountSaltSchema>,
) -> Result<impl IntoResponse, (StatusCode, Json<Value>)> {
    // use relayer_utils::get_account_salt
    let account_salt =
        relayer_utils::calculate_account_salt(&body.email_address, &body.account_code);

    let response = json!({
        "emailAddress": body.email_address,
        "accountCode": body.account_code,
        "accountSalt": account_salt,
    });

    Ok((StatusCode::OK, Json(response)))
}
