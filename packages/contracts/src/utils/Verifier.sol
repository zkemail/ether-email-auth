// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./Groth16Verifier.sol";

struct EmailProof {
    string domainName; // Domain name of the sender's email
    bytes32 publicKeyHash; // Hash of the DKIM public key used in email/proof
    uint timestamp; // Timestamp of the email
    string maskedSubject; // Masked subject of the email
    bytes32 emailNullifier; // Nullifier of email to prevent re-run
    bytes32 accountSalt; // Salt of the account
    bool isCodeExist; // Check if the code is exist
    bytes proof; // ZK Proof of Email
}

contract Verifier {

    Groth16Verifier groth16Verifier;

    uint256 public constant DOMAIN_FIELDS = 9;
    uint256 public constant DOMAIN_BYTES = 255;
    uint256 public constant SUBJECT_FIELDS = 20;
    uint256 public constant SUBJECT_BYTES = 605;
    
    function verifyEmailProof(EmailProof memory proof) public view returns (bool) {        
        (uint256[2] memory pA, uint256[2][2] memory pB, uint256[2] memory pC) = abi.decode(
            proof.proof,
            (uint256[2], uint256[2][2], uint256[2])
        );

        uint256[DOMAIN_FIELDS + SUBJECT_FIELDS + 5] memory pubSignals;
        uint256[] memory stringFields;
        stringFields = _packBytes2Fields(bytes(proof.domainName), DOMAIN_BYTES);
        for (uint256 i = 0; i < DOMAIN_FIELDS; i++) {
            pubSignals[i] = stringFields[i];
        }
        pubSignals[DOMAIN_FIELDS] = uint256(proof.publicKeyHash);
        pubSignals[DOMAIN_FIELDS + 1] = uint256(proof.emailNullifier);
        pubSignals[DOMAIN_FIELDS + 2] = uint256(proof.timestamp);
        stringFields = _packBytes2Fields(bytes(proof.maskedSubject), SUBJECT_BYTES);
        for (uint256 i = 0; i < SUBJECT_FIELDS; i++) {
            pubSignals[DOMAIN_FIELDS + 3 + i] = stringFields[i];
        }
        pubSignals[DOMAIN_FIELDS + 3 + SUBJECT_FIELDS] = uint256(proof.accountSalt);
        pubSignals[DOMAIN_FIELDS + 3 + SUBJECT_FIELDS + 1] = proof.isCodeExist ? 1 : 0;
        
        return groth16Verifier.verifyProof(pA, pB, pC, pubSignals);
    }
    
    function _packBytes2Fields(bytes memory _bytes, uint256 _paddedSize) public pure returns (uint256[] memory) {
        uint256 remain = _paddedSize % 31;
        uint256 numFields = (_paddedSize - remain) / 31;
        if (remain > 0) {
            numFields += 1;
        }
        uint256[] memory fields = new uint[](numFields);
        uint256 idx = 0;
        uint256 byteVal = 0;
        for (uint256 i = 0; i < numFields; i++) {
            for (uint256 j = 0; j < 31; j++) {
                idx = i * 31 + j;
                if (idx >= _paddedSize) {
                    break;
                }
                if (idx >= _bytes.length) {
                    byteVal = 0;
                } else {
                    byteVal = uint256(uint8(_bytes[idx]));
                }
                if (j == 0) {
                    fields[i] = byteVal;
                } else {
                    fields[i] += (byteVal << (8 * j));
                }
            }
        }
        return fields;
    }

}

