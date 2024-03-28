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
    pub request_id: String,
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
                request_id TEXT PRIMARY KEY,
                wallet_eth_addr TEXT NOT NULL,
                guardian_email_addr TEXT NOT NULL,
                random TEXT NOT NULL,
                email_addr_commit TEXT NOT NULL,
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

    #[named]
    pub(crate) async fn insert_credentials(&self, row: &Credentials) -> Result<()> {
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
    pub(crate) async fn get_request(&self, request_id: String) -> Result<Option<Request>> {
        let row = sqlx::query("SELECT * FROM requests WHERE request_id = $1")
            .bind(request_id)
            .fetch_optional(&self.db)
            .await?;

        match row {
            Some(row) => {
                let request_id: String = row.get("request_id");
                let wallet_eth_addr: String = row.get("wallet_eth_addr");
                let guardian_email_addr: String = row.get("guardian_email_addr");
                let is_for_recovery: bool = row.get("is_for_recovery");
                let template_idx: u64 = row.get::<i64, _>("template_idx") as u64;
                let is_processed: bool = row.get("is_processed");
                let is_success: Option<bool> = row.get("is_success");
                let email_nullifier: Option<String> = row.get("email_nullifier");
                let account_salt: Option<String> = row.get("account_salt");
                let requests_row = Request {
                    request_id,
                    wallet_eth_addr,
                    guardian_email_addr,
                    is_for_recovery,
                    template_idx,
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

    #[named]
    pub(crate) async fn insert_request(&self, row: &Request) -> Result<()> {
        info!(LOG, "insert row {:?}", row; "func" => function_name!());
        let row = sqlx::query(
            "INSERT INTO requests (request_id, wallet_eth_addr, guardian_email_addr, is_for_recovery, template_idx, is_processed, is_success, email_nullifier, account_salt) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING *",
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
    pub(crate) async fn request_completed(
        &self,
        request_id: &str,
        email_nullifier: &str,
        account_salt: &str,
    ) -> Result<()> {
        info!(LOG, "request_id {}", request_id; "func" => function_name!());
        let res = sqlx::query("UPDATE requests SET is_processed = TRUE, is_success = TRUE, email_nullifier = $1, account_salt = $2, WHERE request_id = $3")
            .bind(email_nullifier)
            .bind(account_salt)
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
    pub(crate) async fn request_failed(&self, request_id: &str) -> Result<()> {
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
}
