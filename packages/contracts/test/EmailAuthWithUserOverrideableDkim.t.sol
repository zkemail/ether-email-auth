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
    UserOverrideableDKIMRegistry overrideableDkim;
    address emailAuthOwner = vm.addr(77);
    function setUp() public override {
        super.setUp();
        vm.startPrank(deployer);

        ERC1967Proxy overrideableDkimProxy = new ERC1967Proxy(
            address(overrideableDkimImpl),
            abi.encodeCall(
                overrideableDkimImpl.initialize,
                (deployer, deployer, setTimestampDelay)
            )
        );
        overrideableDkim = UserOverrideableDKIMRegistry(
            address(overrideableDkimProxy)
        );

        {
            ERC1967Proxy emailAuthProxy = new ERC1967Proxy(
                address(emailAuth),
                abi.encodeCall(
                    emailAuth.initialize,
                    (emailAuthOwner, accountSalt, deployer)
                )
            );
            emailAuth = EmailAuth(address(emailAuthProxy));
        }
        // emailAuth.initialize(emailAuthOwner, accountSalt, deployer);
        vm.expectEmit(true, false, false, false);
        emit EmailAuth.VerifierUpdated(address(verifier));
        emailAuth.initVerifier(address(verifier));
        vm.expectEmit(true, false, false, false);
        emit EmailAuth.DKIMRegistryUpdated(address(overrideableDkim));
        emailAuth.initDKIMRegistry(address(overrideableDkim));
        vm.stopPrank();
    }

    function _testInsertCommandTemplate() private {
        emailAuth.insertCommandTemplate(templateId, commandTemplate);
        string[] memory result = emailAuth.getCommandTemplate(templateId);
        assertEq(result, commandTemplate);
    }

    function testAuthEmailBeforeEnabled() public {
        vm.startPrank(deployer);
        _testInsertCommandTemplate();
        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        vm.stopPrank();

        assertEq(
            emailAuth.usedNullifiers(emailAuthMsg.proof.emailNullifier),
            false
        );
        assertEq(emailAuth.lastTimestamp(), 0);

        vm.startPrank(deployer);
        overrideableDkim.setDKIMPublicKeyHash(
            domainName,
            publicKeyHash,
            deployer,
            new bytes(0)
        );
        vm.stopPrank();

        vm.startPrank(emailAuthOwner);
        overrideableDkim.setDKIMPublicKeyHash(
            domainName,
            publicKeyHash,
            emailAuthOwner,
            new bytes(0)
        );
        vm.stopPrank();

        vm.startPrank(deployer);
        vm.expectEmit(true, true, true, true);
        emit EmailAuth.EmailAuthed(
            emailAuthMsg.proof.emailNullifier,
            emailAuthMsg.proof.accountSalt,
            emailAuthMsg.proof.isCodeExist,
            emailAuthMsg.templateId
        );
        emailAuth.authEmail(emailAuthMsg);
        vm.stopPrank();

        assertEq(
            emailAuth.usedNullifiers(emailAuthMsg.proof.emailNullifier),
            true
        );
        assertEq(emailAuth.lastTimestamp(), emailAuthMsg.proof.timestamp);
    }

    function testAuthEmailAfterEnabled() public {
        vm.startPrank(deployer);
        _testInsertCommandTemplate();
        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        vm.stopPrank();

        assertEq(
            emailAuth.usedNullifiers(emailAuthMsg.proof.emailNullifier),
            false
        );
        assertEq(emailAuth.lastTimestamp(), 0);

        vm.startPrank(deployer);
        overrideableDkim.setDKIMPublicKeyHash(
            domainName,
            publicKeyHash,
            deployer,
            new bytes(0)
        );
        vm.stopPrank();

        vm.warp(block.timestamp + setTimestampDelay + 1);

        vm.startPrank(deployer);
        vm.expectEmit(true, true, true, true);
        emit EmailAuth.EmailAuthed(
            emailAuthMsg.proof.emailNullifier,
            emailAuthMsg.proof.accountSalt,
            emailAuthMsg.proof.isCodeExist,
            emailAuthMsg.templateId
        );
        emailAuth.authEmail(emailAuthMsg);
        vm.stopPrank();

        assertEq(
            emailAuth.usedNullifiers(emailAuthMsg.proof.emailNullifier),
            true
        );
        assertEq(emailAuth.lastTimestamp(), emailAuthMsg.proof.timestamp);
    }

    function testFailAuthEmailBeforeEnabledWithoutUserApprove() public {
        vm.startPrank(deployer);
        _testInsertCommandTemplate();
        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        vm.stopPrank();

        assertEq(
            emailAuth.usedNullifiers(emailAuthMsg.proof.emailNullifier),
            false
        );
        assertEq(emailAuth.lastTimestamp(), 0);

        vm.startPrank(deployer);
        overrideableDkim.setDKIMPublicKeyHash(
            domainName,
            publicKeyHash,
            deployer,
            new bytes(0)
        );
        emailAuth.authEmail(emailAuthMsg);
        vm.stopPrank();

        assertEq(
            emailAuth.usedNullifiers(emailAuthMsg.proof.emailNullifier),
            true
        );
        assertEq(emailAuth.lastTimestamp(), emailAuthMsg.proof.timestamp);
    }
}
