use crate::*;
use axum::Router;
use relayer_utils::LOG;
use tower_http::cors::{AllowHeaders, AllowMethods, Any, CorsLayer};

#[named]
pub async fn run_server() -> Result<()> {
    let addr = WEB_SERVER_ADDRESS.get().unwrap();

    let mut app = Router::new()
        .route(
            "/api/echo",
            axum::routing::get(move || async move { "Hello, world!" }),
        )
        .route(
            "/api/requestStatus",
            axum::routing::post(move |payload: String| async move {
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
                        let acceptance_response = handle_acceptance_request(payload).await;
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
                        let recovery_response = handle_recovery_request(payload).await;
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
            "/api/completeRequest",
            axum::routing::post(move |payload: String| async move {
                let payload: Result<CompleteRecoveryRequest> =
                    serde_json::from_str(&payload).map_err(|e| anyhow::Error::from(e));
                match payload {
                    Ok(payload) => {
                        let recovery_response = handle_complete_recovery_request(payload).await;
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
            "/api/getAccountSalt",
            axum::routing::post(move |payload: String| async move {
                let payload: Result<GetAccountSaltRequest> =
                    serde_json::from_str(&payload).map_err(|e| anyhow::Error::from(e));
                match payload {
                    Ok(payload) => {
                        let response = get_account_salt(payload).await;
                        Ok::<_, axum::response::Response>(response)
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
            "/api/receiveEmail",
            axum::routing::post::<_, _, (), _>(move |payload: String| async move {
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

    trace!(LOG, "Listening API at {}", addr; "func" => function_name!());
    axum::Server::bind(&addr.parse()?)
        .serve(app.into_make_service())
        .await?;

    Ok(())
}
