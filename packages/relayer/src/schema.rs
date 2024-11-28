use ethers::types::{Address, U256};
use relayer_utils::AccountCode;
use serde::{Deserialize, Serialize};

#[derive(Deserialize, Serialize, Debug, Clone)]
#[serde(rename_all = "camelCase")]
pub struct EmailTxAuthSchema {
    pub dkim_contract_address: Address,
    pub account_code: AccountCode,
    pub code_exists_in_email: bool,
    pub command_template: String,
    pub command_params: Vec<String>,
    pub template_id: U256,
    pub email_address: String,
    pub subject: String,
    pub body: String,
    pub chain: String,
}
