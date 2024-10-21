use crate::*;
use axum::{routing::post, Router};
use relayer_utils::LOG;
use tower_http::cors::{AllowHeaders, AllowMethods, Any, CorsLayer};

/// Runs the server and sets up the API routes.
///
/// # Returns
///
/// A `Result` indicating success or failure.
pub async fn run_server() -> Result<()> {
    let addr = WEB_SERVER_ADDRESS.get().unwrap();

    // Initialize the global DB ref before starting the server
    DB_CELL
        .get_or_init(|| async {
            dotenv::dotenv().ok();
            let db = Database::open(&std::env::var("DATABASE_URL").unwrap())
                .await
                .unwrap();
            Arc::new(db)
        })
        .await;

    info!(LOG, "Testing connection to database");
    if let Err(e) = DB.test_db_connection().await {
        error!(LOG, "Failed to initialize db with e: {}", e);
        panic!("Forcing panic, since connection to DB could not be established");
    };
    info!(LOG, "Testing connection to database successfull");

    // Initialize the API routes
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
        .route("/api/receiveEmail", post(receive_email_api_fn));

    app = app.layer(
        CorsLayer::new()
            .allow_methods(AllowMethods::any())
            .allow_headers(AllowHeaders::any())
            .allow_origin(Any),
    );

    // Start the server
    trace!(LOG, "Listening API at {}", addr);
    axum::Server::bind(&addr.parse()?)
        .serve(app.into_make_service())
        .await?;

    Ok(())
}
