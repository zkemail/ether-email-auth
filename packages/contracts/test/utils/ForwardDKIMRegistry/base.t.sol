// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@zk-email/contracts/DKIMRegistry.sol";

contract MockDKIMRegistry is IDKIMRegistry {
    mapping(string => bytes32) public validHashes;

    function setValidHash(
        string memory domainName,
        bytes32 publicKeyHash
    ) public {
        validHashes[domainName] = publicKeyHash;
    }

    function isDKIMPublicKeyHashValid(
        string memory domainName,
        bytes32 publicKeyHash
    ) public view override returns (bool) {
        return validHashes[domainName] == publicKeyHash;
    }
}
