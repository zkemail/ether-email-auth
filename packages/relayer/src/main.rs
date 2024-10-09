mod config;
mod handler;
mod mail;
mod model;
mod route;
mod schema;
mod utils;

use std::sync::Arc;

use anyhow::Result;
use axum::http::{
    header::{ACCEPT, AUTHORIZATION, CONTENT_TYPE},
    Method,
};
use relayer_utils::LOG;
use reqwest::Client;
use route::create_router;
use slog::info;
use sqlx::{postgres::PgPoolOptions, Pool, Postgres};
use tower_http::cors::CorsLayer;

use config::Config;

#[derive(Debug, Clone)]
pub struct RelayerState {
    http_client: Client,
    config: Config,
    db: Pool<Postgres>,
}

#[tokio::main]
async fn main() -> Result<()> {
    let config = config::load_config()?;
    info!(LOG, "Loaded configuration: {:?}", config);

    let pool = PgPoolOptions::new()
        .max_connections(10)
        .connect(&config.database_url)
        .await?;
    info!(LOG, "Database connection established.");

    let cors = CorsLayer::new()
        .allow_origin(tower_http::cors::Any)
        .allow_methods([Method::GET, Method::POST])
        .allow_headers([AUTHORIZATION, ACCEPT, CONTENT_TYPE]);

    let relayer = create_router(Arc::new(RelayerState {
        http_client: Client::new(),
        config: config.clone(),
        db: pool.clone(),
    }))
    .layer(cors);

    let listener = tokio::net::TcpListener::bind(format!("0.0.0.0:{}", config.port)).await?;
    info!(LOG, "Serving relayer on port: {}", config.port);
    axum::serve(listener, relayer).await?;

    Ok(())
}
