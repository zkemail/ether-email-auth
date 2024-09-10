// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.12;

// import "forge-std/Test.sol";
// import "forge-std/console.sol";
// import {EmailAuth, EmailAuthMsg} from "../../src/EmailAuth.sol";
// import {RecoveryController} from "../helpers/RecoveryController.sol";
// import {StructHelper} from "../helpers/StructHelper.sol";
// import {SimpleWallet} from "../helpers/SimpleWallet.sol";
// import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

// contract EmailAccountRecoveryZkSyncTest_recoverySubjectTemplates is StructHelper {
//     constructor() {}

//     function setUp() public override {
//         super.setUp();
//     }

//     function testRecoverySubjectTemplates() public {
//         skipIfNotZkSync();
       
//        setUp();
//         string[][] memory res = recoveryController.recoverySubjectTemplates();
//         assertEq(res[0][0], "Set");
//         assertEq(res[0][1], "the");
//         assertEq(res[0][2], "new");
//         assertEq(res[0][3], "signer");
//         assertEq(res[0][4], "of");
//         assertEq(res[0][5], "{ethAddr}");
//         assertEq(res[0][6], "to");
//         assertEq(res[0][7], "{ethAddr}");
//     }
// }
