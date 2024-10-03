// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@zk-email/contracts/DKIMRegistry.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import { strings } from "solidity-stringutils/src/strings.sol";

/// @title JWT Registry
/// @notice TODO
/// @dev TODO
contract JwtRegistry is IDKIMRegistry, Ownable {

    using strings for *;

    DKIMRegistry public dkimRegistry;

    // Check if azp is registered
    mapping(string => bool) public whitelistedClients;

    constructor(address _owner) Ownable(_owner) {
        dkimRegistry = new DKIMRegistry(address(this));
    }

    /// @notice Checks if a public key hash is valid and not revoked for a given kis and iss.
    /// @param domainName The domain name contains kis, iss and azp fields.
    /// @param publicKeyHash The public key hash to validate.
    /// @return bool Returns true if the public key hash is valid and not revoked, false otherwise.
    function isDKIMPublicKeyHashValid(
        string memory domainName,
        bytes32 publicKeyHash
    ) public view returns (bool) {
        string[] memory parts = this.stringToArray(domainName);
        string memory kidAndIss = string(abi.encode(parts[0], "|", parts[1]));
        return dkimRegistry.isDKIMPublicKeyHashValid(kidAndIss, publicKeyHash) 
          && whitelistedClients[parts[2]];
    }

    /// @notice Sets a public key hash for a `kis|iss` string  after validating the provided signature.
    /// @param domainName The domain name contains kis, iss and azp fields.
    /// @param publicKeyHash The public key hash to set.
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
            isDKIMPublicKeyHashValid(domainName, publicKeyHash) == false,
            "publicKeyHash is already set"
        );
        require(
            dkimRegistry.revokedDKIMPublicKeyHashes(publicKeyHash) == false,
            "publicKeyHash is revoked"
        );

        dkimRegistry.setDKIMPublicKeyHash(kidAndIss, publicKeyHash);
        // Register azp
        whitelistedClients[parts[2]] = true;
    }

    /// @notice Revokes a public key hash for `kis|iss` string after validating the provided signature.
    /// @param domainName The domain name contains kis, iss and azp fields.
    /// @param publicKeyHash The public key hash to revoke.
    /// @dev This function requires that the public key hash is currently set and not already revoked.
    function revokeDKIMPublicKeyHash(
        string memory domainName,
        bytes32 publicKeyHash
    ) public {
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

        dkimRegistry.revokeDKIMPublicKeyHash(publicKeyHash);
        // Disable azp
        string[] memory parts = this.stringToArray(domainName);
        whitelistedClients[parts[2]] = false;
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
