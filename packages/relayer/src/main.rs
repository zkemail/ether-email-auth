mod abis;
mod chain;
mod command;
mod config;
mod constants;
mod dkim;
mod handler;
mod mail;
mod model;
mod prove;
mod route;
mod schema;
mod statics;

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

/// Represents the state of the relayer, including HTTP client, configuration, and database pool.
#[derive(Debug, Clone)]
pub struct RelayerState {
    /// The HTTP client used for making network requests.
    http_client: Client,
    /// The configuration settings for the relayer.
    config: Config,
    /// The connection pool for the PostgreSQL database.
    db: Pool<Postgres>,
}

/// The main entry point for the relayer application.
///
/// This asynchronous function loads the configuration, establishes a database connection,
/// sets up CORS, creates the router, and starts the server.
///
/// # Returns
///
/// A `Result` indicating the success or failure of the application startup.
#[tokio::main]
async fn main() -> Result<()> {
    // Load the configuration from the config file or environment
    let config = config::load_config()?;
    info!(LOG, "Loaded configuration: {:?}", config);

    // Establish a connection pool to the PostgreSQL database
    let pool = PgPoolOptions::new()
        .max_connections(10)
        .connect(&config.database_url)
        .await?;
    info!(LOG, "Database connection established.");

    // Set up CORS (Cross-Origin Resource Sharing) policy
    let cors = CorsLayer::new()
        .allow_origin(tower_http::cors::Any)
        .allow_methods([Method::GET, Method::POST])
        .allow_headers([AUTHORIZATION, ACCEPT, CONTENT_TYPE]);

    // Create the router with the relayer state and apply the CORS layer
    let relayer = create_router(Arc::new(RelayerState {
        http_client: Client::new(),
        config: config.clone(),
        db: pool.clone(),
    }))
    .layer(cors);

    // Bind the server to the specified port and start listening for requests
    let listener = tokio::net::TcpListener::bind(format!("0.0.0.0:{}", config.port)).await?;
    info!(LOG, "Serving relayer on port: {}", config.port);
    axum::serve(listener, relayer).await?;

    Ok(())
}
