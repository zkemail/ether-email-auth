use crate::*;

use sqlx::{postgres::PgPool, Row};

#[derive(Debug, Clone)]
pub struct Credentials {
    pub account_code: String,
    pub wallet_eth_addr: String,
    pub guardian_email_addr: String,
    pub is_set: bool,
}

#[derive(Debug, Clone)]
pub struct Request {
    pub request_id: u64,
    pub wallet_eth_addr: String,
    pub guardian_email_addr: String,
    pub is_for_recovery: bool,
    pub template_idx: u64,
    pub is_processed: bool,
    pub is_success: Option<bool>,
    pub email_nullifier: Option<String>,
    pub account_salt: Option<String>,
}

pub struct Database {
    db: PgPool,
}

impl Database {
    pub async fn open(path: &str) -> Result<Self> {
        let res = Self {
            db: PgPool::connect(path)
                .await
                .map_err(|e| anyhow::anyhow!(e))?,
        };

        res.setup_database().await?;

        Ok(res)
    }

    pub async fn setup_database(&self) -> Result<()> {
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
                request_id BIGINT PRIMARY KEY,
                wallet_eth_addr TEXT NOT NULL,
                guardian_email_addr TEXT NOT NULL,
                is_for_recovery BOOLEAN NOT NULL DEFAULT FALSE,
                template_idx INT NOT NULL,
                is_processed BOOLEAN NOT NULL DEFAULT FALSE,
                is_success BOOLEAN,
                email_nullifier TEXT,
                account_salt TEXT
            );",
        )
        .execute(&self.db)
        .await?;
        Ok(())
    }

    #[named]
    pub(crate) async fn get_credentials(&self, account_code: &str) -> Result<Option<Credentials>> {
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
                let codes_row = Credentials {
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

    pub(crate) async fn update_credentials(&self, row: &Credentials) -> Result<()> {
        let res = sqlx::query("UPDATE codes SET wallet_eth_addr = $1, guardian_email_addr = $2, is_set = $3 WHERE account_code = $4")
            .bind(&row.wallet_eth_addr)
            .bind(&row.guardian_email_addr)
            .bind(row.is_set)
            .bind(&row.account_code)
            .execute(&self.db)
            .await?;
        Ok(())
    }

    #[named]
    pub(crate) async fn insert_credentials(&self, row: &Credentials) -> Result<()> {
        info!(LOG, "insert row {:?}", row; "func" => function_name!());
        let row = sqlx::query(
            "INSERT INTO codes (account_code, wallet_eth_addr, guardian_email_addr, is_set) VALUES ($1, $2, $3, $4) RETURNING *",
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

    pub async fn is_guardian_set(&self, wallet_eth_addr: &str, guardian_email_addr: &str) -> bool {
        let row = sqlx::query("SELECT * FROM codes WHERE wallet_eth_addr = $1 AND guardian_email_addr = $2 AND is_set = TRUE")
            .bind(wallet_eth_addr)
            .bind(guardian_email_addr)
            .fetch_optional(&self.db)
            .await
            .unwrap();

        match row {
            Some(_) => true,
            None => false,
        }
    }

    #[named]
    pub async fn set_guardian_in_credentials(&self, account_code: &str) -> Result<()> {
        info!(LOG, "account_code {}", account_code; "func" => function_name!());
        let res = sqlx::query("UPDATE codes SET is_set = TRUE WHERE account_code = $1")
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
    pub(crate) async fn get_request(&self, request_id: u64) -> Result<Option<Request>> {
        let row = sqlx::query("SELECT * FROM requests WHERE request_id = $1")
            .bind(request_id as i64)
            .fetch_optional(&self.db)
            .await?;

        match row {
            Some(row) => {
                let request_id: i64 = row.get("request_id");
                let wallet_eth_addr: String = row.get("wallet_eth_addr");
                let guardian_email_addr: String = row.get("guardian_email_addr");
                let is_for_recovery: bool = row.get("is_for_recovery");
                let template_idx: i32 = row.get("template_idx");
                let is_processed: bool = row.get("is_processed");
                let is_success: Option<bool> = row.get("is_success");
                let email_nullifier: Option<String> = row.get("email_nullifier");
                let account_salt: Option<String> = row.get("account_salt");
                let requests_row = Request {
                    request_id: request_id as u64,
                    wallet_eth_addr,
                    guardian_email_addr,
                    is_for_recovery,
                    template_idx: template_idx as u64,
                    is_processed,
                    is_success,
                    email_nullifier,
                    account_salt,
                };
                info!(LOG, "row {:?}", requests_row; "func" => function_name!());
                Ok(Some(requests_row))
            }
            None => Ok(None),
        }
    }

    pub(crate) async fn update_request(&self, row: &Request) -> Result<()> {
        let res = sqlx::query("UPDATE requests SET wallet_eth_addr = $1, guardian_email_addr = $2, is_for_recovery = $3, template_idx = $4, is_processed = $5, is_success = $6, email_nullifier = $7, account_salt = $8 WHERE request_id = $9")
            .bind(&row.wallet_eth_addr)
            .bind(&row.guardian_email_addr)
            .bind(row.is_for_recovery)
            .bind(row.template_idx as i64)
            .bind(row.is_processed)
            .bind(row.is_success)
            .bind(&row.email_nullifier)
            .bind(&row.account_salt)
            .bind(row.request_id as i64)
            .execute(&self.db)
            .await?;
        Ok(())
    }

    pub(crate) async fn get_invitation_code_from_email_addr(
        &self,
        email_addr: &str,
    ) -> Result<Option<String>> {
        println!("email_addr: {}", email_addr);
        let row = sqlx::query("SELECT * FROM codes WHERE guardian_email_addr = $1")
            .bind(email_addr)
            .fetch_optional(&self.db)
            .await?;

        match row {
            Some(row) => {
                let account_code: String = row.get("account_code");
                Ok(Some(account_code))
            }
            None => Ok(None),
        }
    }

    #[named]
    pub(crate) async fn insert_request(&self, row: &Request) -> Result<()> {
        info!(LOG, "insert row {:?}", row; "func" => function_name!());
        let row = sqlx::query(
            "INSERT INTO requests (request_id, wallet_eth_addr, guardian_email_addr, is_for_recovery, template_idx, is_processed, is_success, email_nullifier, account_salt) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING *",
        )
        .bind(row.request_id as i64)
        .bind(&row.wallet_eth_addr)
        .bind(&row.guardian_email_addr)
        .bind(row.is_for_recovery)
        .bind(row.template_idx as i64)
        .bind(row.is_processed)
        .bind(row.is_success)
        .bind(&row.email_nullifier)
        .bind(&row.account_salt)
        .fetch_one(&self.db)
        .await?;
        info!(
            LOG,
            "{} row inserted",
            row.len(); "func" => function_name!()
        );
        Ok(())
    }

    pub(crate) async fn get_request_status(&self, request_id: u64) -> Result<Option<Request>> {
        let row = sqlx::query("SELECT * FROM requests WHERE request_id = $1")
            .bind(request_id as i64)
            .fetch_optional(&self.db)
            .await?;

        match row {
            Some(row) => {
                let request_id: i64 = row.get("request_id");
                let wallet_eth_addr: String = row.get("wallet_eth_addr");
                let guardian_email_addr: String = row.get("guardian_email_addr");
                let is_for_recovery: bool = row.get("is_for_recovery");
                let template_idx: i32 = row.get("template_idx");
                let is_processed: bool = row.get("is_processed");
                let is_success: Option<bool> = row.get("is_success");
                let email_nullifier: Option<String> = row.get("email_nullifier");
                let account_salt: Option<String> = row.get("account_salt");
                let requests_row = Request {
                    request_id: request_id as u64,
                    wallet_eth_addr,
                    guardian_email_addr,
                    is_for_recovery,
                    template_idx: template_idx as u64,
                    is_processed,
                    is_success,
                    email_nullifier,
                    account_salt,
                };
                Ok(Some(requests_row))
            }
            None => Ok(None),
        }
    }

    #[named]
    pub(crate) async fn request_completed(
        &self,
        request_id: u64,
        email_nullifier: &str,
        account_salt: &str,
    ) -> Result<()> {
        info!(LOG, "request_id {}", request_id; "func" => function_name!());
        let res = sqlx::query("UPDATE requests SET is_processed = TRUE, is_success = TRUE, email_nullifier = $1, account_salt = $2, WHERE request_id = $3")
            .bind(email_nullifier)
            .bind(account_salt)
            .bind(request_id as i64)
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
    pub(crate) async fn request_failed(&self, request_id: u64) -> Result<()> {
        info!(LOG, "request_id {}", request_id; "func" => function_name!());
        let res = sqlx::query(
            "UPDATE requests SET is_processed = TRUE, is_success = FALSE WHERE request_id = $1",
        )
        .bind(request_id as i64)
        .execute(&self.db)
        .await?;
        info!(
            LOG,
            "updated result: {:?}",
            res; "func" => function_name!()
        );
        Ok(())
    }
}
