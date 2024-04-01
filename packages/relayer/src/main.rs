use anyhow::Result;
use relayer::*;
use std::env;

#[tokio::main]
async fn main() -> Result<()> {
    let (sender, rx) = EmailForwardSender::new();
    run(RelayerConfig::new(), event_consumer, sender, rx).await?;

    Ok(())
}
