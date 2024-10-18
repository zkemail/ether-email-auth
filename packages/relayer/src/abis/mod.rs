#![allow(clippy::all)]


#[cfg_attr(rustfmt, rustfmt::skip)]
pub mod ecdsa_owned_dkim_registry;

#[cfg_attr(rustfmt, rustfmt::skip)]
pub mod email_auth;

pub use ecdsa_owned_dkim_registry::ECDSAOwnedDKIMRegistry;
pub use email_auth::*;
