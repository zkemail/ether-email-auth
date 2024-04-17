// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {EmailAuthMsg} from "../src/EmailAuth.sol";
import "./helpers/StructHelper.sol";
import "./helpers/SimpleWallet.sol";

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract EmailAccountRecoveryTest is StructHelper {
    constructor() {}

    function setUp() public override {
        super.setUp();
    }

    function testTransfer() public {
        setUp();

        assertEq(address(simpleWallet).balance, 1 ether);
        assertEq(receiver.balance, 0 ether);

        vm.startPrank(deployer);
        simpleWallet.transfer(receiver, 1 ether);
        vm.stopPrank();

        assertEq(address(simpleWallet).balance, 0 ether);
        assertEq(receiver.balance, 1 ether);
    }

    function testExpectRevertTransferOnlyOwner() public {
        setUp();

        assertEq(address(simpleWallet).balance, 1 ether);
        assertEq(receiver.balance, 0 ether);

        vm.expectRevert(bytes("only owner"));
        simpleWallet.transfer(receiver, 1 ether);
    }

    function testExpectRevertTransferOnlyOwnerInsufficientBalance() public {
        setUp();

        assertEq(address(simpleWallet).balance, 1 ether);
        assertEq(receiver.balance, 0 ether);

        vm.startPrank(deployer);
        assertEq(receiver.balance, 0 ether);
        vm.expectRevert(bytes("insufficient balance"));
        simpleWallet.transfer(receiver, 2 ether);
        vm.stopPrank();
    }

    function testWithdraw() public {
        setUp();

        assertEq(address(simpleWallet).balance, 1 ether);
        assertEq(deployer.balance, 0 ether);

        vm.startPrank(deployer);
        simpleWallet.withdraw(1 ether);
        vm.stopPrank();

        assertEq(address(simpleWallet).balance, 0 ether);
        assertEq(deployer.balance, 1 ether);
    }

    function testExpectRevertWithdrawOnlyOwner() public {
        setUp();

        assertEq(address(simpleWallet).balance, 1 ether);
        assertEq(deployer.balance, 0 ether);

        vm.startPrank(receiver);
        vm.expectRevert(bytes("only owner"));
        simpleWallet.withdraw(1 ether);
        vm.stopPrank();
    }

    function testExpectRevertWithdrawInsufficientBalance() public {
        setUp();

        assertEq(address(simpleWallet).balance, 1 ether);
        assertEq(deployer.balance, 0 ether);

        vm.startPrank(deployer);
        vm.expectRevert(bytes("insufficient balance"));
        simpleWallet.withdraw(10 ether);
        vm.stopPrank();
    }

    function testAcceptanceSubjectTemplates() public {
        setUp();
        string[][] memory res = simpleWallet.acceptanceSubjectTemplates();
        assertEq(res[0][0], "Accept");
        assertEq(res[0][1], "guardian");
        assertEq(res[0][2], "request");
        assertEq(res[0][3], "for");
        assertEq(res[0][4], "{ethAddr}");
    }

    function testRecoverySubjectTemplates() public {
        setUp();
        string[][] memory res = simpleWallet.recoverySubjectTemplates();
        assertEq(res[0][0], "Set");
        assertEq(res[0][1], "the");
        assertEq(res[0][2], "new");
        assertEq(res[0][3], "signer");
        assertEq(res[0][4], "of");
        assertEq(res[0][5], "{ethAddr}");
        assertEq(res[0][6], "to");
        assertEq(res[0][7], "{ethAddr}");
    }

    function testRequestGuardian() public {
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

    function testExpectRevertRequestGuardianOnlyOwner() public {
        setUp();

        require(
            simpleWallet.guardians(guardian) == SimpleWallet.GuardianStatus.NONE
        );

        vm.startPrank(receiver);
        vm.expectRevert(bytes("only owner"));
        simpleWallet.requestGuardian(guardian);
        vm.stopPrank();
    }

    function testExpectRevertRequestGuardianInvalidGuardian() public {
        setUp();

        require(
            simpleWallet.guardians(guardian) == SimpleWallet.GuardianStatus.NONE
        );

        vm.startPrank(deployer);
        vm.expectRevert(bytes("invalid guardian"));
        simpleWallet.requestGuardian(address(0x0));
        vm.stopPrank();
    }

    function testExpectRevertRequestGuardianGuardianStatusMustBeNone() public {
        setUp();

        require(
            simpleWallet.guardians(guardian) == SimpleWallet.GuardianStatus.NONE
        );

        vm.startPrank(deployer);
        simpleWallet.requestGuardian(guardian);
        vm.expectRevert(bytes("guardian status must be NONE"));
        simpleWallet.requestGuardian(guardian);
        vm.stopPrank();
    }

    function testHandleAcceptance() public {
        testRequestGuardian();

        require(
            simpleWallet.guardians(guardian) ==
                SimpleWallet.GuardianStatus.REQUESTED
        );

        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
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

    // Can not test recovery in progress using handleAcceptance
    // Can not test invalid guardian using handleAcceptance

    function testExpectRevertHandleAcceptanceGuardianStatusMustBeRequested()
        public
    {
        testRequestGuardian();

        require(
            simpleWallet.guardians(guardian) ==
                SimpleWallet.GuardianStatus.REQUESTED
        );

        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        uint templateId = simpleWallet.computeAcceptanceTemplateId(templateIdx);
        emailAuthMsg.templateId = templateId;
        bytes[] memory subjectParamsForAcceptance = new bytes[](1);
        subjectParamsForAcceptance[0] = abi.encode(address(simpleWallet));
        emailAuthMsg.subjectParams = subjectParamsForAcceptance;
        emailAuthMsg.proof.accountSalt = 0x0;

        vm.mockCall(
            address(simpleWallet.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("guardian status must be REQUESTED"));
        simpleWallet.handleAcceptance(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    function testExpectRevertHandleAcceptanceInvalidTemplateIndex() public {
        testRequestGuardian();

        require(
            simpleWallet.guardians(guardian) ==
                SimpleWallet.GuardianStatus.REQUESTED
        );

        uint templateIdx = 1;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
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

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("invalid template index"));
        simpleWallet.handleAcceptance(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    function testExpectRevertHandleAcceptanceInvalidSubjectParams() public {
        testRequestGuardian();

        require(
            simpleWallet.guardians(guardian) ==
                SimpleWallet.GuardianStatus.REQUESTED
        );

        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        uint templateId = simpleWallet.computeAcceptanceTemplateId(templateIdx);
        emailAuthMsg.templateId = templateId;
        bytes[] memory subjectParamsForAcceptance = new bytes[](2);
        subjectParamsForAcceptance[0] = abi.encode(address(simpleWallet));
        subjectParamsForAcceptance[1] = abi.encode(address(simpleWallet));
        emailAuthMsg.subjectParams = subjectParamsForAcceptance;

        vm.mockCall(
            address(simpleWallet.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("invalid subject params"));
        simpleWallet.handleAcceptance(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    function testExpectRevertHandleAcceptanceInvalidWalletAddressInEmail()
        public
    {
        testRequestGuardian();

        require(
            simpleWallet.guardians(guardian) ==
                SimpleWallet.GuardianStatus.REQUESTED
        );

        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        uint templateId = simpleWallet.computeAcceptanceTemplateId(templateIdx);
        emailAuthMsg.templateId = templateId;
        bytes[] memory subjectParamsForAcceptance = new bytes[](1);
        subjectParamsForAcceptance[0] = abi.encode(address(0x0));
        emailAuthMsg.subjectParams = subjectParamsForAcceptance;

        vm.mockCall(
            address(simpleWallet.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("invalid wallet address in email"));
        simpleWallet.handleAcceptance(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    function testHandleRecovery() public {
        testHandleAcceptance();

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

    function testExpectRevertHandleRecoveryGuardianIsNotDeployed() public {
        testHandleAcceptance();

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
        emailAuthMsg.proof.accountSalt = 0x0;

        vm.mockCall(
            address(simpleWallet.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("guardian is not deployed"));
        simpleWallet.handleRecovery(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    function testExpectRevertHandleRecoveryInvalidTemplateId() public {
        testHandleAcceptance();

        assertEq(simpleWallet.isRecovering(), false);
        assertEq(simpleWallet.timelock(), 0);
        assertEq(simpleWallet.owner(), deployer);
        assertEq(simpleWallet.newSignerCandidate(), address(0x0));

        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
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
        vm.expectRevert(bytes("invalid template id"));
        simpleWallet.handleRecovery(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    // Can not test recovery in progress using handleRecovery
    // Can not test invalid guardian using handleRecovery

    function testExpectRevertHandleRecoveryGuardianStatusMustBeAccepted()
        public
    {
        testHandleAcceptance();

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
        emailAuthMsg.proof.accountSalt = 0x0;

        vm.mockCall(
            address(simpleWallet.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );
        // Deploy mock guardian, that status is NONE
        vm.mockCall(
            address(0x08D901253E998F1767412D7F08b6244c2EFa36A2),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("guardian status must be ACCEPTED"));
        simpleWallet.handleRecovery(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    function testExpectRevertHandleRecoveryInvalidTemplateIndex() public {
        testHandleAcceptance();

        assertEq(simpleWallet.isRecovering(), false);
        assertEq(simpleWallet.timelock(), 0);
        assertEq(simpleWallet.owner(), deployer);
        assertEq(simpleWallet.newSignerCandidate(), address(0x0));

        uint templateIdx = 1;

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
        vm.expectRevert(bytes("invalid template index"));
        simpleWallet.handleRecovery(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    function testExpectRevertHandleRecoveryInvalidSubjectParams() public {
        testHandleAcceptance();

        assertEq(simpleWallet.isRecovering(), false);
        assertEq(simpleWallet.timelock(), 0);
        assertEq(simpleWallet.owner(), deployer);
        assertEq(simpleWallet.newSignerCandidate(), address(0x0));

        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        uint templateId = simpleWallet.computeRecoveryTemplateId(templateIdx);
        emailAuthMsg.templateId = templateId;
        bytes[] memory subjectParamsForRecovery = new bytes[](3);
        subjectParamsForRecovery[0] = abi.encode(simpleWallet);
        subjectParamsForRecovery[1] = abi.encode(newSigner);
        subjectParamsForRecovery[1] = abi.encode(address(0x0));
        emailAuthMsg.subjectParams = subjectParamsForRecovery;

        vm.mockCall(
            address(simpleWallet.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("invalid subject params"));
        simpleWallet.handleRecovery(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    function testExpectRevertHandleRecoveryInvalidGuardianInEmail() public {
        testHandleAcceptance();

        assertEq(simpleWallet.isRecovering(), false);
        assertEq(simpleWallet.timelock(), 0);
        assertEq(simpleWallet.owner(), deployer);
        assertEq(simpleWallet.newSignerCandidate(), address(0x0));

        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        uint templateId = simpleWallet.computeRecoveryTemplateId(templateIdx);
        emailAuthMsg.templateId = templateId;
        bytes[] memory subjectParamsForRecovery = new bytes[](2);
        subjectParamsForRecovery[0] = abi.encode(address(0x0));
        subjectParamsForRecovery[1] = abi.encode(newSigner);
        emailAuthMsg.subjectParams = subjectParamsForRecovery;

        vm.mockCall(
            address(simpleWallet.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("invalid guardian in email"));
        simpleWallet.handleRecovery(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    function testExpectRevertHandleRecoveryInvalidNewSigner() public {
        testHandleAcceptance();

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
        subjectParamsForRecovery[1] = abi.encode(address(0x0));
        emailAuthMsg.subjectParams = subjectParamsForRecovery;

        vm.mockCall(
            address(simpleWallet.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("invalid new signer"));
        simpleWallet.handleRecovery(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    function testRejectRecovery() public {
        vm.warp(block.timestamp + 3 days);

        testHandleRecovery();

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
        testHandleRecovery();

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
        testHandleAcceptance();

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

        testHandleRecovery();

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
        testHandleRecovery();

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
        testHandleAcceptance();

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

        testHandleRecovery();

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
