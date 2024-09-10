// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.12;

// import "forge-std/Test.sol";
// import "forge-std/console.sol";
// import {EmailAuth, EmailAuthMsg} from "../../src/EmailAuth.sol";
// import {RecoveryControllerZkSync} from "../helpers/RecoveryControllerZkSync.sol";
// import {StructHelper} from "../helpers/StructHelper.sol";
// import {SimpleWallet} from "../helpers/SimpleWallet.sol";
// import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

// contract EmailAccountRecoveryZkSyncTest_rejectRecovery is StructHelper {
//     constructor() {}

//     function setUp() public override {
//         super.setUp();
//     }

//     /**
//      * Set up functions
//      */
//     function requestGuardian() public {
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

//     function handleAcceptance() public {
//         requestGuardian();

//         require(
//             recoveryControllerZkSync.guardians(guardian) ==
//                 RecoveryControllerZkSync.GuardianStatus.REQUESTED
//         );

//         console.log("guardian", guardian);
//         uint templateIdx = 0;

//         EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
//         bytes[] memory subjectParamsForAcceptance = new bytes[](1);
//         subjectParamsForAcceptance[0] = abi.encode(address(simpleWallet));
//         emailAuthMsg.subjectParams = subjectParamsForAcceptance;
//         address recoveredAccount = recoveryControllerZkSync
//             .extractRecoveredAccountFromAcceptanceSubject(
//                 emailAuthMsg.subjectParams,
//                 templateIdx
//             );
//         address computedGuardian = recoveryControllerZkSync.computeEmailAuthAddress(
//             recoveredAccount,
//             emailAuthMsg.proof.accountSalt
//         );
//         console.log("computed guardian", computedGuardian);
//         uint templateId = recoveryControllerZkSync.computeAcceptanceTemplateId(
//             templateIdx
//         );
//         emailAuthMsg.templateId = templateId;

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

//     function handleRecovery() public {
//         handleAcceptance();

//         assertEq(simpleWallet.owner(), deployer);
//         assertEq(recoveryControllerZkSync.isRecovering(address(simpleWallet)), false);
//         assertEq(
//             recoveryControllerZkSync.currentTimelockOfAccount(address(simpleWallet)),
//             0
//         );
//         assertEq(
//             recoveryControllerZkSync.newSignerCandidateOfAccount(
//                 address(simpleWallet)
//             ),
//             address(0x0)
//         );

//         uint templateIdx = 0;

//         EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
//         uint templateId = recoveryControllerZkSync.computeRecoveryTemplateId(
//             templateIdx
//         );
//         emailAuthMsg.templateId = templateId;
//         bytes[] memory subjectParamsForRecovery = new bytes[](2);
//         subjectParamsForRecovery[0] = abi.encode(simpleWallet);
//         subjectParamsForRecovery[1] = abi.encode(newSigner);
//         emailAuthMsg.subjectParams = subjectParamsForRecovery;

//         vm.mockCall(
//             address(recoveryControllerZkSync.emailAuthImplementationAddr()),
//             abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
//             abi.encode(0x0)
//         );

//         vm.startPrank(someRelayer);
//         recoveryControllerZkSync.handleRecovery(emailAuthMsg, templateIdx);
//         vm.stopPrank();

//         assertEq(recoveryControllerZkSync.isRecovering(address(simpleWallet)), true);
//         assertEq(simpleWallet.owner(), deployer);
//         assertEq(
//             recoveryControllerZkSync.newSignerCandidateOfAccount(
//                 address(simpleWallet)
//             ),
//             newSigner
//         );
//         assertEq(
//             recoveryControllerZkSync.currentTimelockOfAccount(address(simpleWallet)),
//             block.timestamp +
//                 recoveryControllerZkSync.timelockPeriodOfAccount(
//                     address(simpleWallet)
//                 )
//         );
//     }

//     function testRejectRecovery() public {
//         skipIfNotZkSync();

//         vm.warp(block.timestamp + 3 days);

//         handleRecovery();

//         assertEq(recoveryControllerZkSync.isRecovering(address(simpleWallet)), true);
//         assertEq(
//             recoveryControllerZkSync.currentTimelockOfAccount(address(simpleWallet)),
//             block.timestamp +
//                 recoveryControllerZkSync.timelockPeriodOfAccount(
//                     address(simpleWallet)
//                 )
//         );
//         assertEq(simpleWallet.owner(), deployer);
//         assertEq(
//             recoveryControllerZkSync.newSignerCandidateOfAccount(
//                 address(simpleWallet)
//             ),
//             newSigner
//         );

//         vm.warp(0);

//         vm.startPrank(address(simpleWallet));
//         recoveryControllerZkSync.rejectRecovery();
//         vm.stopPrank();

//         assertEq(recoveryControllerZkSync.isRecovering(address(simpleWallet)), false);
//         assertEq(
//             recoveryControllerZkSync.currentTimelockOfAccount(address(simpleWallet)),
//             0
//         );
//         assertEq(simpleWallet.owner(), deployer);
//         assertEq(
//             recoveryControllerZkSync.newSignerCandidateOfAccount(
//                 address(simpleWallet)
//             ),
//             address(0x0)
//         );
//     }

//     function testExpectRevertRejectRecoveryRecoveryNotInProgress() public {
//         skipIfNotZkSync();

//         handleAcceptance();

//         assertEq(recoveryControllerZkSync.isRecovering(address(simpleWallet)), false);
//         assertEq(
//             recoveryControllerZkSync.currentTimelockOfAccount(address(simpleWallet)),
//             0
//         );
//         assertEq(simpleWallet.owner(), deployer);
//         assertEq(
//             recoveryControllerZkSync.newSignerCandidateOfAccount(
//                 address(simpleWallet)
//             ),
//             address(0x0)
//         );

//         vm.startPrank(deployer);
//         vm.expectRevert(bytes("recovery not in progress"));
//         recoveryControllerZkSync.rejectRecovery();
//         vm.stopPrank();
//     }

//     function testExpectRevertRejectRecovery() public {
//         skipIfNotZkSync();

//         vm.warp(block.timestamp + 1 days);

//         handleRecovery();

//         assertEq(recoveryControllerZkSync.isRecovering(address(simpleWallet)), true);
//         assertEq(
//             recoveryControllerZkSync.currentTimelockOfAccount(address(simpleWallet)),
//             block.timestamp +
//                 recoveryControllerZkSync.timelockPeriodOfAccount(
//                     address(simpleWallet)
//                 )
//         );
//         assertEq(simpleWallet.owner(), deployer);
//         assertEq(
//             recoveryControllerZkSync.newSignerCandidateOfAccount(
//                 address(simpleWallet)
//             ),
//             newSigner
//         );

//         vm.startPrank(address(simpleWallet));
//         vm.warp(block.timestamp + 4 days);
//         vm.expectRevert(bytes("timelock expired"));
//         recoveryControllerZkSync.rejectRecovery();
//         vm.stopPrank();
//     }

//     function testExpectRevertRejectRecoveryOwnableUnauthorizedAccount() public {
//         skipIfNotZkSync();

//         handleRecovery();

//         assertEq(recoveryControllerZkSync.isRecovering(address(simpleWallet)), true);
//         assertEq(
//             recoveryControllerZkSync.currentTimelockOfAccount(address(simpleWallet)),
//             block.timestamp +
//                 recoveryControllerZkSync.timelockPeriodOfAccount(
//                     address(simpleWallet)
//                 )
//         );
//         assertEq(simpleWallet.owner(), deployer);
//         assertEq(
//             recoveryControllerZkSync.newSignerCandidateOfAccount(
//                 address(simpleWallet)
//             ),
//             newSigner
//         );

//         vm.startPrank(deployer);
//         vm.expectRevert("recovery not in progress");
//         recoveryControllerZkSync.rejectRecovery();
//         vm.stopPrank();
//     }
// }
