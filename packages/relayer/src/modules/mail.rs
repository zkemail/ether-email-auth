use crate::core::EmailRequestContext;
use crate::*;
use handlebars::Handlebars;
use serde::{Deserialize, Serialize};
use serde_json::Value;
use tokio::fs::read_to_string;

/// Represents different types of email authentication events.
#[derive(Debug, Clone)]
pub enum EmailAuthEvent {
    AcceptanceRequest {
        account_eth_addr: String,
        guardian_email_addr: String,
        request_id: u32,
        command: String,
        account_code: String,
    },
    GuardianAlreadyExists {
        account_eth_addr: String,
        guardian_email_addr: String,
    },
    Error {
        email_addr: String,
        error: String,
        original_subject: String,
        original_message_id: Option<String>,
        email_request_context: Option<Box<EmailRequestContext>>,
        command: Option<String>,
    },
    RecoveryRequest {
        account_eth_addr: String,
        guardian_email_addr: String,
        request_id: u32,
        command: String,
    },
    AcceptanceSuccess {
        account_eth_addr: String,
        guardian_email_addr: String,
        request_id: u32,
        original_subject: String,
        original_message_id: Option<String>,
    },
    RecoverySuccess {
        account_eth_addr: String,
        guardian_email_addr: String,
        request_id: u32,
        original_subject: String,
        original_message_id: Option<String>,
    },
    GuardianNotSet {
        account_eth_addr: String,
        guardian_email_addr: String,
    },
    GuardianNotRegistered {
        account_eth_addr: String,
        guardian_email_addr: String,
        command: String,
        request_id: u32,
    },
    Ack {
        email_addr: String,
        command: String,
        original_message_id: Option<String>,
        original_subject: String,
    },
    NoOp,
}

/// Represents an email message to be sent.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct EmailMessage {
    pub to: String,
    pub subject: String,
    pub reference: Option<String>,
    pub reply_to: Option<String>,
    pub body_plain: String,
    pub body_html: String,
    pub body_attachments: Option<Vec<EmailAttachment>>,
}

/// Represents an attachment in an email message.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct EmailAttachment {
    pub inline_id: String,
    pub content_type: String,
    pub contents: Vec<u8>,
}

/// Handles all possible email events and requests.
///
/// # Arguments
///
/// * `event` - The `EmailAuthEvent` to be handled.
///
/// # Returns
///
/// A `Result` indicating success or an `EmailError`.
pub async fn handle_email_event(event: EmailAuthEvent) -> Result<(), EmailError> {
    match event {
        EmailAuthEvent::AcceptanceRequest {
            account_eth_addr,
            guardian_email_addr,
            request_id,
            command,
            account_code,
        } => {
            // Prepare the command with the account code
            let command = format!("{} Code {}", command, account_code);

            // Create the plain text body
            let body_plain = format!(
                "You have received an guardian request from the wallet address {}. \
                {} Code {}. \
                Reply \"Confirm\" to this email to accept the request. \
                Your request ID is #{}. \
                If you did not initiate this request, please contact us immediately.",
                account_eth_addr, command, account_code, request_id
            );

            let subject = "[Reply Needed] Recovery: Acceptance Request".to_string();

            // Prepare data for HTML rendering
            let render_data = serde_json::json!({
                "userEmailAddr": guardian_email_addr,
                "walletAddress": account_eth_addr,
                "command": command,
                "requestId": request_id,
            });
            let body_html = render_html("acceptance_request.html", render_data).await?;

            // Create and send the email
            let email = EmailMessage {
                to: guardian_email_addr,
                subject,
                reference: None,
                reply_to: None,
                body_plain,
                body_html,
                body_attachments: None,
            };

            send_email(email, Some(ExpectsReply::new(request_id))).await?;
        }
        EmailAuthEvent::Error {
            email_addr,
            error,
            original_subject,
            original_message_id,
            email_request_context,
            command,
        } => {
            // Send error notification to system user if this is a contract call error
            if let (Some(email_request_context), Some(command)) = (email_request_context, command) {
                let recipient_email = ERROR_EMAIL_ADDR
                    .get()
                    .expect("ERROR_EMAIL_ADDR must be set before use")
                    .clone();

                let body_plain = format!(
                    "Error: {}\n\n\
                    Request ID: {}\n\
                    Command: {}\n\
                    Account Address: {}\n\
                    Controller Address: {}\n\n\
                    Email:\n{}",
                    error,
                    email_request_context.request.request_id,
                    command,
                    email_request_context.request.account_eth_addr,
                    email_request_context.request.controller_eth_addr,
                    email_request_context.email
                );

                let render_data = serde_json::json!({
                    "error": error,
                    "requestId": email_request_context.request.request_id,
                    "command": command,
                    "account_address": email_request_context.request.account_eth_addr,
                    "controller_address": email_request_context.request.controller_eth_addr,
                    "email": email_request_context.email,
                });

                let subject = format!(
                    "[Error] Request ID: {}",
                    email_request_context.request.request_id
                );
                let body_html = render_html("error_for_admin.html", render_data).await?;

                let email = EmailMessage {
                    to: recipient_email,
                    subject,
                    reference: None,
                    reply_to: None,
                    body_plain,
                    body_html,
                    body_attachments: None,
                };

                send_email(email, None).await?;
            }

            let subject = format!("Re: {}", original_subject);

            let body_plain = format!(
                "An error occurred while processing your request. \
                Error: {}",
                error
            );

            // Prepare data for HTML rendering
            let render_data = serde_json::json!({
                "error": error,
                "userEmailAddr": email_addr,
            });
            let body_html = render_html("error.html", render_data).await?;

            // Create and send the email
            let email = EmailMessage {
                to: email_addr,
                subject,
                reference: original_message_id.clone(),
                reply_to: original_message_id,
                body_plain,
                body_html,
                body_attachments: None,
            };

            send_email(email, None).await?;
        }
        EmailAuthEvent::GuardianAlreadyExists {
            account_eth_addr,
            guardian_email_addr,
        } => {
            let subject = "Guardian Already Exists";
            let body_plain = format!(
                "The guardian email address {} is already associated with the wallet address {}. \
                If you did not initiate this request, please contact us immediately.",
                guardian_email_addr, account_eth_addr
            );

            // Prepare data for HTML rendering
            let render_data = serde_json::json!({
                "walletAddress": account_eth_addr,
                "userEmailAddr": guardian_email_addr,
            });
            let body_html = render_html("guardian_already_exists.html", render_data).await?;

            // Create and send the email
            let email = EmailMessage {
                to: guardian_email_addr,
                subject: subject.to_string(),
                reference: None,
                reply_to: None,
                body_plain,
                body_html,
                body_attachments: None,
            };

            send_email(email, None).await?;
        }
        EmailAuthEvent::RecoveryRequest {
            account_eth_addr,
            guardian_email_addr,
            request_id,
            command,
        } => {
            let body_plain = format!(
                "You have received a recovery request from the wallet address {}. \
                Reply \"Confirm\" to this email to accept the request. \
                Your request ID is #{}. \
                If you did not initiate this request, please contact us immediately.",
                account_eth_addr, request_id
            );

            let subject = "[Reply Needed] Recovery: Recovery Request".to_string();

            // Prepare data for HTML rendering
            let render_data = serde_json::json!({
                "userEmailAddr": guardian_email_addr,
                "walletAddress": account_eth_addr,
                "command": command,
                "requestId": request_id,
            });
            let body_html = render_html("recovery_request.html", render_data).await?;

            // Create and send the email
            let email = EmailMessage {
                to: guardian_email_addr,
                subject,
                reference: None,
                reply_to: None,
                body_plain,
                body_html,
                body_attachments: None,
            };

            send_email(email, Some(ExpectsReply::new(request_id))).await?;
        }
        EmailAuthEvent::AcceptanceSuccess {
            account_eth_addr,
            guardian_email_addr,
            request_id,
            original_subject,
            original_message_id,
        } => {
            let subject = format!("Re: {}", original_subject);
            let body_plain = format!(
                "Your guardian request for the wallet address {} has been set. \
                Your request ID is #{} is now complete.",
                account_eth_addr, request_id
            );

            // Prepare data for HTML rendering
            let render_data = serde_json::json!({
                "walletAddress": account_eth_addr,
                "userEmailAddr": guardian_email_addr,
                "requestId": request_id,
            });
            let body_html = render_html("acceptance_success.html", render_data).await?;

            // Create and send the email
            let email = EmailMessage {
                to: guardian_email_addr,
                subject: subject.to_string(),
                reference: original_message_id.clone(),
                reply_to: original_message_id,
                body_plain,
                body_html,
                body_attachments: None,
            };

            send_email(email, None).await?;
        }
        EmailAuthEvent::RecoverySuccess {
            account_eth_addr,
            guardian_email_addr,
            request_id,
            original_subject,
            original_message_id,
        } => {
            let subject = format!("Re: {}", original_subject);
            let body_plain = format!(
                "Your recovery request for the wallet address {} is successful. \
                Your request ID is #{}.",
                account_eth_addr, request_id
            );

            // Prepare data for HTML rendering
            let render_data = serde_json::json!({
                "walletAddress": account_eth_addr,
                "userEmailAddr": guardian_email_addr,
                "requestId": request_id,
            });
            let body_html = render_html("recovery_success.html", render_data).await?;

            // Create and send the email
            let email = EmailMessage {
                to: guardian_email_addr,
                subject: subject.to_string(),
                reference: original_message_id.clone(),
                reply_to: original_message_id,
                body_plain,
                body_html,
                body_attachments: None,
            };

            send_email(email, None).await?;
        }
        EmailAuthEvent::GuardianNotSet {
            account_eth_addr,
            guardian_email_addr,
        } => {
            let subject = "Guardian Not Set";
            let body_plain = format!("Guardian not set for wallet address {}", account_eth_addr);

            // Prepare data for HTML rendering
            let render_data = serde_json::json!({
                "walletAddress": account_eth_addr,
                "userEmailAddr": guardian_email_addr,
            });
            let body_html = render_html("guardian_not_set.html", render_data).await?;

            // Create and send the email
            let email = EmailMessage {
                to: guardian_email_addr,
                subject: subject.to_string(),
                reference: None,
                reply_to: None,
                body_plain,
                body_html,
                body_attachments: None,
            };

            send_email(email, None).await?;
        }
        EmailAuthEvent::GuardianNotRegistered {
            account_eth_addr,
            guardian_email_addr,
            command,
            request_id,
        } => {
            let command = format!("{} Code ", command);

            let body_plain = format!(
                "You have received an guardian request from the wallet address {}. \
                Reply to this email. \
                Your request ID is #{}. \
                If you did not initiate this request, please contact us immediately.",
                account_eth_addr, request_id
            );

            // Prepare data for HTML rendering
            let render_data = serde_json::json!({
                "userEmailAddr": guardian_email_addr,
                "walletAddress": account_eth_addr,
                "requestId": request_id,
                "command": command,
            });

            let subject = "Guardian Not Registered".to_string();
            let body_html = render_html("credential_not_present.html", render_data).await?;

            // Create and send the email
            let email = EmailMessage {
                to: guardian_email_addr,
                subject,
                reference: None,
                reply_to: None,
                body_plain,
                body_html,
                body_attachments: None,
            };

            send_email(email, Some(ExpectsReply::new(request_id))).await?;
        }
        EmailAuthEvent::Ack {
            email_addr,
            command,
            original_message_id,
            original_subject,
        } => {
            let body_plain = format!(
                "Hi {}!\nYour email with the command {} is received.",
                email_addr, command
            );
            // Prepare data for HTML rendering
            let render_data = serde_json::json!({"userEmailAddr": email_addr, "request": command});
            let body_html = render_html("acknowledgement.html", render_data).await?;
            let subject = format!("Re: {}", original_subject);
            // Create and send the email
            let email = EmailMessage {
                to: email_addr,
                subject,
                body_plain,
                body_html,
                reference: original_message_id.clone(),
                reply_to: original_message_id,
                body_attachments: None,
            };
            send_email(email, None).await?;
        }
        EmailAuthEvent::NoOp => {}
    }

    Ok(())
}

/// Renders an HTML template with the given data.
///
/// # Arguments
///
/// * `template_name` - The name of the template file.
/// * `render_data` - The data to be used in rendering the template.
///
/// # Returns
///
/// A `Result` containing the rendered HTML string or an `EmailError`.
async fn render_html(template_name: &str, render_data: Value) -> Result<String, EmailError> {
    // Construct the full path to the email template
    let email_template_filename = PathBuf::new()
        .join(EMAIL_TEMPLATES.get().unwrap())
        .join(template_name);

    // Read the email template file
    let email_template = read_to_string(&email_template_filename)
        .await
        .map_err(|e| {
            EmailError::FileNotFound(format!(
                "Could not get email template {}: {}",
                template_name, e
            ))
        })?;

    // Create a new Handlebars instance
    let reg = Handlebars::new();

    // Render the template with the provided data
    let template = reg.render_template(&email_template, &render_data)?;
    Ok(template)
}

/// Parses an error string and returns a more user-friendly error message.
///
/// # Arguments
///
/// * `error` - The error string to be parsed.
///
/// # Returns
///
/// A `Result` containing an `Option<String>` with the parsed error message.
fn parse_error(error: String) -> Result<Option<String>> {
    let mut error = error;
    if error.contains("Contract call reverted with data: ") {
        // Extract and decode the revert data
        let revert_data = error
            .replace("Contract call reverted with data: ", "")
            .split_at(10)
            .1
            .to_string();
        let revert_bytes = hex::decode(revert_data)
            .unwrap()
            .into_iter()
            .filter(|&b| (0x20..=0x7E).contains(&b))
            .collect();
        error = String::from_utf8(revert_bytes).unwrap().trim().to_string();
    }

    // Match known error messages and provide user-friendly responses
    match error.as_str() {
        "Account is already created" => Ok(Some(error)),
        "insufficient balance" => Ok(Some("You don't have sufficient balance".to_string())),
        _ => Ok(Some(error)),
    }
}

/// Sends an email using the configured SMTP server.
///
/// # Arguments
///
/// * `email` - The `EmailMessage` to be sent.
/// * `expects_reply` - An optional `ExpectsReply` struct indicating if a reply is expected.
///
/// # Returns
///
/// A `Result` indicating success or an `EmailError`.
async fn send_email(
    email: EmailMessage,
    expects_reply: Option<ExpectsReply>,
) -> Result<(), EmailError> {
    let smtp_server = SMTP_SERVER.get().unwrap();

    // Send POST request to email server
    let client = reqwest::Client::new();
    let response = client
        .post(smtp_server)
        .json(&email)
        .send()
        .await
        .map_err(|e| EmailError::Send(format!("Failed to send email: {}", e)))?;

    // Check if the email was sent successfully
    if !response.status().is_success() {
        return Err(EmailError::Send(format!(
            "Failed to send email: {}",
            response.text().await.unwrap_or_default()
        )));
    }

    // Handle expected reply if necessary
    if let Some(expects_reply) = expects_reply {
        let response_body: EmailResponse = response
            .json()
            .await
            .map_err(|e| EmailError::Parse(format!("Failed to parse response JSON: {}", e)))?;

        let message_id = response_body.message_id;
        DB.add_expected_reply(&message_id, expects_reply.request_id)
            .await?;
    }

    Ok(())
}

/// Represents the response from the email server after sending an email.
#[derive(Debug, Clone, Serialize, Deserialize)]
struct EmailResponse {
    status: String,
    message_id: String,
}

/// Represents an expectation of a reply to an email.
pub struct ExpectsReply {
    request_id: Option<String>,
}

impl ExpectsReply {
    /// Creates a new `ExpectsReply` instance with a request ID.
    ///
    /// # Arguments
    ///
    /// * `request_id` - The ID of the request expecting a reply.
    fn new(request_id: u32) -> Self {
        Self {
            request_id: Some(request_id.to_string()),
        }
    }

    /// Creates a new `ExpectsReply` instance without a request ID.
    fn new_no_request_id() -> Self {
        Self { request_id: None }
    }
}

/// Checks if the email is a reply to a command that expects a reply.
/// Will return false for duplicate replies.
/// Will return true if the email is not a reply.
///
/// # Arguments
///
/// * `email` - The `ParsedEmail` to be checked.
///
/// # Returns
///
/// A `Result` containing a boolean indicating if the request is valid.
pub async fn check_is_valid_request(email: &ParsedEmail) -> Result<bool, EmailError> {
    // Check if the email is a reply by looking for the "In-Reply-To" header
    let reply_message_id = match email
        .headers
        .get_header("In-Reply-To")
        .and_then(|v| v.first().cloned())
    {
        Some(id) => id,
        // Email is not a reply, so it's valid
        None => return Ok(true),
    };

    // Check if the reply is valid (not a duplicate) using the database
    let is_valid = DB.is_valid_reply(&reply_message_id).await?;
    Ok(is_valid)
}
