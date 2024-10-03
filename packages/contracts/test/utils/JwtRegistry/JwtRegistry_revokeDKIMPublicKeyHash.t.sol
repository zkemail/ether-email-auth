// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {EmailAuth, EmailAuthMsg} from "../../../src/EmailAuth.sol";
import {RecoveryController} from "../../helpers/RecoveryController.sol";
import {StructHelper} from "../../helpers/StructHelper.sol";
import {SimpleWallet} from "../../helpers/SimpleWallet.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@zk-email/contracts/DKIMRegistry.sol";

contract JwtRegistryTest_revokeDKIMPublicKeyHash is StructHelper {
    constructor() {}

    function setUp() public override {
        super.setUp();
    }

    function testRevert_revokeDKIMPublicKeyHash_invalidDomainName() public {
        string memory domainName = "";
        vm.expectRevert(bytes("Invalid domain name"));
        jwtRegistry.revokeDKIMPublicKeyHash(domainName, publicKeyHash);
    }

    function testRevert_revokeDKIMPublicKeyHash_invalidPublicKeyHash() public {
        string memory domainName = "12345|https://example.com|client-id-12345";
        vm.expectRevert(bytes("Invalid public key hash"));
        jwtRegistry.revokeDKIMPublicKeyHash(domainName, bytes32(0));
    }

    function testRevert_revokeDKIMPublicKeyHash_publicKeyHashIsNotSet() public {
        string memory domainName = "54321|https://example.com|client-id-12345";
        vm.expectRevert(bytes("publicKeyHash is not set"));
        jwtRegistry.revokeDKIMPublicKeyHash(domainName, publicKeyHash);
    }

    function test_revokeDKIMPublicKeyHash() public {
        string memory domainName = "12345|https://example.com|client-id-12345";
        jwtRegistry.revokeDKIMPublicKeyHash(domainName, publicKeyHash);
        assertEq(jwtRegistry.whitelistedClients("client-id-12345"), false);
    }
}
