use crate::*;
use ethers::types::U256;
use std::sync::OnceLock;

pub static CIRCUITS_DIR_PATH: OnceLock<PathBuf> = OnceLock::new();
pub static WEB_SERVER_ADDRESS: OnceLock<String> = OnceLock::new();
pub static RELAYER_RAND: OnceLock<String> = OnceLock::new();
pub static PROVER_ADDRESS: OnceLock<String> = OnceLock::new();
pub static PRIVATE_KEY: OnceLock<String> = OnceLock::new();
pub static CHAIN_ID: OnceLock<u32> = OnceLock::new();
pub static CHAIN_RPC_PROVIDER: OnceLock<String> = OnceLock::new();
pub static CHAIN_RPC_EXPLORER: OnceLock<String> = OnceLock::new();
pub static CORE_CONTRACT_ADDRESS: OnceLock<String> = OnceLock::new();
pub static FEE_PER_GAS: OnceLock<U256> = OnceLock::new();
pub static INPUT_FILES_DIR: OnceLock<String> = OnceLock::new();
pub static RECEIVED_EMAILS_DIR: OnceLock<String> = OnceLock::new();
pub static EMAIL_TEMPLATES: OnceLock<String> = OnceLock::new();
pub static RELAYER_EMAIL_ADDRESS: OnceLock<String> = OnceLock::new();
pub static CANISTER_ID: OnceLock<String> = OnceLock::new();
pub static IC_PEM_PATH: OnceLock<String> = OnceLock::new();
pub static IC_REPLICA_URL: OnceLock<String> = OnceLock::new();

use std::{env, path::PathBuf};

use anyhow::{anyhow, Result};
use dotenv::dotenv;

pub fn setup_configs() -> Result<()> {
    let relayer_rand = env::var("RELAYER_RAND").unwrap();
    RELAYER_RAND.set(relayer_rand);

    let web_server_address = env::var("WEB_SERVER_ADDRESS").unwrap();
    WEB_SERVER_ADDRESS.set(web_server_address);

    let prover_address = env::var("PROVER_ADDRESS").unwrap();
    PROVER_ADDRESS.set(prover_address);

    let private_key = env::var("PRIVATE_KEY").unwrap();
    PRIVATE_KEY.set(private_key);

    let chain_id = env::var("CHAIN_ID").unwrap().parse().unwrap();
    CHAIN_ID.set(chain_id);

    let chain_rpc_provider = env::var("CHAIN_RPC_PROVIDER").unwrap();
    CHAIN_RPC_PROVIDER.set(chain_rpc_provider);

    let chain_rpc_explorer = env::var("CHAIN_RPC_EXPLORER").unwrap();
    CHAIN_RPC_EXPLORER.set(chain_rpc_explorer);

    let core_contract_address = env::var("CORE_CONTRACT_ADDRESS").unwrap();
    CORE_CONTRACT_ADDRESS.set(core_contract_address);

    let fee_per_gas = env::var("FEE_PER_GAS").unwrap();
    let fee_per_gas = U256::from_dec_str(&fee_per_gas).unwrap();
    FEE_PER_GAS.set(fee_per_gas);

    let input_files_dir = env::var("INPUT_FILES_DIR").unwrap();
    INPUT_FILES_DIR.set(input_files_dir);

    let received_emails_dir = env::var("RECEIVED_EMAILS_DIR").unwrap();
    RECEIVED_EMAILS_DIR.set(received_emails_dir);

    let email_templates = env::var("EMAIL_TEMPLATES").unwrap();
    EMAIL_TEMPLATES.set(email_templates);

    let relayer_email_address = env::var("RELAYER_EMAIL_ADDRESS").unwrap();
    RELAYER_EMAIL_ADDRESS.set(relayer_email_address);

    let canister_id = env::var("CANISTER_ID").unwrap();
    CANISTER_ID.set(canister_id);

    let ic_pem_path = env::var("IC_PEM_PATH").unwrap();
    IC_PEM_PATH.set(ic_pem_path);

    let ic_replica_url = env::var("IC_REPLICA_URL").unwrap();
    IC_REPLICA_URL.set(ic_replica_url);
    Ok(())
}
