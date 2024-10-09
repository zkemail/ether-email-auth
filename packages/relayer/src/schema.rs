use std::collections::HashMap;

use ethers::{abi::Item, types::Address};
use relayer_utils::AccountCode;
use serde::Deserialize;

#[derive(Deserialize, Debug)]
#[serde(rename_all = "camelCase")]
pub struct EmailTxAuthSchema {
    pub contract_address: Address,
    pub email_auth_contract_address: Address,
    pub account_code: AccountCode,
    pub code_exists_in_email: bool,
    pub function_abi: Item,
    pub command_template: String,
    pub command_params: HashMap<String, String>,
    pub remaining_args: HashMap<String, String>,
    pub email_address: String,
    pub subject: String,
    pub body: String,
    pub chain: String,
}

#[derive(Deserialize, Debug)]
#[serde(rename_all = "camelCase")]
pub struct DKIMSchema {
    dkim_contract_address: Address,
    selector: String,
    domain: String,
    chain: String,
}
