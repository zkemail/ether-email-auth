/// This pattern includes encoded newline characters and matches a `div` element with a specific ID pattern.
pub const SHA_PRECOMPUTE_SELECTOR: &str = r#"(<(=\r\n)?d(=\r\n)?i(=\r\n)?v(=\r\n)? (=\r\n)?i(=\r\n)?d(=\r\n)?=3D(=\r\n)?\"(=\r\n)?[^\"]*(=\r\n)?z(=\r\n)?k(=\r\n)?e(=\r\n)?m(=\r\n)?a(=\r\n)?i(=\r\n)?l(=\r\n)?[^\"]*(=\r\n)?\"(=\r\n)?[^>]*(=\r\n)?>(=\r\n)?)(=\r\n)?([^<>\/]+)(<(=\r\n)?\/(=\r\n)?d(=\r\n)?i(=\r\n)?v(=\r\n)?>(=\r\n)?)"#;

/// Regex for capturing the request ID from an email body.
pub const REQUEST_ID_REGEX: &str = r"(Your request ID is )([0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12})";

/// The number of fields expected in a domain configuration.
pub const DOMAIN_FIELDS: usize = 9;

/// The number of fields expected in a command configuration.
pub const COMMAND_FIELDS: usize = 20;
