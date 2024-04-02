use crate::{
    error, render_html, EmailForwardSender,
    EmailMessage, Future, Result, LOG,
};

use std::pin::Pin;

#[derive(Debug, Clone)]
pub enum EmailAuthEvent {
    AcceptanceRequest {
        wallet_eth_addr: String,
        guardian_email_addr: String,
        request_id: u64,
        subject: String,
        account_code: String,
    },
    GuardianAlreadyExists {
        wallet_eth_addr: String,
        guardian_email_addr: String,
    },
    Error {
        email_addr: String,
        error: String,
    },
    RecoveryRequest {
        wallet_eth_addr: String,
        guardian_email_addr: String,
        request_id: u64,
        subject: String,
    },
    AcceptanceSuccess {
        wallet_eth_addr: String,
        guardian_email_addr: String,
        request_id: u64,
    },
    RecoverySuccess {
        wallet_eth_addr: String,
        guardian_email_addr: String,
        request_id: u64,
    },
    GuardianNotSet {
        wallet_eth_addr: String,
        guardian_email_addr: String,
    },
    GuardianNotRegistered {
        wallet_eth_addr: String,
        guardian_email_addr: String,
        subject: String,
        request_id: u64,
    },
}

pub fn event_consumer(
    event: EmailAuthEvent,
    sender: EmailForwardSender,
) -> Pin<Box<dyn Future<Output = ()> + Send>> {
    Box::pin(async {
        match event_consumer_fn(event, sender).await {
            Ok(_) => {}
            Err(err) => {
                error!(LOG, "Failed to accept event: {}", err);
            }
        }
    })
}

async fn event_consumer_fn(event: EmailAuthEvent, sender: EmailForwardSender) -> Result<()> {
    match event {
        EmailAuthEvent::AcceptanceRequest {
            wallet_eth_addr,
            guardian_email_addr,
            request_id,
            subject,
            account_code,
        } => {
            let subject = format!("{} Code {}", subject, account_code);

            let body_plain = format!(
                "You have received an guardian request from the wallet address {}. \
                Reply \"Confirm\" to this email to accept the request. \
                Your request ID is #{}. \
                If you did not initiate this request, please contact us immediately.",
                wallet_eth_addr, request_id
            );

            let render_data = serde_json::json!({
                "userEmailAddr": guardian_email_addr,
                "walletAddress": wallet_eth_addr,
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

            sender.send(email)?;
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

            sender.send(email)?;
        }
        EmailAuthEvent::GuardianAlreadyExists {
            wallet_eth_addr,
            guardian_email_addr,
        } => {
            let subject = "Guardian Already Exists";
            let body_plain = format!(
                "The guardian email address {} is already associated with the wallet address {}. \
                If you did not initiate this request, please contact us immediately.",
                guardian_email_addr, wallet_eth_addr
            );

            let render_data = serde_json::json!({
                "walletAddress": wallet_eth_addr,
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

            sender.send(email)?;
        }
        EmailAuthEvent::RecoveryRequest {
            wallet_eth_addr,
            guardian_email_addr,
            request_id,
            subject,
        } => {
            let body_plain = format!(
                "You have received a recovery request from the wallet address {}. \
                Reply \"Confirm\" to this email to accept the request. \
                Your request ID is #{}. \
                If you did not initiate this request, please contact us immediately.",
                wallet_eth_addr, request_id
            );

            let render_data = serde_json::json!({
                "userEmailAddr": guardian_email_addr,
                "walletAddress": wallet_eth_addr,
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

            sender.send(email)?;
        }
        EmailAuthEvent::AcceptanceSuccess {
            wallet_eth_addr,
            guardian_email_addr,
            request_id,
        } => {
            let subject = "Acceptance Success";
            let body_plain = format!(
                "Your guardian request for the wallet address {} has been set. \
                Your request ID is #{} is now complete.",
                wallet_eth_addr, request_id
            );

            let render_data = serde_json::json!({
                "walletAddress": wallet_eth_addr,
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

            sender.send(email)?;
        }
        EmailAuthEvent::RecoverySuccess {
            wallet_eth_addr,
            guardian_email_addr,
            request_id,
        } => {
            let subject = "Recovery Success";
            let body_plain = format!(
                "Your recovery request for the wallet address {} is successful. \
                Your request ID is #{}.",
                wallet_eth_addr, request_id
            );

            let render_data = serde_json::json!({
                "walletAddress": wallet_eth_addr,
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

            sender.send(email)?;
        }
        EmailAuthEvent::GuardianNotSet {
            wallet_eth_addr,
            guardian_email_addr,
        } => {
            let subject = "Guardian Not Set";
            let body_plain = format!("Guardian not set for wallet address {}", wallet_eth_addr);

            let render_data = serde_json::json!({
                "walletAddress": wallet_eth_addr,
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

            sender.send(email)?;
        }
        EmailAuthEvent::GuardianNotRegistered {
            wallet_eth_addr,
            guardian_email_addr,
            subject,
            request_id,
        } => {
            let subject = format!("{} Code ", subject);

            let body_plain = format!(
                "You have received an guardian request from the wallet address {}. \
                Add the guardian's account code in the subject and reply to this email. \
                Your request ID is #{}. \
                If you did not initiate this request, please contact us immediately.",
                wallet_eth_addr, request_id
            );

            let render_data = serde_json::json!({
                "userEmailAddr": guardian_email_addr,
                "walletAddress": wallet_eth_addr,
                "requestId": request_id,
            });
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

            sender.send(email)?;
        }
    }

    Ok(())
}
