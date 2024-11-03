// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@zk-email/contracts/DKIMRegistry.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

/// @title ECDSA Owned DKIM Registry
/// @notice This contract allows for the management of DKIM public key hashes through an ECDSA-signed mechanism. It enables the setting and revoking of DKIM public key hashes for domain names, ensuring that only the authorized signer can perform these operations. The contract leverages an underlying DKIMRegistry contract for the actual storage and validation of public key hashes.
/// @dev The contract uses OpenZeppelin's ECDSA library for signature recovery and the DKIMRegistry for storing the DKIM public key hashes.
contract ECDSAOwnedDKIMRegistry is
    IDKIMRegistry,
    OwnableUpgradeable,
    UUPSUpgradeable
{
    using Strings for *;
    using ECDSA for *;

    DKIMRegistry public dkimRegistry;
    address public signer;

    string public constant SET_PREFIX = "SET:";
    string public constant REVOKE_PREFIX = "REVOKE:";

    event SignerChanged(address indexed oldSigner, address indexed newOwner);

    constructor() {}

    /// @notice Initializes the contract with a predefined signer and deploys a new DKIMRegistry.
    /// @param _initialOwner The address of the initial owner of the contract.
    /// @param _signer The address of the authorized signer who can set or revoke DKIM public key hashes.
    function initialize(
        address _initialOwner,
        address _signer
    ) public initializer {
        __Ownable_init(_initialOwner);
        dkimRegistry = new DKIMRegistry(address(this));
        signer = _signer;
    }

    /// @notice Checks if a DKIM public key hash is valid and not revoked for a given domain name.
    /// @param domainName The domain name to check the DKIM public key hash for.
    /// @param publicKeyHash The DKIM public key hash to validate.
    /// @return bool Returns true if the public key hash is valid and not revoked, false otherwise.
    function isDKIMPublicKeyHashValid(
        string memory domainName,
        bytes32 publicKeyHash
    ) public view returns (bool) {
        return dkimRegistry.isDKIMPublicKeyHashValid(domainName, publicKeyHash);
    }

    /// @notice Sets a DKIM public key hash for a domain name after validating the provided signature.
    /// @param selector The selector associated with the DKIM public key.
    /// @param domainName The domain name to set the DKIM public key hash for.
    /// @param publicKeyHash The DKIM public key hash to set.
    /// @param signature The ECDSA signature proving the operation is authorized by the signer.
    /// @dev This function requires that the public key hash is not already set or revoked.
    function setDKIMPublicKeyHash(
        string memory selector,
        string memory domainName,
        bytes32 publicKeyHash,
        bytes memory signature
    ) public {
        require(bytes(selector).length != 0, "Invalid selector");
        require(bytes(domainName).length != 0, "Invalid domain name");
        require(publicKeyHash != bytes32(0), "Invalid public key hash");
        require(
            isDKIMPublicKeyHashValid(domainName, publicKeyHash) == false,
            "publicKeyHash is already set"
        );
        require(
            dkimRegistry.revokedDKIMPublicKeyHashes(publicKeyHash) == false,
            "publicKeyHash is revoked"
        );

        string memory signedMsg = computeSignedMsg(
            SET_PREFIX,
            domainName,
            publicKeyHash
        );
        bytes32 digest = MessageHashUtils.toEthSignedMessageHash(
            bytes(signedMsg)
        );
        address recoveredSigner = digest.recover(signature);
        require(recoveredSigner == signer, "Invalid signature");

        dkimRegistry.setDKIMPublicKeyHash(domainName, publicKeyHash);
    }

    /// @notice Revokes a DKIM public key hash for a domain name after validating the provided signature.
    /// @param selector The selector associated with the DKIM public key.
    /// @param domainName The domain name to revoke the DKIM public key hash for.
    /// @param publicKeyHash The DKIM public key hash to revoke.
    /// @param signature The ECDSA signature proving the operation is authorized by the signer.
    /// @dev This function requires that the public key hash is currently set and not already revoked.
    function revokeDKIMPublicKeyHash(
        string memory selector,
        string memory domainName,
        bytes32 publicKeyHash,
        bytes memory signature
    ) public {
        require(bytes(selector).length != 0, "Invalid selector");
        require(bytes(domainName).length != 0, "Invalid domain name");
        require(publicKeyHash != bytes32(0), "Invalid public key hash");
        require(
            isDKIMPublicKeyHashValid(domainName, publicKeyHash) == true,
            "publicKeyHash is not set"
        );
        require(
            dkimRegistry.revokedDKIMPublicKeyHashes(publicKeyHash) == false,
            "publicKeyHash is already revoked"
        );

        string memory signedMsg = computeSignedMsg(
            REVOKE_PREFIX,
            domainName,
            publicKeyHash
        );
        bytes32 digest = MessageHashUtils.toEthSignedMessageHash(
            bytes(signedMsg)
        );
        address recoveredSigner = digest.recover(signature);
        require(recoveredSigner == signer, "Invalid signature");

        dkimRegistry.revokeDKIMPublicKeyHash(publicKeyHash);
    }

    /// @notice Computes a signed message string for setting or revoking a DKIM public key hash.
    /// @param prefix The operation prefix (SET: or REVOKE:).
    /// @param domainName The domain name related to the operation.
    /// @param publicKeyHash The DKIM public key hash involved in the operation.
    /// @return string The computed signed message.
    /// @dev This function is used internally to generate the message that needs to be signed for setting or revoking a public key hash.
    function computeSignedMsg(
        string memory prefix,
        string memory domainName,
        bytes32 publicKeyHash
    ) public pure returns (string memory) {
        return
            string.concat(
                prefix,
                "domain=",
                domainName,
                ";public_key_hash=",
                uint256(publicKeyHash).toHexString(),
                ";"
            );
    }

    /// @notice Changes the signer address to a new address.
    /// @param _newSigner The address of the new signer.
    function changeSigner(address _newSigner) public onlyOwner {
        require(_newSigner != address(0), "Invalid signer");
        require(_newSigner != signer, "Same signer");
        address oldSigner = signer;
        signer = _newSigner;
        emit SignerChanged(oldSigner, _newSigner);
    }

    /// @notice Upgrade the implementation of the proxy.
    /// @param newImplementation Address of the new implementation.
    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}
}
