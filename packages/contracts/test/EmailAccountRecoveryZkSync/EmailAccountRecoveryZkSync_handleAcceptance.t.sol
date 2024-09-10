// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.12;

// import "forge-std/Test.sol";
// import "forge-std/console.sol";
// import {EmailAuth, EmailAuthMsg} from "../../src/EmailAuth.sol";
// import {RecoveryControllerZkSync} from "../helpers/RecoveryControllerZkSync.sol";
// import {StructHelper} from "../helpers/StructHelper.sol";
// import {SimpleWallet} from "../helpers/SimpleWallet.sol";
// import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

// contract EmailAccountRecoveryZkSyncTest_handleAcceptance is StructHelper {
//     constructor() {}

//     function setUp() public override {
//         super.setUp();
//     }

//     function requestGuardian() public {
//         skipIfNotZkSync();

//         setUp();
//         require(
//             recoveryControllerZkSync.guardians(guardian) ==
//                 RecoveryControllerZkSync.GuardianStatus.NONE
//         );

//         vm.startPrank(deployer);
//         recoveryControllerZkSync.requestGuardian(guardian);
//         vm.stopPrank();

//         require(
//             recoveryControllerZkSync.guardians(guardian) ==
//                 RecoveryControllerZkSync.GuardianStatus.REQUESTED
//         );
//     }

//     function testHandleAcceptance() public {
//         skipIfNotZkSync();
        
//         requestGuardian();

//         console.log("guardian", guardian);

//         require(
//             recoveryControllerZkSync.guardians(guardian) ==
//                 RecoveryControllerZkSync.GuardianStatus.REQUESTED
//         );

//         uint templateIdx = 0;

//         EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
//         uint templateId = recoveryControllerZkSync.computeAcceptanceTemplateId(
//             templateIdx
//         );
//         emailAuthMsg.templateId = templateId;
//         bytes[] memory subjectParamsForAcceptance = new bytes[](1);
//         subjectParamsForAcceptance[0] = abi.encode(address(simpleWallet));
//         emailAuthMsg.subjectParams = subjectParamsForAcceptance;

//         vm.mockCall(
//             address(recoveryControllerZkSync.emailAuthImplementationAddr()),
//             abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
//             abi.encode(0x0)
//         );

//         // acceptGuardian is internal, we call handleAcceptance, which calls acceptGuardian internally.
//         vm.startPrank(someRelayer);
//         recoveryControllerZkSync.handleAcceptance(emailAuthMsg, templateIdx);
//         vm.stopPrank();

//         require(
//             recoveryControllerZkSync.guardians(guardian) ==
//                 RecoveryControllerZkSync.GuardianStatus.ACCEPTED
//         );
//     }

//     // Can not test recovery in progress using handleAcceptance
//     // Can not test invalid guardian using handleAcceptance

//     function testExpectRevertHandleAcceptanceGuardianStatusMustBeRequested()
//         public
//     {
//         skipIfNotZkSync();

//         requestGuardian();

//         require(
//             recoveryControllerZkSync.guardians(guardian) ==
//                 RecoveryControllerZkSync.GuardianStatus.REQUESTED
//         );

//         uint templateIdx = 0;

//         EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
//         uint templateId = recoveryControllerZkSync.computeAcceptanceTemplateId(
//             templateIdx
//         );
//         emailAuthMsg.templateId = templateId;
//         bytes[] memory subjectParamsForAcceptance = new bytes[](1);
//         subjectParamsForAcceptance[0] = abi.encode(address(simpleWallet));
//         emailAuthMsg.subjectParams = subjectParamsForAcceptance;
//         emailAuthMsg.proof.accountSalt = 0x0;

//         vm.mockCall(
//             address(recoveryControllerZkSync.emailAuthImplementationAddr()),
//             abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
//             abi.encode(0x0)
//         );

//         vm.startPrank(someRelayer);
//         vm.expectRevert(bytes("guardian status must be REQUESTED"));
//         recoveryControllerZkSync.handleAcceptance(emailAuthMsg, templateIdx);
//         vm.stopPrank();
//     }

//     function testExpectRevertHandleAcceptanceInvalidTemplateIndex() public {
//         skipIfNotZkSync();

//         requestGuardian();

//         require(
//             recoveryControllerZkSync.guardians(guardian) ==
//                 RecoveryControllerZkSync.GuardianStatus.REQUESTED
//         );

//         uint templateIdx = 1;

//         EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
//         uint templateId = recoveryControllerZkSync.computeAcceptanceTemplateId(
//             templateIdx
//         );
//         emailAuthMsg.templateId = templateId;
//         bytes[] memory subjectParamsForAcceptance = new bytes[](1);
//         subjectParamsForAcceptance[0] = abi.encode(address(simpleWallet));
//         emailAuthMsg.subjectParams = subjectParamsForAcceptance;

//         vm.mockCall(
//             address(recoveryControllerZkSync.emailAuthImplementationAddr()),
//             abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
//             abi.encode(0x0)
//         );

//         vm.startPrank(someRelayer);
//         vm.expectRevert(bytes("invalid template index"));
//         recoveryControllerZkSync.handleAcceptance(emailAuthMsg, templateIdx);
//         vm.stopPrank();
//     }

//     function testExpectRevertHandleAcceptanceInvalidSubjectParams() public {
//         skipIfNotZkSync();

//         requestGuardian();

//         require(
//             recoveryControllerZkSync.guardians(guardian) ==
//                 RecoveryControllerZkSync.GuardianStatus.REQUESTED
//         );

//         uint templateIdx = 0;

//         EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
//         uint templateId = recoveryControllerZkSync.computeAcceptanceTemplateId(
//             templateIdx
//         );
//         emailAuthMsg.templateId = templateId;
//         bytes[] memory subjectParamsForAcceptance = new bytes[](2);
//         subjectParamsForAcceptance[0] = abi.encode(address(simpleWallet));
//         subjectParamsForAcceptance[1] = abi.encode(address(simpleWallet));
//         emailAuthMsg.subjectParams = subjectParamsForAcceptance;

//         vm.mockCall(
//             address(recoveryControllerZkSync.emailAuthImplementationAddr()),
//             abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
//             abi.encode(0x0)
//         );

//         vm.startPrank(someRelayer);
//         vm.expectRevert(bytes("invalid subject params"));
//         recoveryControllerZkSync.handleAcceptance(emailAuthMsg, templateIdx);
//         vm.stopPrank();
//     }

//     function testExpectRevertHandleAcceptanceInvalidWalletAddressInEmail()
//         public
//     {
//         skipIfNotZkSync();

//         requestGuardian();

//         require(
//             recoveryControllerZkSync.guardians(guardian) ==
//                 RecoveryControllerZkSync.GuardianStatus.REQUESTED
//         );

//         uint templateIdx = 0;

//         EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
//         uint templateId = recoveryControllerZkSync.computeAcceptanceTemplateId(
//             templateIdx
//         );
//         emailAuthMsg.templateId = templateId;
//         bytes[] memory subjectParamsForAcceptance = new bytes[](1);
//         subjectParamsForAcceptance[0] = abi.encode(address(0x0));
//         emailAuthMsg.subjectParams = subjectParamsForAcceptance;

//         vm.mockCall(
//             address(recoveryControllerZkSync.emailAuthImplementationAddr()),
//             abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
//             abi.encode(0x0)
//         );

//         vm.startPrank(someRelayer);
//         vm.expectRevert(bytes("invalid account in email"));
//         recoveryControllerZkSync.handleAcceptance(emailAuthMsg, templateIdx);
//         vm.stopPrank();
//     }
// }
