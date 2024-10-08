use anyhow::Error;
use serde::Deserialize;
use std::collections::HashMap;
use std::env;
use std::fs::File;
use std::io::Read;

#[derive(Deserialize, Debug, Clone)]
#[serde(rename_all = "camelCase")]
pub struct Config {
    pub port: usize,
    pub database_url: String,
    pub prover_url: String,
    pub icp: IcpConfig,
    pub chains: HashMap<String, ChainConfig>,
    pub json_logger: bool,
}

#[derive(Deserialize, Debug, Clone)]
#[serde(rename_all = "camelCase")]
pub struct IcpConfig {
    pub canister_id: String,
    pub pem_path: String,
    pub ic_replica_url: String,
}

#[derive(Deserialize, Debug, Clone)]
#[serde(rename_all = "camelCase")]
pub struct ChainConfig {
    pub private_key: String,
    pub rpc_url: String,
    pub explorer_url: String,
    pub chain_id: u32,
}

// Function to load the configuration from a JSON file
pub fn load_config() -> Result<Config, Error> {
    // Open the configuration file
    let mut file = File::open("config.json")
        .map_err(|e| anyhow::anyhow!("Failed to open config file: {}", e))?;

    // Read the file's content into a string
    let mut data = String::new();
    file.read_to_string(&mut data)
        .map_err(|e| anyhow::anyhow!("Failed to read config file: {}", e))?;

    // Deserialize the JSON content into a Config struct
    let config: Config = serde_json::from_str(&data)
        .map_err(|e| anyhow::anyhow!("Failed to parse config file: {}", e))?;

    // Setting Logger ENV
    if config.json_logger {
        env::set_var("JSON_LOGGER", "true");
    }

    Ok(config)
}
