// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {EmailAuth, EmailAuthMsg} from "../../src/EmailAuth.sol";
import {RecoveryController} from "../helpers/RecoveryController.sol";
import {StructHelper} from "../helpers/StructHelper.sol";
import {SimpleWallet} from "../helpers/SimpleWallet.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract EmailAccountRecoveryTest_jwt_requestGuardian is StructHelper {
    constructor() {}

    function setUp() public override {
        super.setUp();
    }

    function testRequestGuardian() public {
        skipIfZkSync();

        setUp();
        require(
            jwtRecoveryController.guardians(guardian) ==
                RecoveryController.GuardianStatus.NONE
        );

        vm.startPrank(deployer);
        jwtRecoveryController.requestGuardian(guardian);
        vm.stopPrank();

        require(
            jwtRecoveryController.guardians(guardian) ==
                RecoveryController.GuardianStatus.REQUESTED
        );
    }

    // function testRequestGuardianNotOwner() public {
    //     setUp();

    //     require(
    //         jwtRecoveryController.guardians(guardian) ==
    //             jwtRecoveryController.GuardianStatus.NONE
    //     );

    //     vm.startPrank(receiver);
    //     jwtRecoveryController.requestGuardian(guardian);
    //     vm.stopPrank();

    //     require(
    //         jwtRecoveryController.guardians(guardian) ==
    //             jwtRecoveryController.GuardianStatus.NONE
    //     );
    // }

    function testExpectRevertRequestGuardianInvalidGuardian() public {
        skipIfZkSync();

        setUp();

        require(
            jwtRecoveryController.guardians(guardian) ==
                RecoveryController.GuardianStatus.NONE
        );

        vm.startPrank(deployer);
        vm.expectRevert(bytes("invalid guardian"));
        jwtRecoveryController.requestGuardian(address(0x0));
        vm.stopPrank();
    }

    function testExpectRevertRequestGuardianGuardianStatusMustBeNone() public {
        skipIfZkSync();

        setUp();

        require(
            jwtRecoveryController.guardians(guardian) ==
                RecoveryController.GuardianStatus.NONE
        );

        vm.startPrank(deployer);
        jwtRecoveryController.requestGuardian(guardian);
        vm.expectRevert(bytes("guardian status must be NONE"));
        jwtRecoveryController.requestGuardian(guardian);
        vm.stopPrank();
    }
}
