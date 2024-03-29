#![allow(clippy::upper_case_acronyms)]
#![allow(clippy::identity_op)]

use crate::*;

use ethers::utils::keccak256;
use relayer_utils::*;

const DOMAIN_FIELDS: usize = 9;
const SUBJECT_FIELDS: usize = 20;
const EMAIL_ADDR_FIELDS: usize = 9;

#[named]
pub async fn handle_email<P: EmailsPool>(
    email: String,
    db: Arc<Database>,
    chain_client: Arc<ChainClient>,
    emails_pool: P,
) -> Result<EmailAuthEvent> {
    let parsed_email = ParsedEmail::new_from_raw_email(&email).await?;
    trace!(LOG, "email: {}", email; "func" => function_name!());
    let guardian_email_addr = parsed_email.get_from_addr()?;
    trace!(LOG, "From address: {}", guardian_email_addr; "func" => function_name!());
    let subject = parsed_email.get_subject_all()?;
    let request_decomposed_def =
        serde_json::from_str(include_str!("./regex_json/request_def.json"))?;
    let request_idxes = extract_substr_idxes(&subject, &request_decomposed_def)?;
    if request_idxes.is_empty() {
        bail!(WRONG_SUBJECT_FORMAT);
    }
    let request_id = &subject[request_idxes[0].0..request_idxes[0].1];
    let request_id_u64 = request_id
        .parse::<u64>()
        .map_err(|e| anyhow!("Failed to parse request_id to u64: {}", e))?;
    let request_record = db.get_request(request_id_u64).await?;
    if request_record.is_none() {
        return Ok(EmailAuthEvent::Error {
            email_addr: guardian_email_addr,
            error: format!("Request {} not found", request_id),
        });
    }
    let request = request_record.unwrap();
    check_and_update_dkim(&email, &parsed_email, &chain_client).await?;
    let subject_template = chain_client
        .get_acceptance_subject_templates(&request.wallet_eth_addr, request.template_idx)
        .await?;

    let subject_params = extract_template_vals(&subject, subject_template);

    if subject_params.is_err() {
        return Ok(EmailAuthEvent::Error {
            email_addr: guardian_email_addr,
            error: "Invalid subject".to_string(),
        });
    }

    if let Ok(invitation_code) = parsed_email.get_invitation_code() {
        trace!(LOG, "Email with account code"; "func" => function_name!());
        let account_key = AccountKey::from(hex2field(&format!("0x{}", invitation_code))?);
        let stored_account_key = db
            .get_invitation_code_from_email(&guardian_email_addr)
            .await?;
        if let Some(stored_account_key) = stored_account_key.as_ref() {
            if stored_account_key != &field2hex(&account_key.0) {
                return Err(anyhow!(
                    "Stored account key is not equal to one in the email: {} != {}",
                    stored_account_key,
                    field2hex(&account_key.0)
                ));
            }
        }
        if !request.is_for_recovery {
            let template_id = keccak256(
                &[
                    EMAIL_ACCOUNT_RECOVERY_VERSION_ID.as_bytes(),
                    b"ACCEPTANCE",
                    request.template_idx.to_string().as_bytes(),
                ]
                .concat(),
            );

            // Generate Proof - stub

            // TODO

            Ok(EmailAuthEvent::Acceptance {
                wallet_eth_addr: request.wallet_eth_addr,
                guardian_email_addr,
                request_id: request_id_u64,
            })
        } else {
            return Ok(EmailAuthEvent::Error {
                email_addr: guardian_email_addr,
                error: "Request is for recovery".to_string(),
            });
        }
    } else {
        if request.is_for_recovery {
            let template_id = keccak256(
                &[
                    EMAIL_ACCOUNT_RECOVERY_VERSION_ID.as_bytes(),
                    b"RECOVERY",
                    request.template_idx.to_string().as_bytes(),
                ]
                .concat(),
            );

            // Generate Proof - stub

            // TODO

            Ok(EmailAuthEvent::Acceptance {
                wallet_eth_addr: request.wallet_eth_addr,
                guardian_email_addr,
                request_id: request_id_u64,
            })
        } else {
            return Ok(EmailAuthEvent::Error {
                email_addr: guardian_email_addr,
                error: "No account code found".to_string(),
            });
        }
    }
}
