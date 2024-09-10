// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.12;

// import "forge-std/Test.sol";
// import "forge-std/console.sol";
// import {EmailAuth, EmailAuthMsg} from "../../src/EmailAuth.sol";
// import {RecoveryControllerZkSync} from "../helpers/RecoveryControllerZkSync.sol";
// import {StructHelper} from "../helpers/StructHelper.sol";
// import {SimpleWallet} from "../helpers/SimpleWallet.sol";
// import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

// contract EmailAccountRecoveryZkSyncTest_requestGuardian is StructHelper {
//     constructor() {}

//     function setUp() public override {
//         super.setUp();
//     }

//     function testRequestGuardian() public {
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

//     // function testRequestGuardianNotOwner() public {
//     //     setUp();

//     //     require(
//     //         recoveryControllerZkSync.guardians(guardian) ==
//     //             recoveryControllerZkSync.GuardianStatus.NONE
//     //     );

//     //     vm.startPrank(receiver);
//     //     recoveryControllerZkSync.requestGuardian(guardian);
//     //     vm.stopPrank();

//     //     require(
//     //         recoveryControllerZkSync.guardians(guardian) ==
//     //             recoveryControllerZkSync.GuardianStatus.NONE
//     //     );
//     // }

//     function testExpectRevertRequestGuardianInvalidGuardian() public {
//         skipIfNotZkSync();

//         setUp();

//         require(
//             recoveryControllerZkSync.guardians(guardian) ==
//                 RecoveryControllerZkSync.GuardianStatus.NONE
//         );

//         vm.startPrank(deployer);
//         vm.expectRevert(bytes("invalid guardian"));
//         recoveryControllerZkSync.requestGuardian(address(0x0));
//         vm.stopPrank();
//     }

//     function testExpectRevertRequestGuardianGuardianStatusMustBeNone() public {
//         skipIfNotZkSync();

//         setUp();

//         require(
//             recoveryControllerZkSync.guardians(guardian) ==
//                 RecoveryControllerZkSync.GuardianStatus.NONE
//         );

//         vm.startPrank(deployer);
//         recoveryControllerZkSync.requestGuardian(guardian);
//         vm.expectRevert(bytes("guardian status must be NONE"));
//         recoveryControllerZkSync.requestGuardian(guardian);
//         vm.stopPrank();
//     }
// }
