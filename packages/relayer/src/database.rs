use crate::*;

use ic_utils::interfaces::wallet;
use sqlx::{postgres::PgPool, Row};

#[derive(Debug, Clone)]
pub struct CodesRow {
    pub account_code: String,
    pub wallet_eth_addr: String,
    pub guardian_email_addr: String,
    pub is_set: bool,
}

#[derive(Debug, Clone)]
pub struct RequestsRow {
    pub request_id: i64,
    pub wallet_eth_addr: String,
    pub guardian_email_addr: String,
    pub is_for_recovery: bool,
    pub template_idx: u64,
    pub is_processed: bool,
    pub is_success: Option<bool>,
    pub email_nullifier: Option<String>,
    pub account_salt: Option<String>,
    pub is_code_exist: Option<bool>,
}

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
    pub(crate) async fn get_codes_row(&self, account_code: &str) -> Result<Option<CodesRow>> {
        let row = sqlx::query("SELECT * FROM codes WHERE account_code = $1")
            .bind(account_code)
            .fetch_optional(&self.db)
            .await?;

        match row {
            Some(row) => {
                let account_code: String = row.get("account_code");
                let wallet_eth_addr: String = row.get("wallet_eth_addr");
                let guardian_email_addr: String = row.get("guardian_email_addr");
                let is_set: bool = row.get("is_set");
                let codes_row = CodesRow {
                    account_code,
                    wallet_eth_addr,
                    guardian_email_addr,
                    is_set,
                };
                info!(LOG, "row {:?}", codes_row; "func" => function_name!());
                Ok(Some(codes_row))
            }
            None => Ok(None),
        }
    }

    #[named]
    pub(crate) async fn insert_codes_row(&self, row: &CodesRow) -> Result<()> {
        info!(LOG, "insert row {:?}", row; "func" => function_name!());
        let row = sqlx::query(
            "INSERT INTO users (account_code, wallet_eth_addr, guardian_email_addr, is_set) VALUES ($1, $2, $3, $4) RETURNING *",
        )
        .bind(&row.account_code)
        .bind(&row.wallet_eth_addr)
        .bind(&row.guardian_email_addr)
        .bind(row.is_set)
        .fetch_one(&self.db)
        .await?;
        info!(
            LOG,
            "{} row inserted",
            row.len(); "func" => function_name!()
        );
        Ok(())
    }

    #[named]
    pub async fn set_guardian_in_codes(&self, account_code: &str) -> Result<()> {
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

    #[named]
    pub(crate) async fn get_requests_row(&self, request_id: i64) -> Result<Option<RequestsRow>> {
        let row = sqlx::query("SELECT * FROM requests WHERE request_id = $1")
            .bind(request_id)
            .fetch_optional(&self.db)
            .await?;

        match row {
            Some(row) => {
                let request_id: i64 = row.get("request_id");
                let wallet_eth_addr: String = row.get("wallet_eth_addr");
                let guardian_email_addr: String = row.get("guardian_email_addr");
                let is_for_recovery: bool = row.get("is_for_recovery");
                let template_idx: u64 = row.get::<i64, _>("template_idx") as u64;
                let is_processed: bool = row.get("is_processed");
                let is_success: Option<bool> = row.get("is_success");
                let email_nullifier: Option<String> = row.get("email_nullifier");
                let account_salt: Option<String> = row.get("account_salt");
                let is_code_exist: Option<bool> = row.get("is_code_exist");
                let requests_row = RequestsRow {
                    request_id,
                    wallet_eth_addr,
                    guardian_email_addr,
                    is_for_recovery,
                    template_idx,
                    is_processed,
                    is_success,
                    email_nullifier,
                    account_salt,
                    is_code_exist,
                };
                info!(LOG, "row {:?}", requests_row; "func" => function_name!());
                Ok(Some(requests_row))
            }
            None => Ok(None),
        }
    }

    #[named]
    pub(crate) async fn insert_requests_row(&self, row: &RequestsRow) -> Result<()> {
        info!(LOG, "insert row {:?}", row; "func" => function_name!());
        let row = sqlx::query(
            "INSERT INTO requests (request_id, wallet_eth_addr, guardian_email_addr, is_for_recovery, template_idx, is_processed, is_success, email_nullifier, account_salt, is_code_exist) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) RETURNING *",
        )
        .bind(&row.request_id)
        .bind(&row.wallet_eth_addr)
        .bind(&row.guardian_email_addr)
        .bind(row.is_for_recovery)
        .bind(row.template_idx as i64)
        .bind(row.is_processed)
        .bind(row.is_success)
        .bind(&row.email_nullifier)
        .bind(&row.account_salt)
        .bind(row.is_code_exist)
        .fetch_one(&self.db)
        .await?;
        info!(
            LOG,
            "{} row inserted",
            row.len(); "func" => function_name!()
        );
        Ok(())
    }

    #[named]
    pub(crate) async fn request_successed(
        &self,
        request_id: i64,
        email_nullifier: &str,
        account_salt: &str,
        is_code_exist: bool,
    ) -> Result<()> {
        info!(LOG, "request_id {}", request_id; "func" => function_name!());
        let res = sqlx::query("UPDATE requests SET is_processed = TRUE, is_success = TRUE, email_nullifier = $1, account_salt = $2, is_code_exist = $3, WHERE request_id = $4")
            .bind(email_nullifier)
            .bind(account_salt)
            .bind(is_code_exist)
            .bind(request_id)
            .execute(&self.db)
            .await?;
        info!(
            LOG,
            "updated result: {:?}",
            res; "func" => function_name!()
        );
        Ok(())
    }

    #[named]
    pub(crate) async fn request_failed(&self, request_id: i64) -> Result<()> {
        info!(LOG, "request_id {}", request_id; "func" => function_name!());
        let res = sqlx::query(
            "UPDATE requests SET is_processed = TRUE, is_success = FALSE WHERE request_id = $1",
        )
        .bind(request_id)
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
