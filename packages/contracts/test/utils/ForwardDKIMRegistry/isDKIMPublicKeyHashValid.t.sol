// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "./base.t.sol";
import "../../../src/utils/ForwardDKIMRegistry.sol";

contract ForwardDKIMRegistryTest_isDKIMPublicKeyHashValid is Test {
    ForwardDKIMRegistry forwardDKIMRegistry;
    MockDKIMRegistry mockDKIMRegistry;

    function setUp() public {
        mockDKIMRegistry = new MockDKIMRegistry();
        forwardDKIMRegistry = new ForwardDKIMRegistry();
        forwardDKIMRegistry.initialize(
            address(this),
            address(mockDKIMRegistry)
        );
    }

    function testIsDKIMPublicKeyHashValid_ValidHash() public {
        string memory domainName = "example.com";
        bytes32 validHash = keccak256(abi.encodePacked("validPublicKey"));

        mockDKIMRegistry.setValidHash(domainName, validHash);

        bool isValid = forwardDKIMRegistry.isDKIMPublicKeyHashValid(
            domainName,
            validHash
        );
        assertTrue(isValid, "The public key hash should be valid.");
    }

    function testIsDKIMPublicKeyHashValid_InvalidHash() public {
        string memory domainName = "example.com";
        bytes32 validHash = keccak256(abi.encodePacked("validPublicKey"));
        bytes32 invalidHash = keccak256(abi.encodePacked("invalidPublicKey"));

        mockDKIMRegistry.setValidHash(domainName, validHash);

        bool isValid = forwardDKIMRegistry.isDKIMPublicKeyHashValid(
            domainName,
            invalidHash
        );
        assertFalse(isValid, "The public key hash should be invalid.");
    }

    function testIsDKIMPublicKeyHashValid_NoHashSet() public {
        string memory domainName = "example.com";
        bytes32 someHash = keccak256(abi.encodePacked("somePublicKey"));

        bool isValid = forwardDKIMRegistry.isDKIMPublicKeyHashValid(
            domainName,
            someHash
        );
        assertFalse(
            isValid,
            "The public key hash should be invalid as no hash is set."
        );
    }
}
