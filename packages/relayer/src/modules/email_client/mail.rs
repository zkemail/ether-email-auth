use crate::{
    check_domain_sign_reply_to, error, render_html, split_email_address, EmailForwardSender,
    EmailMessage, Future, Result, DB, LOG, RELAYER_EMAIL_ADDRESS,
};
use anyhow::anyhow;
use std::pin::Pin;

#[derive(Debug, Clone)]
pub enum EmailAuthEvent {
    Acceptance {
        wallet_eth_addr: String,
        guardian_email_addr: String,
        request_id: u64,
    },
    GuardianAlreadyExists {
        wallet_eth_addr: String,
        guardian_email_addr: String,
    },
    Error {
        email_addr: String,
        error: String,
    },
    Recovery {
        wallet_eth_addr: String,
        guardian_email_addr: String,
        request_id: u64,
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
        EmailAuthEvent::Acceptance {
            wallet_eth_addr,
            guardian_email_addr,
            request_id,
        } => {
            let invitation_code = DB.get_invitation_code_from_email_addr(&guardian_email_addr).await?;
            println!("Invitation code: {:?}", invitation_code);
            let mut hex_invitation_code = String::new();
            if let Some(code_str) = invitation_code {
                hex_invitation_code = code_str.to_string();
            } else {
                return Err(anyhow!("Account code not found"));
            }

            let mut subject = format!(
                "Acceptance Request for {}. Code {}",
                wallet_eth_addr, hex_invitation_code
            );
            let relayer_email = split_email_address(RELAYER_EMAIL_ADDRESS.get().unwrap());

            let mut reply_to = None;

            if check_domain_sign_reply_to(&guardian_email_addr) {
                if let Some((local_part, domain_part)) = relayer_email {
                    reply_to = Some(
                        local_part.to_string() + "+code" + &hex_invitation_code + "@" + domain_part,
                    );
                    subject = format!("Acceptance Request for {}", wallet_eth_addr);
                } else {
                    return Err(anyhow!("Failed to parse relayer email"));
                }
            }

            let body_plain = format!(
                "You have received an guardian request from the wallet address {}. \
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
                reply_to,
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
        EmailAuthEvent::Recovery {
            wallet_eth_addr,
            guardian_email_addr,
            request_id,
        } => {
            let subject = "Recovery Request";
            let body_plain = format!(
                "You have received a recovery request from the wallet address {}. \
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
                subject: subject.to_string(),
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
    }

    Ok(())
}
