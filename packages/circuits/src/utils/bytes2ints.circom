pragma circom 2.1.6;

include "circomlib/circuits/bitify.circom";
include "circomlib/circuits/comparators.circom";
include "circomlib/circuits/poseidon.circom";
include "./constants.circom";
include "@zk-email/circuits/utils/bytes.circom";

function compute_ints_size(bytes_size) {
    return computeIntChunkLength(bytes_size);
}

template Bytes2Ints(bytes_size) {
    var num_chunk = compute_ints_size(bytes_size);
    signal input bytes[bytes_size];
    signal output ints[num_chunk];

    ints <== PackBytes(bytes_size)(bytes);
}
