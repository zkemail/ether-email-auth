use crate::*;

use std::{env, path::PathBuf};

use dotenv::dotenv;

#[derive(Clone)]
pub struct RelayerConfig {
    pub imap_config: ImapConfig,
    pub smtp_config: SmtpConfig,
    pub db_path: String,
    pub web_server_address: String,
    pub circuits_dir_path: PathBuf,
    pub prover_address: String,
    pub chain_rpc_provider: String,
    pub chain_rpc_explorer: String,
    pub chain_id: u32,
    pub private_key: String,
    pub email_auth_address: String,
    pub input_files_dir: String,
    pub email_templates: String,
}

impl RelayerConfig {
    pub fn new() -> Self {
        dotenv().ok();

        let imap_auth = env::var(IMAP_AUTH_TYPE_KEY).unwrap();
        let imap_auth = match &*imap_auth {
            "password" => ImapAuth::Password {
                user_id: env::var(LOGIN_ID_KEY).unwrap(),
                password: env::var(LOGIN_PASSWORD_KEY).unwrap(),
            },
            "oauth" => ImapAuth::Oauth {
                user_id: env::var(LOGIN_ID_KEY).unwrap(),
                client_id: env::var(IMAP_CLIENT_ID_KEY).unwrap(),
                client_secret: env::var(IMAP_CLIENT_SECRET_KEY).unwrap(),
                auth_url: env::var(IMAP_AUTH_URL_KEY).unwrap(),
                token_url: env::var(IMAP_TOKEN_URL_KEY).unwrap(),
                redirect_url: IMAP_REDIRECT_URL_KEY.to_string(),
            },
            _ => panic!("{WRONG_AUTH_METHOD}"),
        };

        let imap_config = ImapConfig {
            domain_name: env::var(IMAP_DOMAIN_NAME_KEY).unwrap(),
            port: env::var(IMAP_PORT_KEY).unwrap().parse().unwrap(),
            auth: imap_auth,
            initially_checked: false,
        };

        let smtp_config = SmtpConfig {
            domain_name: env::var(SMTP_DOMAIN_NAME_KEY).unwrap(),
            id: env::var(LOGIN_ID_KEY).unwrap(),
            password: env::var(LOGIN_PASSWORD_KEY).unwrap(),
        };

        let input_files_dir = env::var(INPUT_FILES_DIR_KEY).unwrap();

        Self {
            imap_config,
            smtp_config,
            db_path: env::var(DATABASE_PATH_KEY).unwrap(),
            web_server_address: env::var(WEB_SERVER_ADDRESS_KEY).unwrap(),
            circuits_dir_path: env::var(CIRCUITS_DIR_PATH_KEY).unwrap().into(),
            prover_address: env::var(PROVER_ADDRESS_KEY).unwrap(),
            chain_rpc_provider: env::var(CHAIN_RPC_PROVIDER_KEY).unwrap(),
            chain_rpc_explorer: env::var(CHAIN_RPC_EXPLORER_KEY).unwrap(),
            chain_id: env::var(CHAIN_ID_KEY).unwrap().parse().unwrap(),
            private_key: env::var(PRIVATE_KEY_KEY).unwrap(),
            email_auth_address: env::var(EMAIL_AUTH_ADDRESS_KEY).unwrap(),
            input_files_dir,
            email_templates: env::var(EMAIL_TEMPLATES_PATH_KEY).unwrap(),
        }
    }
}

impl Default for RelayerConfig {
    fn default() -> Self {
        Self::new()
    }
}
