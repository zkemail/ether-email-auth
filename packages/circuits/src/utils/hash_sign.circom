pragma circom 2.1.6;

include "circomlib/circuits/poseidon.circom";

template HashSign(n,k) {
    signal input signature[k];

    signal output sign_hash;    

    var k2_chunked_size = k >> 1;
    if(k % 2 == 1) {
        k2_chunked_size += 1;
    }
    signal output sign_ints[k2_chunked_size];

    for(var i = 0; i < k2_chunked_size; i++) {
        if(i==k2_chunked_size-1 && k % 2 == 1) {
            sign_ints[i] <== signature[2*i];
        } else {
            sign_ints[i] <== signature[2*i] + (1<<n) * signature[2*i+1];
        }
    }
    sign_hash <== Poseidon(k2_chunked_size)(sign_ints);
}



