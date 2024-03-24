use crate::*;

use ic_utils::interfaces::wallet;
use sqlx::{postgres::PgPool, Row};

pub struct Database {
    db: PgPool,
}

impl Database {
    pub(crate) async fn open(path: &str) -> Result<Self> {
        let res = Self {
            db: PgPool::connect(path)
                .await
                .map_err(|e| anyhow::anyhow!(e))?,
        };

        res.setup_database().await?;

        Ok(res)
    }

    pub(crate) async fn setup_database(&self) -> Result<()> {
        sqlx::query(
            "CREATE TABLE IF NOT EXISTS codes (
                account_code TEXT PRIMARY KEY,
                wallet_eth_addr TEXT NOT NULL,
                guardian_email_addr TEXT NOT NULL,
                is_set BOOLEAN NOT NULL DEFAULT FALSE
            );",
        )
        .execute(&self.db)
        .await?;

        sqlx::query(
            "CREATE TABLE IF NOT EXISTS requests (
                request_id INT PRIMARY KEY,
                wallet_eth_addr TEXT NOT NULL,
                guardian_email_addr TEXT NOT NULL,
                random TEXT NOT NULL,
                email_addr_commit TEXT NOT NULL,
                is_for_recovery BOOLEAN NOT NULL DEFAULT FALSE,
                template_idx INT NOT NULL,
                is_processed BOOLEAN NOT NULL DEFAULT FALSE,
                is_success BOOLEAN,
                email_nullifier TEXT,
                account_salt TEXT,
                is_code_exist BOOLEAN
            );",
        )
        .execute(&self.db)
        .await?;

        Ok(())
    }

    // pub(crate) async fn get_unhandled_emails(&self) -> Result<Vec<String>> {
    //     let mut vec = Vec::new();

    //     let rows = sqlx::query("SELECT email FROM emails")
    //         .fetch_all(&self.db)
    //         .await?;

    //     for row in rows {
    //         let email: String = row.get("email");
    //         vec.push(email)
    //     }

    //     Ok(vec)
    // }

    // pub(crate) async fn insert_email(&self, email_hash: &str, email: &str) -> Result<()> {
    //     info!("email_hash {}", email_hash);
    //     let row = sqlx::query(
    //         "INSERT INTO emails (email_hash, email) VALUES ($1 $2) REtURNING (email_hash)",
    //     )
    //     .bind(email_hash)
    //     .bind(email)
    //     .fetch_one(&self.db)
    //     .await?;
    //     info!("inserted row: {}", row.get::<String, _>("email_hash"));
    //     Ok(())
    // }

    // pub(crate) async fn delete_email(&self, email_hash: &str) -> Result<()> {
    //     let row_affected = sqlx::query("DELETE FROM emails WHERE email_hash = $1")
    //         .bind(email_hash)
    //         .execute(&self.db)
    //         .await?
    //         .rows_affected();
    //     info!("deleted {} rows", row_affected);

    //     Ok(())
    // }

    // // Result<bool> is bad - fix later (possible solution: to output Result<ReturnStatus>
    // // where, ReturnStatus is some Enum ...
    // pub(crate) async fn contains_email(&self, email_hash: &str) -> Result<bool> {
    //     let result = sqlx::query("SELECT 1 FROM emails WHERE email_hash = $1")
    //         .bind(email_hash)
    //         .fetch_optional(&self.db)
    //         .await?;

    //     Ok(result.is_some())
    // }

    #[named]
    pub(crate) async fn insert_code(
        &self,
        account_code: &str,
        wallet_eth_addr: &str,
        guardian_email_addr: &str,
        is_set: bool,
    ) -> Result<()> {
        let row = sqlx::query(
            "INSERT INTO users (account_code, wallet_eth_addr, guardian_email_addr, is_set) VALUES ($1, $2, $3, $4) RETURNING *",
        )
        .bind(account_code)
        .bind(wallet_eth_addr)
        .bind(guardian_email_addr)
        .bind(is_set)
        .fetch_one(&self.db)
        .await?;
        Ok(())
    }

    #[named]
    pub async fn set_guardian(&self, account_code: &str) -> Result<()> {
        info!(LOG, "account_code {}", account_code; "func" => function_name!());
        let res = sqlx::query("UPDATE users SET is_set = TRUE WHERE account_code = $1")
            .bind(account_code)
            .execute(&self.db)
            .await?;
        info!(
            LOG,
            "updated result: {:?}",
            res; "func" => function_name!()
        );
        Ok(())
    }

    // pub async fn get_claims_by_id(&self, id: &U256) -> Result<Vec<Claim>> {
    //     let mut vec = Vec::new();

    //     let rows = sqlx::query("SELECT * FROM claims WHERE id = $1 AND is_deleted = FALSE")
    //         .bind(u256_to_hex(id))
    //         .fetch_all(&self.db)
    //         .await?;

    //     for row in rows {
    //         let commit: String = row.get("email_addr_commit");
    //         let email_address: String = row.get("email_address");
    //         let random: String = row.get("random");
    //         let expiry_time: i64 = row.get("expiry_time");
    //         let is_fund: bool = row.get("is_fund");
    //         let is_announced: bool = row.get("is_announced");
    //         let is_seen: bool = row.get("is_seen");
    //         vec.push(Claim {
    //             id: *id,
    //             email_address,
    //             random,
    //             commit,
    //             expiry_time,
    //             is_fund,
    //             is_announced,
    //             is_seen,
    //         })
    //     }
    //     Ok(vec)
    // }

    // pub async fn get_claims_by_email_addr(&self, email_addr: &str) -> Result<Vec<Claim>> {
    //     let mut vec = Vec::new();

    //     let rows =
    //         sqlx::query("SELECT * FROM claims WHERE email_address = $1 AND is_deleted = FALSE")
    //             .bind(email_addr)
    //             .fetch_all(&self.db)
    //             .await?;

    //     for row in rows {
    //         let id: String = row.get("id");
    //         let commit: String = row.get("email_addr_commit");
    //         let email_address: String = row.get("email_address");
    //         let random: String = row.get("random");
    //         let expiry_time: i64 = row.get("expiry_time");
    //         let is_fund: bool = row.get("is_fund");
    //         let is_announced: bool = row.get("is_announced");
    //         let is_seen: bool = row.get("is_seen");
    //         vec.push(Claim {
    //             id: hex_to_u256(&id)?,
    //             email_address,
    //             random,
    //             commit,
    //             expiry_time,
    //             is_fund,
    //             is_announced,
    //             is_seen,
    //         })
    //     }
    //     Ok(vec)
    // }

    // #[named]
    // pub async fn get_claims_unexpired(&self, now: i64) -> Result<Vec<Claim>> {
    //     let mut vec = Vec::new();
    //     info!(LOG, "now {}", now; "func" => function_name!());
    //     let rows =
    //         sqlx::query("SELECT * FROM claims WHERE expiry_time > $1 AND is_deleted = FALSE")
    //             .bind(now)
    //             .fetch_all(&self.db)
    //             .await?;

    //     for row in rows {
    //         let id: String = row.get("id");
    //         let commit: String = row.get("email_addr_commit");
    //         let email_address: String = row.get("email_address");
    //         let random: String = row.get("random");
    //         let expiry_time: i64 = row.get("expiry_time");
    //         let is_fund: bool = row.get("is_fund");
    //         let is_announced: bool = row.get("is_announced");
    //         let is_seen: bool = row.get("is_seen");
    //         vec.push(Claim {
    //             id: hex_to_u256(&id)?,
    //             email_address,
    //             random,
    //             commit,
    //             expiry_time,
    //             is_fund,
    //             is_announced,
    //             is_seen,
    //         })
    //     }
    //     Ok(vec)
    // }

    // #[named]
    // pub async fn get_claims_expired(&self, now: i64) -> Result<Vec<Claim>> {
    //     let mut vec = Vec::new();
    //     info!(LOG, "now {}", now; "func" => function_name!());
    //     let rows =
    //         sqlx::query("SELECT * FROM claims WHERE expiry_time < $1 AND is_deleted = FALSE")
    //             .bind(now)
    //             .fetch_all(&self.db)
    //             .await?;

    //     for row in rows {
    //         let id: String = row.get("id");
    //         let commit: String = row.get("email_addr_commit");
    //         let email_address: String = row.get("email_address");
    //         let random: String = row.get("random");
    //         let expiry_time: i64 = row.get("expiry_time");
    //         let is_fund: bool = row.get("is_fund");
    //         let is_announced: bool = row.get("is_announced");
    //         let is_seen: bool = row.get("is_seen");
    //         vec.push(Claim {
    //             id: hex_to_u256(&id)?,
    //             email_address,
    //             random,
    //             commit,
    //             expiry_time,
    //             is_fund,
    //             is_announced,
    //             is_seen,
    //         })
    //     }
    //     Ok(vec)
    // }

    // #[named]
    // pub(crate) async fn insert_claim(&self, claim: &Claim) -> Result<()> {
    //     info!(LOG, "expiry_time {}", claim.expiry_time; "func" => function_name!());
    //     let row = sqlx::query(
    //         "INSERT INTO claims (id, email_address, random, email_addr_commit, expiry_time, is_fund, is_announced, is_seen) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING *",
    //     )
    //     .bind(u256_to_hex(&claim.id))
    //     .bind(claim.email_address.clone())
    //     .bind(claim.random.clone())
    //     .bind(claim.commit.clone())
    //     .bind(claim.expiry_time)
    //     .bind(claim.is_fund)
    //     .bind(claim.is_announced)
    //     .bind(claim.is_seen)
    //     .fetch_one(&self.db)
    //     .await?;
    //     info!(
    //         LOG,
    //         "inserted row: {}",
    //         row.get::<String, _>("email_addr_commit"); "func" => function_name!()
    //     );
    //     Ok(())
    // }

    // pub(crate) async fn delete_claim(&self, id: &U256, is_fund: bool) -> Result<()> {
    //     sqlx::query("UPDATE claims SET is_deleted=TRUE WHERE id = $1 AND is_fund = $2 AND is_deleted = FALSE")
    //         .bind(u256_to_hex(id))
    //         .bind(is_fund)
    //         .execute(&self.db)
    //         .await?;
    //     // sqlx::query("DELETE FROM claims WHERE id = $1 AND is_fund = $2")
    //     //     .bind(u256_to_hex(id))
    //     //     .bind(is_fund)
    //     //     .execute(&self.db)
    //     //     .await?;
    //     Ok(())
    // }

    // pub async fn contains_user(&self, email_address: &str) -> Result<bool> {
    //     let result = sqlx::query("SELECT 1 FROM users WHERE email_address = $1")
    //         .bind(email_address)
    //         .fetch_optional(&self.db)
    //         .await?;

    //     Ok(result.is_some())
    // }

    // pub async fn is_user_onborded(&self, email_address: &str) -> Result<bool> {
    //     let result = sqlx::query("SELECT is_onborded FROM users WHERE email_address = $1")
    //         .bind(email_address)
    //         .fetch_one(&self.db)
    //         .await?;
    //     Ok(result.get("is_onborded"))
    // }

    // pub async fn get_account_key(&self, email_address: &str) -> Result<Option<String>> {
    //     let row_result = sqlx::query("SELECT account_key FROM users WHERE email_address = $1")
    //         .bind(email_address)
    //         .fetch_one(&self.db)
    //         .await;

    //     match row_result {
    //         Ok(row) => {
    //             let account_key: String = row.get("account_key");
    //             Ok(Some(account_key))
    //         }
    //         Err(sqlx::error::Error::RowNotFound) => Ok(None),
    //         Err(e) => Err(e).map_err(|e| anyhow::anyhow!(e))?,
    //     }
    // }

    // pub async fn get_creation_tx_hash(&self, email_address: &str) -> Result<Option<String>> {
    //     let row_result = sqlx::query("SELECT tx_hash FROM users WHERE email_address = $1")
    //         .bind(email_address)
    //         .fetch_one(&self.db)
    //         .await;

    //     match row_result {
    //         Ok(row) => {
    //             let tx_hash: String = row.get("tx_hash");
    //             Ok(Some(tx_hash))
    //         }
    //         Err(sqlx::error::Error::RowNotFound) => Ok(None),
    //         Err(e) => Err(e).map_err(|e| anyhow::anyhow!(e))?,
    //     }
    // }
}
