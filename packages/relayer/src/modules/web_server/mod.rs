//! This module contains the axum web server and its routes and custom errors.

pub mod relayer_errors;
pub mod rest_api;
pub mod server;

pub use relayer_errors::*;
pub use rest_api::*;
pub use server::*;
