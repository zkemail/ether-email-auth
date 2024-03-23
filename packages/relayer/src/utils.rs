#![allow(clippy::upper_case_acronyms)]
#![allow(clippy::identity_op)]

use crate::*;
use chrono::{DateTime, Local};
use email_wallet_utils::*;
use ethers::abi::Token;
use ethers::types::{Bytes, U256};

use serde::Deserialize;

use std::path::Path;

use tokio::{
    fs::{read_to_string, remove_file, File},
    io::AsyncWriteExt,
};

use lazy_static::lazy_static;
use std::sync::Arc;
use tokio::sync::Mutex;

lazy_static! {
    pub static ref SHARED_MUTEX: Arc<Mutex<i32>> = Arc::new(Mutex::new(0));
}

// Error strings
pub const WRONG_AUTH_METHOD: &str = "Not supported auth type";
pub const IMAP_RECONNECT_ERROR: &str = "Failed to reconnect";
pub const SMTP_RECONNECT_ERROR: &str = "Failed to reconnect";
pub const CANNOT_GET_EMAIL_FROM_QUEUE: &str = "Cannot get email from mpsc in handle email task";
pub const NOT_MY_SENDER: &str = "NOT_MY_SENDER";
pub const WRONG_SUBJECT_FORMAT: &str = "Wrong subject format";
pub const INSUFFICIENT_BALANCE: &str = "Insufficient balance";

// Core REGEX'es
// pub(crate) const AMOUNT_REGEX: &str = "[0-9]+(\\.[0-9]+)?";
// pub(crate) const TOKEN_NAME_REGEX: &str = "[A-Z]+";
// pub(crate) const STRING_RGEX: &str = ".+";
// pub(crate) const UINT_REGEX: &str = "[0-9]+";
// pub(crate) const INT_REGEX: &str = "-?[0-9]+";
// pub(crate) const ETH_ADDR_REGEX: &str = "0x[0-9a-fA-F]{40}";
// pub(crate) const EMAIL_ADDR_REGEX: &str =
//     "[a-zA-Z0-9!#$%&'\\*\\+-/=\\?^_`{\\|}~\\.]+@[a-zA-Z0-9]+\\.[a-zA-Z0-9\\.-]+";

pub(crate) const DOMAIN_FIELDS: usize = 9;
pub(crate) const SUBJECT_FIELDS: usize = 17;
pub(crate) const EMAIL_ADDR_FIELDS: usize = 9;

#[derive(Debug, Clone, Deserialize)]
pub struct ProverRes {
    proof: ProofJson,
    pub_signals: Vec<String>,
}

#[derive(Debug, Clone, Deserialize)]
pub struct ProofJson {
    pi_a: Vec<String>,
    pi_b: Vec<Vec<String>>,
    pi_c: Vec<String>,
}

impl ProofJson {
    pub fn to_eth_bytes(&self) -> Result<Bytes> {
        let pi_a = Token::FixedArray(vec![
            Token::Uint(U256::from_dec_str(self.pi_a[0].as_str())?),
            Token::Uint(U256::from_dec_str(self.pi_a[1].as_str())?),
        ]);
        let pi_b = Token::FixedArray(vec![
            Token::FixedArray(vec![
                Token::Uint(U256::from_dec_str(self.pi_b[0][1].as_str())?),
                Token::Uint(U256::from_dec_str(self.pi_b[0][0].as_str())?),
            ]),
            Token::FixedArray(vec![
                Token::Uint(U256::from_dec_str(self.pi_b[1][1].as_str())?),
                Token::Uint(U256::from_dec_str(self.pi_b[1][0].as_str())?),
            ]),
        ]);
        let pi_c = Token::FixedArray(vec![
            Token::Uint(U256::from_dec_str(self.pi_c[0].as_str())?),
            Token::Uint(U256::from_dec_str(self.pi_c[1].as_str())?),
        ]);
        Ok(Bytes::from(abi::encode(&[pi_a, pi_b, pi_c])))
    }
}

pub(crate) async fn generate_email_auth_input(
    circuits_dir_path: &Path,
    email: &str,
    account_code: &str,
) -> Result<String> {
    let email_hash = calculate_default_hash(email);
    let email_file_name = PathBuf::new()
        .join(INPUT_FILES_DIR.get().unwrap())
        .join(email_hash.to_string() + ".email");
    let input_file_name = PathBuf::new()
        .join(INPUT_FILES_DIR.get().unwrap())
        .join(email_hash.to_string() + ".json");

    let mut email_file = File::create(&email_file_name).await?;
    email_file.write_all(email.as_bytes()).await?;

    let command_str = format!(
        "--cwd {} gen-input --email-file {} --account-code {} --input-file {}",
        circuits_dir_path.to_str().unwrap(),
        email_file_name.to_str().unwrap(),
        account_code,
        input_file_name.to_str().unwrap()
    );

    let mut proc = tokio::process::Command::new("yarn")
        .args(command_str.split_whitespace())
        .spawn()?;

    let status = proc.wait().await?;
    assert!(status.success());

    let result = read_to_string(&input_file_name).await?;

    remove_file(email_file_name).await?;
    remove_file(input_file_name).await?;

    Ok(result)
}

#[named]
pub(crate) async fn generate_proof(
    input: &str,
    request: &str,
    address: &str,
) -> Result<(Bytes, Vec<U256>)> {
    let client = reqwest::Client::new();
    info!(LOG, "prover input {}", input; "func" => function_name!());
    let res = client
        .post(format!("{}/prove/{}", address, request))
        .json(&serde_json::json!({ "input": input }))
        .send()
        .await?
        .error_for_status()?;
    let res_json = res.json::<ProverRes>().await?;
    info!(LOG, "prover response {:?}", res_json; "func" => function_name!());
    let proof = res_json.proof.to_eth_bytes()?;
    let pub_signals = res_json
        .pub_signals
        .into_iter()
        .map(|str| U256::from_dec_str(&str).expect("pub signal should be u256"))
        .collect();
    Ok((proof, pub_signals))
}

pub(crate) fn u256_to_bytes32(x: &U256) -> [u8; 32] {
    let mut bytes = [0u8; 32];
    x.to_big_endian(&mut bytes);
    bytes
}

pub(crate) fn u256_to_hex(x: &U256) -> String {
    "0x".to_string() + &hex::encode(u256_to_bytes32(x))
}

pub(crate) fn hex_to_u256(hex: &str) -> Result<U256> {
    let bytes: Vec<u8> = hex::decode(&hex[2..])?;
    let mut array = [0u8; 32];
    array.copy_from_slice(&bytes);
    Ok(U256::from_big_endian(&array))
}

pub(crate) fn fr_to_bytes32(fr: &Fr) -> Result<[u8; 32]> {
    let hex = field2hex(fr);
    let bytes = hex::decode(&hex[2..])?;
    let mut result = [0u8; 32];
    result.copy_from_slice(&bytes);
    Ok(result)
}

pub(crate) fn bytes32_to_fr(bytes32: &[u8; 32]) -> Result<Fr> {
    let hex: String = "0x".to_string() + &hex::encode(bytes32);
    let field = hex2field(&hex)?;
    Ok(field)
}

pub(crate) fn now() -> i64 {
    let dt: DateTime<Local> = Local::now();
    dt.timestamp()
}
