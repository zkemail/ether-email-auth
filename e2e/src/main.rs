use anyhow::{Error, Result};
use relayer_imap;
use relayer_smtp;
use std::sync::Arc;
use tokio::sync::mpsc;
use tokio::task;
pub mod config;
use config::*;
use std::env;
use std::path::Path;
use std::process::Command;

#[tokio::main]
async fn main() -> Result<(), Error> {
    let args: Vec<String> = env::args().collect();
    match args.get(1).map(|s| s.as_str()) {
        Some("--run-smtp") => {
            let config = ReceiverConfig::from_file(&args[2])?;
            relayer_smtp::run(config.smtp).await?;
        }
        Some("--run-imap") => {
            let config = ReceiverConfig::from_file(&args[2])?;
            relayer_imap::run(config.imap).await?;
        }
        _ => {
            panic!("Invalid arguments");
        }
    }
    Ok(())
}
