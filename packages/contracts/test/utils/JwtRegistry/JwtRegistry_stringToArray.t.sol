// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {EmailAuth, EmailAuthMsg} from "../../../src/EmailAuth.sol";
import {RecoveryController} from "../../helpers/RecoveryController.sol";
import {StructHelper} from "../../helpers/StructHelper.sol";
import {SimpleWallet} from "../../helpers/SimpleWallet.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract JwtRegistryTest_stringToArray is StructHelper {
    constructor() {}

    function setUp() public override {
        super.setUp();
    }

    function test_stringToArray() public {
        string[] memory points = jwtRegistry.stringToArray("12345|https://example.com|client-id-12345");
        assertEq(points[0], "12345");
        assertEq(points[1], "https://example.com");
        assertEq(points[2], "client-id-12345");
    }
}