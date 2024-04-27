pragma circom 2.1.6;

include "circomlib/circuits/poseidon.circom";

template EmailNullifier() {
    // signal input header_hash[256];
    signal input sign_hash;

    signal output email_nullifier;

    email_nullifier <== Poseidon(1)([sign_hash]);
}



