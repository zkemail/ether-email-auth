#![allow(clippy::all)]

#[cfg_attr(rustfmt, rustfmt::skip)]
pub mod email_account_recovery;
#[cfg_attr(rustfmt, rustfmt::skip)]
pub mod email_auth;
pub mod forward_dkim_registry;
pub mod user_overridable_dkim_registry;

pub use email_account_recovery::EmailAccountRecovery;
pub use email_auth::*;
pub use forward_dkim_registry::ForwardDKIMRegistry;
pub use user_overridable_dkim_registry::UserOverridableDKIMRegistry;
