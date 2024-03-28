pub const DOMAINS_SIGN_REPLY_TO: &[&str] = &["gmail.com", "outlook.com", "yahoo.com", "icloud.com"];

pub const DOMAINS_DO_NOT_SIGN_REPLY_TO: &[&str] = &["hotmail.com"];

pub fn check_domain_sign_reply_to(email: &str) -> bool {
    if let Some(at_pos) = email.find('@') {
        let domain = &email[at_pos + 1..];
        if DOMAINS_SIGN_REPLY_TO.contains(&domain) {
            return true;
        } else if DOMAINS_DO_NOT_SIGN_REPLY_TO.contains(&domain) {
            return false;
        }
    }
    false
}

pub fn split_email_address(email: &str) -> Option<(&str, &str)> {
    let parts: Vec<&str> = email.split('@').collect();
    if parts.len() == 2 {
        Some((parts[0], parts[1]))
    } else {
        None
    }
}
