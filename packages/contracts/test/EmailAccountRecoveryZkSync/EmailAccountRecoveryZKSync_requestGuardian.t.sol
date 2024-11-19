// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {EmailAuth, EmailAuthMsg} from "../../src/EmailAuth.sol";
import {RecoveryControllerZKSync} from "../helpers/RecoveryControllerZKSync.sol";
import {StructHelper} from "../helpers/StructHelper.sol";
import {SimpleWallet} from "../helpers/SimpleWallet.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract EmailAccountRecoveryZKSyncTest_requestGuardian is StructHelper {
    constructor() {}

    function setUp() public override {
        super.setUp();
    }

    function testRequestGuardian() public {
        skipIfNotZkSync();

        setUp();
        require(
            recoveryControllerZKSync.guardians(guardian) ==
                RecoveryControllerZKSync.GuardianStatus.NONE
        );

        vm.startPrank(deployer);
        recoveryControllerZKSync.requestGuardian(guardian);
        vm.stopPrank();

        require(
            recoveryControllerZKSync.guardians(guardian) ==
                RecoveryControllerZKSync.GuardianStatus.REQUESTED
        );
    }

    function testExpectRevertRequestGuardianInvalidGuardian() public {
        skipIfNotZkSync();

        setUp();

        require(
            recoveryControllerZKSync.guardians(guardian) ==
                RecoveryControllerZKSync.GuardianStatus.NONE
        );

        vm.startPrank(deployer);
        vm.expectRevert(bytes("invalid guardian"));
        recoveryControllerZKSync.requestGuardian(address(0x0));
        vm.stopPrank();
    }

    function testExpectRevertRequestGuardianGuardianStatusMustBeNone() public {
        skipIfNotZkSync();

        setUp();

        require(
            recoveryControllerZKSync.guardians(guardian) ==
                RecoveryControllerZKSync.GuardianStatus.NONE
        );

        vm.startPrank(deployer);
        recoveryControllerZKSync.requestGuardian(guardian);
        vm.expectRevert(bytes("guardian status must be NONE"));
        recoveryControllerZKSync.requestGuardian(guardian);
        vm.stopPrank();
    }
}
