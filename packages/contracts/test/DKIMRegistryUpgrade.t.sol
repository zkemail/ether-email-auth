// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "../src/EmailAuth.sol";
import "../src/utils/Verifier.sol";
import "../src/utils/ECDSAOwnedDKIMRegistry.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "./helpers/StructHelper.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {UserOverrideableDKIMRegistry} from "@zk-email/contracts/UserOverrideableDKIMRegistry.sol";

contract DKIMRegistryUpgradeTest is StructHelper {
    // function setUp() public override {
    //     super.setUp();
    //     vm.startPrank(deployer);
    //     emailAuth.initialize(deployer, accountSalt, deployer);
    //     vm.expectEmit(true, false, false, false);
    //     emit EmailAuth.VerifierUpdated(address(verifier));
    //     emailAuth.updateVerifier(address(verifier));
    //     vm.expectEmit(true, false, false, false);
    //     emit EmailAuth.DKIMRegistryUpdated(address(dkim));
    //     emailAuth.updateDKIMRegistry(address(dkim));
    //     UserOverrideableDKIMRegistry overrideableDkimImpl = new UserOverrideableDKIMRegistry();
    //     ERC1967Proxy overrideableDkimProxy = new ERC1967Proxy(
    //         address(overrideableDkimImpl),
    //         abi.encodeCall(
    //             overrideableDkimImpl.initialize,
    //             (deployer, deployer, setTimestampDelay)
    //         )
    //     );
    //     UserOverrideableDKIMRegistry overrideableDkim = UserOverrideableDKIMRegistry(
    //             address(overrideableDkimProxy)
    //         );
    //     overrideableDkim.setDKIMPublicKeyHash(
    //         domainName,
    //         publicKeyHash,
    //         deployer,
    //         new bytes(0)
    //     );
    //     dkim.upgradeToAndCall(
    //         address(overrideableDkimImpl),
    //         abi.encodeCall(
    //             forwardDkimImpl
    //                 .resetStorageForUpgradeFromECDSAOwnedDKIMRegistry,
    //             (address(overrideableDkim))
    //         )
    //     );
    //     vm.stopPrank();
    // }
    // function testDkimRegistryAddr() public view {
    //     address dkimAddr = emailAuth.dkimRegistryAddr();
    //     assertEq(dkimAddr, address(dkim));
    // }
    // function _testInsertCommandTemplate() private {
    //     emailAuth.insertCommandTemplate(templateId, commandTemplate);
    //     string[] memory result = emailAuth.getCommandTemplate(templateId);
    //     assertEq(result, commandTemplate);
    // }
    // function testAuthEmail() public {
    //     vm.startPrank(deployer);
    //     _testInsertCommandTemplate();
    //     EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
    //     vm.stopPrank();
    //     assertEq(
    //         emailAuth.usedNullifiers(emailAuthMsg.proof.emailNullifier),
    //         false
    //     );
    //     assertEq(emailAuth.lastTimestamp(), 0);
    //     vm.startPrank(deployer);
    //     vm.expectEmit(true, true, true, true);
    //     emit EmailAuth.EmailAuthed(
    //         emailAuthMsg.proof.emailNullifier,
    //         emailAuthMsg.proof.accountSalt,
    //         emailAuthMsg.proof.isCodeExist,
    //         emailAuthMsg.templateId
    //     );
    //     emailAuth.authEmail(emailAuthMsg);
    //     vm.stopPrank();
    //     assertEq(
    //         emailAuth.usedNullifiers(emailAuthMsg.proof.emailNullifier),
    //         true
    //     );
    //     assertEq(emailAuth.lastTimestamp(), emailAuthMsg.proof.timestamp);
    // }
}
