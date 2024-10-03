// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {EmailAuth, EmailAuthMsg} from "../../../src/EmailAuth.sol";
import {RecoveryController} from "../../helpers/RecoveryController.sol";
import {StructHelper} from "../../helpers/StructHelper.sol";
import {SimpleWallet} from "../../helpers/SimpleWallet.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract JwtRegistryTest_isDKIMPublicKeyHashValid is StructHelper {
    constructor() {}

    function setUp() public override {
        super.setUp();
    }

    function testFail_isDKIMPublicKeyHashValid_invalidKid() public {
        string memory domainName = "54321|https://example.com|client-id-12345";
        bool res = jwtRegistry.isDKIMPublicKeyHashValid(
            domainName,
            publicKeyHash
        );
        assertEq(res, true);
    }

    function testFail_isDKIMPublicKeyHashValid_invalidIss() public {
        string memory domainName = "12345|https://example.xyz|client-id-12345";
        bool res = jwtRegistry.isDKIMPublicKeyHashValid(
            domainName,
            publicKeyHash
        );
        assertEq(res, true);
    }

    function testFail_isDKIMPublicKeyHashValid_invalidAzp() public {
        string memory domainName = "12345|https://example.com|client-id-54321";
        bool res = jwtRegistry.isDKIMPublicKeyHashValid(
            domainName,
            publicKeyHash
        );
        assertEq(res, true);
    }

    function test_isDKIMPublicKeyHashValid() public {
        string memory domainName = "12345|https://example.com|client-id-12345";
        bool res = jwtRegistry.isDKIMPublicKeyHashValid(
            domainName,
            publicKeyHash
        );
        assertEq(res, true);
    }
}
