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
            simpleWallet.guardians(guardian) == SimpleWallet.GuardianStatus.NONE
        );

        vm.startPrank(deployer);
        simpleWallet.requestGuardian(guardian);
        vm.stopPrank();

        require(
            simpleWallet.guardians(guardian) ==
                SimpleWallet.GuardianStatus.REQUESTED
        );
    }

    function handleAcceptance() public {
        requestGuardian();

        require(
            simpleWallet.guardians(guardian) ==
                SimpleWallet.GuardianStatus.REQUESTED
        );

        console.log("guardian", guardian);
        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        address computedGuardian = simpleWallet.computeEmailAuthAddress(
            emailAuthMsg.proof.accountSalt
        );
        console.log("computed guardian", computedGuardian);
        uint templateId = simpleWallet.computeAcceptanceTemplateId(templateIdx);
        emailAuthMsg.templateId = templateId;
        bytes[] memory subjectParamsForAcceptance = new bytes[](1);
        subjectParamsForAcceptance[0] = abi.encode(address(simpleWallet));
        emailAuthMsg.subjectParams = subjectParamsForAcceptance;

        vm.mockCall(
            address(simpleWallet.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        // acceptGuardian is internal, we call handleAcceptance, which calls acceptGuardian internally.
        vm.startPrank(someRelayer);
        simpleWallet.handleAcceptance(emailAuthMsg, templateIdx);
        vm.stopPrank();

        require(
            simpleWallet.guardians(guardian) ==
                SimpleWallet.GuardianStatus.ACCEPTED
        );
    }

    function handleRecovery() public {
        handleAcceptance();

        assertEq(simpleWallet.isRecovering(), false);
        assertEq(simpleWallet.timelock(), 0);
        assertEq(simpleWallet.owner(), deployer);
        assertEq(simpleWallet.newSignerCandidate(), address(0x0));

        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        uint templateId = simpleWallet.computeRecoveryTemplateId(templateIdx);
        emailAuthMsg.templateId = templateId;
        bytes[] memory subjectParamsForRecovery = new bytes[](2);
        subjectParamsForRecovery[0] = abi.encode(simpleWallet);
        subjectParamsForRecovery[1] = abi.encode(newSigner);
        emailAuthMsg.subjectParams = subjectParamsForRecovery;

        vm.mockCall(
            address(simpleWallet.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        vm.startPrank(someRelayer);
        simpleWallet.handleRecovery(emailAuthMsg, templateIdx);
        vm.stopPrank();

        assertEq(simpleWallet.isRecovering(), true);
        assertEq(simpleWallet.owner(), deployer);
        assertEq(simpleWallet.newSignerCandidate(), newSigner);
        assertEq(
            simpleWallet.timelock(),
            block.timestamp + simpleWallet.timelockPeriod()
        );
    }

    function testRejectRecovery() public {
        vm.warp(block.timestamp + 3 days);

        handleRecovery();

        assertEq(simpleWallet.isRecovering(), true);
        assertEq(
            simpleWallet.timelock(),
            block.timestamp + simpleWallet.timelockPeriod()
        );
        assertEq(simpleWallet.owner(), deployer);
        assertEq(simpleWallet.newSignerCandidate(), newSigner);

        vm.warp(0);

        vm.startPrank(deployer);
        simpleWallet.rejectRecovery();
        vm.stopPrank();

        assertEq(simpleWallet.isRecovering(), false);
        assertEq(simpleWallet.timelock(), 0);
        assertEq(simpleWallet.owner(), deployer);
        assertEq(simpleWallet.newSignerCandidate(), address(0x0));
    }

    function testExpectRevertRejectRecoveryOwnableUnauthorizedAccount() public {
        handleRecovery();

        vm.startPrank(deployer);
        simpleWallet.transferOwnership(receiver);
        vm.stopPrank();

        assertEq(simpleWallet.isRecovering(), true);
        assertEq(
            simpleWallet.timelock(),
            block.timestamp + simpleWallet.timelockPeriod()
        );
        assertEq(simpleWallet.owner(), receiver);
        assertEq(simpleWallet.newSignerCandidate(), newSigner);

        vm.startPrank(deployer);
        vm.expectRevert(
            abi.encodeWithSelector(
                OwnableUpgradeable.OwnableUnauthorizedAccount.selector,
                deployer
            )
        );
        simpleWallet.rejectRecovery();
        vm.stopPrank();
    }

    function testExpectRevertRejectRecoveryRecoveryNotInProgress() public {
        handleAcceptance();

        assertEq(simpleWallet.isRecovering(), false);
        assertEq(simpleWallet.timelock(), 0);
        assertEq(simpleWallet.owner(), deployer);
        assertEq(simpleWallet.newSignerCandidate(), address(0x0));

        vm.startPrank(deployer);
        vm.expectRevert(bytes("recovery not in progress"));
        simpleWallet.rejectRecovery();
        vm.stopPrank();
    }

    function testExpectRevertRejectRecovery() public {
        vm.warp(block.timestamp + 1 days);

        handleRecovery();

        assertEq(simpleWallet.isRecovering(), true);
        assertEq(
            simpleWallet.timelock(),
            block.timestamp + simpleWallet.timelockPeriod()
        );
        assertEq(simpleWallet.owner(), deployer);
        assertEq(simpleWallet.newSignerCandidate(), newSigner);

        vm.startPrank(deployer);
        vm.warp(block.timestamp + 4 days);
        vm.expectRevert(bytes("timelock expired"));
        simpleWallet.rejectRecovery();
        vm.stopPrank();
    }

    function testCompleteRecovery() public {
        handleRecovery();

        assertEq(simpleWallet.isRecovering(), true);
        assertEq(
            simpleWallet.timelock(),
            block.timestamp + simpleWallet.timelockPeriod()
        );
        assertEq(simpleWallet.owner(), deployer);
        assertEq(simpleWallet.newSignerCandidate(), newSigner);

        vm.startPrank(someRelayer);
        vm.warp(4 days);
        simpleWallet.completeRecovery();
        vm.stopPrank();

        assertEq(simpleWallet.isRecovering(), false);
        assertEq(simpleWallet.timelock(), 0);
        assertEq(simpleWallet.owner(), newSigner);
        assertEq(simpleWallet.newSignerCandidate(), address(0x0));
    }

    function testExpectRevertCompleteRecoveryRecoveryNotInProgress() public {
        handleAcceptance();

        assertEq(simpleWallet.isRecovering(), false);
        assertEq(simpleWallet.timelock(), 0);
        assertEq(simpleWallet.owner(), deployer);
        assertEq(simpleWallet.newSignerCandidate(), address(0x0));

        vm.startPrank(someRelayer);
        vm.warp(4 days);
        vm.expectRevert(bytes("recovery not in progress"));
        simpleWallet.completeRecovery();
        vm.stopPrank();
    }

    function testExpectRevertCompleteRecovery() public {
        vm.warp(block.timestamp + 3 days);

        handleRecovery();

        assertEq(simpleWallet.isRecovering(), true);
        assertEq(
            simpleWallet.timelock(),
            block.timestamp + simpleWallet.timelockPeriod()
        );
        assertEq(simpleWallet.owner(), deployer);
        assertEq(simpleWallet.newSignerCandidate(), newSigner);

        vm.warp(0);

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("timelock not expired"));
        simpleWallet.completeRecovery();
        vm.stopPrank();
    }
}
