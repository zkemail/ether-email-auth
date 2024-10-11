use std::fmt::Display;

use anyhow::{Error, Ok, Result};
use chrono::{DateTime, NaiveDateTime, Utc};
use serde::{Deserialize, Serialize};
use sqlx::types::Json;
use sqlx::{FromRow, PgPool};
use uuid::Uuid;

use crate::schema::EmailTxAuthSchema;

#[derive(Debug, FromRow, Deserialize, Serialize, Clone)]
#[allow(non_snake_case)]
pub struct RequestModel {
    pub id: Uuid,
    pub status: String,
    #[serde(rename = "updatedAt")]
    pub updated_at: Option<NaiveDateTime>,
    #[serde(rename = "emailTxAuth")]
    pub email_tx_auth: EmailTxAuthSchema,
}

#[derive(Debug, FromRow, Deserialize, Serialize)]
#[allow(non_snake_case)]
pub struct ExpectedReplyModel {
    pub message_id: String,
    pub request_id: Option<String>,
    pub has_reply: Option<bool>,
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
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        write!(f, "{:?}", self)
    }
}

impl From<RequestStatus> for String {
    fn from(status: RequestStatus) -> Self {
        status.to_string()
    }
}

impl From<sqlx::types::Json<EmailTxAuthSchema>> for EmailTxAuthSchema {
    fn from(json: sqlx::types::Json<EmailTxAuthSchema>) -> Self {
        json.0
    }
}

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

pub async fn is_valid_reply(pool: &PgPool, message_id: &str) -> Result<bool> {
    let query_result = sqlx::query!(
        "UPDATE expected_replies
         SET has_reply = true
         WHERE message_id = $1 AND has_reply = false
         RETURNING has_reply",
        message_id
    )
    .fetch_one(pool)
    .await
    .map_err(|e| Error::msg(format!("Failed to validate reply: {}", e)))?;

    Ok(query_result.has_reply.unwrap_or(false))
}
