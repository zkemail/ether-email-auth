pragma circom 2.1.6;

include "circomlib/circuits/bitify.circom";
include "circomlib/circuits/comparators.circom";
include "circomlib/circuits/poseidon.circom";
include "@zk-email/circuits/email-verifier.circom";
include "@zk-email/circuits/utils/regex.circom";
include "@zk-email/circuits/utils/functions.circom";
include "./utils/constants.circom";
include "./utils/account_salt.circom";
include "./utils/hash_sign.circom";
include "./utils/email_nullifier.circom";
include "./utils/bytes2ints.circom";
include "./utils/digit2int.circom";
include "./utils/hex2int.circom";
include "./utils/email_addr_commit.circom";
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
// * recipient_enabled - whether the email address commitment of the recipient = email address in the subject is exposed
template EmailAuth(n, k, max_header_bytes, max_subject_bytes, recipient_enabled) {
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
    email_verifier.emailHeader <== padded_header;
    email_verifier.pubkey <== public_key;
    email_verifier.signature <== signature;
    email_verifier.emailHeaderLength <== padded_header_len;
    signal header_hash[256] <== email_verifier.sha;
    public_key_hash <== email_verifier.pubkeyHash;

    // FROM HEADER REGEX
    signal from_regex_out, from_regex_reveal[max_header_bytes];
    (from_regex_out, from_regex_reveal) <== FromAddrRegex(max_header_bytes)(padded_header);
    from_regex_out === 1;
    signal is_valid_from_addr_idx <== LessThan(log2Ceil(max_header_bytes + email_max_bytes - 1))([from_addr_idx, max_header_bytes]);
    is_valid_from_addr_idx === 1;
    signal from_email_addr[email_max_bytes];
    from_email_addr <== SelectRegexReveal(max_header_bytes, email_max_bytes)(from_regex_reveal, from_addr_idx);

    // DOMAIN NAME HEADER REGEX
    signal domain_regex_out, domain_regex_reveal[email_max_bytes];
    (domain_regex_out, domain_regex_reveal) <== EmailDomainRegex(email_max_bytes)(from_email_addr);
    domain_regex_out === 1;
    signal is_valid_domain_idx <== LessThan(log2Ceil(email_max_bytes + domain_len - 1))([domain_idx, email_max_bytes]);
    is_valid_domain_idx === 1;
    signal domain_name_bytes[domain_len];
    domain_name_bytes <== SelectRegexReveal(email_max_bytes, domain_len)(domain_regex_reveal, domain_idx);
    domain_name <== Bytes2Ints(domain_len)(domain_name_bytes);
    
    /// EMAIL NULLIFIER
    signal sign_hash;
    signal sign_ints[k2_chunked_size];
    (sign_hash, sign_ints) <== HashSign(n,k)(signature);
    email_nullifier <== EmailNullifier()(sign_hash);


    // SUBJECT HEADER REGEX
    signal subject_regex_out, subject_regex_reveal[max_header_bytes];
    (subject_regex_out, subject_regex_reveal) <== SubjectAllRegex(max_header_bytes)(padded_header);
    subject_regex_out === 1;
    signal is_valid_subject_idx <== LessThan(log2Ceil(max_header_bytes + max_subject_bytes - 1))([subject_idx, max_header_bytes]);
    is_valid_subject_idx === 1;
    signal subject_all[max_subject_bytes];
    subject_all <== SelectRegexReveal(max_header_bytes, max_subject_bytes)(subject_regex_reveal, subject_idx);

    // Timestamp regex + convert to decimal format
    signal timestamp_regex_out, timestamp_regex_reveal[max_header_bytes];
    (timestamp_regex_out, timestamp_regex_reveal) <== TimestampRegex(max_header_bytes)(padded_header);
    signal is_valid_timestamp_idx <== LessThan(log2Ceil(max_header_bytes + timestamp_len - 1))([timestamp_idx, max_header_bytes]);
    is_valid_timestamp_idx === 1;
    signal timestamp_str[timestamp_len];
    timestamp_str <== SelectRegexReveal(max_header_bytes, timestamp_len)(timestamp_regex_reveal, timestamp_idx);
    signal raw_timestamp <== Digit2Int(timestamp_len)(timestamp_str);
    timestamp <== timestamp_regex_out * raw_timestamp;
    
    /// MASKED SUBJECT
    /// INVITATION CODE WITH PREFIX REGEX
    signal prefixed_code_regex_out, prefixed_code_regex_reveal[max_subject_bytes];
    (prefixed_code_regex_out, prefixed_code_regex_reveal) <== InvitationCodeWithPrefixRegex(max_subject_bytes)(subject_all);
    is_code_exist <== IsZero()(prefixed_code_regex_out-1);
    signal removed_code[max_subject_bytes];
    for(var i = 0; i < max_subject_bytes; i++) {
        removed_code[i] <== is_code_exist * prefixed_code_regex_reveal[i];
    }
    /// EMAIL ADDRESS REGEX
    /// Note: the email address in the subject should not overlap with the invitation code
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
    is_code_exist * (1 - code_regex_out) === 0;
    signal replaced_code_regex_reveal[max_header_bytes];
    for(var i=0; i<max_header_bytes; i++) {
        if(i==0) {
            replaced_code_regex_reveal[i] <== (code_regex_reveal[i] - 1) * is_code_exist + 1;
        } else {
            replaced_code_regex_reveal[i] <== code_regex_reveal[i] * is_code_exist;
        }
    }
    signal is_valid_code_idx <== LessThan(log2Ceil(max_header_bytes + code_len - 1))([code_idx, max_header_bytes]);
    is_valid_code_idx === 1;
    signal shifted_code_hex[code_len] <== SelectRegexReveal(max_header_bytes, code_len)(replaced_code_regex_reveal, code_idx);
    signal invitation_code_hex[code_len];
    for(var i=0; i<code_len; i++) {
        invitation_code_hex[i] <== is_code_exist * (shifted_code_hex[i] - 48) + 48;
    }
    signal embedded_account_code <== Hex2Field()(invitation_code_hex);
    is_code_exist * (embedded_account_code - account_code) === 0;

    // ACCOUNT SALT
    var num_email_addr_ints = compute_ints_size(email_max_bytes);
    signal from_addr_ints[num_email_addr_ints] <== Bytes2Ints(email_max_bytes)(from_email_addr);
    account_salt <== AccountSalt(num_email_addr_ints)(from_addr_ints, account_code);

    if(recipient_enabled==1) {
        signal input subject_email_addr_idx;
        signal output has_email_recipient;
        signal output recipient_email_addr_commit;
        has_email_recipient <== is_subject_email_addr_exist;
        
        // EMAIL ADDRESS COMMITMENT
        signal cm_rand_input[k2_chunked_size+1];
        for(var i=0; i<k2_chunked_size;i++){
            cm_rand_input[i] <== sign_ints[i];
        }
        cm_rand_input[k2_chunked_size] <== 1;
        signal cm_rand <== Poseidon(k2_chunked_size+1)(cm_rand_input);
        signal replaced_email_addr_regex_reveal[max_subject_bytes];
        for(var i=0; i<max_subject_bytes; i++) {
            if(i==0) {
                replaced_email_addr_regex_reveal[i] <== (subject_email_addr_regex_reveal[i] - 1) * has_email_recipient + 1;
            } else {
                replaced_email_addr_regex_reveal[i] <== subject_email_addr_regex_reveal[i] * has_email_recipient;
            }
        }
        signal is_valid_subject_email_addr_idx <== LessThan(log2Ceil(max_subject_bytes + email_max_bytes - 1))([subject_email_addr_idx, max_subject_bytes]);
        is_valid_subject_email_addr_idx === 1;
        signal shifted_email_addr[email_max_bytes];
        shifted_email_addr <== SelectRegexReveal(max_subject_bytes, email_max_bytes)(replaced_email_addr_regex_reveal, subject_email_addr_idx);
        signal recipient_email_addr[email_max_bytes];
        for(var i=0; i<email_max_bytes; i++) {
            recipient_email_addr[i] <== shifted_email_addr[i] * has_email_recipient;
        }
    
        signal recipient_email_addr_ints[num_email_addr_ints] <== Bytes2Ints(email_max_bytes)(recipient_email_addr);
        signal recipient_email_addr_commit_raw;
        recipient_email_addr_commit_raw <== EmailAddrCommit(num_email_addr_ints)(cm_rand, recipient_email_addr_ints);
        recipient_email_addr_commit <== has_email_recipient * recipient_email_addr_commit_raw;
    }
}