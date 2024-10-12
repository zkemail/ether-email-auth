// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {EmailAuth, EmailAuthMsg} from "../../src/EmailAuth.sol";
import {RecoveryController} from "../helpers/RecoveryController.sol";
import {StructHelper} from "../helpers/StructHelper.sol";
import {SimpleWallet} from "../helpers/SimpleWallet.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract EmailAccountRecoveryTest_jwt_handleRecovery is StructHelper {
    constructor() {}

    function setUp() public override {
        super.setUp();
    }

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
        skipIfZkSync();

        requestGuardian();

        console.log("jwtGuardian", jwtGuardian);

        require(
            jwtRecoveryController.guardians(jwtGuardian) ==
                RecoveryController.GuardianStatus.REQUESTED
        );

        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        uint templateId = jwtRecoveryController.computeAcceptanceTemplateId(
            templateIdx
        );
        emailAuthMsg.templateId = templateId;
        bytes[] memory commandParamsForAcceptance = new bytes[](1);
        commandParamsForAcceptance[0] = abi.encode(address(jwtSimpleWallet));
        emailAuthMsg.commandParams = commandParamsForAcceptance;

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

    function testHandleRecovery() public {
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

    function testExpectRevertHandleRecoveryGuardianIsNotDeployed() public {
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
        emailAuthMsg.proof.accountSalt = 0x0;

        vm.mockCall(
            address(jwtRecoveryController.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("guardian is not deployed"));
        jwtRecoveryController.handleRecovery(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    function testExpectRevertHandleRecoveryInvalidTemplateId() public {
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

        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
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
        vm.expectRevert(bytes("invalid template id"));
        jwtRecoveryController.handleRecovery(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    // Can not test recovery in progress using handleRecovery
    // Can not test invalid guardian using handleRecovery

    function testExpectRevertHandleRecoveryGuardianStatusMustBeAccepted()
        public
    {
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
        emailAuthMsg.proof.accountSalt = 0x0;

        // vm.mockCall(
        //     address(jwtSimpleWallet.emailAuthImplementationAddr()),
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
        jwtRecoveryController.handleRecovery(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    function testExpectRevertHandleRecoveryInvalidTemplateIndex() public {
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
        uint templateIdx = 1;

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
        vm.expectRevert(bytes("invalid template index"));
        jwtRecoveryController.handleRecovery(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    function testExpectRevertHandleRecoveryInvalidCommandParams() public {
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
        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        uint templateId = jwtRecoveryController.computeRecoveryTemplateId(
            templateIdx
        );
        emailAuthMsg.templateId = templateId;
        bytes[] memory commandParamsForRecovery = new bytes[](3);
        commandParamsForRecovery[0] = abi.encode(jwtSimpleWallet);
        commandParamsForRecovery[1] = abi.encode(newSigner);
        commandParamsForRecovery[1] = abi.encode(address(0x0));
        emailAuthMsg.commandParams = commandParamsForRecovery;

        vm.mockCall(
            address(jwtRecoveryController.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("invalid command params"));
        jwtRecoveryController.handleRecovery(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    // function testExpectRevertHandleRecoveryInvalidGuardianInEmail() public {
    //     handleAcceptance();

    //     assertEq(jwtRecoveryController.isRecovering(address(jwtSimpleWallet)), false);
    //     assertEq(
    //         jwtRecoveryController.currentTimelockOfAccount(address(jwtSimpleWallet)),
    //         0
    //     );
    //     assertEq(jwtSimpleWallet.owner(), deployer);
    //     assertEq(
    //         jwtRecoveryController.newSignerCandidateOfAccount(address(jwtSimpleWallet)),
    //         address(0x0)
    //     );
    //     uint templateIdx = 0;

    //     EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
    //     uint templateId = jwtRecoveryController.computeRecoveryTemplateId(templateIdx);
    //     emailAuthMsg.templateId = templateId;
    //     bytes[] memory commandParamsForRecovery = new bytes[](2);
    //     commandParamsForRecovery[0] = abi.encode(address(0x0));
    //     commandParamsForRecovery[1] = abi.encode(newSigner);
    //     emailAuthMsg.commandParams = commandParamsForRecovery;

    //     vm.mockCall(
    //         address(jwtRecoveryController.emailAuthImplementationAddr()),
    //         abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
    //         abi.encode(0x0)
    //     );

    //     vm.startPrank(someRelayer);
    //     vm.expectRevert(bytes("invalid guardian in email"));
    //     jwtRecoveryController.handleRecovery(emailAuthMsg, templateIdx);
    //     vm.stopPrank();
    // }

    function testExpectRevertHandleRecoveryInvalidNewSigner() public {
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
        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        uint templateId = jwtRecoveryController.computeRecoveryTemplateId(
            templateIdx
        );
        emailAuthMsg.templateId = templateId;
        bytes[] memory commandParamsForRecovery = new bytes[](2);
        commandParamsForRecovery[0] = abi.encode(jwtSimpleWallet);
        commandParamsForRecovery[1] = abi.encode(address(0x0));
        emailAuthMsg.commandParams = commandParamsForRecovery;

        vm.mockCall(
            address(jwtRecoveryController.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("invalid new signer"));
        jwtRecoveryController.handleRecovery(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }
}
