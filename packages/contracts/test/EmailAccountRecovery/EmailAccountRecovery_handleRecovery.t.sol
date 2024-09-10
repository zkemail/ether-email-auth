// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {EmailAuth, EmailAuthMsg} from "../../src/EmailAuth.sol";
import {RecoveryController} from "../helpers/RecoveryController.sol";
import {StructHelper} from "../helpers/StructHelper.sol";
import {SimpleWallet} from "../helpers/SimpleWallet.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract EmailAccountRecoveryTest_handleRecovery is StructHelper {
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
        bytes[] memory subjectParamsForAcceptance = new bytes[](1);
        subjectParamsForAcceptance[0] = abi.encode(address(simpleWallet));
        emailAuthMsg.subjectParams = subjectParamsForAcceptance;

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

    function testHandleRecovery() public {
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

        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        uint templateId = recoveryController.computeRecoveryTemplateId(
            templateIdx
        );
        emailAuthMsg.templateId = templateId;
        bytes[] memory subjectParamsForRecovery = new bytes[](2);
        subjectParamsForRecovery[0] = abi.encode(simpleWallet);
        subjectParamsForRecovery[1] = abi.encode(newSigner);
        emailAuthMsg.subjectParams = subjectParamsForRecovery;

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

    function testExpectRevertHandleRecoveryGuardianIsNotDeployed() public {
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

        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        uint templateId = recoveryController.computeRecoveryTemplateId(
            templateIdx
        );
        emailAuthMsg.templateId = templateId;
        bytes[] memory subjectParamsForRecovery = new bytes[](2);
        subjectParamsForRecovery[0] = abi.encode(simpleWallet);
        subjectParamsForRecovery[1] = abi.encode(newSigner);
        emailAuthMsg.subjectParams = subjectParamsForRecovery;
        emailAuthMsg.proof.accountSalt = 0x0;

        vm.mockCall(
            address(recoveryController.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("guardian is not deployed"));
        recoveryController.handleRecovery(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    function testExpectRevertHandleRecoveryInvalidTemplateId() public {
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

        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        bytes[] memory subjectParamsForRecovery = new bytes[](2);
        subjectParamsForRecovery[0] = abi.encode(simpleWallet);
        subjectParamsForRecovery[1] = abi.encode(newSigner);
        emailAuthMsg.subjectParams = subjectParamsForRecovery;

        vm.mockCall(
            address(recoveryController.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("invalid template id"));
        recoveryController.handleRecovery(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    // Can not test recovery in progress using handleRecovery
    // Can not test invalid guardian using handleRecovery

    function testExpectRevertHandleRecoveryGuardianStatusMustBeAccepted()
        public
    {
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

        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        uint templateId = recoveryController.computeRecoveryTemplateId(
            templateIdx
        );
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
        recoveryController.handleRecovery(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    function testExpectRevertHandleRecoveryInvalidTemplateIndex() public {
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
        uint templateIdx = 1;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        uint templateId = recoveryController.computeRecoveryTemplateId(
            templateIdx
        );
        emailAuthMsg.templateId = templateId;
        bytes[] memory subjectParamsForRecovery = new bytes[](2);
        subjectParamsForRecovery[0] = abi.encode(simpleWallet);
        subjectParamsForRecovery[1] = abi.encode(newSigner);
        emailAuthMsg.subjectParams = subjectParamsForRecovery;

        vm.mockCall(
            address(recoveryController.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("invalid template index"));
        recoveryController.handleRecovery(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    function testExpectRevertHandleRecoveryInvalidSubjectParams() public {
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
        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        uint templateId = recoveryController.computeRecoveryTemplateId(
            templateIdx
        );
        emailAuthMsg.templateId = templateId;
        bytes[] memory subjectParamsForRecovery = new bytes[](3);
        subjectParamsForRecovery[0] = abi.encode(simpleWallet);
        subjectParamsForRecovery[1] = abi.encode(newSigner);
        subjectParamsForRecovery[1] = abi.encode(address(0x0));
        emailAuthMsg.subjectParams = subjectParamsForRecovery;

        vm.mockCall(
            address(recoveryController.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("invalid subject params"));
        recoveryController.handleRecovery(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    // function testExpectRevertHandleRecoveryInvalidGuardianInEmail() public {
    //     handleAcceptance();

    //     assertEq(recoveryController.isRecovering(address(simpleWallet)), false);
    //     assertEq(
    //         recoveryController.currentTimelockOfAccount(address(simpleWallet)),
    //         0
    //     );
    //     assertEq(simpleWallet.owner(), deployer);
    //     assertEq(
    //         recoveryController.newSignerCandidateOfAccount(address(simpleWallet)),
    //         address(0x0)
    //     );
    //     uint templateIdx = 0;

    //     EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
    //     uint templateId = recoveryController.computeRecoveryTemplateId(templateIdx);
    //     emailAuthMsg.templateId = templateId;
    //     bytes[] memory subjectParamsForRecovery = new bytes[](2);
    //     subjectParamsForRecovery[0] = abi.encode(address(0x0));
    //     subjectParamsForRecovery[1] = abi.encode(newSigner);
    //     emailAuthMsg.subjectParams = subjectParamsForRecovery;

    //     vm.mockCall(
    //         address(recoveryController.emailAuthImplementationAddr()),
    //         abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
    //         abi.encode(0x0)
    //     );

    //     vm.startPrank(someRelayer);
    //     vm.expectRevert(bytes("invalid guardian in email"));
    //     recoveryController.handleRecovery(emailAuthMsg, templateIdx);
    //     vm.stopPrank();
    // }

    function testExpectRevertHandleRecoveryInvalidNewSigner() public {
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
        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        uint templateId = recoveryController.computeRecoveryTemplateId(
            templateIdx
        );
        emailAuthMsg.templateId = templateId;
        bytes[] memory subjectParamsForRecovery = new bytes[](2);
        subjectParamsForRecovery[0] = abi.encode(simpleWallet);
        subjectParamsForRecovery[1] = abi.encode(address(0x0));
        emailAuthMsg.subjectParams = subjectParamsForRecovery;

        vm.mockCall(
            address(recoveryController.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("invalid new signer"));
        recoveryController.handleRecovery(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }
}
