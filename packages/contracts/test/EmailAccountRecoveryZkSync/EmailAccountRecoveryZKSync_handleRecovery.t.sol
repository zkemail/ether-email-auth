// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {EmailAuth, EmailAuthMsg} from "../../src/EmailAuth.sol";
import {RecoveryControllerZKSync} from "../helpers/RecoveryControllerZKSync.sol";
import {StructHelper} from "../helpers/StructHelper.sol";
import {SimpleWallet} from "../helpers/SimpleWallet.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract EmailAccountRecoveryZKSyncTest_handleRecovery is StructHelper {
    constructor() {}

    function setUp() public override {
        super.setUp();
    }

    function requestGuardian() public {
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

    function handleAcceptance() public {
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

    function testHandleRecovery() public {
        skipIfNotZkSync();

        handleAcceptance();

        assertEq(recoveryControllerZKSync.isRecovering(address(simpleWallet)), false);
        assertEq(
            recoveryControllerZKSync.currentTimelockOfAccount(address(simpleWallet)),
            0
        );
        assertEq(simpleWallet.owner(), deployer);
        assertEq(
            recoveryControllerZKSync.newSignerCandidateOfAccount(
                address(simpleWallet)
            ),
            address(0x0)
        );

        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        uint templateId = recoveryControllerZKSync.computeRecoveryTemplateId(
            templateIdx
        );
        emailAuthMsg.templateId = templateId;
        bytes[] memory subjectParamsForRecovery = new bytes[](2);
        subjectParamsForRecovery[0] = abi.encode(simpleWallet);
        subjectParamsForRecovery[1] = abi.encode(newSigner);
        emailAuthMsg.subjectParams = subjectParamsForRecovery;

        vm.mockCall(
            address(recoveryControllerZKSync.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        vm.startPrank(someRelayer);
        recoveryControllerZKSync.handleRecovery(emailAuthMsg, templateIdx);
        vm.stopPrank();

        assertEq(recoveryControllerZKSync.isRecovering(address(simpleWallet)), true);
        assertEq(simpleWallet.owner(), deployer);
        assertEq(
            recoveryControllerZKSync.newSignerCandidateOfAccount(
                address(simpleWallet)
            ),
            newSigner
        );
        assertEq(
            recoveryControllerZKSync.currentTimelockOfAccount(address(simpleWallet)),
            block.timestamp +
                recoveryControllerZKSync.timelockPeriodOfAccount(
                    address(simpleWallet)
                )
        );
    }

    function testExpectRevertHandleRecoveryGuardianIsNotDeployed() public {
        skipIfNotZkSync();

        handleAcceptance();

        assertEq(recoveryControllerZKSync.isRecovering(address(simpleWallet)), false);
        assertEq(
            recoveryControllerZKSync.currentTimelockOfAccount(address(simpleWallet)),
            0
        );
        assertEq(simpleWallet.owner(), deployer);
        assertEq(
            recoveryControllerZKSync.newSignerCandidateOfAccount(
                address(simpleWallet)
            ),
            address(0x0)
        );

        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        uint templateId = recoveryControllerZKSync.computeRecoveryTemplateId(
            templateIdx
        );
        emailAuthMsg.templateId = templateId;
        bytes[] memory subjectParamsForRecovery = new bytes[](2);
        subjectParamsForRecovery[0] = abi.encode(simpleWallet);
        subjectParamsForRecovery[1] = abi.encode(newSigner);
        emailAuthMsg.subjectParams = subjectParamsForRecovery;
        emailAuthMsg.proof.accountSalt = 0x0;

        vm.mockCall(
            address(recoveryControllerZKSync.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("guardian is not deployed"));
        recoveryControllerZKSync.handleRecovery(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    function testExpectRevertHandleRecoveryInvalidTemplateId() public {
        skipIfNotZkSync();

        handleAcceptance();

        assertEq(recoveryControllerZKSync.isRecovering(address(simpleWallet)), false);
        assertEq(
            recoveryControllerZKSync.currentTimelockOfAccount(address(simpleWallet)),
            0
        );
        assertEq(simpleWallet.owner(), deployer);
        assertEq(
            recoveryControllerZKSync.newSignerCandidateOfAccount(
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
            address(recoveryControllerZKSync.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("invalid template id"));
        recoveryControllerZKSync.handleRecovery(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    // Can not test recovery in progress using handleRecovery
    // Can not test invalid guardian using handleRecovery

    function testExpectRevertHandleRecoveryGuardianStatusMustBeAccepted()
        public
    {
        skipIfNotZkSync();

        handleAcceptance();

        assertEq(recoveryControllerZKSync.isRecovering(address(simpleWallet)), false);
        assertEq(
            recoveryControllerZKSync.currentTimelockOfAccount(address(simpleWallet)),
            0
        );
        assertEq(simpleWallet.owner(), deployer);
        assertEq(
            recoveryControllerZKSync.newSignerCandidateOfAccount(
                address(simpleWallet)
            ),
            address(0x0)
        );

        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        uint templateId = recoveryControllerZKSync.computeRecoveryTemplateId(
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
        recoveryControllerZKSync.handleRecovery(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    function testExpectRevertHandleRecoveryInvalidTemplateIndex() public {
        skipIfNotZkSync();

        handleAcceptance();

        assertEq(recoveryControllerZKSync.isRecovering(address(simpleWallet)), false);
        assertEq(
            recoveryControllerZKSync.currentTimelockOfAccount(address(simpleWallet)),
            0
        );
        assertEq(simpleWallet.owner(), deployer);
        assertEq(
            recoveryControllerZKSync.newSignerCandidateOfAccount(
                address(simpleWallet)
            ),
            address(0x0)
        );
        uint templateIdx = 1;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        uint templateId = recoveryControllerZKSync.computeRecoveryTemplateId(
            templateIdx
        );
        emailAuthMsg.templateId = templateId;
        bytes[] memory subjectParamsForRecovery = new bytes[](2);
        subjectParamsForRecovery[0] = abi.encode(simpleWallet);
        subjectParamsForRecovery[1] = abi.encode(newSigner);
        emailAuthMsg.subjectParams = subjectParamsForRecovery;

        vm.mockCall(
            address(recoveryControllerZKSync.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("invalid template index"));
        recoveryControllerZKSync.handleRecovery(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    function testExpectRevertHandleRecoveryInvalidSubjectParams() public {
        skipIfNotZkSync();

        handleAcceptance();

        assertEq(recoveryControllerZKSync.isRecovering(address(simpleWallet)), false);
        assertEq(
            recoveryControllerZKSync.currentTimelockOfAccount(address(simpleWallet)),
            0
        );
        assertEq(simpleWallet.owner(), deployer);
        assertEq(
            recoveryControllerZKSync.newSignerCandidateOfAccount(
                address(simpleWallet)
            ),
            address(0x0)
        );
        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        uint templateId = recoveryControllerZKSync.computeRecoveryTemplateId(
            templateIdx
        );
        emailAuthMsg.templateId = templateId;
        bytes[] memory subjectParamsForRecovery = new bytes[](3);
        subjectParamsForRecovery[0] = abi.encode(simpleWallet);
        subjectParamsForRecovery[1] = abi.encode(newSigner);
        subjectParamsForRecovery[1] = abi.encode(address(0x0));
        emailAuthMsg.subjectParams = subjectParamsForRecovery;

        vm.mockCall(
            address(recoveryControllerZKSync.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("invalid subject params"));
        recoveryControllerZKSync.handleRecovery(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }

    // function testExpectRevertHandleRecoveryInvalidGuardianInEmail() public {
    //     handleAcceptance();

    //     assertEq(recoveryControllerZKSync.isRecovering(address(simpleWallet)), false);
    //     assertEq(
    //         recoveryControllerZKSync.currentTimelockOfAccount(address(simpleWallet)),
    //         0
    //     );
    //     assertEq(simpleWallet.owner(), deployer);
    //     assertEq(
    //         recoveryControllerZKSync.newSignerCandidateOfAccount(address(simpleWallet)),
    //         address(0x0)
    //     );
    //     uint templateIdx = 0;

    //     EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
    //     uint templateId = recoveryControllerZKSync.computeRecoveryTemplateId(templateIdx);
    //     emailAuthMsg.templateId = templateId;
    //     bytes[] memory subjectParamsForRecovery = new bytes[](2);
    //     subjectParamsForRecovery[0] = abi.encode(address(0x0));
    //     subjectParamsForRecovery[1] = abi.encode(newSigner);
    //     emailAuthMsg.subjectParams = subjectParamsForRecovery;

    //     vm.mockCall(
    //         address(recoveryControllerZKSync.emailAuthImplementationAddr()),
    //         abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
    //         abi.encode(0x0)
    //     );

    //     vm.startPrank(someRelayer);
    //     vm.expectRevert(bytes("invalid guardian in email"));
    //     recoveryControllerZKSync.handleRecovery(emailAuthMsg, templateIdx);
    //     vm.stopPrank();
    // }

    function testExpectRevertHandleRecoveryInvalidNewSigner() public {
        skipIfNotZkSync();

        handleAcceptance();

        assertEq(recoveryControllerZKSync.isRecovering(address(simpleWallet)), false);
        assertEq(
            recoveryControllerZKSync.currentTimelockOfAccount(address(simpleWallet)),
            0
        );
        assertEq(simpleWallet.owner(), deployer);
        assertEq(
            recoveryControllerZKSync.newSignerCandidateOfAccount(
                address(simpleWallet)
            ),
            address(0x0)
        );
        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        uint templateId = recoveryControllerZKSync.computeRecoveryTemplateId(
            templateIdx
        );
        emailAuthMsg.templateId = templateId;
        bytes[] memory subjectParamsForRecovery = new bytes[](2);
        subjectParamsForRecovery[0] = abi.encode(simpleWallet);
        subjectParamsForRecovery[1] = abi.encode(address(0x0));
        emailAuthMsg.subjectParams = subjectParamsForRecovery;

        vm.mockCall(
            address(recoveryControllerZKSync.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("invalid new signer"));
        recoveryControllerZKSync.handleRecovery(emailAuthMsg, templateIdx);
        vm.stopPrank();
    }
}
