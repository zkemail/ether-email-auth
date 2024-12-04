use anyhow::{anyhow, Result};
use ethers::types::{Bytes, U256};
use relayer_utils::{extract_template_vals_from_command, u256_to_bytes32_little};

use crate::{constants::COMMAND_FIELDS, model::RequestModel};

pub fn parse_command_template(template: &str, params: Vec<String>) -> String {
    let mut parsed_string = template.to_string();
    let mut param_iter = params.iter();

    #[allow(clippy::while_let_on_iterator)]
    while let Some(value) = param_iter.next() {
        if let Some(start) = parsed_string.find('{') {
            if let Some(end) = parsed_string[start..].find('}') {
                parsed_string.replace_range(start..start + end + 1, value);
            }
        }
    }

    parsed_string
}

/// Retrieves and encodes the command parameters for the email authentication request.
///
/// # Arguments
///
/// * `params` - The `EmailRequestContext` containing request details.
///
/// # Returns
///
/// A `Result` containing a vector of encoded command parameters or an `EmailError`.
pub async fn get_encoded_command_params(email: &str, request: RequestModel) -> Result<Vec<Bytes>> {
    let command_template = request
        .email_tx_auth
        .command_template
        .split_whitespace()
        .map(String::from)
        .collect();

    // Remove \r\n from email
    let email = email.replace("=\r\n", "");

    let command_params = extract_template_vals_from_command(&email, command_template)?;

    let command_params_encoded = command_params
        .iter()
        .map(|param| {
            param
                .abi_encode(None)
                .map_err(|e| anyhow::anyhow!(e.to_string()))
        })
        .collect::<Result<Vec<Bytes>>>()?;

    Ok(command_params_encoded)
}

/// Extracts the masked command from public signals.
///
/// # Arguments
///
/// * `public_signals` - The vector of public signals.
/// * `start_idx` - The starting index for command extraction.
///
/// # Returns
///
/// A `Result` containing the masked command as a `String` or an error.
pub fn get_masked_command(public_signals: Vec<U256>, start_idx: usize) -> Result<String> {
    // Gather signals from start_idx to start_idx + COMMAND_FIELDS
    let command_bytes: Vec<u8> = public_signals
        .iter()
        .skip(start_idx)
        .take(COMMAND_FIELDS)
        .take_while(|&signal| *signal != U256::zero())
        .flat_map(u256_to_bytes32_little)
        .collect();

    // Bytes to string, removing null bytes
    let command = String::from_utf8(command_bytes.into_iter().filter(|&b| b != 0u8).collect())
        .map_err(|e| anyhow!("Failed to convert bytes to string: {}", e))?;

    Ok(command)
}
