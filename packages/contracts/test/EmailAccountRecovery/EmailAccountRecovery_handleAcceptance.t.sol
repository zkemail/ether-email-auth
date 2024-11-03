// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {EmailAuth, EmailAuthMsg} from "../../src/EmailAuth.sol";
import {RecoveryController} from "../helpers/RecoveryController.sol";
import {StructHelper} from "../helpers/StructHelper.sol";
import {SimpleWallet} from "../helpers/SimpleWallet.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {ERC1967Utils} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Utils.sol";

contract EmailAccountRecoveryTest_handleAcceptance is StructHelper {
    constructor() {}

    function setUp() public override {
        super.setUp();
    }

    function requestGuardian() public {
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

    function testExpectRevertHandleAcceptanceInvalidRecoveredAccount() public {
        skipIfZkSync();

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        emailAuthMsg.templateId = recoveryController
            .computeAcceptanceTemplateId(0);
        emailAuthMsg.commandParams[0] = abi.encode(address(0x0)); // Invalid account

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("invalid command params"));
        recoveryController.handleAcceptance(emailAuthMsg, 0);
        vm.stopPrank();
    }

    function testExpectRevertHandleAcceptanceInvalidTemplateId() public {
        skipIfZkSync();

        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        uint templateId = recoveryController.computeAcceptanceTemplateId(
            templateIdx
        );
        emailAuthMsg.templateId = 999; // invalid template id
        bytes[] memory commandParamsForAcceptance = new bytes[](1);
        commandParamsForAcceptance[0] = abi.encode(address(simpleWallet));
        emailAuthMsg.commandParams = commandParamsForAcceptance;

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("invalid template id"));
        recoveryController.handleAcceptance(emailAuthMsg, 0);
        vm.stopPrank();
    }

    function testExpectRevertHandleAcceptanceInvalidEmailAuthMsgStructure()
        public
    {
        skipIfZkSync();

        requestGuardian();

        require(
            recoveryController.guardians(guardian) ==
                RecoveryController.GuardianStatus.REQUESTED
        );

        uint templateIdx = 0;

        // Create an invalid EmailAuthMsg with empty commandParams
        EmailAuthMsg memory emailAuthMsg;
        emailAuthMsg.templateId = recoveryController
            .computeAcceptanceTemplateId(templateIdx);
        emailAuthMsg.commandParams = new bytes[](0); // Invalid structure

        vm.mockCall(
            address(recoveryController.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("invalid command params"));
        recoveryController.handleAcceptance(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    function testExpectRevertHandleAcceptanceInvalidVerifier() public {
        skipIfZkSync();

        requestGuardian();

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

        // Set Verifier address to address(0)
        vm.store(
            address(recoveryController),
            bytes32(uint256(0)), // Assuming Verifier is the 1st storage slot in RecoveryController
            bytes32(uint256(0))
        );

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("invalid verifier address"));
        recoveryController.handleAcceptance(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    function testExpectRevertHandleAcceptanceInvalidDKIMRegistry() public {
        skipIfZkSync();

        requestGuardian();

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

        // Set DKIMRegistry address to address(0)
        vm.store(
            address(recoveryController),
            bytes32(uint256(1)), // Assuming DKIMRegistry is the 2nd storage slot in RecoveryController
            bytes32(uint256(0))
        );

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("invalid dkim registry address"));
        recoveryController.handleAcceptance(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    function testExpectRevertHandleAcceptanceInvalidEmailAuthImplementationAddr()
        public
    {
        skipIfZkSync();

        requestGuardian();

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

        // Set EmailAuthImplementationAddr address to address(0)
        vm.store(
            address(recoveryController),
            bytes32(uint256(2)), // Assuming EmailAuthImplementationAddr is the 3rd storage slot in RecoveryController
            bytes32(uint256(0))
        );

        vm.startPrank(someRelayer);
        vm.expectRevert(
            abi.encodeWithSelector(
                ERC1967Utils.ERC1967InvalidImplementation.selector,
                address(0)
            )
        );
        recoveryController.handleAcceptance(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    function testExpectRevertHandleAcceptanceInvalidController() public {
        skipIfZkSync();

        // First, request and accept a guardian
        requestGuardian();
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

        vm.prank(someRelayer);
        recoveryController.handleAcceptance(emailAuthMsg, templateIdx);

        require(
            recoveryController.guardians(guardian) ==
                RecoveryController.GuardianStatus.ACCEPTED,
            "Guardian should be accepted"
        );

        // Now, set an invalid controller for the guardian's EmailAuth contract
        address invalidController = address(0x1234);
        vm.mockCall(
            guardian,
            abi.encodeWithSelector(bytes4(keccak256("controller()"))),
            abi.encode(invalidController)
        );

        // Try to handle acceptance again, which should fail due to invalid controller
        vm.expectRevert("invalid controller");
        vm.prank(someRelayer);
        recoveryController.handleAcceptance(emailAuthMsg, templateIdx);
    }

    function testHandleAcceptance() public {
        skipIfZkSync();

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

    // Can not test recovery in progress using handleAcceptance
    // Can not test invalid guardian using handleAcceptance

    function testExpectRevertHandleAcceptanceGuardianStatusMustBeRequested()
        public
    {
        skipIfZkSync();

        requestGuardian();

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
        emailAuthMsg.proof.accountSalt = 0x0;

        vm.mockCall(
            address(recoveryController.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("guardian status must be REQUESTED"));
        recoveryController.handleAcceptance(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    function testExpectRevertHandleAcceptanceInvalidTemplateIndex() public {
        skipIfZkSync();

        requestGuardian();

        require(
            recoveryController.guardians(guardian) ==
                RecoveryController.GuardianStatus.REQUESTED
        );

        uint templateIdx = 1;

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

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("invalid template index"));
        recoveryController.handleAcceptance(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    function testExpectRevertHandleAcceptanceInvalidCommandParams() public {
        skipIfZkSync();

        requestGuardian();

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
        bytes[] memory commandParamsForAcceptance = new bytes[](2);
        commandParamsForAcceptance[0] = abi.encode(address(simpleWallet));
        commandParamsForAcceptance[1] = abi.encode(address(simpleWallet));
        emailAuthMsg.commandParams = commandParamsForAcceptance;

        vm.mockCall(
            address(recoveryController.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("invalid command params"));
        recoveryController.handleAcceptance(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    function testExpectRevertHandleAcceptanceInvalidWalletAddressInEmail()
        public
    {
        skipIfZkSync();

        requestGuardian();

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
        commandParamsForAcceptance[0] = abi.encode(address(0x0));
        emailAuthMsg.commandParams = commandParamsForAcceptance;

        vm.mockCall(
            address(recoveryController.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("invalid account in email"));
        recoveryController.handleAcceptance(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }
}
