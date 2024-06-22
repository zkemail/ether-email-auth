use anyhow::anyhow;
use relayer_utils::extract_substr_idxes;
use relayer_utils::LOG;

use crate::*;
use candid::CandidType;
use ethers::types::Bytes;
use ethers::utils::hex::FromHex;
use ic_agent::agent::http_transport::ReqwestTransport;
use ic_agent::agent::*;
use ic_agent::identity::*;
use ic_utils::canister::*;

use serde::Deserialize;

#[derive(Debug, Clone)]
pub struct DkimOracleClient<'a> {
    pub canister: Canister<'a>,
}

#[derive(Default, CandidType, Deserialize, Debug, Clone)]
pub struct SignedDkimPublicKey {
    pub selector: String,
    pub domain: String,
    pub signature: String,
    pub public_key: String,
    pub public_key_hash: String,
}

impl<'a> DkimOracleClient<'a> {
    pub fn gen_agent(pem_path: &str, replica_url: &str) -> anyhow::Result<Agent> {
        let identity = Secp256k1Identity::from_pem_file(pem_path)?;
        let transport = ReqwestTransport::create(replica_url)?;
        let agent = AgentBuilder::default()
            .with_identity(identity)
            .with_transport(transport)
            .build()?;
        Ok(agent)
    }

    pub fn new(canister_id: &str, agent: &'a Agent) -> anyhow::Result<Self> {
        let canister = CanisterBuilder::new()
            .with_canister_id(canister_id)
            .with_agent(&agent)
            .build()?;
        Ok(Self { canister })
    }

    pub async fn request_signature(
        &self,
        selector: &str,
        domain: &str,
    ) -> anyhow::Result<SignedDkimPublicKey> {
        let request = self
            .canister
            .update("sign_dkim_public_key")
            .with_args((selector, domain))
            .build::<(Result<SignedDkimPublicKey, String>,)>();
        let response = request
            .call_and_wait_one::<Result<SignedDkimPublicKey, String>>()
            .await?
            .map_err(|e| anyhow!(format!("Error from canister: {:?}", e)))?;

        Ok(response)
    }
}

#[named]
pub async fn check_and_update_dkim(
    email: &str,
    parsed_email: &ParsedEmail,
    wallet_addr: &str,
    account_salt: &str,
) -> Result<()> {
    let mut public_key_n = parsed_email.public_key.clone();
    public_key_n.reverse();
    let public_key_hash = public_key_hash(&public_key_n)?;
    info!(LOG, "public_key_hash {:?}", public_key_hash; "func" => function_name!());
    let domain = parsed_email.get_email_domain()?;
    info!(LOG, "domain {:?}", domain; "func" => function_name!());
    if CLIENT.get_bytecode(&wallet_addr.to_string()).await? == Bytes::from(vec![0u8; 20]) {
        info!(LOG, "wallet not deployed"; "func" => function_name!());
        return Ok(());
    }
    let email_auth_addr = CLIENT
        .get_email_auth_addr_from_wallet(&wallet_addr.to_string(), &account_salt.to_string())
        .await?;
    let mut dkim = CLIENT
        .get_dkim_from_wallet(&wallet_addr.to_string())
        .await?;
    if CLIENT.get_bytecode(&email_auth_addr.to_string()).await? != Bytes::from(vec![0u8; 20]) {
        dkim = CLIENT
            .get_dkim_from_email_auth(&email_auth_addr.to_string())
            .await?;
    }
    info!(LOG, "dkim {:?}", dkim; "func" => function_name!());
    if CLIENT
        .check_if_dkim_public_key_hash_valid(
            domain.clone(),
            fr_to_bytes32(&public_key_hash)?,
            dkim.clone(),
        )
        .await?
    {
        info!(LOG, "public key registered"; "func" => function_name!());
        return Ok(());
    }
    let selector_decomposed_def =
        serde_json::from_str(include_str!("../regex_json/selector_def.json")).unwrap();
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
    let tx_hash = CLIENT
        .set_dkim_public_key_hash(
            selector,
            domain,
            TryInto::<[u8; 32]>::try_into(public_key_hash).unwrap(),
            signature,
            dkim,
        )
        .await?;
    info!(LOG, "DKIM registry updated {:?}", tx_hash; "func" => function_name!());
    Ok(())
}
