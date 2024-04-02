use std::error::Error;

use crate::converters::*;

use halo2curves::ff::Field;
use poseidon_rs::*;
use rand_core::RngCore;
use rsa::sha2::{Digest, Sha256};
pub use zk_regex_apis::padding::pad_string;

pub const MAX_EMAIL_ADDR_BYTES: usize = 256;

#[derive(Debug, Clone, Copy)]
pub struct RelayerRand(pub Fr);

impl RelayerRand {
    pub fn new<R: RngCore>(mut r: R) -> Self {
        Self(Fr::random(&mut r))
    }

    pub fn new_from_seed(seed: &[u8]) -> Result<Self, PoseidonError> {
        let value = poseidon_bytes(seed)?;
        Ok(Self(value))
    }
}

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
        let padded_bytes = pad_string(email_addr, MAX_EMAIL_ADDR_BYTES);
        Self {
            padded_bytes,
            email_addr_len,
        }
    }

    pub fn to_email_addr_fields(&self) -> Vec<Fr> {
        bytes2fields(&self.padded_bytes)
    }

    // pub fn to_pointer(&self, relayer_rand: &RelayerRand) -> Result<Fr, PoseidonError> {
    //     self.to_commitment(&relayer_rand.0)
    // }

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
pub struct AccountKey(pub Fr);

impl AccountKey {
    pub fn new<R: RngCore>(rng: R) -> Self {
        Self(Fr::random(rng))
    }

    pub fn from(elem: Fr) -> Self {
        Self(elem)
    }

    // pub fn to_commitment(
    //     &self,
    //     email_addr: &PaddedEmailAddr,
    //     relayer_rand_hash: &Fr,
    // ) -> Result<Fr, PoseidonError> {
    //     let mut inputs = vec![self.0];
    //     inputs.append(&mut email_addr.to_email_addr_fields());
    //     inputs.push(*relayer_rand_hash);
    //     poseidon_fields(&inputs)
    // }

    // pub fn to_wallet_salt(&self, account_key: AccountKey) -> Result<WalletSalt, PoseidonError> {
    //     let field = poseidon_fields(&[self.0, Fr::zero()])?;
    //     Ok(WalletSalt(field))
    // }

    // pub fn to_ext_account_salt(&self) -> Result<ExtAccountSalt, PoseidonError> {
    //     let field = poseidon_fields(&[self.0.clone(), Fr::one()])?;
    //     Ok(ExtAccountSalt(field))
    // }
}

#[derive(Debug, Clone, Copy)]
pub struct WalletSalt(pub Fr);

impl WalletSalt {
    pub fn new(
        email_addr: &PaddedEmailAddr,
        account_key: AccountKey,
    ) -> Result<Self, PoseidonError> {
        let mut inputs = email_addr.to_email_addr_fields();
        inputs.push(account_key.0);
        inputs.push(Fr::zero());
        Ok(WalletSalt(poseidon_fields(&inputs)?))
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

pub fn sha256_pad(mut data: Vec<u8>, max_sha_bytes: usize) -> (Vec<u8>, usize) {
    let length_bits = data.len() * 8; // Convert length from bytes to bits
    let length_in_bytes = int64_to_bytes(length_bits as u64);

    // Add the bit '1' to the end of the data
    data = merge_u8_arrays(data, int8_to_bytes(0x80));

    while (data.len() * 8 + length_in_bytes.len() * 8) % 512 != 0 {
        data = merge_u8_arrays(data, int8_to_bytes(0));
    }

    // Append the original length in bits at the end of the data
    data = merge_u8_arrays(data, length_in_bytes);

    assert!(
        (data.len() * 8) % 512 == 0,
        "Padding did not complete properly!"
    );

    let message_len = data.len();

    // Pad the data to the specified maximum length with zeros
    while data.len() < max_sha_bytes {
        data = merge_u8_arrays(data, int64_to_bytes(0));
    }

    assert!(
        data.len() == max_sha_bytes,
        "Padding to max length did not complete properly! Your padded message is {} long but max is {}!",
        data.len(),
        max_sha_bytes
    );

    (data, message_len)
}

pub fn partial_sha(msg: &[u8], msg_len: usize) -> Vec<u8> {
    let mut hasher = Sha256::new();
    // Assuming msg_len is used to specify how much of msg to hash.
    // This example simply hashes the entire msg for simplicity.
    hasher.update(&msg[..msg_len]);
    let result = hasher.finalize();
    result.to_vec()
}

pub fn generate_partial_sha(
    body: Vec<u8>,
    body_length: usize,
    selector_string: Option<String>,
    max_remaining_body_length: usize,
) -> Result<(Vec<u8>, Vec<u8>, usize), Box<dyn Error>> {
    let selector_index = 0;

    if let Some(selector_str) = selector_string {
        let selector = selector_str.as_bytes();
        // Find selector in body and return the starting index
        let body_slice = &body[..body_length];
        let _selector_index = match body_slice
            .windows(selector.len())
            .position(|window| window == selector)
        {
            Some(index) => index,
            None => return Err("Selector not found in body".into()),
        };
    }

    let sha_cutoff_index = (selector_index / 64) * 64;
    let precompute_text = &body[..sha_cutoff_index];
    let mut body_remaining = body[sha_cutoff_index..].to_vec();

    let body_remaining_length = body_length - precompute_text.len();

    if body_remaining_length > max_remaining_body_length {
        return Err(Box::new(std::io::Error::new(
            std::io::ErrorKind::Other,
            format!(
                "Remaining body {} after the selector is longer than max ({})",
                body_remaining_length, max_remaining_body_length
            ),
        )));
    }

    if body_remaining.len() % 64 != 0 {
        return Err(Box::new(std::io::Error::new(
            std::io::ErrorKind::Other,
            "Remaining body was not padded correctly with int64s",
        )));
    }

    while body_remaining.len() < max_remaining_body_length {
        body_remaining.push(0);
    }

    let precomputed_sha = partial_sha(precompute_text, sha_cutoff_index);
    Ok((precomputed_sha, body_remaining, body_remaining_length))
}
