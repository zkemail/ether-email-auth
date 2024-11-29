use anyhow::{Error, Ok, Result};
use bigdecimal::BigDecimal;
use chrono::{DateTime, NaiveDateTime, Utc};
use ethers::types::U256;
use relayer_utils::u256_to_bytes32;
use serde::{Deserialize, Serialize};
use serde_json::Value;
use sqlx::types::Json;
use sqlx::{FromRow, PgPool};
use uuid::Uuid;

use crate::abis::EmailAuthMsg;
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

#[derive(Debug, Serialize, Deserialize, FromRow)]
#[serde(rename_all = "camelCase")]
pub struct EmailAuthMsgModel {
    pub id: Uuid,
    pub template_id: String,
    pub request_id: String,
    pub command_params: Vec<String>,
    pub skipped_command_prefix: String,
    // EmailProof fields
    pub domain_name: String,
    pub public_key_hash: Vec<u8>,
    pub timestamp: String,
    pub masked_command: String,
    pub email_nullifier: Vec<u8>,
    pub account_salt: Vec<u8>,
    pub is_code_exist: bool,
    pub proof: String,
    pub created_at: DateTime<Utc>,
}

impl EmailAuthMsgModel {
    pub fn from_email_auth_msg(email_auth_msg: EmailAuthMsg, request_id: String) -> Self {
        Self {
            id: Uuid::new_v4(),
            template_id: email_auth_msg.template_id.to_string(),
            request_id,
            command_params: email_auth_msg
                .command_params
                .iter()
                .map(|param| param.to_string())
                .collect(),
            skipped_command_prefix: email_auth_msg.skipped_command_prefix.to_string(),
            domain_name: email_auth_msg.proof.domain_name,
            public_key_hash: email_auth_msg.proof.public_key_hash.to_vec(),
            timestamp: email_auth_msg.proof.timestamp.to_string(),
            masked_command: email_auth_msg.proof.masked_command,
            email_nullifier: email_auth_msg.proof.email_nullifier.to_vec(),
            account_salt: email_auth_msg.proof.account_salt.to_vec(),
            is_code_exist: email_auth_msg.proof.is_code_exist,
            proof: email_auth_msg.proof.proof.to_string(),
            created_at: Utc::now(),
        }
    }

    pub async fn save(&self, pool: &PgPool) -> Result<()> {
        let _ = sqlx::query!(
            "INSERT INTO email_auth_messages (template_id, request_id, command_params, skipped_command_prefix, domain_name, public_key_hash, timestamp, masked_command, email_nullifier, account_salt, is_code_exist, proof) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)",
            self.template_id, self.request_id, &self.command_params, self.skipped_command_prefix, self.domain_name, self.public_key_hash, self.timestamp, self.masked_command, self.email_nullifier, self.account_salt, self.is_code_exist, self.proof
        )
            .execute(pool)
            .await
            .map_err(|e| Error::msg(format!("Failed to save email auth msg: {}", e)));

        Ok(())
    }

    pub async fn find_by_request_id(pool: &PgPool, request_id: Uuid) -> Result<Self> {
        let email_auth_msg = sqlx::query_as!(
            EmailAuthMsgModel,
            r#"SELECT id, template_id, request_id, command_params, skipped_command_prefix, 
            domain_name, public_key_hash, timestamp, masked_command, email_nullifier, 
            account_salt, is_code_exist, proof, 
            created_at as "created_at: DateTime<Utc>"
            FROM email_auth_messages WHERE request_id = $1"#,
            request_id.to_string()
        )
        .fetch_one(pool)
        .await?;
        Ok(email_auth_msg)
    }
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
