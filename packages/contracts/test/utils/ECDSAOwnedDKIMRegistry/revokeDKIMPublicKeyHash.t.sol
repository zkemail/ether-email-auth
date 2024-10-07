// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "../../../src/utils/ECDSAOwnedDKIMRegistry.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract ECDSAOwnedDKIMRegistryTest_setDKIMPublicKeyHash is Test {
    ECDSAOwnedDKIMRegistry dkim;
    using console for *;
    using ECDSA for *;
    using Strings for *;

    string public selector = "12345";
    string public domainName = "example.com";
    // uint public signValidityDuration = 1 days;
    bytes32 public publicKeyHash = bytes32(uint256(1));

    function setUp() public {
        address signer = vm.addr(1);
        {
            ECDSAOwnedDKIMRegistry dkimImpl = new ECDSAOwnedDKIMRegistry();
            ERC1967Proxy dkimProxy = new ERC1967Proxy(
                address(dkimImpl),
                abi.encodeCall(dkimImpl.initialize, (msg.sender, signer))
            );
            dkim = ECDSAOwnedDKIMRegistry(address(dkimProxy));
        }
    }

    function test_Revert_IfPublicKeyHashNotSet() public {
        // Attempt to revoke a public key hash that hasn't been set
        string memory revokeMsg = dkim.computeSignedMsg(
            dkim.REVOKE_PREFIX(),
            selector,
            domainName,
            publicKeyHash
        );
        bytes32 digest = MessageHashUtils.toEthSignedMessageHash(bytes(revokeMsg));
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(1, digest);
        bytes memory signature = abi.encodePacked(r, s, v);

        vm.expectRevert("publicKeyHash is not set");
        dkim.revokeDKIMPublicKeyHash(selector, domainName, publicKeyHash, signature);
    }

    function test_Revert_IfSignatureIsInvalid() public {
        // Set a valid public key hash first
        string memory signedMsg = dkim.computeSignedMsg(
            dkim.SET_PREFIX(),
            selector,
            domainName,
            publicKeyHash
        );
        bytes32 digest = MessageHashUtils.toEthSignedMessageHash(bytes(signedMsg));
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(1, digest);
        bytes memory signature = abi.encodePacked(r, s, v);
        dkim.setDKIMPublicKeyHash(selector, domainName, publicKeyHash, signature);

        // Attempt to revoke with an invalid signature
        bytes memory invalidSignature = abi.encodePacked(r, s, v + 1); // Alter the signature
        vm.expectRevert(ECDSA.ECDSAInvalidSignature.selector);
        dkim.revokeDKIMPublicKeyHash(selector, domainName, publicKeyHash, invalidSignature);
    }
    function testRevert_IfDomainNameIsDifferent() public {
        // Set a valid public key hash first
        string memory signedMsg = dkim.computeSignedMsg(
            dkim.SET_PREFIX(),
            selector,
            domainName,
            publicKeyHash
        );
        bytes32 digest = MessageHashUtils.toEthSignedMessageHash(bytes(signedMsg));
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(1, digest);
        bytes memory signature = abi.encodePacked(r, s, v);
        dkim.setDKIMPublicKeyHash(selector, domainName, publicKeyHash, signature);

        // Attempt to revoke with a different domain name
        string memory differentDomainName = "different.com";
        string memory revokeMsg = dkim.computeSignedMsg(
            dkim.REVOKE_PREFIX(),
            selector,
            differentDomainName,
            publicKeyHash
        );
        bytes32 revokeDigest = MessageHashUtils.toEthSignedMessageHash(bytes(revokeMsg));
        (uint8 v1, bytes32 r1, bytes32 s1) = vm.sign(1, revokeDigest);
        bytes memory revokeSig = abi.encodePacked(r1, s1, v1);

        vm.expectRevert("publicKeyHash is not set");
        dkim.revokeDKIMPublicKeyHash(selector, differentDomainName, publicKeyHash, revokeSig);
    }

    function testRevert_IfSelectorIsDifferent() public {
        // Set a valid public key hash first
        string memory signedMsg = dkim.computeSignedMsg(
            dkim.SET_PREFIX(),
            selector,
            domainName,
            publicKeyHash
        );
        bytes32 digest = MessageHashUtils.toEthSignedMessageHash(bytes(signedMsg));
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(1, digest);
        bytes memory signature = abi.encodePacked(r, s, v);
        dkim.setDKIMPublicKeyHash(selector, domainName, publicKeyHash, signature);

        // Attempt to revoke with a different selector
        string memory differentSelector = "54321";
        string memory revokeMsg = dkim.computeSignedMsg(
            dkim.REVOKE_PREFIX(),
            selector,
            domainName,
            publicKeyHash
        );
        bytes32 revokeDigest = MessageHashUtils.toEthSignedMessageHash(bytes(revokeMsg));
        (uint8 v1, bytes32 r1, bytes32 s1) = vm.sign(1, revokeDigest);
        bytes memory revokeSig = abi.encodePacked(r1, s1, v1);

        vm.expectRevert("Invalid signature");
        dkim.revokeDKIMPublicKeyHash(differentSelector, domainName, publicKeyHash, revokeSig);
    }

    function test_RevokeDKIMPublicKeyHash() public {
        // vm.chainId(1);
        string memory signedMsg = dkim.computeSignedMsg(
            dkim.SET_PREFIX(),
            selector,
            domainName,
            publicKeyHash
        );
        bytes32 digest = MessageHashUtils.toEthSignedMessageHash(
            bytes(signedMsg)
        );
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(1, digest);
        bytes memory signature = abi.encodePacked(r, s, v);
        dkim.setDKIMPublicKeyHash(
            selector,
            domainName,
            publicKeyHash,
            signature
        );

        // Revoke
        string memory revokeMsg = dkim.computeSignedMsg(
            dkim.REVOKE_PREFIX(),
            selector,
            domainName,
            publicKeyHash
        );
        (uint8 v1, bytes32 r1, bytes32 s1) = vm.sign(
            1,
            MessageHashUtils.toEthSignedMessageHash(bytes(revokeMsg))
        );
        bytes memory revokeSig = abi.encodePacked(r1, s1, v1);
        dkim.revokeDKIMPublicKeyHash(
            selector,
            domainName,
            publicKeyHash,
            revokeSig
        );

        require(!dkim.isDKIMPublicKeyHashValid(domainName, publicKeyHash));
    }

}