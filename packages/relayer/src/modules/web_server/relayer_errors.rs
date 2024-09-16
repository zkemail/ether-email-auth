use crate::*;
use axum::{
    response::{IntoResponse, Response},
    Json,
};
use handlebars::RenderError;
use relayer_utils::ExtractSubstrssError;
use reqwest::StatusCode;
use rustc_hex::FromHexError;
use serde_json::json;
use thiserror::Error;

#[derive(Error, Debug)]
pub enum ApiError {
    #[error("Database error: {0}")]
    Database(#[from] DatabaseError),
    #[error("Sqlx error: {0}")]
    SqlxError(#[from] sqlx::Error),
    #[error("Validation error: {0}")]
    Validation(String),
    #[error("Chain error: {0}")]
    Chain(#[from] ChainError),
    // #[error("Not found: {0}")]
    // NotFound(String),
    #[error("Anyhow error: {0}")]
    Anyhow(#[from] anyhow::Error),
    #[error("Internal error: {0}")]
    Internal(String),
    #[error("Error recieving email: {0}")]
    Email(#[from] EmailError),
}

#[derive(Error, Debug)]
pub enum EmailError {
    #[error("Email body error: {0}")]
    Body(String),
    #[error("Email address error: {0}")]
    EmailAddress(String),
    #[error("Parse error: {0}")]
    Parse(String),
    #[error("DKIM error: {0}")]
    Dkim(String),
    #[error("ZkRegex error: {0}")]
    ZkRegex(#[from] ExtractSubstrssError),
    #[error("Database error: {0}")]
    Database(#[from] DatabaseError),
    #[error("Not found: {0}")]
    NotFound(String),
    #[error("Circuit error: {0}")]
    Circuit(String),
    #[error("Chain error: {0}")]
    Chain(#[from] ChainError),
    #[error("File not found error: {0}")]
    FileNotFound(String),
    #[error("Render error: {0}")]
    Render(#[from] RenderError),
    #[error("Failed to send email: {0}")]
    Send(String),
    #[error("Hex error: {0}")]
    HexError(#[from] hex::FromHexError),
    #[error("ABI encode error: {0}")]
    AbiError(String),
    // Currently used with some relayer-utils errors
    #[error("Anyhow error: {0}")]
    Anyhow(#[from] anyhow::Error),
}

#[derive(Error, Debug)]
pub enum ChainError {
    #[error("Contract error: {0}")]
    Contract(ContractErrorWrapper),
    #[error("Signer middleware error: {0}")]
    SignerMiddleware(SignerMiddlewareErrorWrapper),
    #[error("Hex error: {0}")]
    HexError(#[from] FromHexError),
    #[error("Provider error: {0}")]
    Provider(ProviderErrorWrapper),
    #[error("Anyhow error: {0}")]
    Anyhow(#[from] anyhow::Error),
    #[error("Validation error: {0}")]
    Validation(String),
}

impl ChainError {
    pub fn contract_error<M: Middleware>(msg: &str, err: ContractError<M>) -> Self {
        Self::Contract(ContractErrorWrapper::new(msg.to_string(), err))
    }

    pub fn signer_middleware_error<M: Middleware, S: Signer>(
        msg: &str,
        err: signer::SignerMiddlewareError<M, S>,
    ) -> Self {
        Self::SignerMiddleware(SignerMiddlewareErrorWrapper::new(msg.to_string(), err))
    }

    pub fn provider_error(msg: &str, err: ethers::providers::ProviderError) -> Self {
        Self::Provider(ProviderErrorWrapper::new(msg.to_string(), err))
    }
}

#[derive(Debug, thiserror::Error)]
#[error("{msg}: {source}")]
pub struct DatabaseError {
    #[source]
    pub source: sqlx::Error,
    pub msg: String,
}

impl DatabaseError {
    pub fn new(msg: &str, source: sqlx::Error) -> Self {
        Self {
            source,
            msg: msg.to_string(),
        }
    }
}

#[derive(Debug)]
pub struct ContractErrorWrapper {
    msg: String,
    source: String,
}

impl std::fmt::Display for ContractErrorWrapper {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}: {}", self.msg, self.source)
    }
}

impl ContractErrorWrapper {
    pub fn new<M: Middleware>(msg: String, err: ContractError<M>) -> Self {
        ContractErrorWrapper {
            msg,
            source: err.to_string(),
        }
    }
}

#[derive(Debug)]
pub struct SignerMiddlewareErrorWrapper {
    msg: String,
    source: String,
}

impl std::fmt::Display for SignerMiddlewareErrorWrapper {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}: {}", self.msg, self.source)
    }
}

impl SignerMiddlewareErrorWrapper {
    pub fn new<M: Middleware, S: Signer>(
        msg: String,
        err: signer::SignerMiddlewareError<M, S>,
    ) -> Self {
        SignerMiddlewareErrorWrapper {
            msg,
            source: err.to_string(),
        }
    }
}

#[derive(Debug)]
pub struct ProviderErrorWrapper {
    msg: String,
    source: ethers::providers::ProviderError,
}

impl std::fmt::Display for ProviderErrorWrapper {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}: {}", self.msg, self.source)
    }
}

impl ProviderErrorWrapper {
    pub fn new(msg: String, err: ethers::providers::ProviderError) -> Self {
        ProviderErrorWrapper { msg, source: err }
    }
}

impl ApiError {
    pub fn database_error(msg: &str, source: sqlx::Error) -> Self {
        Self::Database(DatabaseError::new(msg, source))
    }
}

impl IntoResponse for ApiError {
    fn into_response(self) -> Response {
        let (status, error_message) = match self {
            ApiError::Database(e) => (StatusCode::INTERNAL_SERVER_ERROR, e.to_string()),
            ApiError::Chain(e) => (StatusCode::INTERNAL_SERVER_ERROR, e.to_string()),
            ApiError::SqlxError(e) => (StatusCode::INTERNAL_SERVER_ERROR, e.to_string()),
            ApiError::Validation(e) => (StatusCode::BAD_REQUEST, e.to_string()),
            ApiError::Anyhow(e) => (StatusCode::INTERNAL_SERVER_ERROR, e.to_string()),
            ApiError::Internal(e) => (StatusCode::INTERNAL_SERVER_ERROR, e.to_string()),
            ApiError::Email(e) => match e {
                EmailError::Body(e) => (StatusCode::BAD_REQUEST, e.to_string()),
                EmailError::EmailAddress(e) => (StatusCode::BAD_REQUEST, e.to_string()),
                EmailError::Parse(e) => (StatusCode::BAD_REQUEST, e.to_string()),
                EmailError::NotFound(e) => (StatusCode::BAD_REQUEST, e.to_string()),
                EmailError::Dkim(e) => (StatusCode::INTERNAL_SERVER_ERROR, e.to_string()),
                EmailError::ZkRegex(e) => (StatusCode::INTERNAL_SERVER_ERROR, e.to_string()),
                EmailError::Database(e) => (StatusCode::INTERNAL_SERVER_ERROR, e.to_string()),
                EmailError::HexError(e) => (StatusCode::INTERNAL_SERVER_ERROR, e.to_string()),
                EmailError::AbiError(e) => (StatusCode::INTERNAL_SERVER_ERROR, e.to_string()),
                EmailError::Circuit(e) => (StatusCode::INTERNAL_SERVER_ERROR, e.to_string()),
                EmailError::Chain(e) => (StatusCode::INTERNAL_SERVER_ERROR, e.to_string()),
                EmailError::FileNotFound(e) => (StatusCode::INTERNAL_SERVER_ERROR, e.to_string()),
                EmailError::Render(e) => (StatusCode::INTERNAL_SERVER_ERROR, e.to_string()),
                EmailError::Send(e) => (StatusCode::INTERNAL_SERVER_ERROR, e.to_string()),
                EmailError::Anyhow(e) => (StatusCode::INTERNAL_SERVER_ERROR, e.to_string()),
            },
        };
        (status, Json(json!({ "error": error_message }))).into_response()
    }
}
