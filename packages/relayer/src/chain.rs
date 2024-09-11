use crate::*;
use abis::email_account_recovery::EmailAuthMsg;
use ethers::middleware::Middleware;
use ethers::prelude::*;
use ethers::signers::Signer;
use relayer_utils::converters::u64_to_u8_array_32;

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
        controller_eth_addr: &String,
    ) -> Result<ECDSAOwnedDKIMRegistry<SignerM>, anyhow::Error> {
        let controller_eth_addr: H160 = controller_eth_addr.parse()?;
        let contract = EmailAccountRecovery::new(controller_eth_addr, self.client.clone());
        let dkim = contract.dkim().call().await?;
        Ok(ECDSAOwnedDKIMRegistry::new(dkim, self.client.clone()))
    }

    pub async fn get_dkim_from_email_auth(
        &self,
        email_auth_addr: &String,
    ) -> Result<ECDSAOwnedDKIMRegistry<SignerM>, anyhow::Error> {
        let email_auth_address: H160 = email_auth_addr.parse()?;
        let contract = EmailAuth::new(email_auth_address, self.client.clone());
        let dkim = contract.dkim_registry_addr().call().await?;

        Ok(ECDSAOwnedDKIMRegistry::new(dkim, self.client.clone()))
    }

    pub async fn get_email_auth_addr_from_wallet(
        &self,
        controller_eth_addr: &String,
        wallet_addr: &String,
        account_salt: &String,
    ) -> Result<H160, anyhow::Error> {
        let controller_eth_addr: H160 = controller_eth_addr.parse()?;
        let wallet_address: H160 = wallet_addr.parse()?;
        let contract = EmailAccountRecovery::new(controller_eth_addr, self.client.clone());
        let account_salt_bytes = hex::decode(account_salt.trim_start_matches("0x"))
            .map_err(|e| anyhow!("Failed to decode account_salt: {}", e))?;
        let email_auth_addr = contract
            .compute_email_auth_address(
                wallet_address,
                account_salt_bytes
                    .try_into()
                    .map_err(|_| anyhow!("account_salt must be 32 bytes"))?,
            )
            .await?;
        Ok(email_auth_addr)
    }

    pub async fn is_wallet_deployed(&self, wallet_addr_str: &String) -> Result<bool, ChainError> {
        let wallet_addr: H160 = wallet_addr_str.parse().map_err(ChainError::HexError)?;
        match self.client.get_code(wallet_addr, None).await {
            Ok(code) => Ok(!code.is_empty()),
            Err(e) => {
                // Log the error or handle it as needed
                Err(ChainError::signer_middleware_error(
                    "Failed to check if wallet is deployed",
                    e,
                ))
            }
        }
    }

    pub async fn get_acceptance_command_templates(
        &self,
        controller_eth_addr: &String,
        template_idx: u64,
    ) -> Result<Vec<String>, ChainError> {
        let controller_eth_addr: H160 =
            controller_eth_addr.parse().map_err(ChainError::HexError)?;
        let contract = EmailAccountRecovery::new(controller_eth_addr, self.client.clone());
        let templates = contract
            .acceptance_command_templates()
            .call()
            .await
            .map_err(|e| {
                ChainError::contract_error("Failed to get acceptance subject templates", e)
            })?;
        Ok(templates[template_idx as usize].clone())
    }

    pub async fn get_recovery_command_templates(
        &self,
        controller_eth_addr: &String,
        template_idx: u64,
    ) -> Result<Vec<String>, ChainError> {
        let controller_eth_addr: H160 =
            controller_eth_addr.parse().map_err(ChainError::HexError)?;
        let contract = EmailAccountRecovery::new(controller_eth_addr, self.client.clone());
        let templates = contract
            .recovery_command_templates()
            .call()
            .await
            .map_err(|e| {
                ChainError::contract_error("Failed to get recovery subject templates", e)
            })?;
        Ok(templates[template_idx as usize].clone())
    }

    pub async fn complete_recovery(
        &self,
        controller_eth_addr: &String,
        account_eth_addr: &String,
        complete_calldata: &String,
    ) -> Result<bool, ChainError> {
        let controller_eth_addr: H160 =
            controller_eth_addr.parse().map_err(ChainError::HexError)?;
        let contract = EmailAccountRecovery::new(controller_eth_addr, self.client.clone());
        let decoded_calldata =
            hex::decode(&complete_calldata.trim_start_matches("0x")).expect("Decoding failed");
        let account_eth_addr = account_eth_addr
            .parse::<H160>()
            .map_err(ChainError::HexError)?;
        let call = contract.complete_recovery(account_eth_addr, Bytes::from(decoded_calldata));
        let tx = call
            .send()
            .await
            .map_err(|e| ChainError::contract_error("Failed to call complete_recovery", e))?;
        // If the transaction is successful, the function will return true and false otherwise.
        let receipt = tx
            .log()
            .confirmations(CONFIRMATIONS)
            .await
            .map_err(|e| {
                ChainError::provider_error(
                    "Failed to get receipt after calling complete_recovery",
                    e,
                )
            })?
            .ok_or(anyhow!("No receipt"))?;
        Ok(receipt
            .status
            .map(|status| status == U64::from(1))
            .unwrap_or(false))
    }

    pub async fn handle_acceptance(
        &self,
        controller_eth_addr: &String,
        email_auth_msg: EmailAuthMsg,
        template_idx: u64,
    ) -> std::result::Result<bool, ChainError> {
        let controller_eth_addr: H160 = controller_eth_addr.parse()?;
        let contract = EmailAccountRecovery::new(controller_eth_addr, self.client.clone());
        let call = contract.handle_acceptance(email_auth_msg, template_idx.into());
        let tx = call
            .send()
            .await
            .map_err(|e| ChainError::contract_error("Failed to call handle_acceptance", e))?;
        // If the transaction is successful, the function will return true and false otherwise.
        let receipt = tx
            .log()
            .confirmations(CONFIRMATIONS)
            .await
            .map_err(|e| {
                ChainError::provider_error(
                    "Failed to get receipt after calling handle_acceptance",
                    e,
                )
            })?
            .ok_or(anyhow!("No receipt"))?;
        Ok(receipt
            .status
            .map(|status| status == U64::from(1))
            .unwrap_or(false))
    }

    pub async fn handle_recovery(
        &self,
        controller_eth_addr: &String,
        email_auth_msg: EmailAuthMsg,
        template_idx: u64,
    ) -> std::result::Result<bool, ChainError> {
        let controller_eth_addr: H160 = controller_eth_addr.parse()?;
        let contract = EmailAccountRecovery::new(controller_eth_addr, self.client.clone());
        let call = contract.handle_recovery(email_auth_msg, template_idx.into());
        let tx = call
            .send()
            .await
            .map_err(|e| ChainError::contract_error("Failed to call handle_recovery", e))?;
        // If the transaction is successful, the function will return true and false otherwise.
        let receipt = tx
            .log()
            .confirmations(CONFIRMATIONS)
            .await
            .map_err(|e| {
                ChainError::provider_error("Failed to get receipt after calling handle_recovery", e)
            })?
            .ok_or(anyhow!("No receipt"))?;
        Ok(receipt
            .status
            .map(|status| status == U64::from(1))
            .unwrap_or(false))
    }

    pub async fn get_bytecode(
        &self,
        wallet_addr: &String,
    ) -> std::result::Result<Bytes, ChainError> {
        let wallet_address: H160 = wallet_addr.parse().map_err(ChainError::HexError)?;
        let client_code = self
            .client
            .get_code(wallet_address, None)
            .await
            .map_err(|e| ChainError::signer_middleware_error("Failed to get bytecode", e))?;
        Ok(client_code)
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

    pub async fn get_recovered_account_from_acceptance_command(
        &self,
        controller_eth_addr: &String,
        command_params: Vec<TemplateValue>,
        template_idx: u64,
    ) -> Result<H160, ChainError> {
        let controller_eth_addr: H160 =
            controller_eth_addr.parse().map_err(ChainError::HexError)?;
        let contract = EmailAccountRecovery::new(controller_eth_addr, self.client.clone());
        let command_params_bytes = command_params
            .iter() // Change here: use iter() instead of map() directly on Vec
            .map(|s| {
                s.abi_encode(None) // Assuming decimal_size is not needed or can be None
                    .unwrap_or_else(|_| Bytes::from("Error encoding".as_bytes().to_vec()))
            }) // Error handling
            .collect::<Vec<_>>();
        let recovered_account = contract
            .extract_recovered_account_from_acceptance_command(
                command_params_bytes,
                template_idx.into(),
            )
            .call()
            .await
            .map_err(|e| {
                ChainError::contract_error(
                    "Failed to get recovered account from acceptance subject",
                    e,
                )
            })?;
        Ok(recovered_account)
    }

    pub async fn get_recovered_account_from_recovery_command(
        &self,
        controller_eth_addr: &String,
        command_params: Vec<TemplateValue>,
        template_idx: u64,
    ) -> Result<H160, ChainError> {
        let controller_eth_addr: H160 =
            controller_eth_addr.parse().map_err(ChainError::HexError)?;
        let contract = EmailAccountRecovery::new(controller_eth_addr, self.client.clone());
        let command_params_bytes = command_params
            .iter() // Change here: use iter() instead of map() directly on Vec
            .map(|s| {
                s.abi_encode(None).map_err(|_| {
                    ChainError::Validation("Error encoding subject parameters".to_string())
                })
            })
            .collect::<Result<Vec<_>, ChainError>>()?;
        let recovered_account = contract
            .extract_recovered_account_from_recovery_command(
                command_params_bytes,
                template_idx.into(),
            )
            .call()
            .await
            .map_err(|e| {
                ChainError::contract_error(
                    "Failed to get recovered account from recovery subject",
                    e,
                )
            })?;
        Ok(recovered_account)
    }

    pub async fn get_is_activated(
        &self,
        controller_eth_addr: &String,
        account_eth_addr: &String,
    ) -> Result<bool, ChainError> {
        let controller_eth_addr: H160 =
            controller_eth_addr.parse().map_err(ChainError::HexError)?;
        let account_eth_addr: H160 = account_eth_addr.parse().map_err(ChainError::HexError)?;
        let contract = EmailAccountRecovery::new(controller_eth_addr, self.client.clone());
        let is_activated = contract
            .is_activated(account_eth_addr)
            .call()
            .await
            .map_err(|e| ChainError::contract_error("Failed to check if is activated", e))?;
        Ok(is_activated)
    }
}
