#![allow(dead_code)]
#![allow(unused_variables)]
#![allow(unreachable_code)]

pub mod abis;
pub mod chain;
pub mod config;
pub mod core;
pub mod database;
pub mod modules;
pub mod utils;

pub use abis::*;
pub use chain::*;
pub use config::*;
pub use core::*;
pub use database::*;
pub use modules::*;
pub use utils::*;

use ::function_name::named;
use futures::TryFutureExt;
use tokio::sync::Mutex;

use anyhow::{anyhow, bail, Result};
use dotenv::dotenv;
use ethers::prelude::*;
use lazy_static::lazy_static;
use relayer_utils::{converters::*, cryptos::*, parse_email::ParsedEmail};
use slog::{error, info, trace};
use std::env;
use std::future::Future;
use std::path::PathBuf;
use std::pin::Pin;
use std::sync::{Arc, OnceLock};
use tokio::sync::mpsc::{UnboundedReceiver, UnboundedSender};
use tokio::time::{sleep, Duration};

pub static CIRCUITS_DIR_PATH: OnceLock<PathBuf> = OnceLock::new();
pub static WEB_SERVER_ADDRESS: OnceLock<String> = OnceLock::new();
pub static PROVER_ADDRESS: OnceLock<String> = OnceLock::new();
pub static PRIVATE_KEY: OnceLock<String> = OnceLock::new();
pub static CHAIN_ID: OnceLock<u32> = OnceLock::new();
pub static EMAIL_ACCOUNT_RECOVERY_VERSION_ID: OnceLock<u8> = OnceLock::new();
pub static CHAIN_RPC_PROVIDER: OnceLock<String> = OnceLock::new();
pub static CHAIN_RPC_EXPLORER: OnceLock<String> = OnceLock::new();
pub static INPUT_FILES_DIR: OnceLock<String> = OnceLock::new();
pub static EMAIL_TEMPLATES: OnceLock<String> = OnceLock::new();
pub static RELAYER_EMAIL_ADDRESS: OnceLock<String> = OnceLock::new();

lazy_static! {
    pub static ref DB: Arc<Database> = {
        dotenv().ok();
        let db = tokio::task::block_in_place(|| {
            tokio::runtime::Runtime::new()
                .unwrap()
                .block_on(Database::open(&env::var(DATABASE_PATH_KEY).unwrap()))
        })
        .unwrap();
        Arc::new(db)
    };
    pub static ref CLIENT: Arc<ChainClient> = {
        dotenv().ok();
        let client = tokio::task::block_in_place(|| {
            tokio::runtime::Runtime::new()
                .unwrap()
                .block_on(ChainClient::setup())
        })
        .unwrap();
        Arc::new(client)
    };
    pub static ref SHARED_MUTEX: Arc<Mutex<i32>> = Arc::new(Mutex::new(0));
}

pub type EventConsumer =
    fn(EmailAuthEvent, EmailForwardSender) -> Pin<Box<dyn Future<Output = ()> + Send>>;

#[named]
pub async fn run(
    config: RelayerConfig,
    mut event_consumer: EventConsumer,
    email_forward_sender: EmailForwardSender,
    mut email_forward_rx: UnboundedReceiver<EmailMessage>,
) -> Result<()> {
    info!(LOG, "Starting relayer"; "func" => function_name!());

    CIRCUITS_DIR_PATH.set(config.circuits_dir_path).unwrap();
    WEB_SERVER_ADDRESS.set(config.web_server_address).unwrap();
    PROVER_ADDRESS.set(config.prover_address).unwrap();
    PRIVATE_KEY.set(config.private_key).unwrap();
    CHAIN_ID.set(config.chain_id).unwrap();
    CHAIN_RPC_PROVIDER.set(config.chain_rpc_provider).unwrap();
    CHAIN_RPC_EXPLORER.set(config.chain_rpc_explorer).unwrap();
    EMAIL_ACCOUNT_RECOVERY_VERSION_ID
        .set(config.email_account_recovery_version_id)
        .unwrap();
    INPUT_FILES_DIR.set(config.input_files_dir).unwrap();
    EMAIL_TEMPLATES.set(config.email_templates).unwrap();
    RELAYER_EMAIL_ADDRESS
        .set(config.smtp_config.id.clone())
        .unwrap();

    let (tx_handler, mut rx_handler) = tokio::sync::mpsc::unbounded_channel::<String>();
    let (tx_sender, mut rx_sender) = tokio::sync::mpsc::unbounded_channel::<EmailMessage>();
    let (tx_event_consumer, mut rx_event_consumer) = tokio::sync::mpsc::unbounded_channel();
    let db = DB.clone();
    let client = CLIENT.clone();

    let email_sender = email_forward_sender.clone();
    let event_consumer_task = tokio::task::spawn(async move {
        loop {
            match event_consumer_fn(
                &mut event_consumer,
                &mut rx_event_consumer,
                email_sender.clone(),
            )
            .await
            {
                Ok(()) => {}
                Err(e) => {
                    error!(LOG, "Error at event_consumer: {}", e; "func" => function_name!())
                }
            }
        }
        anyhow::Ok(())
    });

    let tx_handler_for_fetcher_task = tx_handler.clone();
    let emails_pool_fetcher_task = tokio::task::spawn(async move {
        loop {
            match emails_pool_fetcher_fn(&tx_handler_for_fetcher_task).await {
                Ok(()) => {}
                Err(e) => {
                    error!(LOG, "Error at emails_pool_fetcher: {}", e; "func" => function_name!())
                }
            }
        }
        anyhow::Ok(())
    });
    let db_clone_receiver = Arc::clone(&db);
    let mut email_receiver = ImapClient::new(config.imap_config).await?;
    let tx_handler_for_receiver_task = tx_handler.clone();
    let email_receiver_task = tokio::task::spawn(async move {
        loop {
            match email_receiver_fn(&mut email_receiver, &tx_handler_for_receiver_task).await {
                Ok(new_email_receiver) => {}
                Err(e) => {
                    error!(LOG, "Error at email_receiver: {}", e; "func" => function_name!())
                }
            }
        }
        anyhow::Ok(())
    });

    let tx_event_consumer_for_email_task = tx_event_consumer.clone();
    let db_clone = Arc::clone(&db);
    let client_clone = Arc::clone(&client);
    let email_handler_task = tokio::task::spawn(async move {
        loop {
            match email_handler_fn(
                &mut rx_handler,
                Arc::clone(&db_clone),
                Arc::clone(&client_clone),
                tx_event_consumer_for_email_task.clone(),
            )
            .await
            {
                Ok(()) => {}
                Err(e) => {
                    error!(LOG, "Error at email_handler: {}", e; "func" => function_name!())
                }
            }
        }

        anyhow::Ok(())
    });

    let tx_event_consumer_for_api_server = tx_event_consumer.clone();
    let api_server_task = tokio::task::spawn(
        run_server(
            WEB_SERVER_ADDRESS.get().unwrap(),
            Arc::clone(&db),
            Arc::clone(&client),
            email_forward_sender.clone(),
            tx_event_consumer_for_api_server,
        )
        .map_err(|err| error!(LOG, "Error api server: {}", err; "func" => function_name!())),
    );

    let email_sender = SmtpClient::new(config.smtp_config)?;
    let email_sender_task = tokio::task::spawn(async move {
        loop {
            match email_sender_fn(&mut rx_sender, &email_sender).await {
                Ok(()) => {}
                Err(e) => {
                    error!(LOG, "Error at email_sender: {}", e; "func" => function_name!())
                }
            }
        }

        anyhow::Ok(())
    });

    let tx_sender_for_forward_task = tx_sender.clone();
    let email_forward_task = tokio::task::spawn(async move {
        loop {
            match email_forward_rx.recv().await {
                Some(email) => {
                    tx_sender_for_forward_task.send(email)?;
                }
                None => {
                    error!(LOG, "Error at email_forward: no email"; "func" => function_name!())
                }
            }
        }
        anyhow::Ok(())
    });

    let _ = tokio::join!(
        event_consumer_task,
        email_receiver_task,
        email_handler_task,
        api_server_task,
        email_sender_task,
    );

    Ok(())
}

#[named]
async fn emails_pool_fetcher_fn(
    tx_handler_for_fetcher_task: &UnboundedSender<String>,
) -> Result<()> {
    let emails_pool = FileEmailsPool::new();
    let unhandled_emails = emails_pool.get_unhandled_emails().await?;
    for (email_hash, _) in unhandled_emails {
        info!(LOG, "unhandled email {}", email_hash; "func" => function_name!());
        tx_handler_for_fetcher_task.send(email_hash)?;
    }
    sleep(Duration::from_secs(30)).await;
    anyhow::Ok(())
}

#[named]
async fn email_receiver_fn(
    email_receiver: &mut ImapClient,
    tx_handler_for_receiver_task: &UnboundedSender<String>,
) -> Result<()> {
    let fetches = email_receiver.retrieve_new_emails().await?;
    info!(LOG, "Fetched {} emails", fetches.len(); "func" => function_name!());
    for fetch in fetches {
        for email in fetch.iter() {
            if let Some(body) = email.body() {
                let body = String::from_utf8(body.to_vec())?;
                info!(LOG, "Received email {}", body; "func" => function_name!());
                let email_hash = calculate_default_hash(&body);
                let emails_pool = FileEmailsPool::new();
                if !emails_pool.contains_email(&email_hash).await? {
                    emails_pool.insert_email(&email_hash, &body).await?;
                    tx_handler_for_receiver_task.send(email_hash)?;
                }
            }
        }
    }
    sleep(Duration::from_secs(5)).await;
    Ok(())
}

#[named]
async fn email_handler_fn(
    rx_handler: &mut UnboundedReceiver<String>,
    db_clone: Arc<Database>,
    client_clone: Arc<ChainClient>,
    event_consumer: UnboundedSender<EmailAuthEvent>,
    // tx_creator_for_email_task: &UnboundedSender<(String, Option<AccountKey>)>,
) -> Result<()> {
    let email_hash = rx_handler
        .recv()
        .await
        .ok_or(anyhow!(CANNOT_GET_EMAIL_FROM_QUEUE))?;
    let emails_pool = FileEmailsPool::new();
    let email = emails_pool.get_email_by_hash(&email_hash).await?;
    let emails_pool = FileEmailsPool::new();
    emails_pool.delete_email(&email_hash).await?;
    let parsed_email = ParsedEmail::new_from_raw_email(&email).await?;
    let email_addr = parsed_email.get_from_addr().unwrap();
    let event = match handle_email(
        email.clone(),
        Arc::clone(&db_clone),
        Arc::clone(&client_clone),
        emails_pool,
    )
    .await
    {
        Ok(event) => event,
        Err(err) => {
            let error = err.to_string();
            error!(LOG, "Error handling email: {}", error; "func" => function_name!());
            EmailAuthEvent::Error { email_addr, error }
        }
    };
    event_consumer.send(event)?;
    anyhow::Ok(())
}

#[named]
async fn event_consumer_fn(
    consumer: &mut EventConsumer,
    rx: &mut UnboundedReceiver<EmailAuthEvent>,
    email_sender: EmailForwardSender,
) -> Result<()> {
    let event = rx.recv().await.ok_or(anyhow!("No event"))?;
    info!(LOG, "Event: {:?}", event; "func" => function_name!());
    (consumer)(event, email_sender).await;
    Ok(())
}

#[named]
async fn email_sender_fn(
    rx_sender: &mut UnboundedReceiver<EmailMessage>,
    email_sender: &SmtpClient,
) -> Result<()> {
    let email = rx_sender
        .recv()
        .await
        .ok_or(anyhow!(CANNOT_GET_EMAIL_FROM_QUEUE))?;
    info!(LOG, "Sending email: {:?}", email; "func" => function_name!());
    // info!(LOG, "Email arg: {:?}", email.email_args; "func" => function_name!());
    email_sender.send_new_email(email).await?;
    Ok(())
}
