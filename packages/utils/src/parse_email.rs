use itertools::Itertools;

use anyhow::Result;
use hex;

use cfdkim::{canonicalize_signed_email, resolve_public_key};
use rsa::traits::PublicKeyParts;

use serde::{Deserialize, Serialize};
use zk_regex_apis::extract_substrs::*;
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ParsedEmail {
    pub canonicalized_header: String,
    pub canonicalized_body: String,
    pub signature: Vec<u8>,
    pub public_key: Vec<u8>,
}

impl ParsedEmail {
    pub async fn new_from_raw_email(raw_email: &str) -> Result<Self> {
        let logger = slog::Logger::root(slog::Discard, slog::o!());
        let public_key = resolve_public_key(&logger, raw_email.as_bytes())
            .await
            .unwrap();
        let public_key = match public_key {
            cfdkim::DkimPublicKey::Rsa(pk) => pk,
            _ => panic!("not supportted public key type."),
        };
        let (canonicalized_header, canonicalized_body, signature_bytes) =
            canonicalize_signed_email(raw_email.as_bytes()).unwrap();
        let parsed_email = ParsedEmail {
            canonicalized_header: String::from_utf8(canonicalized_header)?,
            canonicalized_body: String::from_utf8(canonicalized_body)?,
            signature: signature_bytes.into_iter().collect_vec(),
            public_key: public_key.n().to_bytes_be(),
        };
        Ok(parsed_email)
    }

    pub fn signature_string(&self) -> String {
        "0x".to_string() + hex::encode(&self.signature).as_str()
    }

    pub fn public_key_string(&self) -> String {
        "0x".to_string() + hex::encode(&self.public_key).as_str()
    }

    pub fn get_from_addr(&self) -> Result<String> {
        let idxes = extract_from_addr_idxes(&self.canonicalized_header)?[0];
        let str = self.canonicalized_header[idxes.0..idxes.1].to_string();
        Ok(str)
    }

    pub fn get_from_addr_idxes(&self) -> Result<(usize, usize)> {
        let idxes = extract_from_addr_idxes(&self.canonicalized_header)?[0];
        Ok(idxes)
    }

    pub fn get_to_addr(&self) -> Result<String> {
        let idxes = extract_to_addr_idxes(&self.canonicalized_header)?[0];
        let str = self.canonicalized_header[idxes.0..idxes.1].to_string();
        Ok(str)
    }

    pub fn get_email_domain(&self) -> Result<String> {
        let idxes = extract_from_addr_idxes(&self.canonicalized_header)?[0];
        let from_addr = self.canonicalized_header[idxes.0..idxes.1].to_string();
        let idxes = extract_email_domain_idxes(&from_addr)?[0];
        let str = from_addr[idxes.0..idxes.1].to_string();
        Ok(str)
    }

    pub fn get_email_domain_idxes(&self) -> Result<(usize, usize)> {
        let idxes = extract_from_addr_idxes(&self.canonicalized_header)?[0];
        let str = self.canonicalized_header[idxes.0..idxes.1].to_string();
        let idxes = extract_email_domain_idxes(&str)?[0];
        Ok(idxes)
    }

    pub fn get_subject_all(&self) -> Result<String> {
        let idxes = extract_subject_all_idxes(&self.canonicalized_header)?[0];
        let str = self.canonicalized_header[idxes.0..idxes.1].to_string();
        Ok(str)
    }

    pub fn get_subject_all_idxes(&self) -> Result<(usize, usize)> {
        let idxes = extract_subject_all_idxes(&self.canonicalized_header)?[0];
        Ok(idxes)
    }

    pub fn get_timestamp(&self) -> Result<u64> {
        let idxes = extract_timestamp_idxes(&self.canonicalized_header)?[0];
        let str = &self.canonicalized_header[idxes.0..idxes.1];
        Ok(str.parse()?)
    }

    pub fn get_timestamp_idxes(&self) -> Result<(usize, usize)> {
        let idxes = extract_timestamp_idxes(&self.canonicalized_header)?[0];
        Ok(idxes)
    }

    pub fn get_invitation_code(&self) -> Result<String> {
        let regex_config = serde_json::from_str(include_str!(
            "../../circuits/src/regexes/invitation_code.json"
        ))
        .unwrap();
        let idxes = extract_substr_idxes(&self.canonicalized_header, &regex_config)?[0];
        let str = self.canonicalized_header[idxes.0..idxes.1].to_string();
        Ok(str)
    }

    pub fn get_invitation_code_idxes(&self) -> Result<(usize, usize)> {
        let regex_config = serde_json::from_str(include_str!(
            "../../circuits/src/regexes/invitation_code.json"
        ))
        .unwrap();
        let idxes = extract_substr_idxes(&self.canonicalized_header, &regex_config)?[0];
        Ok(idxes)
    }

    pub fn get_email_addr_in_subject(&self) -> Result<String> {
        let idxes = extract_subject_all_idxes(&self.canonicalized_header)?[0];
        let subject = self.canonicalized_header[idxes.0..idxes.1].to_string();
        let idxes = extract_email_addr_idxes(&subject)?[0];
        let str = subject[idxes.0..idxes.1].to_string();
        Ok(str)
    }

    pub fn get_email_addr_in_subject_idxes(&self) -> Result<(usize, usize)> {
        let idxes = extract_subject_all_idxes(&self.canonicalized_header)?[0];
        let subject = self.canonicalized_header[idxes.0..idxes.1].to_string();
        let idxes = extract_email_addr_idxes(&subject)?[0];
        Ok(idxes)
    }

    pub fn get_message_id(&self) -> Result<String> {
        let idxes = extract_message_id_idxes(&self.canonicalized_header)?[0];
        let str = self.canonicalized_header[idxes.0..idxes.1].to_string();
        Ok(str)
    }
}
