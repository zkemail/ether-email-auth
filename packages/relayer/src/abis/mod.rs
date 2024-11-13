#![allow(clippy::all)]


#[cfg_attr(rustfmt, rustfmt::skip)]
pub mod user_overridable_dkim_registry;

#[cfg_attr(rustfmt, rustfmt::skip)]
pub mod email_auth;

pub use email_auth::*;
pub use user_overridable_dkim_registry::UserOverridableDKIMRegistry;
