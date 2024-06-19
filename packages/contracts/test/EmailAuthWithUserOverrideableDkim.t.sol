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

contract EmailAuthWithUserOverrideableDkimTest is StructHelper {
    function setUp() public override {
        super.setUp();

        vm.startPrank(deployer);

        emailAuth.initialize(deployer, accountSalt, deployer);
        vm.expectEmit(true, false, false, false);
        emit EmailAuth.VerifierUpdated(address(verifier));
        emailAuth.updateVerifier(address(verifier));
        vm.expectEmit(true, false, false, false);
        emit EmailAuth.DKIMRegistryUpdated(address(overrideableDkim));
        emailAuth.updateDKIMRegistry(address(overrideableDkim));
        vm.stopPrank();
    }

    function testDkimRegistryAddr() public view {
        address dkimAddr = emailAuth.dkimRegistryAddr();
        assertEq(dkimAddr, address(overrideableDkim));
    }

    function _testInsertSubjectTemplate() private {
        emailAuth.insertSubjectTemplate(templateId, subjectTemplate);
        string[] memory result = emailAuth.getSubjectTemplate(templateId);
        assertEq(result, subjectTemplate);
    }

    function testAuthEmail() public {
        vm.startPrank(deployer);
        _testInsertSubjectTemplate();
        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        vm.stopPrank();

        assertEq(
            emailAuth.usedNullifiers(emailAuthMsg.proof.emailNullifier),
            false
        );
        assertEq(emailAuth.lastTimestamp(), 0);
        assertEq(emailAuth.authedHash(emailAuthMsg.proof.emailNullifier), 0x0);

        vm.startPrank(deployer);
        vm.expectEmit(true, true, true, true);
        emit EmailAuth.EmailAuthed(
            emailAuthMsg.proof.emailNullifier,
            bytes32(
                0x07db5f3c5c23bea55c416ae251bfb8a2128d110aa1738eefa90e7c84e1e0afd5
            ),
            emailAuthMsg.proof.accountSalt,
            emailAuthMsg.proof.isCodeExist,
            emailAuthMsg.templateId
        );
        bytes32 msgHash = emailAuth.authEmail(emailAuthMsg);
        assertEq(
            msgHash,
            0x07db5f3c5c23bea55c416ae251bfb8a2128d110aa1738eefa90e7c84e1e0afd5
        );
        vm.stopPrank();

        assertEq(
            emailAuth.usedNullifiers(emailAuthMsg.proof.emailNullifier),
            true
        );
        assertEq(emailAuth.lastTimestamp(), emailAuthMsg.proof.timestamp);
        assertEq(
            emailAuth.authedHash(emailAuthMsg.proof.emailNullifier),
            msgHash
        );
    }
}
