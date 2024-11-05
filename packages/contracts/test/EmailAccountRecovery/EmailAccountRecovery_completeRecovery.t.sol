// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {EmailAuth, EmailAuthMsg} from "../../src/EmailAuth.sol";
import {RecoveryController} from "../helpers/RecoveryController.sol";
import {StructHelper} from "../helpers/StructHelper.sol";
import {SimpleWallet} from "../helpers/SimpleWallet.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract EmailAccountRecoveryTest_completeRecovery is StructHelper {
    constructor() {}

    function setUp() public override {
        super.setUp();
    }

    function requestGuardian() public {
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

    function handleAcceptance() public {
        requestGuardian();

        console.log("guardian", guardian);

        require(
            recoveryController.guardians(guardian) ==
                RecoveryController.GuardianStatus.REQUESTED
        );

        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        uint templateId = recoveryController.computeAcceptanceTemplateId(
            templateIdx
        );
        emailAuthMsg.templateId = templateId;
        bytes[] memory commandParamsForAcceptance = new bytes[](1);
        commandParamsForAcceptance[0] = abi.encode(address(simpleWallet));
        emailAuthMsg.commandParams = commandParamsForAcceptance;

        vm.mockCall(
            address(recoveryController.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        // acceptGuardian is internal, we call handleAcceptance, which calls acceptGuardian internally.
        vm.startPrank(someRelayer);
        recoveryController.handleAcceptance(emailAuthMsg, templateIdx);
        vm.stopPrank();

        require(
            recoveryController.guardians(guardian) ==
                RecoveryController.GuardianStatus.ACCEPTED
        );
    }

    function handleRecovery() public {
        handleAcceptance();

        assertEq(recoveryController.isRecovering(address(simpleWallet)), false);
        assertEq(
            recoveryController.currentTimelockOfAccount(address(simpleWallet)),
            0
        );
        assertEq(simpleWallet.owner(), deployer);
        assertEq(
            recoveryController.newSignerCandidateOfAccount(
                address(simpleWallet)
            ),
            address(0x0)
        );

        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        uint templateId = recoveryController.computeRecoveryTemplateId(
            templateIdx
        );
        emailAuthMsg.templateId = templateId;
        bytes[] memory commandParamsForRecovery = new bytes[](2);
        commandParamsForRecovery[0] = abi.encode(simpleWallet);
        commandParamsForRecovery[1] = abi.encode(newSigner);
        emailAuthMsg.commandParams = commandParamsForRecovery;

        vm.mockCall(
            address(recoveryController.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        vm.startPrank(someRelayer);
        recoveryController.handleRecovery(emailAuthMsg, templateIdx);
        vm.stopPrank();

        assertEq(recoveryController.isRecovering(address(simpleWallet)), true);
        assertEq(simpleWallet.owner(), deployer);
        assertEq(
            recoveryController.newSignerCandidateOfAccount(
                address(simpleWallet)
            ),
            newSigner
        );
        assertEq(
            recoveryController.currentTimelockOfAccount(address(simpleWallet)),
            block.timestamp +
                recoveryController.timelockPeriodOfAccount(
                    address(simpleWallet)
                )
        );
    }

    function testCompleteRecovery() public {
        skipIfZkSync();

        handleRecovery();

        assertEq(recoveryController.isRecovering(address(simpleWallet)), true);
        assertEq(
            recoveryController.currentTimelockOfAccount(address(simpleWallet)),
            block.timestamp +
                recoveryController.timelockPeriodOfAccount(
                    address(simpleWallet)
                )
        );
        assertEq(simpleWallet.owner(), deployer);
        assertEq(
            recoveryController.newSignerCandidateOfAccount(
                address(simpleWallet)
            ),
            newSigner
        );

        vm.startPrank(someRelayer);
        vm.warp(4 days);
        recoveryController.completeRecovery(
            address(simpleWallet),
            new bytes(0)
        );
        vm.stopPrank();

        assertEq(recoveryController.isRecovering(address(simpleWallet)), false);
        assertEq(
            recoveryController.currentTimelockOfAccount(address(simpleWallet)),
            0
        );
        assertEq(simpleWallet.owner(), newSigner);
        assertEq(
            recoveryController.newSignerCandidateOfAccount(
                address(simpleWallet)
            ),
            address(0x0)
        );
    }

    function testExpectRevertCompleteRecoveryRecoveryNotInProgress() public {
        skipIfZkSync();

        handleAcceptance();

        assertEq(recoveryController.isRecovering(address(simpleWallet)), false);
        assertEq(
            recoveryController.currentTimelockOfAccount(address(simpleWallet)),
            0
        );
        assertEq(simpleWallet.owner(), deployer);
        assertEq(
            recoveryController.newSignerCandidateOfAccount(
                address(simpleWallet)
            ),
            address(0x0)
        );

        vm.startPrank(someRelayer);
        vm.warp(4 days);
        vm.expectRevert(bytes("recovery not in progress"));
        bytes memory recoveryCalldata;
        recoveryController.completeRecovery(
            address(simpleWallet),
            recoveryCalldata
        );

        vm.stopPrank();
    }

    function testExpectRevertCompleteRecovery() public {
        skipIfZkSync();

        vm.warp(block.timestamp + 3 days);

        handleRecovery();

        assertEq(recoveryController.isRecovering(address(simpleWallet)), true);
        assertEq(
            recoveryController.currentTimelockOfAccount(address(simpleWallet)),
            block.timestamp +
                recoveryController.timelockPeriodOfAccount(
                    address(simpleWallet)
                )
        );
        assertEq(simpleWallet.owner(), deployer);
        assertEq(
            recoveryController.newSignerCandidateOfAccount(
                address(simpleWallet)
            ),
            newSigner
        );

        vm.warp(0);

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("timelock not expired"));
        bytes memory recoveryCalldata;
        recoveryController.completeRecovery(
            address(simpleWallet),
            recoveryCalldata
        );

        vm.stopPrank();
    }
}
