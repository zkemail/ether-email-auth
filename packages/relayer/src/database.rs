use crate::*;

use relayer_utils::LOG;
use sqlx::{postgres::PgPool, Row};

/// Represents the credentials for a user account.
#[derive(Debug, Clone)]
pub struct Credentials {
    /// The unique code associated with the account.
    pub account_code: String,
    /// The Ethereum address of the account.
    pub account_eth_addr: String,
    /// The email address of the guardian.
    pub guardian_email_addr: String,
    /// Indicates whether the credentials are set.
    pub is_set: bool,
}

/// Represents a request in the system.
#[derive(Debug, Clone)]
pub struct Request {
    /// The unique identifier for the request.
    pub request_id: u32,
    /// The Ethereum address of the account.
    pub account_eth_addr: String,
    /// The Ethereum address of the controller.
    pub controller_eth_addr: String,
    /// The email address of the guardian.
    pub guardian_email_addr: String,
    /// Indicates whether the request is for recovery.
    pub is_for_recovery: bool,
    /// The index of the template used for the request.
    pub template_idx: u64,
    /// Indicates whether the request has been processed.
    pub is_processed: bool,
    /// Indicates the success status of the request, if available.
    pub is_success: Option<bool>,
    /// The nullifier for the email, if available.
    pub email_nullifier: Option<String>,
    /// The salt for the account, if available.
    pub account_salt: Option<String>,
}

/// Represents the database connection and operations.
pub struct Database {
    db: PgPool,
}

impl Database {
    /// Opens a new database connection.
    ///
    /// # Arguments
    ///
    /// * `path` - The connection string for the database.
    ///
    /// # Returns
    ///
    /// A `Result` containing the `Database` struct if successful, or an error if the connection fails.
    pub async fn open(path: &str) -> Result<Self> {
        let res = Self {
            db: PgPool::connect(path)
                .await
                .map_err(|e| anyhow::anyhow!(e))?,
        };

        res.setup_database().await?;

        Ok(res)
    }

    /// Sets up the database by creating necessary tables if they don't exist.
    ///
    /// # Returns
    ///
    /// A `Result` indicating success or failure of the setup process.
    pub async fn setup_database(&self) -> Result<()> {
        // Create credentials table
        sqlx::query(
            "CREATE TABLE IF NOT EXISTS credentials (
                account_code TEXT PRIMARY KEY,
                account_eth_addr TEXT NOT NULL,
                guardian_email_addr TEXT NOT NULL,
                is_set BOOLEAN NOT NULL DEFAULT FALSE
            );",
        )
        .execute(&self.db)
        .await?;

        // Create requests table
        sqlx::query(
            "CREATE TABLE IF NOT EXISTS requests (
                request_id BIGINT PRIMARY KEY,
                account_eth_addr TEXT NOT NULL,
                controller_eth_addr TEXT NOT NULL,
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

        // Create expected_replies table
        sqlx::query(
            "CREATE TABLE IF NOT EXISTS expected_replies (
                message_id VARCHAR(255) PRIMARY KEY,
                request_id VARCHAR(255),
                has_reply BOOLEAN DEFAULT FALSE,
                created_at TIMESTAMP DEFAULT (NOW() AT TIME ZONE 'UTC')
            );",
        )
        .execute(&self.db)
        .await?;
        Ok(())
    }

    /// Tests the database connection by attempting to execute a simple query.
    ///
    /// # Returns
    ///
    /// A `Result` indicating success or failure of the connection test.
    pub(crate) async fn test_db_connection(&self) -> Result<()> {
        // Try up to 3 times
        for i in 1..4 {
            match sqlx::query("SELECT 1").execute(&self.db).await {
                Ok(_) => {
                    info!(LOG, "Connected successfully to database");
                    return Ok(());
                }
                Err(e) => {
                    error!(
                        LOG,
                        "Failed to initialize connection to the database: {:?}. Retrying...", e
                    );
                    tokio::time::sleep(Duration::from_secs(i * i)).await;
                }
            }
        }
        Err(anyhow::anyhow!(
            "Failed to initialize database connection after 3 attempts"
        ))
    }

    /// Retrieves credentials for a given account code.
    ///
    /// # Arguments
    ///
    /// * `account_code` - The unique code associated with the account.
    ///
    /// # Returns
    ///
    /// A `Result` containing an `Option<Credentials>` if successful, or an error if the query fails.
    pub(crate) async fn get_credentials(&self, account_code: &str) -> Result<Option<Credentials>> {
        let row = sqlx::query("SELECT * FROM credentials WHERE account_code = $1")
            .bind(account_code)
            .fetch_optional(&self.db)
            .await?;

        match row {
            Some(row) => {
                // Extract values from the row
                let account_code: String = row.get("account_code");
                let account_eth_addr: String = row.get("account_eth_addr");
                let guardian_email_addr: String = row.get("guardian_email_addr");
                let is_set: bool = row.get("is_set");
                let codes_row = Credentials {
                    account_code,
                    account_eth_addr,
                    guardian_email_addr,
                    is_set,
                };
                info!(LOG, "row {:?}", codes_row);
                Ok(Some(codes_row))
            }
            None => Ok(None),
        }
    }

    /// Checks if a wallet and email combination is registered in the database.
    ///
    /// # Arguments
    ///
    /// * `account_eth_addr` - The Ethereum address of the account.
    /// * `email_addr` - The email address to check.
    ///
    /// # Returns
    ///
    /// A `Result` containing a boolean indicating if the combination is registered.
    pub(crate) async fn is_wallet_and_email_registered(
        &self,
        account_eth_addr: &str,
        email_addr: &str,
    ) -> std::result::Result<bool, DatabaseError> {
        let row = sqlx::query(
            "SELECT * FROM credentials WHERE account_eth_addr = $1 AND guardian_email_addr = $2",
        )
        .bind(account_eth_addr)
        .bind(email_addr)
        .fetch_optional(&self.db)
        .await
        .map_err(|e| DatabaseError::new("Failed to check if wallet and email are registered", e))?;

        Ok(row.is_some())
    }

    /// Updates the credentials for a given account code.
    ///
    /// # Arguments
    ///
    /// * `row` - The `Credentials` struct containing the updated information.
    ///
    /// # Returns
    ///
    /// A `Result` indicating success or failure of the update operation.
    pub(crate) async fn update_credentials_of_account_code(
        &self,
        row: &Credentials,
    ) -> std::result::Result<(), DatabaseError> {
        sqlx::query("UPDATE credentials SET account_eth_addr = $1, guardian_email_addr = $2, is_set = $3 WHERE account_code = $4")
            .bind(&row.account_eth_addr)
            .bind(&row.guardian_email_addr)
            .bind(row.is_set)
            .bind(&row.account_code)
            .execute(&self.db)
            .await
            .map_err(|e| {
                DatabaseError::new("Failed to update credentials of account code", e)
            })?;
        Ok(())
    }

    /// Updates the credentials for a given wallet and email combination.
    ///
    /// # Arguments
    ///
    /// * `row` - The `Credentials` struct containing the updated information.
    ///
    /// # Returns
    ///
    /// A `Result` indicating success or failure of the update operation.
    pub(crate) async fn update_credentials_of_wallet_and_email(
        &self,
        row: &Credentials,
    ) -> std::result::Result<(), DatabaseError> {
        sqlx::query("UPDATE credentials SET account_code = $1, is_set = $2 WHERE account_eth_addr = $3 AND guardian_email_addr = $4")
            .bind(&row.account_code)
            .bind(row.is_set)
            .bind(&row.account_eth_addr)
            .bind(&row.guardian_email_addr)
            .execute(&self.db)
            .await
            .map_err(|e| {
                DatabaseError::new("Failed to insert credentials of wallet and email", e)
            })?;
        Ok(())
    }

    /// Updates the credentials of an inactive guardian.
    ///
    /// # Arguments
    ///
    /// * `is_set` - The new value for the `is_set` field.
    /// * `account_eth_addr` - The Ethereum address of the account.
    ///
    /// # Returns
    ///
    /// A `Result` indicating success or failure of the update operation.
    pub(crate) async fn update_credentials_of_inactive_guardian(
        &self,
        is_set: bool,
        account_eth_addr: &str,
    ) -> std::result::Result<(), DatabaseError> {
        sqlx::query(
            "UPDATE credentials SET is_set = $1 WHERE account_eth_addr = $2 AND is_set = true",
        )
        .bind(is_set)
        .bind(account_eth_addr)
        .execute(&self.db)
        .await
        .map_err(|e| DatabaseError::new("Failed to update credentials of inactive guardian", e))?;
        Ok(())
    }

    /// Inserts new credentials into the database.
    ///
    /// # Arguments
    ///
    /// * `row` - The `Credentials` struct containing the new information.
    ///
    /// # Returns
    ///
    /// A `Result` indicating success or failure of the insert operation.
    pub(crate) async fn insert_credentials(
        &self,
        row: &Credentials,
    ) -> std::result::Result<(), DatabaseError> {
        sqlx::query(
            "INSERT INTO credentials (account_code, account_eth_addr, guardian_email_addr, is_set) VALUES ($1, $2, $3, $4) RETURNING *",
        )
        .bind(&row.account_code)
        .bind(&row.account_eth_addr)
        .bind(&row.guardian_email_addr)
        .bind(row.is_set)
        .fetch_one(&self.db)
        .await
        .map_err(|e| DatabaseError::new("Failed to insert credentials", e))?;
        info!(LOG, "Credentials inserted");
        Ok(())
    }

    /// Checks if a guardian is set for a given account and email address.
    ///
    /// # Arguments
    ///
    /// * `account_eth_addr` - The Ethereum address of the account.
    /// * `guardian_email_addr` - The email address of the guardian.
    ///
    /// # Returns
    ///
    /// A `Result` containing a boolean indicating whether the guardian is set.
    pub async fn is_guardian_set(
        &self,
        account_eth_addr: &str,
        guardian_email_addr: &str,
    ) -> std::result::Result<bool, DatabaseError> {
        let row = sqlx::query("SELECT * FROM credentials WHERE account_eth_addr = $1 AND guardian_email_addr = $2 AND is_set = TRUE")
            .bind(account_eth_addr)
            .bind(guardian_email_addr)
            .fetch_optional(&self.db)
            .await
            .map_err(|e| DatabaseError::new("Failed to check if guardian is set", e))?;

        Ok(row.is_some())
    }

    /// Retrieves a request from the database based on the request ID.
    ///
    /// # Arguments
    ///
    /// * `request_id` - The unique identifier of the request.
    ///
    /// # Returns
    ///
    /// A `Result` containing an `Option<Request>` if successful, or an error if the query fails.
    pub(crate) async fn get_request(
        &self,
        request_id: u32,
    ) -> std::result::Result<Option<Request>, DatabaseError> {
        let row = sqlx::query("SELECT * FROM requests WHERE request_id = $1")
            .bind(request_id as i64)
            .fetch_optional(&self.db)
            .await
            .map_err(|e| DatabaseError::new("Failed to get request", e))?;

        match row {
            Some(row) => {
                // Extract values from the row
                let request_id: i64 = row.get("request_id");
                let account_eth_addr: String = row.get("account_eth_addr");
                let controller_eth_addr: String = row.get("controller_eth_addr");
                let guardian_email_addr: String = row.get("guardian_email_addr");
                let is_for_recovery: bool = row.get("is_for_recovery");
                let template_idx: i32 = row.get("template_idx");
                let is_processed: bool = row.get("is_processed");
                let is_success: Option<bool> = row.get("is_success");
                let email_nullifier: Option<String> = row.get("email_nullifier");
                let account_salt: Option<String> = row.get("account_salt");
                let requests_row = Request {
                    request_id: request_id as u32,
                    account_eth_addr,
                    controller_eth_addr,
                    guardian_email_addr,
                    is_for_recovery,
                    template_idx: template_idx as u64,
                    is_processed,
                    is_success,
                    email_nullifier,
                    account_salt,
                };
                info!(LOG, "row {:?}", requests_row);
                Ok(Some(requests_row))
            }
            None => Ok(None),
        }
    }

    /// Updates an existing request in the database.
    ///
    /// # Arguments
    ///
    /// * `row` - The `Request` struct containing the updated information.
    ///
    /// # Returns
    ///
    /// A `Result` indicating success or failure of the update operation.
    pub(crate) async fn update_request(
        &self,
        row: &Request,
    ) -> std::result::Result<(), DatabaseError> {
        sqlx::query("UPDATE requests SET account_eth_addr = $1, controller_eth_addr = $2, guardian_email_addr = $3, is_for_recovery = $4, template_idx = $5, is_processed = $6, is_success = $7, email_nullifier = $8, account_salt = $9 WHERE request_id = $10")
            .bind(&row.account_eth_addr)
            .bind(&row.controller_eth_addr)
            .bind(&row.guardian_email_addr)
            .bind(row.is_for_recovery)
            .bind(row.template_idx as i64)
            .bind(row.is_processed)
            .bind(row.is_success)
            .bind(&row.email_nullifier)
            .bind(&row.account_salt)
            .bind(row.request_id as i64)
            .execute(&self.db)
            .await
            .map_err(|e| DatabaseError::new("Failed to update request", e))?;
        Ok(())
    }

    /// Retrieves the account code for a given wallet and email combination.
    ///
    /// # Arguments
    ///
    /// * `account_eth_addr` - The Ethereum address of the account.
    /// * `email_addr` - The email address associated with the account.
    ///
    /// # Returns
    ///
    /// A `Result` containing an `Option<String>` with the account code if found, or an error if the query fails.
    pub(crate) async fn get_account_code_from_wallet_and_email(
        &self,
        account_eth_addr: &str,
        email_addr: &str,
    ) -> std::result::Result<Option<String>, DatabaseError> {
        let row = sqlx::query(
            "SELECT * FROM credentials WHERE account_eth_addr = $1 AND guardian_email_addr = $2",
        )
        .bind(account_eth_addr)
        .bind(email_addr)
        .fetch_optional(&self.db)
        .await
        .map_err(|e| DatabaseError::new("Failed to get account code from wallet and email", e))?;

        match row {
            Some(row) => {
                let account_code: String = row.get("account_code");
                Ok(Some(account_code))
            }
            None => Ok(None),
        }
    }

    /// Retrieves the credentials for a given wallet and email combination.
    ///
    /// # Arguments
    ///
    /// * `account_eth_addr` - The Ethereum address of the account.
    /// * `email_addr` - The email address associated with the account.
    ///
    /// # Returns
    ///
    /// A `Result` containing an `Option<Credentials>` if found, or an error if the query fails.
    pub(crate) async fn get_credentials_from_wallet_and_email(
        &self,
        account_eth_addr: &str,
        email_addr: &str,
    ) -> std::result::Result<Option<Credentials>, DatabaseError> {
        let row = sqlx::query(
            "SELECT * FROM credentials WHERE account_eth_addr = $1 AND guardian_email_addr = $2",
        )
        .bind(account_eth_addr)
        .bind(email_addr)
        .fetch_optional(&self.db)
        .await
        .map_err(|e| DatabaseError::new("Failed to get credentials from wallet and email", e))?;

        match row {
            Some(row) => {
                // Extract values from the row
                let account_code: String = row.get("account_code");
                let account_eth_addr: String = row.get("account_eth_addr");
                let guardian_email_addr: String = row.get("guardian_email_addr");
                let is_set: bool = row.get("is_set");
                let codes_row = Credentials {
                    account_code,
                    account_eth_addr,
                    guardian_email_addr,
                    is_set,
                };
                info!(LOG, "row {:?}", codes_row);
                Ok(Some(codes_row))
            }
            None => Ok(None),
        }
    }

    /// Inserts a new request into the database.
    ///
    /// # Arguments
    ///
    /// * `row` - The `Request` struct containing the new request information.
    ///
    /// # Returns
    ///
    /// A `Result` indicating success or failure of the insert operation.
    pub(crate) async fn insert_request(
        &self,
        row: &Request,
    ) -> std::result::Result<(), DatabaseError> {
        let request_id = row.request_id;
        sqlx::query(
            "INSERT INTO requests (request_id, account_eth_addr, controller_eth_addr, guardian_email_addr, is_for_recovery, template_idx, is_processed, is_success, email_nullifier, account_salt) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) RETURNING *",
        )
        .bind(row.request_id as i64)
        .bind(&row.account_eth_addr)
        .bind(&row.controller_eth_addr)
        .bind(&row.guardian_email_addr)
        .bind(row.is_for_recovery)
        .bind(row.template_idx as i64)
        .bind(row.is_processed)
        .bind(row.is_success)
        .bind(&row.email_nullifier)
        .bind(&row.account_salt)
        .fetch_one(&self.db)
        .await
        .map_err(|e| DatabaseError::new("Failed to insert request", e))?;
        info!(LOG, "Request inserted with request_id: {}", request_id);
        Ok(())
    }

    /// Adds an expected reply to the database.
    ///
    /// # Arguments
    ///
    /// * `message_id` - The unique identifier of the message.
    /// * `request_id` - An optional request ID associated with the reply.
    ///
    /// # Returns
    ///
    /// A `Result` indicating success or failure of the insert operation.
    pub(crate) async fn add_expected_reply(
        &self,
        message_id: &str,
        request_id: Option<String>,
    ) -> Result<(), DatabaseError> {
        let query = "
                INSERT INTO expected_replies (message_id, request_id)
                VALUES ($1, $2);
            ";
        sqlx::query(query)
            .bind(message_id)
            .bind(request_id)
            .execute(&self.db)
            .await
            .map_err(|e| DatabaseError::new("Failed to insert expected_reply", e))?;
        Ok(())
    }

    /// Checks if the given message_id corresponds to a valid reply.
    ///
    /// This function updates the `has_reply` field to true if the message_id exists and hasn't been replied to yet.
    ///
    /// # Arguments
    ///
    /// * `message_id` - The unique identifier of the message.
    ///
    /// # Returns
    ///
    /// A `Result` containing a boolean indicating if the reply is valid (true if the update was successful).
    pub(crate) async fn is_valid_reply(&self, message_id: &str) -> Result<bool, DatabaseError> {
        let query = "
                UPDATE expected_replies
                SET has_reply = true
                WHERE message_id = $1 AND has_reply = false
                RETURNING *;
            ";
        let result = sqlx::query(query)
            .bind(message_id)
            .execute(&self.db)
            .await
            .map_err(|e| DatabaseError::new("Failed to validate reply", e))?;
        Ok(result.rows_affected() > 0)
    }
}
