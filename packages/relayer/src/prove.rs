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
/// This asynchronous function updates the request status, parses the email, generates the circuit input,
/// and produces a cryptographic proof. It returns the email proof and account salt.
///
/// # Arguments
///
/// * `email` - The raw email content as a `&str`.
/// * `request` - The `RequestModel` containing details of the request associated with the email.
/// * `relayer_state` - The current state of the relayer, containing configuration and state information.
///
/// # Returns
///
/// A `Result` containing:
/// - `Ok`: An `EmailProof` with the generated proof and account salt.
/// - `Err`: An error if any step in the process fails.
pub async fn generate_email_proof(
    email: &str,
    request: RequestModel,
    relayer_state: RelayerState,
) -> Result<EmailProof> {
    // Update the request status to "Proving" in the database
    update_request(&relayer_state.db, request.id, RequestStatus::Proving).await?;

    // Parse the email from the raw content
    let parsed_email = ParsedEmail::new_from_raw_email(&email).await?;

    // Generate the circuit input for the email proof
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

    // Generate the proof and public signals using the circuit input
    let (proof, public_signals) = generate_proof(
        &circuit_input,
        "email_auth",
        &relayer_state.config.prover_url,
    )
    .await?;

    // Log the public signals for debugging purposes
    info!(LOG, "Public signals: {:?}", public_signals);

    // Extract the account salt from the public signals
    let account_salt = u256_to_bytes32(&public_signals[COMMAND_FIELDS + DOMAIN_FIELDS + 3]);
    // Determine if the code exists based on the public signals
    let is_code_exist = public_signals[COMMAND_FIELDS + DOMAIN_FIELDS + 4] == 1u8.into();
    // Get the masked command from the public signals
    let masked_command = get_masked_command(public_signals.clone(), DOMAIN_FIELDS + 3)?;

    // Construct the email proof with the generated data
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

    // Return the constructed email proof
    Ok(email_proof)
}
