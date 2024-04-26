pragma circom 2.1.6;

include "circomlib/circuits/bitify.circom";
include "circomlib/circuits/comparators.circom";
include "circomlib/circuits/poseidon.circom";
include "./constants.circom";


// `in` is a big-endtian digit string of `out`.
template Digit2Int(n) {
    signal input in[n];
    signal output out;

    out <== DigitBytesToInt(n)(in);
}

