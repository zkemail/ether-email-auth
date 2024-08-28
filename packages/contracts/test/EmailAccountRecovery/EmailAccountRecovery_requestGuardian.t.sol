// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {EmailAuth, EmailAuthMsg} from "../../src/EmailAuth.sol";
import {RecoveryController} from "../helpers/RecoveryController.sol";
import {StructHelper} from "../helpers/StructHelper.sol";
import {SimpleWallet} from "../helpers/SimpleWallet.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract EmailAccountRecoveryTest is StructHelper {
    constructor() {}

    function setUp() public override {
        super.setUp();
    }

    function testRequestGuardian() public {
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

    // function testRequestGuardianNotOwner() public {
    //     setUp();

    //     require(
    //         recoveryController.guardians(guardian) ==
    //             recoveryController.GuardianStatus.NONE
    //     );

    //     vm.startPrank(receiver);
    //     recoveryController.requestGuardian(guardian);
    //     vm.stopPrank();

    //     require(
    //         recoveryController.guardians(guardian) ==
    //             recoveryController.GuardianStatus.NONE
    //     );
    // }

    function testExpectRevertRequestGuardianInvalidGuardian() public {
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
}
