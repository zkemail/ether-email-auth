#![allow(unused_imports)]

use std::path::PathBuf;

use crate::*;

use anyhow::anyhow;
use handlebars::Handlebars;
use lettre::{
    message::{
        header::{Cc, From, Header, HeaderName, InReplyTo, ReplyTo, To},
        Attachment, Mailbox, Mailboxes, MessageBuilder, MultiPart, SinglePart,
    },
    transport::smtp::{
        authentication::Credentials, client::SmtpConnection, commands::*, extension::ClientId,
        SMTP_PORT,
    },
    Address, AsyncSmtpTransport, AsyncTransport, Message, Tokio1Executor,
};
use serde_json::Value;
use tokio::fs::read_to_string;

#[derive(Debug, Clone)]
pub struct EmailMessage {
    pub to: String,
    pub subject: String,
    pub reference: Option<String>,
    pub reply_to: Option<String>,
    pub body_plain: String,
    pub body_html: String,
    pub body_attachments: Option<Vec<EmailAttachment>>,
}

#[derive(Debug, Clone)]
pub struct EmailAttachment {
    pub inline_id: String,
    pub content_type: String,
    pub contents: Vec<u8>,
}

#[derive(Clone)]
pub(crate) struct SmtpConfig {
    pub(crate) domain_name: String,
    pub(crate) id: String,
    pub(crate) password: String,
}

pub(crate) struct SmtpClient {
    config: SmtpConfig,
    transport: AsyncSmtpTransport<Tokio1Executor>,
}

impl SmtpClient {
    pub(crate) fn new(config: SmtpConfig) -> Result<Self> {
        let creds = Credentials::new(config.id.clone(), config.password.clone());
        let transport = AsyncSmtpTransport::<Tokio1Executor>::relay(&config.domain_name)?
            .credentials(creds)
            .build();

        Ok(Self { config, transport })
    }

    pub(crate) async fn send_new_email(&self, email: EmailMessage) -> Result<()> {
        self.send_inner(
            email.to,
            email.subject,
            email.reference,
            email.reply_to,
            email.body_plain,
            email.body_html,
            email.body_attachments,
        )
        .await
    }

    async fn send_inner(
        &self,
        to: String,
        subject: String,
        reference: Option<String>,
        reply_to: Option<String>,
        body_plain: String,
        body_html: String,
        body_attachments: Option<Vec<EmailAttachment>>,
    ) -> Result<()> {
        let from_mbox = Mailbox::new(None, self.config.id.parse::<Address>()?);
        let to_mbox = Mailbox::new(None, to.parse::<Address>()?);

        let mut email_builder = Message::builder()
            .from(from_mbox)
            .subject(subject)
            .to(to_mbox);
        if let Some(reference) = reference {
            email_builder = email_builder.references(reference);
        }
        if let Some(reply_to) = reply_to {
            email_builder = email_builder.in_reply_to(reply_to);
        }
        let mut multipart = MultiPart::related().singlepart(SinglePart::html(body_html));
        if let Some(body_attachments) = body_attachments {
            for attachment in body_attachments {
                multipart = multipart.singlepart(
                    Attachment::new_inline(attachment.inline_id)
                        .body(attachment.contents, attachment.content_type.parse()?),
                );
            }
        }
        let email = email_builder.multipart(
            MultiPart::alternative()
                .singlepart(SinglePart::plain(body_plain))
                .multipart(multipart),
        )?;

        self.transport.send(email).await?;

        Ok(())
    }

    fn reconnect(mut self) -> Result<()> {
        const MAX_RETRIES: u32 = 5;
        let mut retry_count = 0;

        while retry_count < MAX_RETRIES {
            match SmtpClient::new(self.config.clone()) {
                Ok(new_client) => {
                    self.transport = new_client.transport;
                    return Ok(());
                }
                Err(_) => {
                    retry_count += 1;
                    std::thread::sleep(std::time::Duration::from_millis(1000));
                }
            }
        }

        Err(anyhow!("{SMTP_RECONNECT_ERROR}"))
    }
}

pub async fn render_html(template_name: &str, render_data: Value) -> Result<String> {
    let email_template_filename = PathBuf::new()
        .join(EMAIL_TEMPLATES.get().unwrap())
        .join(template_name);
    let email_template = read_to_string(&email_template_filename).await?;

    let reg = Handlebars::new();
    Ok(reg.render_template(&email_template, &render_data)?)
}
