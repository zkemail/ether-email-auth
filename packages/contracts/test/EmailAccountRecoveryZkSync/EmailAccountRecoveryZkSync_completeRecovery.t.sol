// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.12;

// import "forge-std/Test.sol";
// import "forge-std/console.sol";
// import {EmailAuth, EmailAuthMsg} from "../../src/EmailAuth.sol";
// import {RecoveryControllerZkSync} from "../helpers/RecoveryControllerZkSync.sol";
// import {StructHelper} from "../helpers/StructHelper.sol";
// import {SimpleWallet} from "../helpers/SimpleWallet.sol";
// import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

// contract EmailAccountRecoveryZkSyncTest_completeRecovery is StructHelper {
//     constructor() {}

//     function setUp() public override {
//         super.setUp();
//     }

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

//     function handleRecovery() public {
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

//     function testCompleteRecovery() public {
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

//         vm.startPrank(someRelayer);
//         vm.warp(4 days);
//         recoveryControllerZkSync.completeRecovery(
//             address(simpleWallet),
//             new bytes(0)
//         );
//         vm.stopPrank();

//         assertEq(recoveryControllerZkSync.isRecovering(address(simpleWallet)), false);
//         assertEq(
//             recoveryControllerZkSync.currentTimelockOfAccount(address(simpleWallet)),
//             0
//         );
//         assertEq(simpleWallet.owner(), newSigner);
//         assertEq(
//             recoveryControllerZkSync.newSignerCandidateOfAccount(
//                 address(simpleWallet)
//             ),
//             address(0x0)
//         );
//     }

//     function testExpectRevertCompleteRecoveryRecoveryNotInProgress() public {
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

//         vm.startPrank(someRelayer);
//         vm.warp(4 days);
//         vm.expectRevert(bytes("recovery not in progress"));
//         bytes memory recoveryCalldata;
//         recoveryControllerZkSync.completeRecovery(
//             address(simpleWallet),
//             recoveryCalldata
//         );

//         vm.stopPrank();
//     }

//     function testExpectRevertCompleteRecovery() public {
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

//         vm.startPrank(someRelayer);
//         vm.expectRevert(bytes("timelock not expired"));
//         bytes memory recoveryCalldata;
//         recoveryControllerZkSync.completeRecovery(
//             address(simpleWallet),
//             recoveryCalldata
//         );

//         vm.stopPrank();
//     }
// }
