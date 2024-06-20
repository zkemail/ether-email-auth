use anyhow::Result;
use relayer::*;

#[tokio::main]
async fn main() -> Result<()> {
    run(RelayerConfig::new()).await?;

    Ok(())
}
