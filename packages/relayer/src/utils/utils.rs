#![allow(clippy::upper_case_acronyms)]
#![allow(clippy::identity_op)]

use crate::*;
use ethers::abi::Token;
use ethers::types::{Bytes, U256};
use relayer_utils::*;

use ::serde::{Deserialize, Serialize};

use std::collections::hash_map::DefaultHasher;
use std::hash::{Hash, Hasher};
use std::path::Path;

const DOMAIN_FIELDS: usize = 9;
const SUBJECT_FIELDS: usize = 17;
const EMAIL_ADDR_FIELDS: usize = 9;

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

#[derive(Serialize, Deserialize)]
struct EmailAuthInput {
    padded_header: Vec<String>,
    public_key: Vec<String>,
    signature: Vec<String>,
    padded_header_len: String,
    account_code: String,
    from_addr_idx: usize,
    subject_idx: usize,
    domain_idx: usize,
    timestamp_idx: usize,
    code_idx: usize,
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

pub async fn generate_email_auth_input(email: &str, account_key: &str) -> Result<String> {
    let parsed_email = ParsedEmail::new_from_raw_email(&email).await?;
    let circuit_input_params = circuit::CircuitInputParams::new(
        vec![],
        parsed_email.canonicalized_header.as_bytes().to_vec(),
        "".to_string(),
        vec_u8_to_bigint(parsed_email.clone().signature),
        vec_u8_to_bigint(parsed_email.clone().public_key),
        None,
        Some(1024),
        Some(64),
        Some(true),
    );
    let email_circuit_inputs = circuit::generate_circuit_inputs(circuit_input_params);

    let from_addr_idx = parsed_email.get_from_addr_idxes().unwrap();
    let domain_idx = parsed_email.get_email_domain_idxes().unwrap();
    let subject_idx = parsed_email.get_subject_all_idxes().unwrap();
    let code_idx = parsed_email.get_invitation_code_idxes().unwrap();
    let timestamp_idx = parsed_email.get_timestamp_idxes().unwrap();

    let email_auth_input = EmailAuthInput {
        padded_header: email_circuit_inputs.in_padded,
        public_key: email_circuit_inputs.pubkey,
        signature: email_circuit_inputs.signature,
        padded_header_len: email_circuit_inputs.in_len_padded_bytes,
        account_code: format!("0x{}", account_key.to_string()),
        from_addr_idx: from_addr_idx.0,
        subject_idx: subject_idx.0,
        domain_idx: domain_idx.0,
        timestamp_idx: timestamp_idx.0,
        code_idx: code_idx.0,
    };

    Ok(serde_json::to_string(&email_auth_input)?)
}

#[named]
pub async fn generate_proof(
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

pub fn u256_to_bytes32(x: &U256) -> [u8; 32] {
    let mut bytes = [0u8; 32];
    x.to_big_endian(&mut bytes);
    bytes
}

pub fn u256_to_bytes32_little(x: &U256) -> [u8; 32] {
    let mut bytes = [0u8; 32];
    x.to_little_endian(&mut bytes);
    bytes
}

pub fn u256_to_hex(x: &U256) -> String {
    "0x".to_string() + &hex::encode(u256_to_bytes32(x))
}

pub fn bytes32_to_hex(bytes: &[u8; 32]) -> String {
    "0x".to_string() + &hex::encode(bytes)
}

pub fn hex_to_u256(hex: &str) -> Result<U256> {
    let bytes: Vec<u8> = hex::decode(&hex[2..])?;
    let mut array = [0u8; 32];
    array.copy_from_slice(&bytes);
    Ok(U256::from_big_endian(&array))
}

pub fn fr_to_bytes32(fr: &Fr) -> Result<[u8; 32]> {
    let hex = field2hex(fr);
    let bytes = hex::decode(&hex[2..])?;
    let mut result = [0u8; 32];
    result.copy_from_slice(&bytes);
    Ok(result)
}

pub fn bytes32_to_fr(bytes32: &[u8; 32]) -> Result<Fr> {
    let hex: String = "0x".to_string() + &hex::encode(bytes32);
    let field = hex2field(&hex)?;
    Ok(field)
}

pub fn calculate_default_hash(input: &str) -> String {
    let mut hasher = DefaultHasher::new();
    input.hash(&mut hasher);
    let hash_code = hasher.finish();

    hash_code.to_string()
}
