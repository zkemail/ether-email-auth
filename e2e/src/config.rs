use anyhow::Error;
use relayer_imap::RelayerIMAPConfig;
use relayer_smtp::RelayerSMTPConfig;
use serde::Deserialize;
use serde_json;
use std::collections::HashMap;
use std::env;
use std::fs::File;
use std::io::Read;

// #[derive(Deserialize, Debug, Clone)]
// #[serde(rename_all = "camelCase")]
// pub struct ReceiverConfigs {
//     pub configs: Vec<ReceiverConfig>,
//     pub json_logger: bool,
//     // pub logs_path: String,
// }

// unsafe impl Send for ReceiverConfigs {}
// unsafe impl Sync for ReceiverConfigs {}

// impl ReceiverConfigs {
//     pub fn from_file(file_path: &str) -> Result<Self, Error> {
//         // Open the configuration file
//         let mut file = File::open(file_path)
//             .map_err(|e| anyhow::anyhow!("Failed to open config file: {}", e))?;

//         // Read the file's content into a string
//         let mut data = String::new();
//         file.read_to_string(&mut data)
//             .map_err(|e| anyhow::anyhow!("Failed to read config file: {}", e))?;

//         // Deserialize the JSON content into a Config struct
//         let config: Self = serde_json::from_str(&data)
//             .map_err(|e| anyhow::anyhow!("Failed to parse config file: {}", e))?;

//         // Setting Logger ENV
//         if config.json_logger {
//             env::set_var("JSON_LOGGER", "true");
//         }
//         Ok(config)
//     }
// }

#[derive(Deserialize, Debug, Clone)]
#[serde(rename_all = "camelCase")]
pub struct ReceiverConfig {
    pub id: String,
    pub imap: RelayerIMAPConfig,
    pub smtp: RelayerSMTPConfig,
    pub json_logger: bool,
    // pub logs_path: String,
}

unsafe impl Send for ReceiverConfig {}
unsafe impl Sync for ReceiverConfig {}

impl ReceiverConfig {
    pub fn from_file(file_path: &str) -> Result<Self, Error> {
        // Open the configuration file
        let mut file = File::open(file_path)
            .map_err(|e| anyhow::anyhow!("Failed to open config file: {}", e))?;

        // Read the file's content into a string
        let mut data = String::new();
        file.read_to_string(&mut data)
            .map_err(|e| anyhow::anyhow!("Failed to read config file: {}", e))?;

        // Deserialize the JSON content into a Config struct
        let config: Self = serde_json::from_str(&data)
            .map_err(|e| anyhow::anyhow!("Failed to parse config file: {}", e))?;

        // Setting Logger ENV
        if config.json_logger {
            env::set_var("JSON_LOGGER", "true");
        }
        Ok(config)
    }
}
