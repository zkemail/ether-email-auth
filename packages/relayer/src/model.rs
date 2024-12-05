use anyhow::{Error, Ok, Result};
use chrono::NaiveDateTime;
use serde::{Deserialize, Serialize};
use sqlx::types::Json;
use sqlx::{FromRow, PgPool};
use uuid::Uuid;

use crate::schema::EmailTxAuthSchema;

/// Represents a request model with details about the request status and associated email transaction authentication.
#[derive(Debug, FromRow, Deserialize, Serialize, Clone)]
#[allow(non_snake_case)]
pub struct RequestModel {
    /// The unique identifier for the request.
    pub id: Uuid,
    /// The current status of the request.
    pub status: String,
    /// The timestamp when the request was last updated.
    #[serde(rename = "updatedAt")]
    pub updated_at: Option<NaiveDateTime>,
    #[serde(rename = "body")]
    pub email_tx_auth: EmailTxAuthSchema,
}

/// Represents an expected reply model with details about the message and request.
#[derive(Debug, FromRow, Deserialize, Serialize)]
#[allow(non_snake_case)]
pub struct ExpectedReplyModel {
    /// The unique identifier for the message.
    pub message_id: String,
    /// The optional request ID associated with the message.
    pub request_id: Option<String>,
    /// Indicates whether a reply has been received.
    pub has_reply: Option<bool>,
    /// The timestamp when the expected reply was created.
    #[serde(rename = "createdAt")]
    pub created_at: chrono::DateTime<chrono::Utc>,
}

#[derive(Debug, Serialize, Deserialize, sqlx::Type)]
#[sqlx(type_name = "status_enum")]
pub enum RequestStatus {
    #[sqlx(rename = "Request received")]
    RequestReceived,
    #[sqlx(rename = "Email sent")]
    EmailSent,
    #[sqlx(rename = "Email response received")]
    EmailResponseReceived,
    #[sqlx(rename = "Proving")]
    Proving,
    #[sqlx(rename = "Performing on chain transaction")]
    PerformingOnChainTransaction,
    #[sqlx(rename = "Finished")]
    Finished,
}

impl std::fmt::Display for RequestStatus {
    /// Formats the `RequestStatus` as a string for display purposes.
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        write!(f, "{:?}", self)
    }
}

impl From<RequestStatus> for String {
    /// Converts a `RequestStatus` into a `String`.
    fn from(status: RequestStatus) -> Self {
        status.to_string()
    }
}

impl From<sqlx::types::Json<EmailTxAuthSchema>> for EmailTxAuthSchema {
    /// Converts a JSON-wrapped `EmailTxAuthSchema` into an `EmailTxAuthSchema`.
    fn from(json: sqlx::types::Json<EmailTxAuthSchema>) -> Self {
        json.0
    }
}

/// Creates a new request in the database and returns its unique identifier.
///
/// # Arguments
///
/// * `pool` - A reference to the PostgreSQL connection pool.
/// * `email_tx_auth` - A reference to the `EmailTxAuthSchema` to be inserted.
///
/// # Returns
///
/// A `Result` containing the `Uuid` of the newly created request.
pub async fn create_request(pool: &PgPool, email_tx_auth: &EmailTxAuthSchema) -> Result<Uuid> {
    // Assuming the database column is of type JSONB and can directly accept the struct
    let query_result = sqlx::query!(
        "INSERT INTO requests (email_tx_auth) VALUES ($1) RETURNING id",
        serde_json::to_value(email_tx_auth)? // Convert struct to JSON for insertion
    )
    .fetch_one(pool)
    .await?;

    Ok(query_result.id)
}

/// Updates the status of an existing request in the database.
///
/// # Arguments
///
/// * `pool` - A reference to the PostgreSQL connection pool.
/// * `request_id` - The unique identifier of the request to update.
/// * `status` - The new status to set for the request.
///
/// # Returns
///
/// A `Result` indicating success or failure.
pub async fn update_request(pool: &PgPool, request_id: Uuid, status: RequestStatus) -> Result<()> {
    sqlx::query!(
        "UPDATE requests SET status = $1 WHERE id = $2",
        status as RequestStatus,
        request_id
    )
    .execute(pool)
    .await
    .map_err(|e| Error::msg(format!("Failed to update request: {}", e)))?;

    Ok(())
}

/// Retrieves a request from the database by its unique identifier.
///
/// # Arguments
///
/// * `pool` - A reference to the PostgreSQL connection pool.
/// * `request_id` - The unique identifier of the request to retrieve.
///
/// # Returns
///
/// A `Result` containing the `RequestModel` if found, or an error if not.
pub async fn get_request(pool: &PgPool, request_id: Uuid) -> Result<RequestModel, sqlx::Error> {
    let query_result = sqlx::query_as!(
        RequestModel,
        r#"
        SELECT 
            id, 
            status as "status: RequestStatus", 
            updated_at::timestamp as "updated_at: NaiveDateTime",
            email_tx_auth as "email_tx_auth: Json<EmailTxAuthSchema>"
        FROM requests 
        WHERE id = $1
        "#,
        request_id
    )
    .fetch_optional(pool)
    .await?;

    // If query_result is None, it means no row was found for the given request_id
    query_result.ok_or_else(|| sqlx::Error::RowNotFound)
}

/// Inserts a new expected reply into the database.
///
/// # Arguments
///
/// * `pool` - A reference to the PostgreSQL connection pool.
/// * `message_id` - The unique identifier of the message.
/// * `request_id` - An optional request ID associated with the message.
///
/// # Returns
///
/// A `Result` indicating success or failure.
pub async fn insert_expected_reply(
    pool: &PgPool,
    message_id: &str,
    request_id: Option<String>,
) -> Result<()> {
    sqlx::query!(
        "INSERT INTO expected_replies (message_id, request_id) VALUES ($1, $2)",
        message_id,
        request_id
    )
    .execute(pool)
    .await
    .map_err(|e| Error::msg(format!("Failed to insert expected_reply: {}", e)))?;

    Ok(())
}
