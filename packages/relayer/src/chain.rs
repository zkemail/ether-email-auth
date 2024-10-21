use crate::*;
use abis::email_account_recovery::EmailAuthMsg;
use ethers::middleware::Middleware;
use ethers::prelude::*;
use ethers::signers::Signer;
use relayer_utils::converters::u64_to_u8_array_32;
use relayer_utils::TemplateValue;

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
    pub async fn setup() -> Result<Self> {
        let wallet: LocalWallet = PRIVATE_KEY.get().unwrap().parse()?;
        let provider = Provider::<Http>::try_from(CHAIN_RPC_PROVIDER.get().unwrap())?;

        // Create a new SignerMiddleware with the provider and wallet
        let client = Arc::new(SignerMiddleware::new(
            provider,
            wallet.with_chain_id(*CHAIN_ID.get().unwrap()),
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

        let main_authorizer = dkim.main_authorizer().call().await?;
        let call =
            dkim.set_dkim_public_key_hash(domain_name, public_key_hash, main_authorizer, signature);
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
        dkim: UserOverridableDKIMRegistry<SignerM>,
    ) -> Result<bool> {
        // Call the contract method to check if the hash is valid
        let main_authorizer = dkim.main_authorizer().call().await?;
        let is_valid = dkim
            .is_dkim_public_key_hash_valid_with_domain_name_and_public_key_hash(
                domain_name,
                public_key_hash,
                main_authorizer,
            )
            .call()
            .await?;
        Ok(is_valid)
    }

    /// Gets the DKIM from a controller.
    ///
    /// # Arguments
    ///
    /// * `controller_eth_addr` - The controller Ethereum address as a string.
    ///
    /// # Returns
    ///
    /// A `Result` containing the ECDSA Owned DKIM Registry if successful, or an error if not.
    pub async fn get_dkim_from_controller(
        &self,
        controller_eth_addr: &str,
    ) -> Result<UserOverridableDKIMRegistry<SignerM>, anyhow::Error> {
        let controller_eth_addr: H160 = controller_eth_addr.parse()?;

        // Create a new EmailAccountRecovery contract instance
        let contract = EmailAccountRecovery::new(controller_eth_addr, self.client.clone());

        // Call the dkim method to get the DKIM registry address
        let dkim = contract.dkim().call().await?;
        Ok(UserOverridableDKIMRegistry::new(dkim, self.client.clone()))
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
        email_auth_addr: &String,
    ) -> Result<UserOverridableDKIMRegistry<SignerM>, anyhow::Error> {
        let email_auth_address: H160 = email_auth_addr.parse()?;

        // Create a new EmailAuth contract instance
        let contract = EmailAuth::new(email_auth_address, self.client.clone());

        // Call the dkim_registry_addr method to get the DKIM registry address
        let dkim = contract.dkim_registry_addr().call().await?;

        Ok(UserOverridableDKIMRegistry::new(dkim, self.client.clone()))
    }

    /// Gets the email auth address from a wallet.
    ///
    /// # Arguments
    ///
    /// * `controller_eth_addr` - The controller Ethereum address as a string.
    /// * `wallet_addr` - The wallet address as a string.
    /// * `account_salt` - The account salt as a string.
    ///
    /// # Returns
    ///
    /// A `Result` containing the email auth address as H160 if successful, or an error if not.
    pub async fn get_email_auth_addr_from_wallet(
        &self,
        controller_eth_addr: &str,
        wallet_addr: &str,
        account_salt: &str,
    ) -> Result<H160, anyhow::Error> {
        // Parse the controller and wallet Ethereum addresses
        let controller_eth_addr: H160 = controller_eth_addr.parse()?;
        let wallet_address: H160 = wallet_addr.parse()?;

        // Create a new EmailAccountRecovery contract instance
        let contract = EmailAccountRecovery::new(controller_eth_addr, self.client.clone());

        // Decode the account salt
        let account_salt_bytes = hex::decode(account_salt.trim_start_matches("0x"))
            .map_err(|e| anyhow!("Failed to decode account_salt: {}", e))?;

        // Compute the email auth address
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

    /// Checks if a wallet is deployed.
    ///
    /// # Arguments
    ///
    /// * `wallet_addr_str` - The wallet address as a string.
    ///
    /// # Returns
    ///
    /// A `Result` containing a boolean indicating if the wallet is deployed.
    pub async fn is_wallet_deployed(&self, wallet_addr_str: &str) -> Result<bool, ChainError> {
        // Parse the wallet address
        let wallet_addr: H160 = wallet_addr_str.parse().map_err(ChainError::HexError)?;

        // Get the bytecode at the wallet address
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

    /// Gets the acceptance command templates.
    ///
    /// # Arguments
    ///
    /// * `controller_eth_addr` - The controller Ethereum address as a string.
    /// * `template_idx` - The template index.
    ///
    /// # Returns
    ///
    /// A `Result` containing a vector of acceptance command templates.
    pub async fn get_acceptance_command_templates(
        &self,
        controller_eth_addr: &str,
        template_idx: u64,
    ) -> Result<Vec<String>, ChainError> {
        // Parse the controller Ethereum address
        let controller_eth_addr: H160 =
            controller_eth_addr.parse().map_err(ChainError::HexError)?;

        // Create a new EmailAccountRecovery contract instance
        let contract = EmailAccountRecovery::new(controller_eth_addr, self.client.clone());

        // Get the acceptance command templates
        let templates = contract
            .acceptance_command_templates()
            .call()
            .await
            .map_err(|e| {
                ChainError::contract_error("Failed to get acceptance subject templates", e)
            })?;
        Ok(templates[template_idx as usize].clone())
    }

    /// Gets the recovery command templates.
    ///
    /// # Arguments
    ///
    /// * `controller_eth_addr` - The controller Ethereum address as a string.
    /// * `template_idx` - The template index.
    ///
    /// # Returns
    ///
    /// A `Result` containing a vector of recovery command templates.
    pub async fn get_recovery_command_templates(
        &self,
        controller_eth_addr: &str,
        template_idx: u64,
    ) -> Result<Vec<String>, ChainError> {
        // Parse the controller Ethereum address
        let controller_eth_addr: H160 =
            controller_eth_addr.parse().map_err(ChainError::HexError)?;

        // Create a new EmailAccountRecovery contract instance
        let contract = EmailAccountRecovery::new(controller_eth_addr, self.client.clone());

        // Get the recovery command templates
        let templates = contract
            .recovery_command_templates()
            .call()
            .await
            .map_err(|e| {
                ChainError::contract_error("Failed to get recovery command templates", e)
            })?;
        Ok(templates[template_idx as usize].clone())
    }

    /// Completes the recovery process.
    ///
    /// # Arguments
    ///
    /// * `controller_eth_addr` - The controller Ethereum address as a string.
    /// * `account_eth_addr` - The account Ethereum address as a string.
    /// * `complete_calldata` - The complete calldata as a string.
    ///
    /// # Returns
    ///
    /// A `Result` containing a boolean indicating if the recovery was successful.
    pub async fn complete_recovery(
        &self,
        controller_eth_addr: &str,
        account_eth_addr: &str,
        complete_calldata: &str,
    ) -> Result<bool, ChainError> {
        // Parse the controller and account Ethereum addresses
        let controller_eth_addr: H160 =
            controller_eth_addr.parse().map_err(ChainError::HexError)?;

        // Create a new EmailAccountRecovery contract instance
        let contract = EmailAccountRecovery::new(controller_eth_addr, self.client.clone());

        // Decode the complete calldata
        let decoded_calldata =
            hex::decode(complete_calldata.trim_start_matches("0x")).expect("Decoding failed");

        let account_eth_addr = account_eth_addr
            .parse::<H160>()
            .map_err(ChainError::HexError)?;

        // Call the complete_recovery method
        let call = contract.complete_recovery(account_eth_addr, Bytes::from(decoded_calldata));

        let tx = call
            .send()
            .await
            .map_err(|e| ChainError::contract_error("Failed to call complete_recovery", e))?;

        // Wait for the transaction to be confirmed
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

        // Check if the transaction was successful
        Ok(receipt
            .status
            .map(|status| status == U64::from(1))
            .unwrap_or(false))
    }

    /// Handles the acceptance process.
    ///
    /// # Arguments
    ///
    /// * `controller_eth_addr` - The controller Ethereum address as a string.
    /// * `email_auth_msg` - The email authentication message.
    /// * `template_idx` - The template index.
    ///
    /// # Returns
    ///
    /// A `Result` containing a boolean indicating if the acceptance was successful.
    pub async fn handle_acceptance(
        &self,
        controller_eth_addr: &str,
        email_auth_msg: EmailAuthMsg,
        template_idx: u64,
    ) -> std::result::Result<bool, ChainError> {
        // Parse the controller Ethereum address
        let controller_eth_addr: H160 = controller_eth_addr.parse()?;

        // Create a new EmailAccountRecovery contract instance
        let contract = EmailAccountRecovery::new(controller_eth_addr, self.client.clone());

        // Call the handle_acceptance method
        let call = contract.handle_acceptance(email_auth_msg, template_idx.into());
        let tx = call
            .send()
            .await
            .map_err(|e| ChainError::contract_error("Failed to call handle_acceptance", e))?;

        // Wait for the transaction to be confirmed
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

        // Check if the transaction was successful
        Ok(receipt
            .status
            .map(|status| status == U64::from(1))
            .unwrap_or(false))
    }

    /// Handles the recovery process.
    ///
    /// # Arguments
    ///
    /// * `controller_eth_addr` - The controller Ethereum address as a string.
    /// * `email_auth_msg` - The email authentication message.
    /// * `template_idx` - The template index.
    ///
    /// # Returns
    ///
    /// A `Result` containing a boolean indicating if the recovery was successful.
    pub async fn handle_recovery(
        &self,
        controller_eth_addr: &str,
        email_auth_msg: EmailAuthMsg,
        template_idx: u64,
    ) -> std::result::Result<bool, ChainError> {
        // Parse the controller Ethereum address
        let controller_eth_addr: H160 = controller_eth_addr.parse()?;

        // Create a new EmailAccountRecovery contract instance
        let contract = EmailAccountRecovery::new(controller_eth_addr, self.client.clone());

        // Call the handle_recovery method
        let call = contract.handle_recovery(email_auth_msg, template_idx.into());
        let tx = call
            .send()
            .await
            .map_err(|e| ChainError::contract_error("Failed to call handle_recovery", e))?;

        // Wait for the transaction to be confirmed
        let receipt = tx
            .log()
            .confirmations(CONFIRMATIONS)
            .await
            .map_err(|e| {
                ChainError::provider_error("Failed to get receipt after calling handle_recovery", e)
            })?
            .ok_or(anyhow!("No receipt"))?;

        // Check if the transaction was successful
        Ok(receipt
            .status
            .map(|status| status == U64::from(1))
            .unwrap_or(false))
    }

    /// Gets the bytecode of a wallet.
    ///
    /// # Arguments
    ///
    /// * `wallet_addr` - The wallet address as a string.
    ///
    /// # Returns
    ///
    /// A `Result` containing the bytecode as Bytes.
    pub async fn get_bytecode(&self, wallet_addr: &str) -> std::result::Result<Bytes, ChainError> {
        // Parse the wallet address
        let wallet_address: H160 = wallet_addr.parse().map_err(ChainError::HexError)?;

        // Get the bytecode at the wallet address
        let client_code = self
            .client
            .get_code(wallet_address, None)
            .await
            .map_err(|e| ChainError::signer_middleware_error("Failed to get bytecode", e))?;
        Ok(client_code)
    }

    /// Gets the storage at a specific slot for a wallet.
    ///
    /// # Arguments
    ///
    /// * `wallet_addr` - The wallet address as a string.
    /// * `slot` - The storage slot.
    ///
    /// # Returns
    ///
    /// A `Result` containing the storage value as H256.
    pub async fn get_storage_at(
        &self,
        wallet_addr: &str,
        slot: u64,
    ) -> Result<H256, anyhow::Error> {
        // Parse the wallet address
        let wallet_address: H160 = wallet_addr.parse()?;

        // Get the storage at the specified slot
        Ok(self
            .client
            .get_storage_at(wallet_address, u64_to_u8_array_32(slot).into(), None)
            .await?)
    }

    /// Gets the recovered account from an acceptance command.
    ///
    /// # Arguments
    ///
    /// * `controller_eth_addr` - The controller Ethereum address as a string.
    /// * `command_params` - The command parameters.
    /// * `template_idx` - The template index.
    ///
    /// # Returns
    ///
    /// A `Result` containing the recovered account address as H160.
    pub async fn get_recovered_account_from_acceptance_command(
        &self,
        controller_eth_addr: &str,
        command_params: Vec<TemplateValue>,
        template_idx: u64,
    ) -> Result<H160, ChainError> {
        // Parse the controller Ethereum address
        let controller_eth_addr: H160 =
            controller_eth_addr.parse().map_err(ChainError::HexError)?;

        // Create a new EmailAccountRecovery contract instance
        let contract = EmailAccountRecovery::new(controller_eth_addr, self.client.clone());

        // Encode the command parameters
        let command_params_bytes = command_params
            .iter()
            .map(|s| {
                s.abi_encode(None)
                    .unwrap_or_else(|_| Bytes::from("Error encoding".as_bytes().to_vec()))
            })
            .collect::<Vec<_>>();

        // Call the extract_recovered_account_from_acceptance_command method
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

    /// Gets the recovered account from a recovery command.
    ///
    /// # Arguments
    ///
    /// * `controller_eth_addr` - The controller Ethereum address as a string.
    /// * `command_params` - The command parameters.
    /// * `template_idx` - The template index.
    ///
    /// # Returns
    ///
    /// A `Result` containing the recovered account address as H160.
    pub async fn get_recovered_account_from_recovery_command(
        &self,
        controller_eth_addr: &str,
        command_params: Vec<TemplateValue>,
        template_idx: u64,
    ) -> Result<H160, ChainError> {
        // Parse the controller Ethereum address
        let controller_eth_addr: H160 =
            controller_eth_addr.parse().map_err(ChainError::HexError)?;

        // Create a new EmailAccountRecovery contract instance
        let contract = EmailAccountRecovery::new(controller_eth_addr, self.client.clone());

        // Encode the command parameters
        let command_params_bytes = command_params
            .iter()
            .map(|s| {
                s.abi_encode(None).map_err(|_| {
                    ChainError::Validation("Error encoding subject parameters".to_string())
                })
            })
            .collect::<Result<Vec<_>, ChainError>>()?;

        // Call the extract_recovered_account_from_recovery_command method
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

    /// Checks if an account is activated.
    ///
    /// # Arguments
    ///
    /// * `controller_eth_addr` - The controller Ethereum address as a string.
    /// * `account_eth_addr` - The account Ethereum address as a string.
    ///
    /// # Returns
    ///
    /// A `Result` containing a boolean indicating if the account is activated.
    pub async fn get_is_activated(
        &self,
        controller_eth_addr: &str,
        account_eth_addr: &str,
    ) -> Result<bool, ChainError> {
        // Parse the controller and account Ethereum addresses
        let controller_eth_addr: H160 =
            controller_eth_addr.parse().map_err(ChainError::HexError)?;
        let account_eth_addr: H160 = account_eth_addr.parse().map_err(ChainError::HexError)?;

        // Create a new EmailAccountRecovery contract instance
        let contract = EmailAccountRecovery::new(controller_eth_addr, self.client.clone());

        // Call the is_activated method
        let is_activated = contract
            .is_activated(account_eth_addr)
            .call()
            .await
            .map_err(|e| ChainError::contract_error("Failed to check if is activated", e))?;
        Ok(is_activated)
    }
}
