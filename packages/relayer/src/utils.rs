use std::collections::HashMap;

pub fn parse_command_template(template: &str, params: &HashMap<String, String>) -> String {
    let mut parsed_string = template.to_string();

    for (key, value) in params {
        let placeholder = format!("${{{}}}", key);
        parsed_string = parsed_string.replace(&placeholder, value);
    }

    parsed_string
}
