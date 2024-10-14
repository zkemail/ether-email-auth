// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {EmailAuth, EmailAuthMsg} from "../../src/EmailAuth.sol";
import {RecoveryControllerZKSync} from "../helpers/RecoveryControllerZKSync.sol";
import {StructHelper} from "../helpers/StructHelper.sol";
import {SimpleWallet} from "../helpers/SimpleWallet.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract EmailAccountRecoveryZKSyncTest_acceptanceCommandTemplates is
    StructHelper
{
    constructor() {}

    function setUp() public override {
        super.setUp();
    }

    function testAcceptanceCommandTemplates() public {
        skipIfNotZkSync();

        setUp();
        string[][] memory res = recoveryController.acceptanceCommandTemplates();
        assertEq(res[0][0], "Accept");
        assertEq(res[0][1], "guardian");
        assertEq(res[0][2], "request");
        assertEq(res[0][3], "for");
        assertEq(res[0][4], "{ethAddr}");
    }
}
