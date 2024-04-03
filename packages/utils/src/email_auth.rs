use std::cmp;

use crate::*;
use anyhow::Result;
use num_bigint::BigInt;
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize)]
pub struct EmailAuthInput {
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

pub async fn generate_email_auth_input(email: &str, account_code: &AccountCode) -> Result<String> {
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

    let from_addr_idx = parsed_email.get_from_addr_idxes().unwrap().0;
    let domain_idx = parsed_email.get_email_domain_idxes().unwrap().0;
    let subject_idx = parsed_email.get_subject_all_idxes().unwrap().0;
    let code_idx = match parsed_email.get_invitation_code_idxes() {
        Ok(indexes) => indexes.0,
        Err(_) => {
            // info!(LOG, "No invitation code in header");
            0
        }
    };
    let timestamp_idx = parsed_email.get_timestamp_idxes().unwrap().0;

    let email_auth_input = EmailAuthInput {
        padded_header: email_circuit_inputs.in_padded,
        public_key: email_circuit_inputs.pubkey,
        signature: email_circuit_inputs.signature,
        padded_header_len: email_circuit_inputs.in_len_padded_bytes,
        account_code: field2hex(&account_code.0),
        from_addr_idx: from_addr_idx,
        subject_idx: subject_idx,
        domain_idx: domain_idx,
        timestamp_idx: timestamp_idx,
        code_idx,
    };

    Ok(serde_json::to_string(&email_auth_input)?)
}

pub fn generate_email_auth_input_node(mut cx: FunctionContext) -> JsResult<JsPromise> {
    let email = cx.argument::<JsString>(0)?.value(&mut cx);
    let account_code = cx.argument::<JsString>(1)?.value(&mut cx);
    let account_code = AccountCode::from(hex2field_node(&mut cx, &account_code)?);
    let channel = cx.channel();
    let (deferred, promise) = cx.promise();
    let rt = runtime(&mut cx)?;

    rt.spawn(async move {
        let email_auth_input = generate_email_auth_input(&email, &account_code).await;
        deferred.settle_with(&channel, move |mut cx| match email_auth_input {
            Ok(email_auth_input) => {
                let email_auth_input = cx.string(email_auth_input);
                Ok(email_auth_input)
            }
            Err(err) => cx.throw_error(format!("Could not generate email auth input: {}", err)),
        });
    });

    Ok(promise)
}
