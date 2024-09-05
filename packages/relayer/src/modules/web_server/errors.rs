use crate::*;
use axum::{
    response::{IntoResponse, Response},
    Json,
};
use reqwest::StatusCode;
use rustc_hex::FromHexError;
use serde_json::json;
use thiserror::Error;

#[derive(Error, Debug)]
pub enum ApiError {
    #[error("Database error: {0}")]
    Database(DatabaseError),
    #[error("Sqlx error: {0}")]
    SqlxError(#[from] sqlx::Error),
    #[error("Contract error: {0}")]
    Contract(ContractErrorWrapper),
    #[error("Signer middleware error: {0}")]
    SignerMiddleware(SignerMiddlewareErrorWrapper),
    #[error("Validation error: {0}")]
    Validation(String),
    // #[error("Not found: {0}")]
    // NotFound(String),
    #[error("Provider error: {0}")]
    Provider(ProviderErrorWrapper),
    #[error("Hex error: {0}")]
    HexError(#[from] FromHexError),
    #[error("Anyhow error: {0}")]
    Anyhow(#[from] anyhow::Error),
    #[error("Internal error: {0}")]
    Internal(String),
}

#[derive(Debug, thiserror::Error)]
#[error("{msg}: {source}")]
pub struct DatabaseError {
    #[source]
    pub source: sqlx::Error,
    pub msg: String,
}

impl DatabaseError {
    pub fn new(source: sqlx::Error, msg: String) -> Self {
        Self { source, msg }
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
        Self::Database(DatabaseError::new(source, msg.to_string()))
    }

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

impl IntoResponse for ApiError {
    fn into_response(self) -> Response {
        let (status, error_message) = match self {
            ApiError::Database(e) => (StatusCode::INTERNAL_SERVER_ERROR, e.to_string()),
            ApiError::Contract(e) => (StatusCode::INTERNAL_SERVER_ERROR, e.to_string()),
            ApiError::SignerMiddleware(e) => (StatusCode::INTERNAL_SERVER_ERROR, e.to_string()),
            ApiError::SqlxError(e) => (StatusCode::INTERNAL_SERVER_ERROR, e.to_string()),
            ApiError::Validation(e) => (StatusCode::BAD_REQUEST, e),
            // ApiError::NotFound(e) => (StatusCode::NOT_FOUND, e),
            ApiError::Provider(e) => (StatusCode::INTERNAL_SERVER_ERROR, e.to_string()),
            ApiError::Anyhow(e) => (StatusCode::INTERNAL_SERVER_ERROR, e.to_string()),
            ApiError::HexError(e) => (StatusCode::INTERNAL_SERVER_ERROR, e.to_string()),
            ApiError::Internal(e) => (StatusCode::INTERNAL_SERVER_ERROR, e.to_string()),
        };
        (status, Json(json!({ "error": error_message }))).into_response()
    }
}
