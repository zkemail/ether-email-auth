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

contract JwtRegistryTest_setDKIMPublicKeyHash is StructHelper {
    constructor() {}

    function setUp() public override {
        super.setUp();
    }

    function testRevert_setDKIMPublicKeyHash_publicKeyHashIsAlreadySet()
        public
    {
        string memory domainName = "12345|https://example.com|client-id-12345";
        vm.expectRevert(bytes("publicKeyHash is already set"));
        jwtRegistry.setDKIMPublicKeyHash(domainName, publicKeyHash);
    }

    function testRevert_setDKIMPublicKeyHash_publicKeyHashIsRevoked() public {
        string memory domainName = "12345|https://example.com|client-id-12345";
        jwtRegistry.revokeDKIMPublicKeyHash(domainName, publicKeyHash);
        vm.expectRevert(bytes("publicKeyHash is revoked"));
        jwtRegistry.setDKIMPublicKeyHash(domainName, publicKeyHash);
    }

    function test_setDKIMPublicKeyHash() public {
        string memory domainName = "12345|https://example.xyz|client-id-12345";
        jwtRegistry.setDKIMPublicKeyHash(domainName, publicKeyHash);
        assertEq(jwtRegistry.whitelistedClients("client-id-12345"), true);
    }
}
