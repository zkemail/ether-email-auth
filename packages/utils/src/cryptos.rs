use crate::converters::*;

use halo2curves::ff::Field;
use neon::prelude::*;
use poseidon_rs::*;
use rand_core::{OsRng, RngCore};
pub use zk_regex_apis::padding::pad_string;

pub const MAX_EMAIL_ADDR_BYTES: usize = 256;

#[derive(Debug, Clone)]
pub struct PaddedEmailAddr {
    pub padded_bytes: Vec<u8>,
    pub email_addr_len: usize,
}

impl PaddedEmailAddr {
    pub fn from_email_addr(email_addr: &str) -> Self {
        let email_addr_len = email_addr.as_bytes().len();
        // let mut padded_bytes = email_addr.as_bytes().to_vec();
        // padded_bytes.append(&mut vec![0; MAX_EMAIL_ADDR_BYTES - email_addr_len]);
        let padded_bytes = pad_string(email_addr, MAX_EMAIL_ADDR_BYTES).to_vec();
        Self {
            padded_bytes,
            email_addr_len,
        }
    }

    pub fn to_email_addr_fields(&self) -> Vec<Fr> {
        bytes2fields(&self.padded_bytes)
    }

    pub fn to_commitment(&self, rand: &Fr) -> Result<Fr, PoseidonError> {
        let mut inputs = vec![*rand];
        inputs.append(&mut self.to_email_addr_fields());
        poseidon_fields(&inputs)
    }

    pub fn to_commitment_with_signature(&self, signature: &[u8]) -> Result<Fr, PoseidonError> {
        let cm_rand = extract_rand_from_signature(signature)?;
        poseidon_fields(&[vec![cm_rand], self.to_email_addr_fields()].concat())
    }
}

pub fn extract_rand_from_signature(signature: &[u8]) -> Result<Fr, PoseidonError> {
    let mut signature = signature.to_vec();
    signature.reverse();
    let mut inputs = bytes_chunk_fields(&signature, 121, 2);
    inputs.push(Fr::one());
    let cm_rand = poseidon_fields(&inputs)?;
    Ok(cm_rand)
}

#[derive(Debug, Clone, Copy)]
pub struct AccountCode(pub Fr);

impl AccountCode {
    pub fn new<R: RngCore>(rng: R) -> Self {
        Self(Fr::random(rng))
    }

    pub fn from(elem: Fr) -> Self {
        Self(elem)
    }
}

#[derive(Debug, Clone, Copy)]
pub struct AccountSalt(pub Fr);

impl AccountSalt {
    pub fn new(
        email_addr: &PaddedEmailAddr,
        account_code: AccountCode,
    ) -> Result<Self, PoseidonError> {
        let mut inputs = email_addr.to_email_addr_fields();
        inputs.push(account_code.0);
        inputs.push(Fr::zero());
        Ok(Self(poseidon_fields(&inputs)?))
    }
}

/// `public_key_n` is little endian.
pub fn public_key_hash(public_key_n: &[u8]) -> Result<Fr, PoseidonError> {
    let inputs = bytes_chunk_fields(public_key_n, 121, 2);
    poseidon_fields(&inputs)
}

/// `signature` is little endian.
pub fn email_nullifier(signature: &[u8]) -> Result<Fr, PoseidonError> {
    let inputs = bytes_chunk_fields(signature, 121, 2);
    let sign_rand = poseidon_fields(&inputs)?;
    poseidon_fields(&[sign_rand])
}

pub fn pad_email_addr_node(mut cx: FunctionContext) -> JsResult<JsArray> {
    let email_addr = cx.argument::<JsString>(0)?.value(&mut cx);
    let padded_email_addr = PaddedEmailAddr::from_email_addr(&email_addr);
    let padded_email_addr_bytes =
        JsArray::new(&mut cx, padded_email_addr.padded_bytes.len() as u32);
    for (idx, byte) in padded_email_addr.padded_bytes.into_iter().enumerate() {
        let js_byte = cx.number(byte);
        padded_email_addr_bytes.set(&mut cx, idx as u32, js_byte)?;
    }
    Ok(padded_email_addr_bytes)
}

pub fn gen_account_code_node(mut cx: FunctionContext) -> JsResult<JsString> {
    let mut rng = OsRng;
    let account_code = AccountCode::new(&mut rng);
    let account_code_str = field2hex(&account_code.0);
    Ok(cx.string(account_code_str))
}

pub fn account_salt_node(mut cx: FunctionContext) -> JsResult<JsString> {
    let email_addr = cx.argument::<JsString>(0)?.value(&mut cx);
    let padded_email_addr = PaddedEmailAddr::from_email_addr(&email_addr);
    let account_code_str = cx.argument::<JsString>(1)?.value(&mut cx);
    let account_code = hex2field_node(&mut cx, &account_code_str)?;
    let account_salt = match AccountSalt::new(&padded_email_addr, AccountCode(account_code)) {
        Ok(account_salt) => account_salt,
        Err(e) => return cx.throw_error(&format!("WalletSalt failed: {}", e)),
    };
    let account_salt_str = field2hex(&account_salt.0);
    Ok(cx.string(account_salt_str))
}

pub fn public_key_hash_node(mut cx: FunctionContext) -> JsResult<JsString> {
    let public_key_n = cx.argument::<JsString>(0)?.value(&mut cx);
    let mut public_key_n = match hex::decode(&public_key_n[2..]) {
        Ok(bytes) => bytes,
        Err(e) => return cx.throw_error(&format!("public_key_n is an invalid hex string: {}", e)),
    };
    public_key_n.reverse();
    let hash_field = match public_key_hash(&public_key_n) {
        Ok(hash_field) => hash_field,
        Err(e) => return cx.throw_error(&format!("public_key_hash failed: {}", e)),
    };
    let hash_str = field2hex(&hash_field);
    Ok(cx.string(hash_str))
}

pub fn email_nullifier_node(mut cx: FunctionContext) -> JsResult<JsString> {
    let signature = cx.argument::<JsString>(0)?.value(&mut cx);
    let mut signature = match hex::decode(&signature[2..]) {
        Ok(bytes) => bytes,
        Err(e) => return cx.throw_error(&format!("signature is an invalid hex string: {}", e)),
    };
    signature.reverse();
    let nullifier = match email_nullifier(&signature) {
        Ok(nullifier) => nullifier,
        Err(e) => return cx.throw_error(&format!("email_nullifier failed: {}", e)),
    };
    let nullifier_str = field2hex(&nullifier);
    Ok(cx.string(nullifier_str))
}

pub fn email_addr_commit_node(mut cx: FunctionContext) -> JsResult<JsString> {
    let email_addr = cx.argument::<JsString>(0)?.value(&mut cx);
    let rand = cx.argument::<JsString>(1)?.value(&mut cx);
    let rand = hex2field_node(&mut cx, &rand)?;
    let padded_email_addr = PaddedEmailAddr::from_email_addr(&email_addr);
    let email_addr_commit = match padded_email_addr.to_commitment(&rand) {
        Ok(fr) => fr,
        Err(e) => return cx.throw_error(&format!("EmailAddrCommit failed: {}", e)),
    };
    let email_addr_commit_str = field2hex(&email_addr_commit);
    Ok(cx.string(email_addr_commit_str))
}

pub fn email_addr_commit_with_signature_node(mut cx: FunctionContext) -> JsResult<JsString> {
    let email_addr = cx.argument::<JsString>(0)?.value(&mut cx);
    let signature = cx.argument::<JsString>(1)?.value(&mut cx);
    let signature = match hex::decode(&signature[2..]) {
        Ok(bytes) => bytes,
        Err(e) => return cx.throw_error(&format!("signature is an invalid hex string: {}", e)),
    };
    // signature.reverse();
    let padded_email_addr = PaddedEmailAddr::from_email_addr(&email_addr);
    let email_addr_commit = match padded_email_addr.to_commitment_with_signature(&signature) {
        Ok(fr) => fr,
        Err(e) => return cx.throw_error(&format!("EmailAddrCommit failed: {}", e)),
    };
    let email_addr_commit_str = field2hex(&email_addr_commit);
    Ok(cx.string(email_addr_commit_str))
}

pub fn extract_rand_from_signature_node(mut cx: FunctionContext) -> JsResult<JsString> {
    let signature = cx.argument::<JsString>(0)?.value(&mut cx);
    let signature = match hex::decode(&signature[2..]) {
        Ok(bytes) => bytes,
        Err(e) => return cx.throw_error(&format!("signature is an invalid hex string: {}", e)),
    };
    // signature.reverse();
    let rand = match extract_rand_from_signature(&signature) {
        Ok(fr) => fr,
        Err(e) => return cx.throw_error(&format!("extract_rand_from_signature failed: {}", e)),
    };
    let rand_str = field2hex(&rand);
    Ok(cx.string(rand_str))
}
