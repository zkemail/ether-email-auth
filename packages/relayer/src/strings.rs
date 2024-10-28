// Config strings
pub const SMTP_SERVER_KEY: &str = "SMTP_SERVER";
pub const RELAYER_EMAIL_ADDR_KEY: &str = "RELAYER_EMAIL_ADDR";
pub const DATABASE_PATH_KEY: &str = "DATABASE_URL";
pub const WEB_SERVER_ADDRESS_KEY: &str = "WEB_SERVER_ADDRESS";
pub const PROVER_ADDRESS_KEY: &str = "PROVER_ADDRESS";
pub const CHAIN_RPC_PROVIDER_KEY: &str = "CHAIN_RPC_PROVIDER";
pub const CHAIN_RPC_EXPLORER_KEY: &str = "CHAIN_RPC_EXPLORER";
pub const PRIVATE_KEY_KEY: &str = "PRIVATE_KEY";
pub const CHAIN_ID_KEY: &str = "CHAIN_ID";
pub const EMAIL_ACCOUNT_RECOVERY_VERSION_ID_KEY: &str = "EMAIL_ACCOUNT_RECOVERY_VERSION_ID";
pub const EMAIL_TEMPLATES_PATH_KEY: &str = "EMAIL_TEMPLATES_PATH";
pub const REGEX_JSON_DIR_PATH_KEY: &str = "REGEX_JSON_DIR_PATH";

// Log strings
pub const JSON_LOGGER_KEY: &str = "JSON_LOGGER";

// Error strings
pub const WRONG_AUTH_METHOD: &str = "Not supported auth type";
pub const IMAP_RECONNECT_ERROR: &str = "Failed to reconnect";
pub const SMTP_RECONNECT_ERROR: &str = "Failed to reconnect";
pub const CANNOT_GET_EMAIL_FROM_QUEUE: &str = "Cannot get email from mpsc in handle email task";
pub const NOT_MY_SENDER: &str = "NOT_MY_SENDER";
pub const WRONG_COMMAND_FORMAT: &str = "Wrong command format";

// Core REGEX'es and Commands
pub const STRING_REGEX: &str = r"\S+";
pub const UINT_REGEX: &str = r"\d+";
pub const INT_REGEX: &str = r"-?\d+";
pub const ETH_ADDR_REGEX: &str = r"0x[a-fA-F0-9]{40}";
pub const DECIMALS_REGEX: &str = r"\d+\.\d+";
pub const SHA_PRECOMPUTE_SELECTOR: &str = r#"(<(=\r\n)?d(=\r\n)?i(=\r\n)?v(=\r\n)? (=\r\n)?i(=\r\n)?d(=\r\n)?=3D(=\r\n)?\"(=\r\n)?[^\"]*(=\r\n)?z(=\r\n)?k(=\r\n)?e(=\r\n)?m(=\r\n)?a(=\r\n)?i(=\r\n)?l(=\r\n)?[^\"]*(=\r\n)?\"(=\r\n)?[^>]*(=\r\n)?>(=\r\n)?)(=\r\n)?([^<>\/]+)(<(=\r\n)?\/(=\r\n)?d(=\r\n)?i(=\r\n)?v(=\r\n)?>(=\r\n)?)"#;

// DKIM ORACLE ARGS
pub const DKIM_CANISTER_ID_KEY: &str = "DKIM_CANISTER_ID";
pub const WALLET_CANISTER_ID_KEY: &str = "WALLET_CANISTER_ID";
pub const PEM_PATH_KEY: &str = "PEM_PATH";
pub const IC_REPLICA_URL_KEY: &str = "IC_REPLICA_URL";
