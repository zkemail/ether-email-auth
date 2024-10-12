// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

struct EmailProof {
    string domainName; // Domain name of the sender's email
    bytes32 publicKeyHash; // Hash of the DKIM public key used in email/proof
    uint timestamp; // Timestamp of the email
    string maskedCommand; // Masked command of the email
    bytes32 emailNullifier; // Nullifier of the email to prevent its reuse.
    bytes32 accountSalt; // Create2 salt of the account
    bool isCodeExist; // Check if the account code is exist
    bytes proof; // ZK Proof of Email
}

interface IVerifier {

    /**
     * @notice Verifies the provided email proof.
     * @param proof The email proof to be verified.
     * @return bool indicating whether the proof is valid.
     */    
    function verifyEmailProof(
        EmailProof memory proof
    ) external view returns (bool);

    /**
     * @notice Returns a constant value representing command bytes.
     * @return uint256 The constant value of command bytes.
     */
    function getCommandBytes() external pure returns (uint256);
}
