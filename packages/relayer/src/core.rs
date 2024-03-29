#![allow(clippy::upper_case_acronyms)]
#![allow(clippy::identity_op)]

use crate::*;

use ethers::utils::keccak256;
use relayer_utils::*;

use ethers::types::{Address, Bytes, U256};
use ethers::utils::hex::FromHex;

use std::collections::hash_map::DefaultHasher;
use std::hash::{Hash, Hasher};

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
    let request_decomposed_def = serde_json::from_str(include_str!("./request_def.json"))?;
    let request_idxes = extract_substr_idxes(&subject, &request_decomposed_def)?;
    if request_idxes.is_empty() {
        bail!(WRONG_SUBJECT_FORMAT);
    }
    let request_id = &subject[request_idxes[0].0..request_idxes[0].1];
    let request_record = db.get_request(request_id.to_string()).await?;
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
                request_id: request_id.to_string(),
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
                request_id: request_id.to_string(),
            })
        } else {
            return Ok(EmailAuthEvent::Error {
                email_addr: guardian_email_addr,
                error: "No account code found".to_string(),
            });
        }
    }
}

pub fn calculate_default_hash(input: &str) -> String {
    let mut hasher = DefaultHasher::new();
    input.hash(&mut hasher);
    let hash_code = hasher.finish();

    hash_code.to_string()
}

#[named]
pub async fn check_and_update_dkim(
    email: &str,
    parsed_email: &ParsedEmail,
    chain_client: &Arc<ChainClient>,
) -> Result<()> {
    let mut public_key_n = parsed_email.public_key.clone();
    public_key_n.reverse();
    let public_key_hash = public_key_hash(&public_key_n)?;
    info!(LOG, "public_key_hash {:?}", public_key_hash; "func" => function_name!());
    let domain = parsed_email.get_email_domain()?;
    info!(LOG, "domain {:?}", domain; "func" => function_name!());
    if chain_client
        .check_if_dkim_public_key_hash_valid(domain.clone(), fr_to_bytes32(&public_key_hash)?)
        .await?
    {
        info!(LOG, "public key registered"; "func" => function_name!());
        return Ok(());
    }
    let selector_decomposed_def =
        serde_json::from_str(include_str!("./selector_def.json")).unwrap();
    let selector = {
        let idxes =
            extract_substr_idxes(&parsed_email.canonicalized_header, &selector_decomposed_def)?[0];
        let str = parsed_email.canonicalized_header[idxes.0..idxes.1].to_string();
        str
    };
    info!(LOG, "selector {}", selector; "func" => function_name!());
    let ic_agent = DkimOracleClient::gen_agent(
        &env::var(PEM_PATH_KEY).unwrap(),
        &env::var(IC_REPLICA_URL_KEY).unwrap(),
    )?;
    let oracle_client = DkimOracleClient::new(&env::var(CANISTER_ID_KEY).unwrap(), &ic_agent)?;
    let oracle_result = oracle_client.request_signature(&selector, &domain).await?;
    info!(LOG, "DKIM oracle result {:?}", oracle_result; "func" => function_name!());
    let public_key_hash = hex::decode(&oracle_result.public_key_hash[2..])?;
    info!(LOG, "public_key_hash from oracle {:?}", public_key_hash; "func" => function_name!());
    let signature = Bytes::from_hex(&oracle_result.signature[2..])?;
    info!(LOG, "signature {:?}", signature; "func" => function_name!());
    let tx_hash = chain_client
        .set_dkim_public_key_hash(
            selector,
            domain,
            TryInto::<[u8; 32]>::try_into(public_key_hash).unwrap(),
            signature,
        )
        .await?;
    info!(LOG, "DKIM registry updated {:?}", tx_hash; "func" => function_name!());
    Ok(())
}
