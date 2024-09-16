#![allow(dead_code)]
#![allow(unused_variables)]
#![allow(unreachable_code)]

pub mod abis;
pub mod chain;
pub mod config;
pub mod core;
pub mod database;
pub mod modules;
pub mod strings;

pub use abis::*;
pub use chain::*;
pub use config::*;
pub use core::*;
pub use database::*;
pub use modules::*;
use relayer_utils::LOG;
pub use strings::*;

use tokio::sync::Mutex;

use anyhow::{anyhow, Result};
use dotenv::dotenv;
use ethers::prelude::*;
use lazy_static::lazy_static;
use relayer_utils::{converters::*, cryptos::*, parse_email::ParsedEmail};
use slog::{error, info, trace};
use std::env;
use std::path::PathBuf;
use std::sync::{Arc, OnceLock};
use tokio::time::Duration;

pub static CIRCUITS_DIR_PATH: OnceLock<PathBuf> = OnceLock::new();
pub static WEB_SERVER_ADDRESS: OnceLock<String> = OnceLock::new();
pub static PROVER_ADDRESS: OnceLock<String> = OnceLock::new();
pub static PRIVATE_KEY: OnceLock<String> = OnceLock::new();
pub static CHAIN_ID: OnceLock<u32> = OnceLock::new();
pub static EMAIL_ACCOUNT_RECOVERY_VERSION_ID: OnceLock<u8> = OnceLock::new();
pub static CHAIN_RPC_PROVIDER: OnceLock<String> = OnceLock::new();
pub static CHAIN_RPC_EXPLORER: OnceLock<String> = OnceLock::new();
pub static EMAIL_TEMPLATES: OnceLock<String> = OnceLock::new();
pub static RELAYER_EMAIL_ADDRESS: OnceLock<String> = OnceLock::new();
pub static SMTP_SERVER: OnceLock<String> = OnceLock::new();

lazy_static! {
    pub static ref DB: Arc<Database> = {
        dotenv().ok();
        let db = tokio::task::block_in_place(|| {
            tokio::runtime::Runtime::new()
                .unwrap()
                .block_on(Database::open(&env::var(DATABASE_PATH_KEY).unwrap()))
        })
        .unwrap();
        Arc::new(db)
    };
    pub static ref CLIENT: Arc<ChainClient> = {
        dotenv().ok();
        let client = tokio::task::block_in_place(|| {
            tokio::runtime::Runtime::new()
                .unwrap()
                .block_on(ChainClient::setup())
        })
        .unwrap();
        Arc::new(client)
    };
    pub static ref SHARED_MUTEX: Arc<Mutex<i32>> = Arc::new(Mutex::new(0));
}

pub async fn run(config: RelayerConfig) -> Result<()> {
    info!(LOG, "Starting relayer");

    CIRCUITS_DIR_PATH.set(config.circuits_dir_path).unwrap();
    WEB_SERVER_ADDRESS.set(config.web_server_address).unwrap();
    PROVER_ADDRESS.set(config.prover_address).unwrap();
    PRIVATE_KEY.set(config.private_key).unwrap();
    CHAIN_ID.set(config.chain_id).unwrap();
    CHAIN_RPC_PROVIDER.set(config.chain_rpc_provider).unwrap();
    CHAIN_RPC_EXPLORER.set(config.chain_rpc_explorer).unwrap();
    EMAIL_ACCOUNT_RECOVERY_VERSION_ID
        .set(config.email_account_recovery_version_id)
        .unwrap();
    EMAIL_TEMPLATES.set(config.email_templates).unwrap();
    RELAYER_EMAIL_ADDRESS
        .set(config.relayer_email_addr)
        .unwrap();
    SMTP_SERVER.set(config.smtp_server).unwrap();

    let api_server_task = tokio::task::spawn(async move {
        loop {
            match run_server().await {
                Ok(_) => {
                    info!(LOG, "run_server exited normally");
                    break; // Exit loop if run_server exits normally
                }
                Err(err) => {
                    error!(LOG, "Error api server: {}", err);
                    // Optionally, add a delay before restarting
                    tokio::time::sleep(Duration::from_secs(5)).await;
                }
            }
        }
    });

    let _ = tokio::join!(api_server_task);

    Ok(())
}
