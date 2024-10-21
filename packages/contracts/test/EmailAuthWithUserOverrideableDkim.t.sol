// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "../src/EmailAuth.sol";
import "../src/utils/Verifier.sol";
import "../src/utils/ECDSAOwnedDKIMRegistry.sol";
import "../src/utils/ForwardDKIMRegistry.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "./helpers/StructHelper.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract EmailAuthWithUserOverrideableDkimTest is StructHelper {
    ForwardDKIMRegistry forwardDkim;
    function setUp() public override {
        super.setUp();

        vm.startPrank(deployer);

        ForwardDKIMRegistry forwardDkimImpl = new ForwardDKIMRegistry();
        ERC1967Proxy forwardDKIMRegistryProxy = new ERC1967Proxy(
            address(forwardDkimImpl),
            abi.encodeCall(
                forwardDkimImpl.initializeWithUserOverrideableDKIMRegistry,
                (
                    deployer,
                    address(overrideableDkimImpl),
                    deployer,
                    setTimestampDelay
                )
            )
        );
        forwardDkim = ForwardDKIMRegistry(address(forwardDKIMRegistryProxy));
        UserOverrideableDKIMRegistry overrideableDkim = UserOverrideableDKIMRegistry(
                address(forwardDkim.sourceDKIMRegistry())
            );
        overrideableDkim.setDKIMPublicKeyHash(
            domainName,
            publicKeyHash,
            deployer,
            new bytes(0)
        );

        emailAuth.initialize(deployer, accountSalt, deployer);
        vm.expectEmit(true, false, false, false);
        emit EmailAuth.VerifierUpdated(address(verifier));
        emailAuth.updateVerifier(address(verifier));
        vm.expectEmit(true, false, false, false);
        emit EmailAuth.DKIMRegistryUpdated(address(forwardDkim));
        emailAuth.updateDKIMRegistry(address(forwardDkim));
        vm.stopPrank();
    }

    function _testInsertCommandTemplate() private {
        emailAuth.insertCommandTemplate(templateId, commandTemplate);
        string[] memory result = emailAuth.getCommandTemplate(templateId);
        assertEq(result, commandTemplate);
    }

    function testAuthEmail() public {
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
}
