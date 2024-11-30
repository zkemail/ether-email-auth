use crate::*;
use abis::UserOverridableDKIMRegistry;
use anyhow::anyhow;
use config::ChainConfig;
use ethers::prelude::*;
use ethers::signers::Signer;
use ethers::utils::hex;
use statics::SHARED_MUTEX;
use std::collections::HashMap;

// Number of confirmations required for a transaction to be considered confirmed
const CONFIRMATIONS: usize = 1;

// Type alias for a SignerMiddleware that combines a provider and a local wallet
type SignerM = SignerMiddleware<Provider<Http>, LocalWallet>;

/// Represents a client for interacting with the blockchain.
#[derive(Debug, Clone)]
pub struct ChainClient {
    // The client is an Arc (atomic reference counted) pointer to a SignerMiddleware
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
        domain_name: String,
        public_key_hash: [u8; 32],
        signature: Bytes,
        dkim: UserOverridableDKIMRegistry<SignerM>,
    ) -> Result<String> {
        // Mutex is used to prevent nonce conflicts.
        let mut mutex = SHARED_MUTEX.lock().await;
        *mutex += 1;

        // Call the contract method
        let main_authorizer = dkim.main_authorizer().call().await?;
        let call =
            dkim.set_dkim_public_key_hash(domain_name, public_key_hash, main_authorizer, signature);
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
        dkim: UserOverridableDKIMRegistry<SignerM>,
    ) -> Result<bool> {
        // Call the contract method to check if the hash is valid
        let main_authorizer = dkim.main_authorizer().call().await?;
        let is_set = dkim
            .dkim_public_key_hashes(domain_name, public_key_hash, main_authorizer)
            .call()
            .await?;
        Ok(is_set)
    }
}
