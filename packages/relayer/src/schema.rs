use std::collections::HashMap;

use ethers::{
    abi::{Abi, Function, Token},
    types::Address,
};
use relayer_utils::AccountCode;
use serde::{Deserialize, Serialize};

#[derive(Deserialize, Serialize, Debug, Clone)]
#[serde(rename_all = "camelCase")]
pub struct EmailTxAuthSchema {
    pub contract_address: Address,
    pub email_auth_contract_address: Address,
    pub account_code: AccountCode,
    pub code_exists_in_email: bool,
    pub function_abi: Function,
    pub command_template: String,
    pub command_params: Vec<String>,
    pub template_id: usize,
    pub remaining_args: Vec<Token>,
    pub email_address: String,
    pub subject: String,
    pub body: String,
    pub chain: String,
}

#[derive(Deserialize, Debug, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct DKIMSchema {
    dkim_contract_address: Address,
    selector: String,
    domain: String,
    chain: String,
}
