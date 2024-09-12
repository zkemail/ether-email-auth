use crate::*;
use handlebars::Handlebars;
use serde::{Deserialize, Serialize};
use serde_json::Value;
use tokio::fs::read_to_string;

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
    },
    RecoverySuccess {
        account_eth_addr: String,
        guardian_email_addr: String,
        request_id: u32,
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

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct EmailAttachment {
    pub inline_id: String,
    pub content_type: String,
    pub contents: Vec<u8>,
}

pub async fn handle_email_event(event: EmailAuthEvent) -> Result<(), EmailError> {
    match event {
        EmailAuthEvent::AcceptanceRequest {
            account_eth_addr,
            guardian_email_addr,
            request_id,
            command,
            account_code,
        } => {
            let command = format!("{} Code {}", command, account_code);

            let body_plain = format!(
                "You have received an guardian request from the wallet address {}. \
                {} Code {}. \
                Reply \"Confirm\" to this email to accept the request. \
                Your request ID is #{}. \
                If you did not initiate this request, please contact us immediately.",
                account_eth_addr, command, account_code, request_id
            );

            let subject = format!("Email Recovery: Acceptance Request");

            let render_data = serde_json::json!({
                "userEmailAddr": guardian_email_addr,
                "walletAddress": account_eth_addr,
                "command": command,
                "requestId": request_id,
            });
            let body_html = render_html("acceptance_request.html", render_data).await?;

            let email = EmailMessage {
                to: guardian_email_addr,
                subject,
                reference: None,
                reply_to: None,
                body_plain,
                body_html,
                body_attachments: None,
            };

            send_email(email).await?;
        }
        EmailAuthEvent::Error { email_addr, error } => {
            let subject = "Error";
            let body_plain = format!(
                "An error occurred while processing your request. \
                Error: {}",
                error
            );

            let render_data = serde_json::json!({
                "error": error,
                "userEmailAddr": email_addr,
            });
            let body_html = render_html("error.html", render_data).await?;

            let email = EmailMessage {
                to: email_addr,
                subject: subject.to_string(),
                reference: None,
                reply_to: None,
                body_plain,
                body_html,
                body_attachments: None,
            };

            send_email(email).await?;
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

            let render_data = serde_json::json!({
                "walletAddress": account_eth_addr,
                "userEmailAddr": guardian_email_addr,
            });
            let body_html = render_html("guardian_already_exists.html", render_data).await?;

            let email = EmailMessage {
                to: guardian_email_addr,
                subject: subject.to_string(),
                reference: None,
                reply_to: None,
                body_plain,
                body_html,
                body_attachments: None,
            };

            send_email(email).await?;
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

            let subject = format!("Email Recovery: Recovery Request");

            let render_data = serde_json::json!({
                "userEmailAddr": guardian_email_addr,
                "walletAddress": account_eth_addr,
                "command": command,
                "requestId": request_id,
            });
            let body_html = render_html("recovery_request.html", render_data).await?;

            let email = EmailMessage {
                to: guardian_email_addr,
                subject,
                reference: None,
                reply_to: None,
                body_plain,
                body_html,
                body_attachments: None,
            };

            send_email(email).await?;
        }
        EmailAuthEvent::AcceptanceSuccess {
            account_eth_addr,
            guardian_email_addr,
            request_id,
        } => {
            let subject = "Acceptance Success";
            let body_plain = format!(
                "Your guardian request for the wallet address {} has been set. \
                Your request ID is #{} is now complete.",
                account_eth_addr, request_id
            );

            let render_data = serde_json::json!({
                "walletAddress": account_eth_addr,
                "userEmailAddr": guardian_email_addr,
                "requestId": request_id,
            });
            let body_html = render_html("acceptance_success.html", render_data).await?;

            let email = EmailMessage {
                to: guardian_email_addr,
                subject: subject.to_string(),
                reference: None,
                reply_to: None,
                body_plain,
                body_html,
                body_attachments: None,
            };

            send_email(email).await?;
        }
        EmailAuthEvent::RecoverySuccess {
            account_eth_addr,
            guardian_email_addr,
            request_id,
        } => {
            let subject = "Recovery Success";
            let body_plain = format!(
                "Your recovery request for the wallet address {} is successful. \
                Your request ID is #{}.",
                account_eth_addr, request_id
            );

            let render_data = serde_json::json!({
                "walletAddress": account_eth_addr,
                "userEmailAddr": guardian_email_addr,
                "requestId": request_id,
            });
            let body_html = render_html("recovery_success.html", render_data).await?;

            let email = EmailMessage {
                to: guardian_email_addr,
                subject: subject.to_string(),
                reference: None,
                reply_to: None,
                body_plain,
                body_html,
                body_attachments: None,
            };

            send_email(email).await?;
        }
        EmailAuthEvent::GuardianNotSet {
            account_eth_addr,
            guardian_email_addr,
        } => {
            let subject = "Guardian Not Set";
            let body_plain = format!("Guardian not set for wallet address {}", account_eth_addr);

            let render_data = serde_json::json!({
                "walletAddress": account_eth_addr,
                "userEmailAddr": guardian_email_addr,
            });
            let body_html = render_html("guardian_not_set.html", render_data).await?;

            let email = EmailMessage {
                to: guardian_email_addr,
                subject: subject.to_string(),
                reference: None,
                reply_to: None,
                body_plain,
                body_html,
                body_attachments: None,
            };

            send_email(email).await?;
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

            let render_data = serde_json::json!({
                "userEmailAddr": guardian_email_addr,
                "walletAddress": account_eth_addr,
                "requestId": request_id,
                "command": command,
            });

            let subject = "Guardian Not Registered".to_string();
            let body_html = render_html("credential_not_present.html", render_data).await?;

            let email = EmailMessage {
                to: guardian_email_addr,
                subject,
                reference: None,
                reply_to: None,
                body_plain,
                body_html,
                body_attachments: None,
            };

            send_email(email).await?;
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
            let render_data = serde_json::json!({"userEmailAddr": email_addr, "request": command});
            let body_html = render_html("acknowledgement.html", render_data).await?;
            let subject = format!("Re: {}", original_subject);
            let email = EmailMessage {
                to: email_addr,
                subject,
                body_plain,
                body_html,
                reference: original_message_id.clone(),
                reply_to: original_message_id,
                body_attachments: None,
            };
            send_email(email).await?;
        }
        EmailAuthEvent::NoOp => {}
    }

    Ok(())
}

pub async fn render_html(template_name: &str, render_data: Value) -> Result<String, EmailError> {
    let email_template_filename = PathBuf::new()
        .join(EMAIL_TEMPLATES.get().unwrap())
        .join(template_name);
    let email_template = read_to_string(&email_template_filename)
        .await
        .map_err(|e| {
            EmailError::FileNotFound(format!(
                "Could not get email template {}: {}",
                template_name, e
            ))
        })?;

    let reg = Handlebars::new();

    let template = reg.render_template(&email_template, &render_data)?;
    Ok(template)
}

pub fn parse_error(error: String) -> Result<Option<String>> {
    let mut error = error;
    if error.contains("Contract call reverted with data: ") {
        let revert_data = error
            .replace("Contract call reverted with data: ", "")
            .split_at(10)
            .1
            .to_string();
        let revert_bytes = hex::decode(revert_data)
            .unwrap()
            .into_iter()
            .filter(|&b| b >= 0x20 && b <= 0x7E)
            .collect();
        error = String::from_utf8(revert_bytes).unwrap().trim().to_string();
    }

    match error.as_str() {
        "Account is already created" => Ok(Some(error)),
        "insufficient balance" => Ok(Some("You don't have sufficient balance".to_string())),
        _ => Ok(Some(error)),
    }
}

pub async fn send_email(email: EmailMessage) -> Result<(), EmailError> {
    let smtp_server = SMTP_SERVER.get().unwrap();

    // Send POST request to email server
    let client = reqwest::Client::new();
    let response = client
        .post(smtp_server)
        .json(&email)
        .send()
        .await
        .map_err(|e| EmailError::Send(format!("Failed to send email: {}", e)))?;

    if !response.status().is_success() {
        return Err(EmailError::Send(format!(
            "Failed to send email: {}",
            response.text().await.unwrap_or_default()
        )));
    }

    Ok(())
}
