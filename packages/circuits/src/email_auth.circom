
pragma circom 2.1.5;

include "circomlib/circuits/bitify.circom";
include "circomlib/circuits/comparators.circom";
include "circomlib/circuits/poseidon.circom";
include "@zk-email/circuits/email-verifier.circom";
include "@zk-email/circuits/helpers/extract.circom";
include "./utils/constants.circom";
include "./utils/account_salt.circom";
include "./utils/hash_sign.circom";
include "./utils/email_nullifier.circom";
include "./utils/bytes2ints.circom";
include "./utils/digit2int.circom";
include "./utils/hex2int.circom";
include "./regexes/invitation_code_with_prefix_regex.circom";
include "./regexes/invitation_code_regex.circom";
include "@zk-email/zk-regex-circom/circuits/common/from_addr_regex.circom";
include "@zk-email/zk-regex-circom/circuits/common/email_addr_regex.circom";
include "@zk-email/zk-regex-circom/circuits/common/email_domain_regex.circom";
include "@zk-email/zk-regex-circom/circuits/common/subject_all_regex.circom";
include "@zk-email/zk-regex-circom/circuits/common/timestamp_regex.circom";


// Verify email from user (sender) and extract subject, timestmap, recipient email (commitment), etc.
// * n - the number of bits in each chunk of the RSA public key (modulust)
// * k - the number of chunks in the RSA public key (n * k > 2048)
// * max_header_bytes - max number of bytes in the email header
// * max_subject_bytes - max number of bytes in the email subject
template EmailAuth(n, k, max_header_bytes, max_subject_bytes) {
    signal input padded_header[max_header_bytes]; // email data (only header part)
    signal input public_key[k]; // RSA public key (modulus), k parts of n bits each.
    signal input signature[k]; // RSA signature, k parts of n bits each.
    signal input padded_header_len; // length of in email data including the padding
    // signal input sender_relayer_rand; // Private randomness of the relayer
    signal input account_code;
    signal input from_addr_idx; // Index of the from email address (= sender email address) in the email header
    signal input subject_idx; // Index of the subject in the header
    signal input domain_idx; // Index of the domain name in the from email address
    signal input timestamp_idx; // Index of the timestamp in the header
    signal input code_idx; // index of the invitation code in the header


    var email_max_bytes = email_max_bytes_const();
    var subject_field_len = compute_ints_size(max_subject_bytes);
    var domain_len = domain_len_const();
    var domain_filed_len = compute_ints_size(domain_len);
    var k2_chunked_size = k >> 1;
    if(k % 2 == 1) {
        k2_chunked_size += 1;
    }
    var timestamp_len = timestamp_len_const();
    var code_len = invitation_code_len_const();


    signal output domain_name[domain_filed_len];
    signal output public_key_hash;
    signal output email_nullifier;
    signal output timestamp;
    signal output masked_subject[subject_field_len];
    signal output account_salt;
    signal output is_code_exist;
    
    // Verify Email Signature
    component email_verifier = EmailVerifier(max_header_bytes, 0, n, k, 1);
    email_verifier.in_padded <== padded_header;
    email_verifier.pubkey <== public_key;
    email_verifier.signature <== signature;
    email_verifier.in_len_padded_bytes <== padded_header_len;
    signal header_hash[256] <== email_verifier.sha;
    public_key_hash <== email_verifier.pubkey_hash;

    // FROM HEADER REGEX
    signal from_regex_out, from_regex_reveal[max_header_bytes];
    (from_regex_out, from_regex_reveal) <== FromAddrRegex(max_header_bytes)(padded_header);
    from_regex_out === 1;
    signal from_email_addr[email_max_bytes];
    from_email_addr <== VarShiftMaskedStr(max_header_bytes, email_max_bytes)(from_regex_reveal, from_addr_idx);

    // DOMAIN NAME HEADER REGEX
    signal domain_regex_out, domain_regex_reveal[email_max_bytes];
    (domain_regex_out, domain_regex_reveal) <== EmailDomainRegex(email_max_bytes)(from_email_addr);
    domain_regex_out === 1;
    signal domain_name_bytes[domain_len];
    domain_name_bytes <== VarShiftMaskedStr(email_max_bytes, domain_len)(domain_regex_reveal, domain_idx);
    domain_name <== Bytes2Ints(domain_len)(domain_name_bytes);
    
    signal sign_hash;
    signal sign_ints[k2_chunked_size];
    (sign_hash, sign_ints) <== HashSign(n,k)(signature);
    email_nullifier <== EmailNullifier()(sign_hash);


    // SUBJECT HEADER REGEX
    signal subject_regex_out, subject_regex_reveal[max_header_bytes];
    (subject_regex_out, subject_regex_reveal) <== SubjectAllRegex(max_header_bytes)(padded_header);
    subject_regex_out === 1;
    signal subject_all[max_subject_bytes];
    subject_all <== VarShiftMaskedStr(max_header_bytes, max_subject_bytes)(subject_regex_reveal, subject_idx);

    // Timestamp regex + convert to decimal format
    signal timestamp_regex_out, timestamp_regex_reveal[max_header_bytes];
    (timestamp_regex_out, timestamp_regex_reveal) <== TimestampRegex(max_header_bytes)(padded_header);
    // timestamp_regex_out === 1;
    signal timestamp_str[timestamp_len];
    timestamp_str <== VarShiftMaskedStr(max_header_bytes, timestamp_len)(timestamp_regex_reveal, timestamp_idx);
    signal raw_timestamp <== Digit2Int(timestamp_len)(timestamp_str);
    timestamp <== timestamp_regex_out * raw_timestamp;
    
    signal prefixed_code_regex_out, prefixed_code_regex_reveal[max_subject_bytes];
    (prefixed_code_regex_out, prefixed_code_regex_reveal) <== InvitationCodeWithPrefixRegex(max_subject_bytes)(subject_all);
    is_code_exist <== IsZero()(prefixed_code_regex_out-1);
    signal removed_code[max_subject_bytes];
    for(var i = 0; i < max_subject_bytes; i++) {
        removed_code[i] <== is_code_exist * prefixed_code_regex_reveal[i];
    }
    signal subject_email_addr_regex_out, subject_email_addr_regex_reveal[max_subject_bytes];
    (subject_email_addr_regex_out, subject_email_addr_regex_reveal) <== EmailAddrRegex(max_subject_bytes)(subject_all);
    signal is_subject_email_addr_exist <== IsZero()(subject_email_addr_regex_out-1);
    signal removed_subject_email_addr[max_subject_bytes];
    for(var i = 0; i < max_subject_bytes; i++) {
        removed_subject_email_addr[i] <== is_subject_email_addr_exist * subject_email_addr_regex_reveal[i];
    }
    signal masked_subject_bytes[max_subject_bytes];
    for(var i = 0; i < max_subject_bytes; i++) {
        masked_subject_bytes[i] <== subject_all[i] - removed_code[i] - removed_subject_email_addr[i];
    }
    masked_subject <== Bytes2Ints(max_subject_bytes)(masked_subject_bytes);

    // INVITATION CODE REGEX
    signal code_regex_out, code_regex_reveal[max_header_bytes];
    (code_regex_out, code_regex_reveal) <== InvitationCodeRegex(max_header_bytes)(padded_header);
    signal code_consistency <== IsZero()(is_code_exist * (1 - code_regex_out));
    code_consistency === 1;
    signal replaced_code_regex_reveal[max_header_bytes];
    for(var i=0; i<max_header_bytes; i++) {
        if(i==0) {
            replaced_code_regex_reveal[i] <== (code_regex_reveal[i] - 1) * is_code_exist + 1;
        } else {
            replaced_code_regex_reveal[i] <== code_regex_reveal[i] * is_code_exist;
        }
    }
    signal shifted_code_hex[code_len] <== VarShiftMaskedStr(max_header_bytes, code_len)(replaced_code_regex_reveal, code_idx);
    signal invitation_code_hex[code_len];
    for(var i=0; i<code_len; i++) {
        invitation_code_hex[i] <== is_code_exist * (shifted_code_hex[i] - 48) + 48;
    }
    signal embedded_account_code <== Hex2Field()(invitation_code_hex);
    is_code_exist * (embedded_account_code - account_code) === 0;

    // Account salt
    var num_email_addr_ints = compute_ints_size(email_max_bytes);
    signal from_addr_ints[num_email_addr_ints] <== Bytes2Ints(email_max_bytes)(from_email_addr);
    account_salt <== AccountSalt(num_email_addr_ints)(from_addr_ints, account_code);

}

// Args:
// * n = 121 is the number of bits in each chunk of the modulus (RSA parameter)
// * k = 17 is the number of chunks in the modulus (RSA parameter)
// * max_header_bytes = 1024 is the max number of bytes in the header
// * max_subject_bytes = 605 = 512 + 31*3 is the max number of bytes in the body after precomputed slice. The last 31*3 bytes can be used for the invitation code.
component main  = EmailAuth(121, 17, 1024, 605);
