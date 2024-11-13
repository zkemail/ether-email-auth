// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {EmailAuth, EmailAuthMsg} from "../../src/EmailAuth.sol";
import {RecoveryController} from "../helpers/RecoveryController.sol";
import {StructHelper} from "../helpers/StructHelper.sol";
import {SimpleWallet} from "../helpers/SimpleWallet.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract EmailAccountRecoveryTest_requestGuardian is StructHelper {
    using stdStorage for StdStorage;

    constructor() {}

    function setUp() public override {
        super.setUp();
    }

    function testExpectRevertRequestGuardianRecoveryInProgress() public {
        skipIfZkSync();

        setUp();
        vm.startPrank(deployer);
        recoveryController.requestGuardian(guardian);

        // Simulate recovery in progress
        stdstore
            .target(address(recoveryController))
            .sig("isRecovering(address)")
            .with_key(address(deployer))
            .checked_write(true);

        vm.expectRevert(bytes("recovery in progress"));
        recoveryController.requestGuardian(address(0x123)); // Try to request a new guardian
        vm.stopPrank();
    }

    function testExpectRevertRequestGuardianInvalidGuardian() public {
        skipIfZkSync();

        setUp();

        require(
            recoveryController.guardians(guardian) ==
                RecoveryController.GuardianStatus.NONE
        );

        vm.startPrank(deployer);
        vm.expectRevert(bytes("invalid guardian"));
        recoveryController.requestGuardian(address(0x0));
        vm.stopPrank();
    }

    function testExpectRevertRequestGuardianGuardianStatusMustBeNone() public {
        skipIfZkSync();

        setUp();

        require(
            recoveryController.guardians(guardian) ==
                RecoveryController.GuardianStatus.NONE
        );

        vm.startPrank(deployer);
        recoveryController.requestGuardian(guardian);
        vm.expectRevert(bytes("guardian status must be NONE"));
        recoveryController.requestGuardian(guardian);
        vm.stopPrank();
    }

    function testRequestGuardian() public {
        skipIfZkSync();

        setUp();
        require(
            recoveryController.guardians(guardian) ==
                RecoveryController.GuardianStatus.NONE
        );

        vm.startPrank(deployer);
        recoveryController.requestGuardian(guardian);
        vm.stopPrank();

        require(
            recoveryController.guardians(guardian) ==
                RecoveryController.GuardianStatus.REQUESTED
        );
    }

    function testMultipleGuardianRequests() public {
        skipIfZkSync();

        address anotherGuardian = vm.addr(9);
        setUp();
        vm.startPrank(deployer);
        recoveryController.requestGuardian(guardian);
        recoveryController.requestGuardian(anotherGuardian); // Assuming anotherGuardian is defined
        vm.stopPrank();

        require(
            recoveryController.guardians(guardian) ==
                RecoveryController.GuardianStatus.REQUESTED
        );
        require(
            recoveryController.guardians(anotherGuardian) ==
                RecoveryController.GuardianStatus.REQUESTED
        );
    }
}
