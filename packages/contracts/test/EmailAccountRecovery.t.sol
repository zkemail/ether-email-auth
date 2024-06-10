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

        vm.startPrank(receiver);
        vm.expectRevert(
            abi.encodeWithSelector(
                OwnableUpgradeable.OwnableUnauthorizedAccount.selector,
                receiver
            )
        );
        simpleWallet.transfer(receiver, 1 ether);
        vm.stopPrank();
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
        vm.expectRevert(
            abi.encodeWithSelector(
                OwnableUpgradeable.OwnableUnauthorizedAccount.selector,
                address(receiver)
            )
        );
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
        string[][] memory res = recoveryModule.acceptanceSubjectTemplates();
        assertEq(res[0][0], "Accept");
        assertEq(res[0][1], "guardian");
        assertEq(res[0][2], "request");
        assertEq(res[0][3], "for");
        assertEq(res[0][4], "{ethAddr}");
    }

    function testRecoverySubjectTemplates() public {
        setUp();
        string[][] memory res = recoveryModule.recoverySubjectTemplates();
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

    // function testRequestGuardianNotOwner() public {
    //     setUp();

    //     require(
    //         recoveryModule.guardians(guardian) ==
    //             RecoveryModule.GuardianStatus.NONE
    //     );

    //     vm.startPrank(receiver);
    //     recoveryModule.requestGuardian(guardian);
    //     vm.stopPrank();

    //     require(
    //         recoveryModule.guardians(guardian) ==
    //             RecoveryModule.GuardianStatus.NONE
    //     );
    // }

    function testExpectRevertRequestGuardianInvalidGuardian() public {
        setUp();

        require(
            recoveryModule.guardians(guardian) ==
                RecoveryModule.GuardianStatus.NONE
        );

        vm.startPrank(deployer);
        vm.expectRevert(bytes("invalid guardian"));
        recoveryModule.requestGuardian(address(0x0));
        vm.stopPrank();
    }

    function testExpectRevertRequestGuardianGuardianStatusMustBeNone() public {
        setUp();

        require(
            recoveryModule.guardians(guardian) ==
                RecoveryModule.GuardianStatus.NONE
        );

        vm.startPrank(deployer);
        recoveryModule.requestGuardian(guardian);
        vm.expectRevert(bytes("guardian status must be NONE"));
        recoveryModule.requestGuardian(guardian);
        vm.stopPrank();
    }

    function testHandleAcceptance() public {
        testRequestGuardian();

        console.log("guardian", guardian);

        require(
            recoveryModule.guardians(guardian) ==
                RecoveryModule.GuardianStatus.REQUESTED
        );

        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        uint templateId = recoveryModule.computeAcceptanceTemplateId(
            templateIdx
        );
        emailAuthMsg.templateId = templateId;
        bytes[] memory subjectParamsForAcceptance = new bytes[](1);
        subjectParamsForAcceptance[0] = abi.encode(address(simpleWallet));
        emailAuthMsg.subjectParams = subjectParamsForAcceptance;

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

    // Can not test recovery in progress using handleAcceptance
    // Can not test invalid guardian using handleAcceptance

    function testExpectRevertHandleAcceptanceGuardianStatusMustBeRequested()
        public
    {
        testRequestGuardian();

        require(
            recoveryModule.guardians(guardian) ==
                RecoveryModule.GuardianStatus.REQUESTED
        );

        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        uint templateId = recoveryModule.computeAcceptanceTemplateId(
            templateIdx
        );
        emailAuthMsg.templateId = templateId;
        bytes[] memory subjectParamsForAcceptance = new bytes[](1);
        subjectParamsForAcceptance[0] = abi.encode(address(simpleWallet));
        emailAuthMsg.subjectParams = subjectParamsForAcceptance;
        emailAuthMsg.proof.accountSalt = 0x0;

        vm.mockCall(
            address(recoveryModule.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("guardian status must be REQUESTED"));
        recoveryModule.handleAcceptance(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    function testExpectRevertHandleAcceptanceInvalidTemplateIndex() public {
        testRequestGuardian();

        require(
            recoveryModule.guardians(guardian) ==
                RecoveryModule.GuardianStatus.REQUESTED
        );

        uint templateIdx = 1;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        uint templateId = recoveryModule.computeAcceptanceTemplateId(
            templateIdx
        );
        emailAuthMsg.templateId = templateId;
        bytes[] memory subjectParamsForAcceptance = new bytes[](1);
        subjectParamsForAcceptance[0] = abi.encode(address(simpleWallet));
        emailAuthMsg.subjectParams = subjectParamsForAcceptance;

        vm.mockCall(
            address(recoveryModule.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("invalid template index"));
        recoveryModule.handleAcceptance(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    function testExpectRevertHandleAcceptanceInvalidSubjectParams() public {
        testRequestGuardian();

        require(
            recoveryModule.guardians(guardian) ==
                RecoveryModule.GuardianStatus.REQUESTED
        );

        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        uint templateId = recoveryModule.computeAcceptanceTemplateId(
            templateIdx
        );
        emailAuthMsg.templateId = templateId;
        bytes[] memory subjectParamsForAcceptance = new bytes[](2);
        subjectParamsForAcceptance[0] = abi.encode(address(simpleWallet));
        subjectParamsForAcceptance[1] = abi.encode(address(simpleWallet));
        emailAuthMsg.subjectParams = subjectParamsForAcceptance;

        vm.mockCall(
            address(recoveryModule.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("invalid subject params"));
        recoveryModule.handleAcceptance(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    function testExpectRevertHandleAcceptanceInvalidWalletAddressInEmail()
        public
    {
        testRequestGuardian();

        require(
            recoveryModule.guardians(guardian) ==
                RecoveryModule.GuardianStatus.REQUESTED
        );

        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        uint templateId = recoveryModule.computeAcceptanceTemplateId(
            templateIdx
        );
        emailAuthMsg.templateId = templateId;
        bytes[] memory subjectParamsForAcceptance = new bytes[](1);
        subjectParamsForAcceptance[0] = abi.encode(address(0x0));
        emailAuthMsg.subjectParams = subjectParamsForAcceptance;

        vm.mockCall(
            address(recoveryModule.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("invalid account in email"));
        recoveryModule.handleAcceptance(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    function testHandleRecovery() public {
        testHandleAcceptance();

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

    function testExpectRevertHandleRecoveryGuardianIsNotDeployed() public {
        testHandleAcceptance();

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

        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        uint templateId = recoveryModule.computeRecoveryTemplateId(templateIdx);
        emailAuthMsg.templateId = templateId;
        bytes[] memory subjectParamsForRecovery = new bytes[](2);
        subjectParamsForRecovery[0] = abi.encode(simpleWallet);
        subjectParamsForRecovery[1] = abi.encode(newSigner);
        emailAuthMsg.subjectParams = subjectParamsForRecovery;
        emailAuthMsg.proof.accountSalt = 0x0;

        vm.mockCall(
            address(recoveryModule.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("guardian is not deployed"));
        recoveryModule.handleRecovery(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    function testExpectRevertHandleRecoveryInvalidTemplateId() public {
        testHandleAcceptance();

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

        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
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
        vm.expectRevert(bytes("invalid template id"));
        recoveryModule.handleRecovery(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    // Can not test recovery in progress using handleRecovery
    // Can not test invalid guardian using handleRecovery

    function testExpectRevertHandleRecoveryGuardianStatusMustBeAccepted()
        public
    {
        testHandleAcceptance();

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

        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        uint templateId = recoveryModule.computeRecoveryTemplateId(templateIdx);
        emailAuthMsg.templateId = templateId;
        bytes[] memory subjectParamsForRecovery = new bytes[](2);
        subjectParamsForRecovery[0] = abi.encode(simpleWallet);
        subjectParamsForRecovery[1] = abi.encode(newSigner);
        emailAuthMsg.subjectParams = subjectParamsForRecovery;
        emailAuthMsg.proof.accountSalt = 0x0;

        // vm.mockCall(
        //     address(simpleWallet.emailAuthImplementationAddr()),
        //     abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
        //     abi.encode(0x0)
        // );

        // // Deploy mock guardian, that status is NONE
        // address mockCallAddress;
        // if(block.chainid == 300) {
        //     mockCallAddress = address(0x889170C6bEe9053626f8460A9875d22Cf6DE0782);
        // } else {
        //     mockCallAddress = address(0x2Cfb66029975B1c8881adaa3b79c5Caa4FEB84B5);
        // }
        // vm.mockCall(
        //     mockCallAddress,
        //     abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
        //     abi.encode(0x0)
        // );

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("guardian is not deployed"));
        recoveryModule.handleRecovery(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    function testExpectRevertHandleRecoveryInvalidTemplateIndex() public {
        testHandleAcceptance();

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
        uint templateIdx = 1;

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
        vm.expectRevert(bytes("invalid template index"));
        recoveryModule.handleRecovery(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    function testExpectRevertHandleRecoveryInvalidSubjectParams() public {
        testHandleAcceptance();

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
        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        uint templateId = recoveryModule.computeRecoveryTemplateId(templateIdx);
        emailAuthMsg.templateId = templateId;
        bytes[] memory subjectParamsForRecovery = new bytes[](3);
        subjectParamsForRecovery[0] = abi.encode(simpleWallet);
        subjectParamsForRecovery[1] = abi.encode(newSigner);
        subjectParamsForRecovery[1] = abi.encode(address(0x0));
        emailAuthMsg.subjectParams = subjectParamsForRecovery;

        vm.mockCall(
            address(recoveryModule.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("invalid subject params"));
        recoveryModule.handleRecovery(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    // function testExpectRevertHandleRecoveryInvalidGuardianInEmail() public {
    //     testHandleAcceptance();

    //     assertEq(recoveryModule.isRecovering(address(simpleWallet)), false);
    //     assertEq(
    //         recoveryModule.currentTimelockOfAccount(address(simpleWallet)),
    //         0
    //     );
    //     assertEq(simpleWallet.owner(), deployer);
    //     assertEq(
    //         recoveryModule.newSignerCandidateOfAccount(address(simpleWallet)),
    //         address(0x0)
    //     );
    //     uint templateIdx = 0;

    //     EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
    //     uint templateId = recoveryModule.computeRecoveryTemplateId(templateIdx);
    //     emailAuthMsg.templateId = templateId;
    //     bytes[] memory subjectParamsForRecovery = new bytes[](2);
    //     subjectParamsForRecovery[0] = abi.encode(address(0x0));
    //     subjectParamsForRecovery[1] = abi.encode(newSigner);
    //     emailAuthMsg.subjectParams = subjectParamsForRecovery;

    //     vm.mockCall(
    //         address(recoveryModule.emailAuthImplementationAddr()),
    //         abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
    //         abi.encode(0x0)
    //     );

    //     vm.startPrank(someRelayer);
    //     vm.expectRevert(bytes("invalid guardian in email"));
    //     recoveryModule.handleRecovery(emailAuthMsg, templateIdx);
    //     vm.stopPrank();
    // }

    function testExpectRevertHandleRecoveryInvalidNewSigner() public {
        testHandleAcceptance();

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
        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        uint templateId = recoveryModule.computeRecoveryTemplateId(templateIdx);
        emailAuthMsg.templateId = templateId;
        bytes[] memory subjectParamsForRecovery = new bytes[](2);
        subjectParamsForRecovery[0] = abi.encode(simpleWallet);
        subjectParamsForRecovery[1] = abi.encode(address(0x0));
        emailAuthMsg.subjectParams = subjectParamsForRecovery;

        vm.mockCall(
            address(recoveryModule.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("invalid new signer"));
        recoveryModule.handleRecovery(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    function testRejectRecovery() public {
        vm.warp(block.timestamp + 3 days);

        testHandleRecovery();

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

    function testExpectRevertRejectRecoveryOwnableUnauthorizedAccount() public {
        testHandleRecovery();

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

        vm.startPrank(deployer);
        vm.expectRevert("recovery not in progress");
        recoveryModule.rejectRecovery();
        vm.stopPrank();
    }

    function testExpectRevertRejectRecoveryRecoveryNotInProgress() public {
        testHandleAcceptance();

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

        testHandleRecovery();

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
        testHandleRecovery();

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
        recoveryModule.completeRecovery(address(simpleWallet), new bytes(0));
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
        testHandleAcceptance();

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

        testHandleRecovery();

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
