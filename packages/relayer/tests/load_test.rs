mod erc1967_proxy;
mod simple_wallet;
pub(crate) use erc1967_proxy::*;
use ethers::utils::to_checksum;
use futures::future::join_all;
use relayer_utils::converters::{field2hex, fr_to_bytes32};
use relayer_utils::cryptos::{AccountCode, AccountSalt, PaddedEmailAddr};
use relayer_utils::parse_email::ParsedEmail;
use relayer_utils::regex::extract_substr_idxes;
use serde_json::json;
use simple_wallet::InitializeCall;
pub(crate) use simple_wallet::*;

use anyhow::{anyhow, Result};
use dotenv::dotenv;
use ethers::abi::AbiEncode;
use ethers::middleware::Middleware;
use ethers::prelude::*;
use ethers::signers::Signer;
use relayer::*;
use relayer_utils::*;
use reqwest;
use std::env;
use std::sync::{Arc, Mutex};
use std::time::Duration;
use tokio::task;
use tokio::time::sleep;

const CONFIRMATIONS: usize = 1;

type SignerM = SignerMiddleware<Provider<Http>, LocalWallet>;

#[derive(Debug, Clone)]
pub struct TestEnv {
    main_client: ChainClient,
    eth_amount_per_account: U256,
    verifier_addr: Address,
    dkim_addr: Address,
    email_auth_impl_addr: Address,
    wallet_impl_addr: Address,
    test_accounts: Vec<TestAccount>,
}

#[derive(Debug, Clone)]
pub struct TestAccount {
    pub client: Arc<SignerM>,
    wallet: SimpleWallet<SignerM>,
    new_owner: Address,
    relayer_hostname: String,
    relayer_eth_addr: Address,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
pub enum GuardianStatus {
    NotGuardian = 0,
    Requested = 1,
    Confirmed = 2,
}

pub enum TestAccountStatus {
    Init,
    GuardianRequested,
    GuardianConfirmed,
    RecoveryRequested,
    RecoveryConfirmed,
    End,
}

impl TestEnv {
    pub async fn setup() -> Result<Self> {
        PRIVATE_KEY
            .set(env::var("TEST_PRIVATE_KEY").unwrap())
            .unwrap();
        CHAIN_RPC_PROVIDER
            .set(env::var("CHAIN_RPC_PROVIDER").unwrap())
            .unwrap();
        CHAIN_ID
            .set(env::var("CHAIN_ID").unwrap().parse().unwrap())
            .unwrap();
        let eth_amount_per_account = env::var("TEST_ETH_AMOUNT_PER_ACCOUNT").unwrap();
        let verifier_addr = env::var("TEST_VERIFIER_ADDR").unwrap().parse()?;
        let dkim_addr = env::var("TEST_DKIM_ADDR").unwrap().parse()?;
        let email_auth_impl_addr = env::var("TEST_EMAIL_AUTH_IMPL_ADDR").unwrap().parse()?;
        let wallet_impl_addr = env::var("TEST_WALLET_IMPL_ADDR").unwrap().parse()?;
        let main_client = ChainClient::setup().await?;
        let eth_amount_per_account = U256::from_str_radix(&eth_amount_per_account, 10)?;
        let test_accounts = vec![];

        Ok(Self {
            main_client,
            eth_amount_per_account,
            verifier_addr,
            dkim_addr,
            email_auth_impl_addr,
            wallet_impl_addr,
            test_accounts,
        })
    }

    pub async fn add_test_account(&mut self) -> Result<()> {
        // randomly generate a private key
        let test_wallet = LocalWallet::new(&mut rand::thread_rng());
        let provider = Provider::<Http>::try_from(CHAIN_RPC_PROVIDER.get().unwrap())?;
        let test_client = Arc::new(SignerMiddleware::new(
            provider,
            test_wallet.with_chain_id(*CHAIN_ID.get().unwrap()),
        ));
        {
            // transfer self.eth_amount_per_account to the test account
            let tx = self
                .main_client
                .client
                .send_transaction(
                    TransactionRequest::new()
                        .to(test_client.address())
                        .value(self.eth_amount_per_account),
                    None,
                )
                .await?;
            let receipt = tx
                .log()
                .confirmations(CONFIRMATIONS)
                .await?
                .ok_or(anyhow!("No receipt"))?;
            let tx_hash = receipt.transaction_hash;
            let tx_hash = format!("0x{}", hex::encode(tx_hash.as_bytes()));
            println!("ETH Transfer tx hash: {}", tx_hash);
        }

        let wallet_init_call = SimpleWalletCalls::Initialize(InitializeCall {
            initial_owner: self.main_client.client.address(),
            verifier: self.verifier_addr,
            dkim: self.dkim_addr,
            email_auth_implementation: self.email_auth_impl_addr,
        });
        let wallet_init_data = wallet_init_call.encode();
        let proxy_deploy = ERC1967Proxy::deploy(
            test_client.clone(),
            (self.wallet_impl_addr, wallet_init_data),
        )?;
        let proxy = proxy_deploy.send().await?;
        let wallet = SimpleWallet::new(proxy.address(), test_client.clone());
        let new_owner = LocalWallet::new(&mut rand::thread_rng()).address();
        let relayer_hostname = env::var("TEST_RELAYER_HOSTNAME").unwrap();

        let test_account = TestAccount {
            client: test_client,
            wallet,
            new_owner,
            relayer_hostname,
            relayer_eth_addr: self.main_client.client.address(),
        };
        self.test_accounts.push(test_account);
        Ok(())
    }

    pub fn main_address(&self) -> Address {
        self.main_client.client.address()
    }
}

impl TestAccount {
    pub async fn process(mut self) -> Result<()> {
        let mut state = TestAccountStatus::Init;
        let imap_config = ImapConfig {
            domain_name: env::var("IMAP_DOMAIN_NAME").unwrap(),
            port: env::var("IMAP_PORT").unwrap().parse().unwrap(),
            auth: ImapAuth::Password {
                user_id: env::var("TEST_LOGIN_ID").unwrap(),
                password: env::var("TEST_LOGIN_PASSWORD").unwrap(),
            },
            initially_checked: false,
        };

        let mut imap_client = ImapClient::new(imap_config).await?;

        let smtp_config = SmtpConfig {
            domain_name: env::var("SMTP_DOMAIN_NAME").unwrap(),
            id: env::var("TEST_LOGIN_ID").unwrap(),
            password: env::var("TEST_LOGIN_PASSWORD").unwrap(),
        };
        let smtp_client = SmtpClient::new(smtp_config)?;

        let mut request_id: Option<u64> = None;
        let mut account_code: AccountCode = AccountCode::new(rand::thread_rng());
        let mut guardian_email_addr = env::var("TEST_LOGIN_ID").unwrap();
        let account_salt = AccountSalt::new(
            &PaddedEmailAddr::from_email_addr(&guardian_email_addr),
            account_code,
        )?;
        let guardian_eth_addr = self
            .wallet
            .compute_email_auth_address(fr_to_bytes32(&account_salt.0)?)
            .await?;
        loop {
            match state {
                TestAccountStatus::Init => {
                    self.request_guardian(guardian_eth_addr).await?;
                    request_id = Some(
                        self.call_acceptance_request_api(&guardian_email_addr, account_code)
                            .await?,
                    );
                    state = TestAccountStatus::GuardianRequested;
                    continue;
                }
                TestAccountStatus::GuardianRequested => {
                    if self.get_guardian_status(guardian_eth_addr).await?
                        != GuardianStatus::Requested
                    {
                        continue;
                    }
                    let fetches = imap_client.retrieve_new_emails().await?;
                    println!("Received emails: {:?}", fetches);
                    let mut found = false;
                    for fetch in fetches {
                        for email in fetch.iter() {
                            if let Some(body) = email.body() {
                                let raw_email = String::from_utf8(body.to_vec())?;
                                println!("Received email {}", raw_email);
                                let request_decomposed_def = serde_json::from_str(include_str!(
                                    "../src/regex_json/request_def.json"
                                ))?;
                                let request_idxes =
                                    extract_substr_idxes(&raw_email, &request_decomposed_def)?;
                                if request_idxes.is_empty() {
                                    println!("No request id found in email");
                                    continue;
                                }
                                let request_id_str =
                                    &raw_email[request_idxes[0].0..request_idxes[0].1];
                                let request_id_u64 =
                                    request_id_str.parse::<u64>().map_err(|e| {
                                        anyhow!("Failed to parse request_id to u64: {}", e)
                                    })?;
                                if request_id_u64 != request_id.unwrap() {
                                    println!("Request id mismatch");
                                    continue;
                                }
                                found = true;
                                let parsed_email =
                                    ParsedEmail::new_from_raw_email(&raw_email).await?;
                                let send_email = EmailMessage {
                                    to: env::var("TEST_RELAYER_EMAIL_ADDR").unwrap(),
                                    subject: parsed_email.get_subject_all()?,
                                    reference: None,
                                    reply_to: None,
                                    body_plain: parsed_email.canonicalized_body.clone(),
                                    body_html: String::new(),
                                    body_attachments: None,
                                };
                                smtp_client.send_new_email(send_email).await?;
                                println!("Sent email");
                                break;
                            }
                        }
                    }
                    if found {
                        state = TestAccountStatus::GuardianConfirmed;
                    }
                    continue;
                }
                TestAccountStatus::GuardianConfirmed => {
                    if self.get_guardian_status(guardian_eth_addr).await?
                        != GuardianStatus::Confirmed
                    {
                        continue;
                    }
                    request_id = Some(self.call_recovery_request_api(&guardian_email_addr).await?);
                    state = TestAccountStatus::RecoveryRequested;
                }
                TestAccountStatus::RecoveryRequested => {
                    let fetches = imap_client.retrieve_new_emails().await?;
                    println!("Received emails: {:?}", fetches);
                    let mut found = false;
                    for fetch in fetches {
                        for email in fetch.iter() {
                            if let Some(body) = email.body() {
                                let raw_email = String::from_utf8(body.to_vec())?;
                                println!("Received email {}", raw_email);
                                let request_decomposed_def = serde_json::from_str(include_str!(
                                    "../src/regex_json/request_def.json"
                                ))?;
                                let request_idxes =
                                    extract_substr_idxes(&raw_email, &request_decomposed_def)?;
                                if request_idxes.is_empty() {
                                    println!("No request id found in email");
                                    continue;
                                }
                                let request_id_str =
                                    &raw_email[request_idxes[0].0..request_idxes[0].1];
                                let request_id_u64 =
                                    request_id_str.parse::<u64>().map_err(|e| {
                                        anyhow!("Failed to parse request_id to u64: {}", e)
                                    })?;
                                if request_id_u64 != request_id.unwrap() {
                                    println!("Request id mismatch");
                                    continue;
                                }
                                found = true;
                                let parsed_email =
                                    ParsedEmail::new_from_raw_email(&raw_email).await?;
                                let send_email = EmailMessage {
                                    to: env::var("TEST_RELAYER_EMAIL_ADDR").unwrap(),
                                    subject: parsed_email.get_subject_all()?,
                                    reference: None,
                                    reply_to: None,
                                    body_plain: parsed_email.canonicalized_body.clone(),
                                    body_html: String::new(),
                                    body_attachments: None,
                                };
                                smtp_client.send_new_email(send_email).await?;
                                println!("Sent email");
                                break;
                            }
                        }
                    }
                    if found {
                        state = TestAccountStatus::RecoveryConfirmed;
                    }
                    continue;
                }
                TestAccountStatus::RecoveryConfirmed => {
                    if !self.wallet.is_recovering().await? {
                        continue;
                    }
                    if self.new_owner != self.wallet.new_signer_candidate().await? {
                        return Err(anyhow!("New owner mismatch on-chain"));
                    }
                    let block_time = self
                        .client
                        .get_block(BlockNumber::Latest)
                        .await?
                        .unwrap()
                        .timestamp;
                    if block_time < self.wallet.timelock().await? {
                        continue;
                    }
                    self.complete_recovery().await?;
                    self.return_all_eth(self.relayer_eth_addr).await?;
                    state = TestAccountStatus::End;
                    continue;
                }
                TestAccountStatus::End => {
                    if self.wallet.is_recovering().await? {
                        continue;
                    }
                    if self.new_owner != self.wallet.owner().await? {
                        return Err(anyhow!("Owner mismatch on-chain"));
                    }
                    return Ok(());
                }
            }
            sleep(Duration::from_secs(5)).await;
        }
    }

    pub async fn get_guardian_status(&self, guardian_eth_addr: Address) -> Result<GuardianStatus> {
        let status = self.wallet.guardians(guardian_eth_addr).call().await?;
        match status {
            0 => Ok(GuardianStatus::NotGuardian),
            1 => Ok(GuardianStatus::Requested),
            2 => Ok(GuardianStatus::Confirmed),
            _ => Err(anyhow!("Invalid guardian status")),
        }
    }

    async fn request_guardian(&mut self, guardian_eth_addr: Address) -> Result<()> {
        let call = self.wallet.request_guardian(guardian_eth_addr);
        let tx = call.send().await?;
        let receipt = tx
            .log()
            .confirmations(CONFIRMATIONS)
            .await?
            .ok_or(anyhow!("No receipt"))?;
        let tx_hash = receipt.transaction_hash;
        let tx_hash = format!("0x{}", hex::encode(tx_hash.as_bytes()));
        println!("Request Guardian tx hash: {}", tx_hash);
        Ok(())
    }

    async fn call_acceptance_request_api(
        &mut self,
        guardian_email_addr: &str,
        account_code: AccountCode,
    ) -> Result<u64> {
        let wallet_addr = to_checksum(&self.wallet.address(), None);
        let account_code_hex = field2hex(&account_code.0);
        let template_idx = 0;
        let subject = format!("Accept guardian request for {}", wallet_addr,);
        // call POST api of "{self.relayer_hostname}/api/acceptanceRequest" with input json
        let client = reqwest::Client::new();
        let res = client
            .post(&format!("{}/api/acceptanceRequest", self.relayer_hostname))
            .json(&json!({
                "wallet_eth_addr": wallet_addr,
                "guardian_email_addr": guardian_email_addr,
                "account_code": account_code_hex,
                "template_idx": template_idx,
                "subject": subject,
            }))
            .send()
            .await?;
        if res.status() != 200 {
            return Err(anyhow!("API call to acceptanceRequest failed"));
        }
        let res_json = res.json::<AcceptanceResponse>().await?;
        Ok(res_json.request_id)
    }

    async fn call_recovery_request_api(&mut self, guardian_email_addr: &str) -> Result<u64> {
        let wallet_addr = to_checksum(&self.wallet.address(), None);
        let template_idx = 0;
        let subject = format!(
            "Set the new signer of {} to {}",
            wallet_addr, self.new_owner
        );
        // call POST api of "{self.relayer_hostname}/api/acceptanceRequest" with input json
        let client = reqwest::Client::new();
        let res = client
            .post(&format!("{}/api/recoveryRequest", self.relayer_hostname))
            .json(&json!({
                "wallet_eth_addr": wallet_addr,
                "guardian_email_addr": guardian_email_addr,
                "template_idx": template_idx,
                "subject": subject,
            }))
            .send()
            .await?;
        if res.status() != 200 {
            return Err(anyhow!("API call to recoveryRequest failed"));
        }
        let res_json = res.json::<RecoveryResponse>().await?;
        Ok(res_json.request_id)
    }

    async fn complete_recovery(&mut self) -> Result<()> {
        let call = self.wallet.complete_recovery();
        let tx = call.send().await?;
        let receipt = tx
            .log()
            .confirmations(CONFIRMATIONS)
            .await?
            .ok_or(anyhow!("No receipt"))?;
        let tx_hash = receipt.transaction_hash;
        let tx_hash = format!("0x{}", hex::encode(tx_hash.as_bytes()));
        println!("Complete Recovery tx hash: {}", tx_hash);
        Ok(())
    }

    async fn return_all_eth(&self, to: Address) -> Result<()> {
        let tx = self
            .client
            .send_transaction(
                TransactionRequest::new()
                    .to(to)
                    .value(self.client.get_balance(self.client.address(), None).await?),
                None,
            )
            .await?;
        let receipt = tx
            .log()
            .confirmations(CONFIRMATIONS)
            .await?
            .ok_or(anyhow!("No receipt"))?;
        let tx_hash = receipt.transaction_hash;
        let tx_hash = format!("0x{}", hex::encode(tx_hash.as_bytes()));
        println!("ETH Transfer tx hash: {}", tx_hash);
        Ok(())
    }
}

#[tokio::test]
async fn load_test() -> Result<()> {
    dotenv().ok();
    let mut test_env = TestEnv::setup().await?;
    let num_test_accounts = env::var("TEST_NUM_TEST_ACCOUNTS").unwrap().parse()?;
    for _ in 0..num_test_accounts {
        test_env.add_test_account().await?;
    }
    let tasks: Vec<_> = (0..num_test_accounts)
        .map(|idx| {
            let test_account = test_env.test_accounts[idx].clone();
            task::spawn(async move {
                println!("Task {} started", idx);
                test_account.process().await.unwrap();
                println!("Task {} finished", idx);
            })
        })
        .collect();
    let _ = join_all(tasks).await;
    Ok(())
}
