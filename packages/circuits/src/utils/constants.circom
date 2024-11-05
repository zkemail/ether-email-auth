pragma circom 2.1.6;

include "@zk-email/circuits/utils/constants.circom";


function email_max_bytes_const() {
    return EMAIL_ADDR_MAX_BYTES();
}

function domain_len_const() {
    return DOMAIN_MAX_BYTES();
}

function invitation_code_len_const() {
    return 64;
}

function field_pack_bits_const() {
    return 248;
}

function pack_bytes_const() {
    return MAX_BYTES_IN_FIELD();
}

function timestamp_len_const() {
    return 10;
}

