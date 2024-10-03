// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {EmailAuth, EmailAuthMsg} from "../../src/EmailAuth.sol";
import {RecoveryController} from "../helpers/RecoveryController.sol";
import {StructHelper} from "../helpers/StructHelper.sol";
import {SimpleWallet} from "../helpers/SimpleWallet.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract EmailAccountRecoveryForRejectRecoveryTest_jwt_rejectRecovery is
    StructHelper
{
    constructor() {}

    function setUp() public override {
        super.setUp();
    }

    /**
     * Set up functions
     */
    function requestGuardian() public {
        setUp();

        require(
            jwtRecoveryController.guardians(jwtGuardian) ==
                RecoveryController.GuardianStatus.NONE
        );

        vm.startPrank(deployer);
        jwtRecoveryController.requestGuardian(jwtGuardian);
        vm.stopPrank();

        require(
            jwtRecoveryController.guardians(jwtGuardian) ==
                RecoveryController.GuardianStatus.REQUESTED
        );
    }

    function handleAcceptance() public {
        requestGuardian();

        require(
            jwtRecoveryController.guardians(jwtGuardian) ==
                RecoveryController.GuardianStatus.REQUESTED
        );

        console.log("guardian", guardian);
        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildJwtMsg();
        bytes[] memory commandParamsForAcceptance = new bytes[](1);
        commandParamsForAcceptance[0] = abi.encode(address(jwtSimpleWallet));
        emailAuthMsg.commandParams = commandParamsForAcceptance;
        address recoveredAccount = jwtRecoveryController
            .extractRecoveredAccountFromAcceptanceCommand(
                emailAuthMsg.commandParams,
                templateIdx
            );
        address computedGuardian = jwtRecoveryController.computeEmailAuthAddress(
            recoveredAccount,
            emailAuthMsg.proof.accountSalt
        );
        console.log("computed guardian", computedGuardian);
        uint templateId = jwtRecoveryController.computeAcceptanceTemplateId(
            templateIdx
        );
        emailAuthMsg.templateId = templateId;

        vm.mockCall(
            address(jwtRecoveryController.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        // acceptGuardian is internal, we call handleAcceptance, which calls acceptGuardian internally.
        vm.startPrank(someRelayer);
        jwtRecoveryController.handleAcceptance(emailAuthMsg, templateIdx);
        vm.stopPrank();

        require(
            jwtRecoveryController.guardians(jwtGuardian) ==
                RecoveryController.GuardianStatus.ACCEPTED
        );
    }

    function handleRecovery() public {
        handleAcceptance();

        assertEq(jwtSimpleWallet.owner(), deployer);
        assertEq(jwtRecoveryController.isRecovering(address(jwtSimpleWallet)), false);
        assertEq(
            jwtRecoveryController.currentTimelockOfAccount(address(jwtSimpleWallet)),
            0
        );
        assertEq(
            jwtRecoveryController.newSignerCandidateOfAccount(
                address(jwtSimpleWallet)
            ),
            address(0x0)
        );

        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        uint templateId = jwtRecoveryController.computeRecoveryTemplateId(
            templateIdx
        );
        emailAuthMsg.templateId = templateId;
        bytes[] memory commandParamsForRecovery = new bytes[](2);
        commandParamsForRecovery[0] = abi.encode(jwtSimpleWallet);
        commandParamsForRecovery[1] = abi.encode(newSigner);
        emailAuthMsg.commandParams = commandParamsForRecovery;

        vm.mockCall(
            address(jwtRecoveryController.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        vm.startPrank(someRelayer);
        jwtRecoveryController.handleRecovery(emailAuthMsg, templateIdx);
        vm.stopPrank();

        assertEq(jwtRecoveryController.isRecovering(address(jwtSimpleWallet)), true);
        assertEq(jwtSimpleWallet.owner(), deployer);
        assertEq(
            jwtRecoveryController.newSignerCandidateOfAccount(
                address(jwtSimpleWallet)
            ),
            newSigner
        );
        assertEq(
            jwtRecoveryController.currentTimelockOfAccount(address(jwtSimpleWallet)),
            block.timestamp +
                jwtRecoveryController.timelockPeriodOfAccount(
                    address(jwtSimpleWallet)
                )
        );
    }

    function testRejectRecovery() public {
        skipIfZkSync();

        vm.warp(block.timestamp + 3 days);

        handleRecovery();

        assertEq(jwtRecoveryController.isRecovering(address(jwtSimpleWallet)), true);
        assertEq(
            jwtRecoveryController.currentTimelockOfAccount(address(jwtSimpleWallet)),
            block.timestamp +
                jwtRecoveryController.timelockPeriodOfAccount(
                    address(jwtSimpleWallet)
                )
        );
        assertEq(jwtSimpleWallet.owner(), deployer);
        assertEq(
            jwtRecoveryController.newSignerCandidateOfAccount(
                address(jwtSimpleWallet)
            ),
            newSigner
        );

        vm.warp(0);

        vm.startPrank(address(jwtSimpleWallet));
        jwtRecoveryController.rejectRecovery();
        vm.stopPrank();

        assertEq(jwtRecoveryController.isRecovering(address(jwtSimpleWallet)), false);
        assertEq(
            jwtRecoveryController.currentTimelockOfAccount(address(jwtSimpleWallet)),
            0
        );
        assertEq(jwtSimpleWallet.owner(), deployer);
        assertEq(
            jwtRecoveryController.newSignerCandidateOfAccount(
                address(jwtSimpleWallet)
            ),
            address(0x0)
        );
    }

    function testExpectRevertRejectRecoveryRecoveryNotInProgress() public {
        skipIfZkSync();

        handleAcceptance();

        assertEq(jwtRecoveryController.isRecovering(address(jwtSimpleWallet)), false);
        assertEq(
            jwtRecoveryController.currentTimelockOfAccount(address(jwtSimpleWallet)),
            0
        );
        assertEq(jwtSimpleWallet.owner(), deployer);
        assertEq(
            jwtRecoveryController.newSignerCandidateOfAccount(
                address(jwtSimpleWallet)
            ),
            address(0x0)
        );

        vm.startPrank(deployer);
        vm.expectRevert(bytes("recovery not in progress"));
        jwtRecoveryController.rejectRecovery();
        vm.stopPrank();
    }

    function testExpectRevertRejectRecovery() public {
        skipIfZkSync();

        vm.warp(block.timestamp + 1 days);

        handleRecovery();

        assertEq(jwtRecoveryController.isRecovering(address(jwtSimpleWallet)), true);
        assertEq(
            jwtRecoveryController.currentTimelockOfAccount(address(jwtSimpleWallet)),
            block.timestamp +
                jwtRecoveryController.timelockPeriodOfAccount(
                    address(jwtSimpleWallet)
                )
        );
        assertEq(jwtSimpleWallet.owner(), deployer);
        assertEq(
            jwtRecoveryController.newSignerCandidateOfAccount(
                address(jwtSimpleWallet)
            ),
            newSigner
        );

        vm.startPrank(address(jwtSimpleWallet));
        vm.warp(block.timestamp + 4 days);
        vm.expectRevert(bytes("timelock expired"));
        jwtRecoveryController.rejectRecovery();
        vm.stopPrank();
    }

    function testExpectRevertRejectRecoveryOwnableUnauthorizedAccount() public {
        skipIfZkSync();

        handleRecovery();

        assertEq(jwtRecoveryController.isRecovering(address(jwtSimpleWallet)), true);
        assertEq(
            jwtRecoveryController.currentTimelockOfAccount(address(jwtSimpleWallet)),
            block.timestamp +
                jwtRecoveryController.timelockPeriodOfAccount(
                    address(jwtSimpleWallet)
                )
        );
        assertEq(jwtSimpleWallet.owner(), deployer);
        assertEq(
            jwtRecoveryController.newSignerCandidateOfAccount(
                address(jwtSimpleWallet)
            ),
            newSigner
        );

        vm.startPrank(deployer);
        vm.expectRevert("recovery not in progress");
        jwtRecoveryController.rejectRecovery();
        vm.stopPrank();
    }
}
