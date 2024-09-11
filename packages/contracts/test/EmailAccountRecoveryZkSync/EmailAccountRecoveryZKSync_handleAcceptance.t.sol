// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {EmailAuth, EmailAuthMsg} from "../../src/EmailAuth.sol";
import {RecoveryControllerZKSync} from "../helpers/RecoveryControllerZKSync.sol";
import {StructHelper} from "../helpers/StructHelper.sol";
import {SimpleWallet} from "../helpers/SimpleWallet.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract EmailAccountRecoveryZKSyncTest_handleAcceptance is StructHelper {
    constructor() {}

    function setUp() public override {
        super.setUp();
    }

    function requestGuardian() public {
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

    function testHandleAcceptance() public {
        skipIfNotZkSync();
        
        requestGuardian();

        console.log("guardian", guardian);

        require(
            recoveryControllerZKSync.guardians(guardian) ==
                RecoveryControllerZKSync.GuardianStatus.REQUESTED
        );

        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        uint templateId = recoveryControllerZKSync.computeAcceptanceTemplateId(
            templateIdx
        );
        emailAuthMsg.templateId = templateId;
        bytes[] memory subjectParamsForAcceptance = new bytes[](1);
        subjectParamsForAcceptance[0] = abi.encode(address(simpleWallet));
        emailAuthMsg.subjectParams = subjectParamsForAcceptance;

        vm.mockCall(
            address(recoveryControllerZKSync.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        // acceptGuardian is internal, we call handleAcceptance, which calls acceptGuardian internally.
        vm.startPrank(someRelayer);
        recoveryControllerZKSync.handleAcceptance(emailAuthMsg, templateIdx);
        vm.stopPrank();

        require(
            recoveryControllerZKSync.guardians(guardian) ==
                RecoveryControllerZKSync.GuardianStatus.ACCEPTED
        );
    }

    // Can not test recovery in progress using handleAcceptance
    // Can not test invalid guardian using handleAcceptance

    function testExpectRevertHandleAcceptanceGuardianStatusMustBeRequested()
        public
    {
        skipIfNotZkSync();

        requestGuardian();

        require(
            recoveryControllerZKSync.guardians(guardian) ==
                RecoveryControllerZKSync.GuardianStatus.REQUESTED
        );

        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        uint templateId = recoveryControllerZKSync.computeAcceptanceTemplateId(
            templateIdx
        );
        emailAuthMsg.templateId = templateId;
        bytes[] memory subjectParamsForAcceptance = new bytes[](1);
        subjectParamsForAcceptance[0] = abi.encode(address(simpleWallet));
        emailAuthMsg.subjectParams = subjectParamsForAcceptance;
        emailAuthMsg.proof.accountSalt = 0x0;

        vm.mockCall(
            address(recoveryControllerZKSync.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("guardian status must be REQUESTED"));
        recoveryControllerZKSync.handleAcceptance(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    function testExpectRevertHandleAcceptanceInvalidTemplateIndex() public {
        skipIfNotZkSync();

        requestGuardian();

        require(
            recoveryControllerZKSync.guardians(guardian) ==
                RecoveryControllerZKSync.GuardianStatus.REQUESTED
        );

        uint templateIdx = 1;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        uint templateId = recoveryControllerZKSync.computeAcceptanceTemplateId(
            templateIdx
        );
        emailAuthMsg.templateId = templateId;
        bytes[] memory subjectParamsForAcceptance = new bytes[](1);
        subjectParamsForAcceptance[0] = abi.encode(address(simpleWallet));
        emailAuthMsg.subjectParams = subjectParamsForAcceptance;

        vm.mockCall(
            address(recoveryControllerZKSync.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("invalid template index"));
        recoveryControllerZKSync.handleAcceptance(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    function testExpectRevertHandleAcceptanceInvalidSubjectParams() public {
        skipIfNotZkSync();

        requestGuardian();

        require(
            recoveryControllerZKSync.guardians(guardian) ==
                RecoveryControllerZKSync.GuardianStatus.REQUESTED
        );

        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        uint templateId = recoveryControllerZKSync.computeAcceptanceTemplateId(
            templateIdx
        );
        emailAuthMsg.templateId = templateId;
        bytes[] memory subjectParamsForAcceptance = new bytes[](2);
        subjectParamsForAcceptance[0] = abi.encode(address(simpleWallet));
        subjectParamsForAcceptance[1] = abi.encode(address(simpleWallet));
        emailAuthMsg.subjectParams = subjectParamsForAcceptance;

        vm.mockCall(
            address(recoveryControllerZKSync.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("invalid subject params"));
        recoveryControllerZKSync.handleAcceptance(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    function testExpectRevertHandleAcceptanceInvalidWalletAddressInEmail()
        public
    {
        skipIfNotZkSync();

        requestGuardian();

        require(
            recoveryControllerZKSync.guardians(guardian) ==
                RecoveryControllerZKSync.GuardianStatus.REQUESTED
        );

        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        uint templateId = recoveryControllerZKSync.computeAcceptanceTemplateId(
            templateIdx
        );
        emailAuthMsg.templateId = templateId;
        bytes[] memory subjectParamsForAcceptance = new bytes[](1);
        subjectParamsForAcceptance[0] = abi.encode(address(0x0));
        emailAuthMsg.subjectParams = subjectParamsForAcceptance;

        vm.mockCall(
            address(recoveryControllerZKSync.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("invalid account in email"));
        recoveryControllerZKSync.handleAcceptance(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }
}
