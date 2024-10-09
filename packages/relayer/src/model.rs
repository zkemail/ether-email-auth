use anyhow::{Error, Ok, Result};
use serde::{Deserialize, Serialize};
use sqlx::{FromRow, PgPool, Row};
use uuid::Uuid;

#[derive(Debug, FromRow, Deserialize, Serialize)]
#[allow(non_snake_case)]
pub struct RequestModel {
    pub id: Uuid,
    pub status: String,
    #[serde(rename = "updatedAt")]
    pub updated_at: Option<chrono::DateTime<chrono::Utc>>,
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

pub async fn create_request(pool: &PgPool) -> Result<Uuid> {
    let query_result = sqlx::query!("INSERT INTO requests DEFAULT VALUES RETURNING id")
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
