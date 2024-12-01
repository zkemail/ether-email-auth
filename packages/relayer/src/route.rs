use std::sync::Arc;

use axum::{
    routing::{get, post},
    Router,
};

use crate::{
    handler::{
        account_salt_handler, get_status_handler, health_checker_handler, receive_email_handler,
        submit_handler,
    },
    RelayerState,
};

/// Creates and configures the router for the relayer service.
///
/// This function sets up the routes for the API endpoints and associates them with their respective handlers.
/// It also attaches the shared state to the router.
///
/// # Arguments
///
/// * `relayer_state` - An `Arc` containing the shared state of the relayer, which includes configuration and resources.
///
/// # Returns
///
/// A `Router` configured with the necessary routes and state.
pub fn create_router(relayer_state: Arc<RelayerState>) -> Router {
    Router::new()
        // Route for health check endpoint
        .route("/api/healthz", get(health_checker_handler))
        // Route for submitting email transaction authentication requests
        .route("/api/submit", post(submit_handler))
        // Route for computing the account salt
        .route("/api/accountSalt", post(account_salt_handler))
        // Route for receiving emails
        .route("/api/receiveEmail", post(receive_email_handler))
        // Route for retrieving the status of a specific request
        .route("/api/status/:id", get(get_status_handler))
        // Attach the shared state to the router
        .with_state(relayer_state)
}
