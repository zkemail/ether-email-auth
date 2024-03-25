use crate::*;

use std::sync::atomic::Ordering;

use axum::{routing::MethodRouter, Router};
use serde::{Deserialize, Serialize};
use tokio::sync::mpsc::UnboundedSender;
use tower_http::cors::{AllowHeaders, AllowMethods, Any, CorsLayer};

#[derive(Serialize, Deserialize)]
pub struct RequestStatusRequest {
    pub request_id: i64,
}

#[derive(Serialize, Deserialize)]
pub enum RequestStatus {
    NotExist = 0,
    Pending = 1,
    Processed = 2,
}

#[derive(Serialize, Deserialize)]
pub struct RequestStatusResponse {
    pub request_id: i64,
    pub status: RequestStatus,
    pub is_success: bool,
    pub email_nullifier: Option<String>,
    pub account_salt: Option<String>,
    pub is_code_exist: Option<bool>,
}

#[derive(Serialize, Deserialize)]
pub struct AcceptanceRequest {
    pub wallet_eth_addr: String,
    pub guardian_email_addr: String,
    pub account_code: String,
    pub template_idx: u64,
    pub subject: String,
}

#[derive(Serialize, Deserialize)]
pub struct AcceptanceResponse {
    pub request_id: i64,
    pub subject_params: Vec<String>,
}

#[derive(Serialize, Deserialize)]
pub struct RecoveryRequest {
    pub wallet_eth_addr: String,
    pub guardian_email_addr: String,
    pub template_idx: u64,
    pub subject: String,
}

#[derive(Serialize, Deserialize)]
pub struct RecoveryResponse {
    pub request_id: i64,
    pub subject_params: Vec<String>,
}

#[named]
async fn requestStatus(payload: String, db: Arc<Database>) -> Result<RequestStatusResponse> {
    let req = serde_json::from_str::<RequestStatusRequest>(&payload)
        .map_err(|_| anyhow!("Invalid payload json".to_string()))?;
    let request_id = req.request_id;
    let row = db.get_requests_row(request_id).await?;
    match row {
        None => Ok(RequestStatusResponse {
            request_id,
            status: RequestStatus::NotExist,
            is_success: false,
            email_nullifier: None,
            account_salt: None,
            is_code_exist: None,
        }),
        Some(row) => {
            let status = if row.is_processed {
                RequestStatus::Processed
            } else {
                RequestStatus::Pending
            };
            Ok(RequestStatusResponse {
                request_id,
                status,
                is_success: row.is_success.unwrap_or(false),
                email_nullifier: if row.is_processed {
                    row.email_nullifier
                } else {
                    None
                },
                account_salt: if row.is_processed {
                    row.account_salt
                } else {
                    None
                },
                is_code_exist: if row.is_processed {
                    row.is_code_exist
                } else {
                    None
                },
            })
        }
    }
}

// #[named]
// async fn acceptanceRequest(payload: String, db: Arc<Database>) -> Result<RequestStatusResponse> {
//     let req = serde_json::from_str::<AcceptanceRequest>(&payload)
//         .map_err(|_| anyhow!("Invalid payload json".to_string()))?;

// }
// #[named]
// async fn unclaim(
//     payload: UnclaimRequest,
//     db: Arc<Database>,
//     chain_client: Arc<ChainClient>,
//     tx_claimer: UnboundedSender<Claim>,
// ) -> Result<String> {
//     let padded_email_addr = PaddedEmailAddr::from_email_addr(&payload.email_address);
//     info!(
//         LOG,
//         "padded email address fields: {:?}",
//         padded_email_addr.to_email_addr_fields(); "func" => function_name!()
//     );
//     let commit = padded_email_addr.to_commitment(&hex2field(&payload.random)?)?;
//     info!(LOG, "commit {:?}", commit; "func" => function_name!());
//     let id = chain_client
//         .get_unclaim_id_from_tx_hash(&payload.tx_hash, payload.is_fund)
//         .await?;
//     info!(LOG, "id {:?}", id; "func" => function_name!());
//     // let psi_client = PSIClient::new(
//     //     Arc::clone(&chain_client),
//     //     payload.email_address.clone(),
//     //     id,
//     //     payload.is_fund,
//     // )
//     // .await?;
//     // psi_client
//     //     .check_and_reveal(db.clone(), chain_client.clone(), &payload.email_address)
//     //     .await?;
//     let claim = Claim {
//         id,
//         email_address: payload.email_address.clone(),
//         random: payload.random.clone(),
//         commit: field2hex(&commit),
//         expiry_time: payload.expiry_time,
//         is_fund: payload.is_fund,
//         is_announced: false,
//         is_seen: false,
//     };
//     tx_claimer.send(claim)?;
//     trace!(LOG, "claim sent to tx_claimer"; "func" => function_name!());

//     Ok(format!(
//         "Unclaimed {} for {} is accepted",
//         if payload.is_fund { "fund" } else { "state" },
//         payload.email_address
//     ))
// }

// #[named]
// pub(crate) async fn run_server(
//     addr: &str,
//     routes: Vec<(String, MethodRouter)>,
//     db: Arc<Database>,
//     chain_client: Arc<ChainClient>,
//     tx_claimer: UnboundedSender<Claim>,
// ) -> Result<()> {
//     let chain_client_check_clone = Arc::clone(&chain_client);
//     let chain_client_reveal_clone = Arc::clone(&chain_client);
//     let tx_claimer_reveal_clone = tx_claimer.clone();

//     let mut app = Router::new()
//         .route(
//             "/api/emailAddrCommit",
//             axum::routing::post(move |payload: String| async move {
//                 info!(LOG, "/emailAddrCommit Received payload: {}", payload; "func" => function_name!());
//                 let json = serde_json::from_str::<EmailAddrCommitRequest>(&payload)
//                     .map_err(|_| "Invalid payload json".to_string())
//                     .unwrap();
//                 let padded_email_addr = PaddedEmailAddr::from_email_addr(&json.email_address);
//                 let commit = padded_email_addr
//                     .to_commitment(&hex2field(&json.random).unwrap())
//                     .unwrap();
//                 info!(LOG, "commit {:?}", commit; "func" => function_name!());
//                 field2hex(&commit)
//             }),
//         )
//         .route(
//             "/api/unclaim",
//             axum::routing::post(move |payload: String| async move {
//                 info!(LOG, "/unclaim Received payload: {}", payload; "func" => function_name!());
//                 let json = serde_json::from_str::<UnclaimRequest>(&payload)
//                     .map_err(|_| "Invalid payload json".to_string())?;
//                 unclaim(json, db, chain_client, tx_claimer)
//                     .await
//                     .map_err(|err| {
//                         error!(LOG, "Failed to accept unclaim: {}", err; "func" => function_name!());
//                         err.to_string()
//                     })
//             }),
//         )
//         .route(
//             "/api/stats",
//             axum::routing::get(move || async move {
//                 let stats = StatResponse {
//                     onboarding_tokens_distributed: ONBOARDING_COUNTER.load(Ordering::SeqCst),
//                     onboarding_tokens_left: *ONBOARDING_TOKEN_DISTRIBUTION_LIMIT.get().unwrap()
//                         - ONBOARDING_COUNTER.load(Ordering::SeqCst),
//                 };
//                 axum::Json(stats)
//             }),
//         )
//         .route(
//             "/api/serveCheck/",
//             axum::routing::post(move |payload: String| async move {
//                 info!(LOG, "/serveCheck Received payload: {}", payload; "func" => function_name!());
//                 let json = serde_json::from_str::<CheckRequest>(&payload)
//                     .map_err(|_| "Invalid payload json".to_string())?;
//                 serve_check_request(json, chain_client_check_clone)
//                     .await
//                     .map_err(|err| {
//                         error!(LOG, "Failed PSI check serve: {}", err; "func" => function_name!());
//                         err.to_string()
//                     })
//             }),
//         )
//         .route(
//             "/api/serveReveal/",
//             axum::routing::post(move |payload: String| async move {
//                 info!(LOG, "/serveCheck Received payload: {}", payload; "func" => function_name!());
//                 let json = serde_json::from_str::<RevealRequest>(&payload)
//                     .map_err(|_| "Invalid payload json".to_string())?;
//                 serve_reveal_request(json, chain_client_reveal_clone, tx_claimer_reveal_clone)
//                     .await
//                     .map_err(|err| {
//                         error!(LOG, "Failed PSI reveal serve: {}", err; "func" => function_name!());
//                         err.to_string()
//                     })
//             }),
//         );
//     for (path, router) in routes {
//         app = app.route(&path, router);
//     }
//     app = app.layer(
//         CorsLayer::new()
//             .allow_methods(AllowMethods::any())
//             .allow_headers(AllowHeaders::any())
//             .allow_origin(Any),
//     );

//     trace!(LOG, "Listening API at {}", addr; "func" => function_name!());
//     axum::Server::bind(&addr.parse()?)
//         .serve(app.into_make_service())
//         .await?;

//     Ok(())
// }
