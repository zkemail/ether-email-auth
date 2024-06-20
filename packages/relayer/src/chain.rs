use crate::*;
use ethers::middleware::Middleware;
use ethers::prelude::*;
use ethers::signers::Signer;
use relayer_utils::converters::u64_to_u8_array_32;
use relayer_utils::LOG;

const CONFIRMATIONS: usize = 1;

type SignerM = SignerMiddleware<Provider<Http>, LocalWallet>;

#[derive(Debug, Clone)]
pub struct ChainClient {
    pub client: Arc<SignerM>,
}

impl ChainClient {
    pub async fn setup() -> Result<Self> {
        let wallet: LocalWallet = PRIVATE_KEY.get().unwrap().parse()?;
        let provider = Provider::<Http>::try_from(CHAIN_RPC_PROVIDER.get().unwrap())?;

        let client = Arc::new(SignerMiddleware::new(
            provider,
            wallet.with_chain_id(*CHAIN_ID.get().unwrap()),
        ));

        Ok(Self { client })
    }

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

        let call = dkim.set_dkim_public_key_hash(selector, domain_name, public_key_hash, signature);
        let tx = call.send().await?;
        let receipt = tx
            .log()
            .confirmations(CONFIRMATIONS)
            .await?
            .ok_or(anyhow!("No receipt"))?;
        let tx_hash = receipt.transaction_hash;
        let tx_hash = format!("0x{}", hex::encode(tx_hash.as_bytes()));
        Ok(tx_hash)
    }

    pub async fn check_if_dkim_public_key_hash_valid(
        &self,
        domain_name: ::std::string::String,
        public_key_hash: [u8; 32],
        dkim: ECDSAOwnedDKIMRegistry<SignerM>,
    ) -> Result<bool> {
        let is_valid = dkim
            .is_dkim_public_key_hash_valid(domain_name, public_key_hash)
            .call()
            .await?;
        Ok(is_valid)
    }

    pub async fn get_dkim_from_wallet(
        &self,
        wallet_addr: &String,
    ) -> Result<ECDSAOwnedDKIMRegistry<SignerM>, anyhow::Error> {
        let wallet_address: H160 = wallet_addr.parse()?;
        let contract = EmailAccountRecovery::new(wallet_address, self.client.clone());
        let dkim = contract.dkim().call().await?;

        Ok(ECDSAOwnedDKIMRegistry::new(dkim, self.client.clone()))
    }

    pub async fn is_wallet_deployed(&self, wallet_addr_str: &String) -> bool {
        let wallet_addr: H160 = wallet_addr_str.parse().unwrap();
        match self.client.get_code(wallet_addr, None).await {
            Ok(code) => !code.is_empty(),
            Err(e) => {
                // Log the error or handle it as needed
                error!(LOG, "Error querying contract code: {:?}", e);
                false
            }
        }
    }

    pub async fn get_acceptance_subject_templates(
        &self,
        wallet_addr: &String,
        template_idx: u64,
    ) -> Result<Vec<String>, anyhow::Error> {
        let wallet_address: H160 = wallet_addr.parse()?;
        let contract = EmailAccountRecovery::new(wallet_address, self.client.clone());
        let templates = contract
            .acceptance_subject_templates()
            .call()
            .await
            .map_err(|e| anyhow::Error::from(e))?;
        Ok(templates[template_idx as usize].clone())
    }

    pub async fn get_recovery_subject_templates(
        &self,
        wallet_addr: &String,
        template_idx: u64,
    ) -> Result<Vec<String>, anyhow::Error> {
        let wallet_address: H160 = wallet_addr.parse()?;
        let contract = EmailAccountRecovery::new(wallet_address, self.client.clone());
        let templates = contract
            .recovery_subject_templates()
            .call()
            .await
            .map_err(|e| anyhow::Error::from(e))?;
        Ok(templates[template_idx as usize].clone())
    }

    pub async fn complete_recovery(&self, wallet_addr: &String) -> Result<bool, anyhow::Error> {
        let wallet_address: H160 = wallet_addr.parse()?;
        let contract = EmailAccountRecovery::new(wallet_address, self.client.clone());
        let call = contract.complete_recovery();
        let tx = call.send().await?;
        // If the transaction is successful, the function will return true and false otherwise.
        let receipt = tx
            .log()
            .confirmations(CONFIRMATIONS)
            .await?
            .ok_or(anyhow!("No receipt"))?;
        Ok(receipt
            .status
            .map(|status| status == U64::from(1))
            .unwrap_or(false))
    }

    pub async fn handle_acceptance(
        &self,
        wallet_addr: &String,
        email_auth_msg: EmailAuthMsg,
        template_idx: u64,
    ) -> Result<bool, anyhow::Error> {
        let wallet_address: H160 = wallet_addr.parse()?;
        let contract = EmailAccountRecovery::new(wallet_address, self.client.clone());
        let call = contract.handle_acceptance(email_auth_msg, template_idx.into());
        let tx = call.send().await?;
        // If the transaction is successful, the function will return true and false otherwise.
        let receipt = tx
            .log()
            .confirmations(CONFIRMATIONS)
            .await?
            .ok_or(anyhow!("No receipt"))?;
        Ok(receipt
            .status
            .map(|status| status == U64::from(1))
            .unwrap_or(false))
    }

    pub async fn handle_recovery(
        &self,
        wallet_addr: &String,
        email_auth_msg: EmailAuthMsg,
        template_idx: u64,
    ) -> Result<bool, anyhow::Error> {
        let wallet_address: H160 = wallet_addr.parse()?;
        let contract = EmailAccountRecovery::new(wallet_address, self.client.clone());
        let call = contract.handle_recovery(email_auth_msg, template_idx.into());
        let tx = call.send().await?;
        // If the transaction is successful, the function will return true and false otherwise.
        let receipt = tx
            .log()
            .confirmations(CONFIRMATIONS)
            .await?
            .ok_or(anyhow!("No receipt"))?;
        Ok(receipt
            .status
            .map(|status| status == U64::from(1))
            .unwrap_or(false))
    }

    pub async fn get_bytecode(&self, wallet_addr: &String) -> Result<Bytes, anyhow::Error> {
        let wallet_address: H160 = wallet_addr.parse()?;
        Ok(self.client.get_code(wallet_address, None).await?)
    }

    pub async fn get_storage_at(
        &self,
        wallet_addr: &String,
        slot: u64,
    ) -> Result<H256, anyhow::Error> {
        let wallet_address: H160 = wallet_addr.parse()?;
        Ok(self
            .client
            .get_storage_at(wallet_address, u64_to_u8_array_32(slot).into(), None)
            .await?)
    }
}
