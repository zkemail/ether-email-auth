use std::sync::Arc;

use axum::{
    routing::{get, post},
    Router,
};

use crate::{
    handler::{get_status_handler, health_checker_handler, receive_email_handler, submit_handler},
    RelayerState,
};

pub fn create_router(relayer_state: Arc<RelayerState>) -> Router {
    Router::new()
        .route("/api/healthz", get(health_checker_handler))
        .route("/api/submit", post(submit_handler))
        .route("/api/receiveEmail", post(receive_email_handler))
        .route("/api/status/:id", get(get_status_handler))
        .with_state(relayer_state)
}
