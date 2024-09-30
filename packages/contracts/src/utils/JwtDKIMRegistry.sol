// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@zk-email/contracts/DKIMRegistry.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import { strings } from "solidity-stringutils/src/strings.sol";

/// @title JWT DKIM Registry
/// @notice This contract manages the registration, validation, and revocation of DKIM public key hashes for domain names.
/// @dev This contract uses the DKIMRegistry for underlying DKIM operations and extends it with additional functionality.
contract JwtDKIMRegistry is IDKIMRegistry, Ownable {

    using strings for *;

    DKIMRegistry public dkimRegistry;

    constructor(address _owner) Ownable(_owner) {
        dkimRegistry = new DKIMRegistry(address(this));
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
    /// @param domainName The domain name to set the DKIM public key hash for.
    /// @param publicKeyHash The DKIM public key hash to set.
    /// @dev This function requires that the public key hash is not already set or revoked.
    function setDKIMPublicKeyHash(
        string memory domainName,
        bytes32 publicKeyHash
    ) public {
        require(bytes(domainName).length != 0, "Invalid domain name");
        require(publicKeyHash != bytes32(0), "Invalid public key hash");
        string[] memory parts = this.stringToArray(domainName);
        string memory kidAndIss = string(abi.encode(parts[0], "|", parts[1]));
        require(
            isDKIMPublicKeyHashValid(kidAndIss, publicKeyHash) == false,
            "publicKeyHash is already set"
        );
        require(
            dkimRegistry.revokedDKIMPublicKeyHashes(publicKeyHash) == false,
            "publicKeyHash is revoked"
        );

        dkimRegistry.setDKIMPublicKeyHash(kidAndIss, publicKeyHash);
    }

    /// @notice Revokes a DKIM public key hash for a domain name after validating the provided signature.
    /// @param domainName The domain name to revoke the DKIM public key hash for.
    /// @param publicKeyHash The DKIM public key hash to revoke.
    /// @dev This function requires that the public key hash is currently set and not already revoked.
    function revokeDKIMPublicKeyHash(
        string memory domainName,
        bytes32 publicKeyHash
    ) public {
        require(bytes(domainName).length != 0, "Invalid domain name");
        require(publicKeyHash != bytes32(0), "Invalid public key hash");
        string[] memory parts = this.stringToArray(domainName);
        string memory kidAndIss = string(abi.encode(parts[0], "|", parts[1]));
        require(
            isDKIMPublicKeyHashValid(kidAndIss, publicKeyHash) == true,
            "publicKeyHash is not set"
        );
        require(
            dkimRegistry.revokedDKIMPublicKeyHashes(publicKeyHash) == false,
            "publicKeyHash is already revoked"
        );

        dkimRegistry.revokeDKIMPublicKeyHash(publicKeyHash);
    }

    function stringToArray(string memory _strings) external pure returns (string[] memory) {
        strings.slice memory slicee = _strings.toSlice();
        strings.slice memory delim = "|".toSlice();
        string[] memory parts = new string[](slicee.count(delim) + 1);
        for (uint i = 0; i < parts.length; i++) {
            parts[i] = slicee.split(delim).toString();
        }
        require(parts.length == 3, "Invalid kid|iss|azp strings");
        return parts;
    }
}
