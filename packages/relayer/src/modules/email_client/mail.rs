use crate::{
    error, hex2field, parse_error, render_html, AccountKey, EmailForwardSender, EmailMessage,
    Future, Result, CHAIN_RPC_EXPLORER, CLIENT, DB, LOG, RELAYER_EMAIL_ADDRESS,
};
use anyhow::anyhow;
use relayer_utils::cryptos::{PaddedEmailAddr, WalletSalt};
use std::{pin::Pin, sync::atomic::Ordering};

#[derive(Debug, Clone)]
pub enum EmailAuthEvent {
    Acceptance {
        wallet_eth_addr: String,
        guardian_email_addr: String,
        request_id: String,
    },
    Error {
        email_addr: String,
        error: String,
    },
}

pub fn event_consumer(
    event: EmailAuthEvent,
    sender: EmailForwardSender,
) -> Pin<Box<dyn Future<Output = ()> + Send>> {
    Box::pin(async {
        match event_consumer_fn(event, sender).await {
            Ok(_) => {}
            Err(err) => {
                error!(LOG, "Failed to accept event: {}", err);
            }
        }
    })
}

async fn event_consumer_fn(event: EmailAuthEvent, sender: EmailForwardSender) -> Result<()> {
    match event {
        EmailAuthEvent::Acceptance {
            wallet_eth_addr,
            guardian_email_addr,
            request_id,
        } => todo!(),
        EmailAuthEvent::Error { email_addr, error } => todo!(),
    }

    Ok(())
}
