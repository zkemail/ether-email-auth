use anyhow::Result;
use relayer_utils::{
    generate_email_circuit_input, generate_proof, u256_to_bytes32, EmailCircuitParams, ParsedEmail,
    LOG,
};
use slog::info;

use crate::{
    abis::EmailProof,
    command::get_masked_command,
    constants::{COMMAND_FIELDS, DOMAIN_FIELDS, SHA_PRECOMPUTE_SELECTOR},
    model::{update_request, RequestModel, RequestStatus},
    RelayerState,
};

/// Generates the email proof for authentication.
///
/// # Arguments
///
/// * `params` - The `EmailRequestContext` containing request details.
///
/// # Returns
///
/// A `Result` containing the `EmailProof` and account salt, or an `EmailError`.
pub async fn generate_email_proof(
    email: &str,
    request: RequestModel,
    relayer_state: RelayerState,
) -> Result<EmailProof> {
    update_request(&relayer_state.db, request.id, RequestStatus::Proving).await?;

    let parsed_email = ParsedEmail::new_from_raw_email(&email).await?;
    let circuit_input = generate_email_circuit_input(
        &email,
        &request.email_tx_auth.account_code,
        Some(EmailCircuitParams {
            max_header_length: Some(1024),
            max_body_length: Some(1024),
            sha_precompute_selector: Some(SHA_PRECOMPUTE_SELECTOR.to_string()),
            ignore_body_hash_check: Some(false),
        }),
    )
    .await?;

    let (proof, public_signals) = generate_proof(
        &circuit_input,
        "email_auth",
        &relayer_state.config.prover_url,
    )
    .await?;

    info!(LOG, "Public signals: {:?}", public_signals);

    let account_salt = u256_to_bytes32(&public_signals[COMMAND_FIELDS + DOMAIN_FIELDS + 3]);
    let is_code_exist = public_signals[COMMAND_FIELDS + DOMAIN_FIELDS + 4] == 1u8.into();
    let masked_command = get_masked_command(public_signals.clone(), DOMAIN_FIELDS + 3)?;

    let email_proof = EmailProof {
        proof,
        domain_name: parsed_email.get_email_domain()?,
        public_key_hash: u256_to_bytes32(&public_signals[DOMAIN_FIELDS + 0]),
        timestamp: u256_to_bytes32(&public_signals[DOMAIN_FIELDS + 2]).into(),
        masked_command,
        email_nullifier: u256_to_bytes32(&public_signals[DOMAIN_FIELDS + 1]),
        account_salt,
        is_code_exist,
    };

    Ok(email_proof)
}
