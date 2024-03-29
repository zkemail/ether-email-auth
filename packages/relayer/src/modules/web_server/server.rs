use crate::*;
use axum::Router;
use tower_http::cors::{AllowHeaders, AllowMethods, Any, CorsLayer};

#[named]
pub async fn run_server(
    addr: &str,
    db: Arc<Database>,
    chain_client: Arc<ChainClient>,
    email_sender: EmailForwardSender,
    tx_event_consumer: UnboundedSender<EmailAuthEvent>,
) -> Result<()> {
    let db_acceptance = Arc::clone(&db);
    let db_recovery = Arc::clone(&db);
    let db_complete_recovery = Arc::clone(&db);
    let chain_client_acceptance = Arc::clone(&chain_client);
    let chain_client_recovery = Arc::clone(&chain_client);
    let chain_client_complete_recovery = Arc::clone(&chain_client);
    let email_sender_acceptance = email_sender.clone();
    let email_sender_recovery = email_sender.clone();
    let tx_event_consumer_acceptance = tx_event_consumer.clone();
    let tx_event_consumer_recovery = tx_event_consumer.clone();

    let mut app = Router::new()
        .route(
            "/api/requestStatus",
            axum::routing::get(move |payload: String| async move {
                let payload: Result<RequestStatusRequest> =
                    serde_json::from_str(&payload).map_err(|e| anyhow::Error::from(e));
                match payload {
                    Ok(payload) => {
                        let response = request_status_api(payload).await;
                        match response {
                            Ok(response) => {
                                let body = serde_json::to_string(&response)
                                    .map_err(|e| axum::http::StatusCode::INTERNAL_SERVER_ERROR)
                                    .unwrap();
                                Ok::<_, axum::response::Response>(
                                    axum::http::Response::builder()
                                        .status(axum::http::StatusCode::OK)
                                        .body(axum::body::Body::from(body))
                                        .unwrap(),
                                )
                            }
                            Err(e) => {
                                let error_message = serde_json::to_string(&e.to_string())
                                    .map_err(|_| axum::http::StatusCode::INTERNAL_SERVER_ERROR)
                                    .unwrap();
                                Ok(axum::http::Response::builder()
                                    .status(axum::http::StatusCode::INTERNAL_SERVER_ERROR)
                                    .body(serde_json::to_string(&e.to_string()).unwrap().into())
                                    .unwrap())
                            }
                        }
                    }
                    Err(e) => {
                        let error_message = serde_json::to_string(&e.to_string())
                            .map_err(|_| axum::http::StatusCode::INTERNAL_SERVER_ERROR)
                            .unwrap();
                        Ok(axum::http::Response::builder()
                            .status(axum::http::StatusCode::INTERNAL_SERVER_ERROR)
                            .body(serde_json::to_string(&e.to_string()).unwrap().into())
                            .unwrap())
                    }
                }
            }),
        )
        .route(
            "/api/acceptanceRequest",
            axum::routing::post(move |payload: String| async move {
                let payload: Result<AcceptanceRequest> =
                    serde_json::from_str(&payload).map_err(|e| anyhow::Error::from(e));
                match payload {
                    Ok(payload) => {
                        let acceptance_response = handle_acceptance_request(
                            payload,
                            db_acceptance,
                            email_sender_acceptance,
                            chain_client_acceptance,
                            tx_event_consumer_acceptance,
                        )
                        .await;
                        Ok::<_, axum::response::Response>(acceptance_response)
                    }
                    Err(e) => {
                        let error_message = serde_json::to_string(&e.to_string())
                            .map_err(|_| axum::http::StatusCode::INTERNAL_SERVER_ERROR)
                            .unwrap();
                        Ok(axum::http::Response::builder()
                            .status(axum::http::StatusCode::INTERNAL_SERVER_ERROR)
                            .body(serde_json::to_string(&e.to_string()).unwrap().into())
                            .unwrap())
                    }
                }
            }),
        )
        .route(
            "/api/recoveryRequest",
            axum::routing::post(move |payload: String| async move {
                let payload: Result<RecoveryRequest> =
                    serde_json::from_str(&payload).map_err(|e| anyhow::Error::from(e));
                match payload {
                    Ok(payload) => {
                        let recovery_response = handle_recovery_request(
                            payload,
                            db_recovery,
                            email_sender_recovery,
                            chain_client_recovery,
                            tx_event_consumer_recovery,
                        )
                        .await;
                        Ok::<_, axum::response::Response>(recovery_response)
                    }
                    Err(e) => {
                        let error_message = serde_json::to_string(&e.to_string())
                            .map_err(|_| axum::http::StatusCode::INTERNAL_SERVER_ERROR)
                            .unwrap();
                        Ok(axum::http::Response::builder()
                            .status(axum::http::StatusCode::INTERNAL_SERVER_ERROR)
                            .body(serde_json::to_string(&e.to_string()).unwrap().into())
                            .unwrap())
                    }
                }
            }),
        )
        .route(
            "/api/completeRecovery",
            axum::routing::post(move |payload: String| async move {
                let payload: Result<CompleteRecoveryRequest> =
                    serde_json::from_str(&payload).map_err(|e| anyhow::Error::from(e));
                match payload {
                    Ok(payload) => {
                        let recovery_response = handle_complete_recovery_request(
                            payload,
                            db_complete_recovery,
                            chain_client_complete_recovery,
                        )
                        .await;
                        Ok::<_, axum::response::Response>(recovery_response)
                    }
                    Err(e) => {
                        let error_message = serde_json::to_string(&e.to_string())
                            .map_err(|_| axum::http::StatusCode::INTERNAL_SERVER_ERROR)
                            .unwrap();
                        Ok(axum::http::Response::builder()
                            .status(axum::http::StatusCode::INTERNAL_SERVER_ERROR)
                            .body(serde_json::to_string(&e.to_string()).unwrap().into())
                            .unwrap())
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

    trace!(LOG, "Listening API at {}", addr; "func" => function_name!());
    axum::Server::bind(&addr.parse()?)
        .serve(app.into_make_service())
        .await?;

    Ok(())
}
