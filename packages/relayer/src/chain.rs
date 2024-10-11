use std::collections::HashMap;

use crate::*;
use abi::{Abi, Token};
use abis::{ECDSAOwnedDKIMRegistry, EmailAuth, EmailAuthMsg, EmailProof};
use anyhow::anyhow;
use config::ChainConfig;
use ethers::prelude::*;
use ethers::signers::Signer;
use ethers::utils::hex;
use model::RequestModel;
use statics::SHARED_MUTEX;

const CONFIRMATIONS: usize = 1;

type SignerM = SignerMiddleware<Provider<Http>, LocalWallet>;

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
            .log()
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

    /// Gets the DKIM from an email auth address.
    ///
    /// # Arguments
    ///
    /// * `email_auth_addr` - The email auth address as a string.
    ///
    /// # Returns
    ///
    /// A `Result` containing the ECDSA Owned DKIM Registry if successful, or an error if not.
    pub async fn get_dkim_from_email_auth(
        &self,
        email_auth_address: Address,
    ) -> Result<ECDSAOwnedDKIMRegistry<SignerM>, anyhow::Error> {
        // Create a new EmailAuth contract instance
        let contract = EmailAuth::new(email_auth_address, self.client.clone());

        // Call the dkim_registry_addr method to get the DKIM registry address
        let dkim = contract.dkim_registry_addr().call().await?;

        // Create and return a new ECDSAOwnedDKIMRegistry instance
        Ok(ECDSAOwnedDKIMRegistry::new(dkim, self.client.clone()))
    }

    pub async fn call(&self, request: RequestModel, email_auth_msg: EmailAuthMsg) -> Result<()> {
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

        // Assuming remaining_args is a Vec of some type that can be converted to tokens
        let mut tokens = email_auth_msg.to_tokens();

        // Convert remaining_args to tokens and add them to the tokens vector
        for arg in remaining_args {
            // Convert each arg to a Token. This conversion depends on the type of arg.
            // For example, if arg is a string, you might use Token::String(arg).
            // Adjust the conversion based on the actual type of arg.
            let token = Token::from(arg); // Replace with appropriate conversion
            tokens.push(token);
        }

        // Now you can use the tokens vector to call the contract function
        let call = contract.method::<_, ()>(&function.name, tokens)?;
        let _result = call.send().await?;
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
