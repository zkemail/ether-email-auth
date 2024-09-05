use crate::*;
use axum::{routing::post, Router};
use relayer_utils::LOG;
use tower_http::cors::{AllowHeaders, AllowMethods, Any, CorsLayer};

pub async fn run_server() -> Result<()> {
    let addr = WEB_SERVER_ADDRESS.get().unwrap();

    let mut app = Router::new()
        .route(
            "/api/echo",
            axum::routing::get(move || async move { "Hello, world!" }),
        )
        .route("/api/requestStatus", post(request_status_api))
        .route("/api/acceptanceRequest", post(handle_acceptance_request))
        .route("/api/recoveryRequest", post(handle_recovery_request))
        .route(
            "/api/completeRequest",
            post(handle_complete_recovery_request),
        )
        .route("/api/getAccountSalt", post(get_account_salt))
        .route("/api/inactiveGuardian", post(inactive_guardian))
        .route(
            "/api/receiveEmail",
            axum::routing::post::<_, _, (), _>(move |payload: String| async move {
                println!("/api/receiveEmail");
                info!(LOG, "Receive email payload: {}", payload);
                match receive_email_api_fn(payload).await {
                    Ok(_) => "Request processed".to_string(),
                    Err(err) => {
                        error!(LOG, "Failed to complete the receive email request: {}", err);
                        err.to_string()
                    }
                }
            }),
        );

    app = app.layer(
        CorsLayer::new()
            .allow_methods(AllowMethods::any())
            .allow_headers(AllowHeaders::any())
            .allow_origin(Any),
    );

    trace!(LOG, "Listening API at {}", addr);
    axum::Server::bind(&addr.parse()?)
        .serve(app.into_make_service())
        .await?;

    Ok(())
}
