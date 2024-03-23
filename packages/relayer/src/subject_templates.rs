#![allow(clippy::upper_case_acronyms)]

use crate::*;

use ethers::abi::{self, Token};
use ethers::types::{Address, Bytes, I256, U256};
use regex::Regex;

#[derive(Debug, Clone)]
pub enum TemplateValue {
    String(String),
    Uint(U256),
    Int(I256),
    Decimals(String),
    EthAddr(Address),
    Fixed(String),
}

pub(crate) const STRING_RGEX: &str = ".+";
pub(crate) const UINT_REGEX: &str = "[0-9]+";
pub(crate) const INT_REGEX: &str = "-?[0-9]+";
pub(crate) const DECIMALS_REGEX: &str = "[0-9]+(\\.[0-9]+)?";
pub(crate) const ETH_ADDR_REGEX: &str = "0x[0-9a-fA-F]{40}";
// pub(crate) const EMAIL_ADDR_REGEX: &str =
//     "[a-zA-Z0-9!#$%&'\\*\\+-/=\\?^_`{\\|}~\\.]+@[a-zA-Z0-9]+\\.[a-zA-Z0-9\\.-]+";

impl TemplateValue {
    #[named]
    pub fn abi_encode(&self, decimal_size: Option<u8>) -> Result<Bytes> {
        match self {
            Self::String(string) => Ok(Bytes::from(abi::encode(&[Token::String(string.clone())]))),
            Self::Uint(uint) => Ok(Bytes::from(abi::encode(&[Token::Uint(*uint)]))),
            Self::Int(int) => Ok(Bytes::from(abi::encode(&[Token::Int(int.into_raw())]))),
            Self::Decimals(string) => Ok(Bytes::from(abi::encode(&[Token::Uint(
                Self::decimals_str_to_uint(&string, decimal_size),
            )]))),
            Self::EthAddr(address) => Ok(Bytes::from(abi::encode(&[Token::Address(*address)]))),
            Self::Fixed(string) => Err(anyhow!("Fixed value must not be passed to abi_encode")),
        }
    }

    pub fn decimals_str_to_uint(str: &str, decimal_size: u8) -> U256 {
        let decimal_size = decimal_size as usize;
        let dot = Regex::new("\\.").unwrap().find(str);
        let (before_dot_str, mut after_dot_str) = match dot {
            Some(dot_match) => (
                str[0..dot_match.start()].to_string(),
                str[dot_match.end()..].to_string(),
            ),
            None => (str.to_string(), "".to_string()),
        };
        assert!(after_dot_str.len() <= decimal_size);
        let num_leading_zeros = decimal_size - after_dot_str.len();
        after_dot_str.push_str(&"0".repeat(num_leading_zeros));
        U256::from_dec_str(&(before_dot_str + &after_dot_str))
            .expect("composed amount string is not valid decimal")
    }
}

pub fn extract_template_vals_and_idx(
    input: &str,
    templates_array: Vec<Vec<String>>,
) -> Result<(Option<usize>, Vec<TemplateValue>)> {
    for (idx, templates) in templates_array.into_iter().enumerate() {
        let template_vals = extract_template_vals(input, templates);
        match template_vals {
            Ok(vals) => {
                return Ok((Some(idx), vals));
            }
            Err(_) => {
                continue;
            }
        }
    }
    Ok((None, Vec::new()))
}

pub fn extract_template_vals(input: &str, templates: Vec<String>) -> Result<Vec<TemplateValue>> {
    let input_decomposed: Vec<&str> = input.split(' ').collect();
    let mut template_vals = Vec::new();
    let mut input_idx = 0;
    for template in templates.iter() {
        match template.as_str() {
            "{string}" => {
                let string_match = Regex::new(STRING_RGEX)
                    .unwrap()
                    .find(input_decomposed[input_idx])
                    .ok_or(anyhow!("No string found"))?;
                if string_match.start() != 0
                    || string_match.end() != input_decomposed[input_idx].len()
                {
                    return Err(anyhow!("String must be the whole word"));
                }
                let string = string_match.as_str().to_string();
                template_vals.push(TemplateValue::String(string));
                input_idx += 1;
            }
            "{uint}" => {
                let uint_match = Regex::new(UINT_REGEX)
                    .unwrap()
                    .find(input_decomposed[input_idx])
                    .ok_or(anyhow!("No uint found"))?;
                if uint_match.start() != 0 || uint_match.end() != input_decomposed[input_idx].len()
                {
                    return Err(anyhow!("Uint must be the whole word"));
                }
                let uint = U256::from_dec_str(uint_match.as_str()).unwrap();
                template_vals.push(TemplateValue::Uint(uint));
                input_idx += 1;
            }
            "{int}" => {
                let int_match = Regex::new(INT_REGEX)
                    .unwrap()
                    .find(input_decomposed[input_idx])
                    .ok_or(anyhow!("No int found"))?;
                if int_match.start() != 0 || int_match.end() != input_decomposed[input_idx].len() {
                    return Err(anyhow!("Int must be the whole word"));
                }
                let int_str = int_match.as_str();
                let int = I256::from_dec_str(int_match.as_str()).unwrap();
                template_vals.push(TemplateValue::Int(int));
                input_idx += 1;
            }
            "{decimals}" => {
                let decimals_match = Regex::new(DECIMALS_REGEX)
                    .unwrap()
                    .find(input_decomposed[input_idx])
                    .ok_or(anyhow!("No amount found"))?;
                if decimals_match.start() != 0
                    || decimals_match.end() != input_decomposed[input_idx].len()
                {
                    return Err(anyhow!("Amount must be the whole word"));
                }
                let decimals = decimals_match.as_str().to_string();
                template_vals.push(TemplateValue::Decimals(decimals));
                input_idx += 1;
            }
            "{ethAddr}" => {
                let address_match = Regex::new(ETH_ADDR_REGEX)
                    .unwrap()
                    .find(input_decomposed[input_idx])
                    .ok_or(anyhow!("No address found"))?;
                if address_match.start() != 0
                    || address_match.end() != input_decomposed[input_idx].len()
                {
                    return Err(anyhow!("Address must be the whole word"));
                }
                let address = address_match.as_str().parse::<Address>().unwrap();
                template_vals.push(TemplateValue::Address(address));
                input_idx += 1;
            }
            _ => {
                input_idx += 1;
            }
        }
    }
    if input_idx != input_decomposed.len() {
        return Err(anyhow!("Input is not fully consumed"));
    }
    Ok(template_vals)
}

// Generated by Github Copilot!
pub fn uint_to_decimal_string(uint: u128, decimal: usize) -> String {
    // Convert amount to string in wei format (no decimals)
    let uint_str = uint.to_string();
    let uint_length = uint_str.len();

    // Create result vector with max length
    // If less than 18 decimals, then 2 extra for "0.", otherwise one extra for "."
    let mut result = vec![
        '0';
        if uint_length > decimal {
            uint_length + 1
        } else {
            decimal + 2
        }
    ];
    let result_length = result.len();

    // Difference between result and amount array index when copying
    // If more than 18, then 1 index diff for ".", otherwise actual diff in length
    let mut delta = if uint_length > decimal {
        1
    } else {
        result_length - uint_length
    };

    // Boolean to indicate if we found a non-zero digit when scanning from last to first index
    let mut found_non_zero_decimal = false;

    let mut actual_result_len = 0;

    // In each iteration we fill one index of result array (starting from end)
    for i in (0..result_length).rev() {
        // Check if we have reached the index where we need to add decimal point
        if i == result_length - decimal - 1 {
            // No need to add "." if there was no value in decimal places
            if found_non_zero_decimal {
                result[i] = '.';
                actual_result_len += 1;
            }
            // Set delta to 0, as we have already added decimal point (only for amount_length > 18)
            delta = 0;
        }
        // If amountLength < 18 and we have copied everything, fill zeros
        else if uint_length <= decimal && i < result_length - uint_length {
            result[i] = '0';
            actual_result_len += 1;
        }
        // If non-zero decimal is found, or decimal point inserted (delta == 0), copy from amount array
        else if found_non_zero_decimal || delta == 0 {
            result[i] = uint_str.chars().nth(i - delta).unwrap();
            actual_result_len += 1;
        }
        // If we find non-zero decimal for the first time (trailing zeros are skipped)
        else if uint_str.chars().nth(i - delta).unwrap() != '0' {
            result[i] = amount_str.chars().nth(i - delta).unwrap();
            actual_result_len += 1;
            found_non_zero_decimal = true;
        }
    }

    // Create final result string with correct length
    let compact_result: String = result.into_iter().take(actual_result_len).collect();

    compact_result
}
