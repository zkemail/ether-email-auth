// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {EmailAuthMsg} from "../src/EmailAuth.sol";
import "./helpers/StructHelper.sol";
import "./helpers/SimpleWallet.sol";

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract EmailAccountRecoveryForRejectRecoveryTest is StructHelper {
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
            recoveryModule.guardians(guardian) ==
                RecoveryModule.GuardianStatus.NONE
        );

        vm.startPrank(deployer);
        recoveryModule.requestGuardian(guardian);
        vm.stopPrank();

        require(
            recoveryModule.guardians(guardian) ==
                RecoveryModule.GuardianStatus.REQUESTED
        );
    }

    function handleAcceptance() public {
        requestGuardian();

        require(
            recoveryModule.guardians(guardian) ==
                RecoveryModule.GuardianStatus.REQUESTED
        );

        console.log("guardian", guardian);
        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        bytes[] memory subjectParamsForAcceptance = new bytes[](1);
        subjectParamsForAcceptance[0] = abi.encode(address(simpleWallet));
        emailAuthMsg.subjectParams = subjectParamsForAcceptance;
        address recoveredAccount = recoveryModule
            .extractRecoveredAccountFromAcceptanceSubject(
                emailAuthMsg.subjectParams,
                templateIdx
            );
        address computedGuardian = recoveryModule.computeEmailAuthAddress(
            recoveredAccount,
            emailAuthMsg.proof.accountSalt
        );
        console.log("computed guardian", computedGuardian);
        uint templateId = recoveryModule.computeAcceptanceTemplateId(
            templateIdx
        );
        emailAuthMsg.templateId = templateId;

        vm.mockCall(
            address(recoveryModule.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        // acceptGuardian is internal, we call handleAcceptance, which calls acceptGuardian internally.
        vm.startPrank(someRelayer);
        recoveryModule.handleAcceptance(emailAuthMsg, templateIdx);
        vm.stopPrank();

        require(
            recoveryModule.guardians(guardian) ==
                RecoveryModule.GuardianStatus.ACCEPTED
        );
    }

    function handleRecovery() public {
        handleAcceptance();

        assertEq(simpleWallet.owner(), deployer);
        assertEq(recoveryModule.isRecovering(address(simpleWallet)), false);
        assertEq(
            recoveryModule.currentTimelockOfAccount(address(simpleWallet)),
            0
        );
        assertEq(
            recoveryModule.newSignerCandidateOfAccount(address(simpleWallet)),
            address(0x0)
        );

        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        uint templateId = recoveryModule.computeRecoveryTemplateId(templateIdx);
        emailAuthMsg.templateId = templateId;
        bytes[] memory subjectParamsForRecovery = new bytes[](2);
        subjectParamsForRecovery[0] = abi.encode(simpleWallet);
        subjectParamsForRecovery[1] = abi.encode(newSigner);
        emailAuthMsg.subjectParams = subjectParamsForRecovery;

        vm.mockCall(
            address(recoveryModule.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        vm.startPrank(someRelayer);
        recoveryModule.handleRecovery(emailAuthMsg, templateIdx);
        vm.stopPrank();

        assertEq(recoveryModule.isRecovering(address(simpleWallet)), true);
        assertEq(simpleWallet.owner(), deployer);
        assertEq(
            recoveryModule.newSignerCandidateOfAccount(address(simpleWallet)),
            newSigner
        );
        assertEq(
            recoveryModule.currentTimelockOfAccount(address(simpleWallet)),
            block.timestamp +
                recoveryModule.timelockPeriodOfAccount(address(simpleWallet))
        );
    }

    function testRejectRecovery() public {
        vm.warp(block.timestamp + 3 days);

        handleRecovery();

        assertEq(recoveryModule.isRecovering(address(simpleWallet)), true);
        assertEq(
            recoveryModule.currentTimelockOfAccount(address(simpleWallet)),
            block.timestamp +
                recoveryModule.timelockPeriodOfAccount(address(simpleWallet))
        );
        assertEq(simpleWallet.owner(), deployer);
        assertEq(
            recoveryModule.newSignerCandidateOfAccount(address(simpleWallet)),
            newSigner
        );

        vm.warp(0);

        vm.startPrank(address(simpleWallet));
        recoveryModule.rejectRecovery();
        vm.stopPrank();

        assertEq(recoveryModule.isRecovering(address(simpleWallet)), false);
        assertEq(
            recoveryModule.currentTimelockOfAccount(address(simpleWallet)),
            0
        );
        assertEq(simpleWallet.owner(), deployer);
        assertEq(
            recoveryModule.newSignerCandidateOfAccount(address(simpleWallet)),
            address(0x0)
        );
    }

    function testExpectRevertRejectRecoveryRecoveryNotInProgress() public {
        handleAcceptance();

        assertEq(recoveryModule.isRecovering(address(simpleWallet)), false);
        assertEq(
            recoveryModule.currentTimelockOfAccount(address(simpleWallet)),
            0
        );
        assertEq(simpleWallet.owner(), deployer);
        assertEq(
            recoveryModule.newSignerCandidateOfAccount(address(simpleWallet)),
            address(0x0)
        );

        vm.startPrank(deployer);
        vm.expectRevert(bytes("recovery not in progress"));
        recoveryModule.rejectRecovery();
        vm.stopPrank();
    }

    function testExpectRevertRejectRecovery() public {
        vm.warp(block.timestamp + 1 days);

        handleRecovery();

        assertEq(recoveryModule.isRecovering(address(simpleWallet)), true);
        assertEq(
            recoveryModule.currentTimelockOfAccount(address(simpleWallet)),
            block.timestamp +
                recoveryModule.timelockPeriodOfAccount(address(simpleWallet))
        );
        assertEq(simpleWallet.owner(), deployer);
        assertEq(
            recoveryModule.newSignerCandidateOfAccount(address(simpleWallet)),
            newSigner
        );

        vm.startPrank(address(simpleWallet));
        vm.warp(block.timestamp + 4 days);
        vm.expectRevert(bytes("timelock expired"));
        recoveryModule.rejectRecovery();
        vm.stopPrank();
    }

    function testCompleteRecovery() public {
        handleRecovery();

        assertEq(recoveryModule.isRecovering(address(simpleWallet)), true);
        assertEq(
            recoveryModule.currentTimelockOfAccount(address(simpleWallet)),
            block.timestamp +
                recoveryModule.timelockPeriodOfAccount(address(simpleWallet))
        );
        assertEq(simpleWallet.owner(), deployer);
        assertEq(
            recoveryModule.newSignerCandidateOfAccount(address(simpleWallet)),
            newSigner
        );

        vm.startPrank(someRelayer);
        vm.warp(4 days);
        bytes memory recoveryCalldata;
        recoveryModule.completeRecovery(
            address(simpleWallet),
            recoveryCalldata
        );
        vm.stopPrank();

        assertEq(recoveryModule.isRecovering(address(simpleWallet)), false);
        assertEq(
            recoveryModule.currentTimelockOfAccount(address(simpleWallet)),
            0
        );
        assertEq(simpleWallet.owner(), newSigner);
        assertEq(
            recoveryModule.newSignerCandidateOfAccount(address(simpleWallet)),
            address(0x0)
        );
    }

    function testExpectRevertCompleteRecoveryRecoveryNotInProgress() public {
        handleAcceptance();

        assertEq(recoveryModule.isRecovering(address(simpleWallet)), false);
        assertEq(
            recoveryModule.currentTimelockOfAccount(address(simpleWallet)),
            0
        );
        assertEq(simpleWallet.owner(), deployer);
        assertEq(
            recoveryModule.newSignerCandidateOfAccount(address(simpleWallet)),
            address(0x0)
        );

        vm.startPrank(someRelayer);
        vm.warp(4 days);
        vm.expectRevert(bytes("recovery not in progress"));
        bytes memory recoveryCalldata;
        recoveryModule.completeRecovery(
            address(simpleWallet),
            recoveryCalldata
        );

        vm.stopPrank();
    }

    function testExpectRevertCompleteRecovery() public {
        vm.warp(block.timestamp + 3 days);

        handleRecovery();

        assertEq(recoveryModule.isRecovering(address(simpleWallet)), true);
        assertEq(
            recoveryModule.currentTimelockOfAccount(address(simpleWallet)),
            block.timestamp +
                recoveryModule.timelockPeriodOfAccount(address(simpleWallet))
        );
        assertEq(simpleWallet.owner(), deployer);
        assertEq(
            recoveryModule.newSignerCandidateOfAccount(address(simpleWallet)),
            newSigner
        );

        vm.warp(0);

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("timelock not expired"));
        bytes memory recoveryCalldata;
        recoveryModule.completeRecovery(
            address(simpleWallet),
            recoveryCalldata
        );

        vm.stopPrank();
    }
}
