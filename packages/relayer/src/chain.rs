use std::{collections::HashMap, time::Duration};

use crate::*;
use abi::{encode, Abi, ParamType, Token, Tokenize};
use abis::{ECDSAOwnedDKIMRegistry, EmailAuth, EmailAuthMsg, EmailProof};
use anyhow::anyhow;
use config::ChainConfig;
use ethers::prelude::*;
use ethers::signers::Signer;
use ethers::utils::hex;
use model::RequestModel;
use rand::Rng;
use relayer_utils::{bytes_to_hex, h160_to_hex, u256_to_hex};
use slog::error;
use statics::SHARED_MUTEX;
use tokio::time::sleep;

const CONFIRMATIONS: usize = 1;

type SignerM = SignerMiddleware<Provider<Http>, LocalWallet>;

struct CustomTokenVec {
    tokens: Vec<Token>,
}

impl Tokenize for CustomTokenVec {
    fn into_tokens(self) -> Vec<Token> {
        self.tokens
    }
}

/// Represents a client for interacting with the blockchain.
#[derive(Debug, Clone)]
pub struct ChainClient {
    pub client: Arc<SignerM>,
}

impl ChainClient {
    /// Sets up a new ChainClient.
    ///
    /// # Returns
    ///
    /// A `Result` containing the new `ChainClient` if successful, or an error if not.
    pub async fn setup(chain: String, chains: HashMap<String, ChainConfig>) -> Result<Self> {
        let chain_config = chains
            .get(&chain)
            .ok_or_else(|| anyhow!("Chain configuration not found"))?;
        let wallet: LocalWallet = chain_config.private_key.parse()?;
        let provider = Provider::<Http>::try_from(chain_config.rpc_url.clone())?;

        // Create a new SignerMiddleware with the provider and wallet
        let client = Arc::new(SignerMiddleware::new(
            provider,
            wallet.with_chain_id(chain_config.chain_id),
        ));

        Ok(Self { client })
    }

    /// Sets the DKIM public key hash.
    ///
    /// # Arguments
    ///
    /// * `selector` - The selector string.
    /// * `domain_name` - The domain name.
    /// * `public_key_hash` - The public key hash as a 32-byte array.
    /// * `signature` - The signature as Bytes.
    /// * `dkim` - The ECDSA Owned DKIM Registry.
    ///
    /// # Returns
    ///
    /// A `Result` containing the transaction hash as a String if successful, or an error if not.
    pub async fn set_dkim_public_key_hash(
        &self,
        selector: String,
        domain_name: String,
        public_key_hash: [u8; 32],
        signature: Bytes,
        dkim: ECDSAOwnedDKIMRegistry<SignerM>,
    ) -> Result<String> {
        // Mutex is used to prevent nonce conflicts.
        let mut mutex = SHARED_MUTEX.lock().await;
        *mutex += 1;

        // Call the contract method
        let call = dkim.set_dkim_public_key_hash(selector, domain_name, public_key_hash, signature);
        let tx = call.send().await?;

        // Wait for the transaction to be confirmed
        let receipt = tx
            .confirmations(CONFIRMATIONS)
            .await?
            .ok_or(anyhow!("No receipt"))?;

        // Format the transaction hash
        let tx_hash = receipt.transaction_hash;
        let tx_hash = format!("0x{}", hex::encode(tx_hash.as_bytes()));
        Ok(tx_hash)
    }

    /// Checks if a DKIM public key hash is valid.
    ///
    /// # Arguments
    ///
    /// * `domain_name` - The domain name.
    /// * `public_key_hash` - The public key hash as a 32-byte array.
    /// * `dkim` - The ECDSA Owned DKIM Registry.
    ///
    /// # Returns
    ///
    /// A `Result` containing a boolean indicating if the hash is valid.
    pub async fn check_if_dkim_public_key_hash_valid(
        &self,
        domain_name: ::std::string::String,
        public_key_hash: [u8; 32],
        dkim: ECDSAOwnedDKIMRegistry<SignerM>,
    ) -> Result<bool> {
        // Call the contract method to check if the hash is valid
        let is_valid = dkim
            .is_dkim_public_key_hash_valid(domain_name, public_key_hash)
            .call()
            .await?;
        Ok(is_valid)
    }

    pub async fn call(
        &self,
        request: RequestModel,
        email_auth_msg: EmailAuthMsg,
        relayer_state: RelayerState,
    ) -> Result<()> {
        let abi = Abi {
            functions: vec![request.email_tx_auth.function_abi.clone()]
                .into_iter()
                .map(|f| (f.name.clone(), vec![f]))
                .collect(),
            events: Default::default(),
            constructor: None,
            receive: false,
            fallback: false,
            errors: Default::default(),
        };

        let contract = Contract::new(
            request.email_tx_auth.contract_address,
            abi,
            self.client.clone(),
        );

        let function = request.email_tx_auth.function_abi;
        let remaining_args = request.email_tx_auth.remaining_args;

        // Initialize your tokens vector
        let mut tokens = Vec::new();

        // Add the first token (assuming email_auth_msg.to_tokens() returns Vec<Token>)
        tokens.push(Token::Tuple(email_auth_msg.to_tokens()));

        // Convert remaining_args to tokens and add them to the tokens vector
        for arg in remaining_args {
            let token = Token::from(arg);
            tokens.push(token);
        }

        let custom_tokens = CustomTokenVec { tokens };

        // Now you can use the tokens vector to call the contract function
        let call = contract.method::<_, ()>(&function.name, custom_tokens)?;
        let tx = call.clone().tx;
        let from = h160_to_hex(&self.client.address());
        let to = h160_to_hex(
            tx.to()
                .expect("to not found")
                .as_address()
                .expect("to not found"),
        );
        let data = bytes_to_hex(&tx.data().expect("data not found").to_vec());

        // Call Alchemy to check for asset changes (Make a POST request to Alchemy)
        let alchemy_url = format!(
            "https://{}.g.alchemy.com/v2/{}",
            relayer_state.config.chains[request.email_tx_auth.chain.as_str()].alchemy_name,
            relayer_state.config.alchemy_api_key
        );

        // Prepare the JSON body for the POST request using extracted transaction details
        let json_body = serde_json::json!({
            "id": 1,
            "jsonrpc": "2.0",
            "method": "alchemy_simulateAssetChanges",
            "params": [
                {
                    "from": from,
                    "to": to,
                    "value": "0x0",
                    "data": data,
                }
            ]
        });

        info!(LOG, "Alchemy request: {:?}", json_body);

        // Send the POST request
        let response = simulate_with_retry(
            &relayer_state.http_client,
            &alchemy_url,
            &json_body,
            5,
            1000,
        )
        .await?;

        // Handle the response
        if response.status().is_success() {
            let response_text = response.text().await?;
            info!(LOG, "Alchemy response: {:?}", response_text);

            // Parse the response to check if changes is empty
            let response_json: serde_json::Value = serde_json::from_str(&response_text)?;
            if let Some(changes) = response_json["result"]["changes"].as_array() {
                if !changes.is_empty() {
                    error!(LOG, "Unexpected changes in Alchemy response: {:?}", changes);
                    return Err(anyhow!("Unexpected changes in Alchemy response"));
                }
            }
        } else {
            let error_text = response.text().await?;
            error!(LOG, "Alchemy request failed: {:?}", error_text);
        }

        let receipt = call
            .send()
            .await?
            .interval(Duration::from_secs(1))
            .retries(5)
            .confirmations(CONFIRMATIONS)
            .await?;

        info!(
            LOG,
            "tx hash: {:?}",
            receipt.expect("tx not found").transaction_hash
        );

        Ok(())
    }
}

impl EmailAuthMsg {
    pub fn to_tokens(&self) -> Vec<Token> {
        vec![
            Token::Uint(self.template_id),
            Token::Array(
                self.command_params
                    .iter()
                    .map(|param| Token::Bytes(param.clone().to_vec()))
                    .collect(),
            ),
            Token::Uint(self.skipped_command_prefix),
            Token::Tuple(self.proof.to_tokens()),
        ]
    }
}

impl EmailProof {
    pub fn to_tokens(&self) -> Vec<Token> {
        vec![
            Token::String(self.domain_name.clone()),
            Token::FixedBytes(self.public_key_hash.to_vec()),
            Token::Uint(self.timestamp),
            Token::String(self.masked_command.clone()),
            Token::FixedBytes(self.email_nullifier.to_vec()),
            Token::FixedBytes(self.account_salt.to_vec()),
            Token::Bool(self.is_code_exist),
            Token::Bytes(self.proof.clone().to_vec()),
        ]
    }
}

async fn simulate_with_retry(
    http_client: &reqwest::Client,
    url: &str,
    json_body: &serde_json::Value,
    max_attempts: usize,
    max_backoff: u64,
) -> Result<reqwest::Response> {
    let mut attempts = 0;

    loop {
        attempts += 1;
        let response = http_client
            .post(url)
            .header("accept", "application/json")
            .header("content-type", "application/json")
            .json(json_body)
            .send()
            .await;

        match response {
            Ok(resp) if resp.status().is_success() => return Ok(resp),
            Ok(_) | Err(_) if attempts < max_attempts => {
                // Calculate exponential backoff with jitter using spawn_blocking
                let backoff = tokio::task::spawn_blocking(move || {
                    let mut rng = rand::thread_rng();
                    2u64.pow(attempts as u32) + rng.gen_range(0..1000)
                })
                .await?
                .min(max_backoff);

                error!(
                    LOG,
                    "Request failed, retrying in {} ms... (attempt {}/{})",
                    backoff,
                    attempts,
                    max_attempts
                );
                sleep(Duration::from_millis(backoff)).await;
                continue;
            }
            Ok(resp) => {
                // Log the final failed attempt
                let error_text = resp
                    .text()
                    .await
                    .unwrap_or_else(|_| "Unknown error".to_string());
                error!(LOG, "Alchemy request failed: {:?}", error_text);
                return Err(anyhow!(
                    "Alchemy request failed after {} attempts",
                    max_attempts
                ));
            }
            Err(err) => {
                // Log the final failed attempt
                error!(LOG, "Alchemy request failed: {:?}", err);
                return Err(anyhow!(
                    "Alchemy request failed after {} attempts",
                    max_attempts
                ));
            }
        }
    }
}
