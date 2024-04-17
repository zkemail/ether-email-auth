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

contract EmailAuthTest is StructHelper {
    function setUp() public override {
        super.setUp();

        vm.startPrank(deployer);
        emailAuth.initialize(deployer, accountSalt);
        emailAuth.updateVerifier(address(verifier));
        emailAuth.updateDKIMRegistry(address(dkim));
        vm.stopPrank();
    }

    function testDkimRegistryAddr() public view {
        address dkimAddr = emailAuth.dkimRegistryAddr();
        assertEq(dkimAddr, address(dkim));
    }

    function testVerifierAddr() public view {
        address verifierAddr = emailAuth.verifierAddr();
        assertEq(verifierAddr, address(verifier));
    }

    function testUpdateDKIMRegistry() public {
        assertEq(emailAuth.dkimRegistryAddr(), address(dkim));

        vm.startPrank(deployer);
        ECDSAOwnedDKIMRegistry newDKIM = new ECDSAOwnedDKIMRegistry(msg.sender);
        emailAuth.updateDKIMRegistry(address(newDKIM));
        vm.stopPrank();

        assertEq(emailAuth.dkimRegistryAddr(), address(newDKIM));
    }

    function testExpectRevertUpdateDKIMRegistryInvalidDkimRegistryAddress()
        public
    {
        assertEq(emailAuth.dkimRegistryAddr(), address(dkim));

        vm.startPrank(deployer);
        vm.expectRevert(bytes("invalid dkim registry address"));
        emailAuth.updateDKIMRegistry(address(0));
        vm.stopPrank();
    }

    function testUpdateVerifier() public {
        assertEq(emailAuth.verifierAddr(), address(verifier));

        vm.startPrank(deployer);
        Verifier newVerifier = new Verifier();
        emailAuth.updateVerifier(address(newVerifier));
        vm.stopPrank();

        assertEq(emailAuth.verifierAddr(), address(newVerifier));
    }

    function testExpectRevertUpdateVerifierInvalidVerifierAddress() public {
        assertEq(emailAuth.verifierAddr(), address(verifier));

        vm.startPrank(deployer);
        vm.expectRevert(bytes("invalid verifier address"));
        emailAuth.updateVerifier(address(0));
        vm.stopPrank();
    }

    function testGetSubjectTemplate() public {
        emailAuth.insertSubjectTemplate(templateId, subjectTemplate);
        string[] memory result = emailAuth.getSubjectTemplate(templateId);
        assertEq(result, subjectTemplate);
    }

    function testExpectRevertGetSubjectTemplateTemplateIdNotExists() public {
        vm.expectRevert(bytes("template id not exists"));
        emailAuth.getSubjectTemplate(templateId);
    }

    function testInsertSubjectTemplate() public {
        emailAuth.insertSubjectTemplate(templateId, subjectTemplate);
        string[] memory result = emailAuth.getSubjectTemplate(templateId);
        assertEq(result, subjectTemplate);
    }

    function testExpectRevertInsertSubjectTemplateSubjectTemplateIsEmpty()
        public
    {
        string[] memory emptySubjectTemplate = new string[](0);
        vm.expectRevert(bytes("subject template is empty"));
        emailAuth.insertSubjectTemplate(templateId, emptySubjectTemplate);
    }

    function testExpectRevertInsertSubjectTemplateTemplateIdAlreadyExists()
        public
    {
        emailAuth.insertSubjectTemplate(templateId, subjectTemplate);
        string[] memory result = emailAuth.getSubjectTemplate(templateId);
        assertEq(result, subjectTemplate);

        vm.expectRevert(bytes("template id already exists"));
        emailAuth.insertSubjectTemplate(templateId, subjectTemplate);
    }

    function testUpdateSubjectTemplate() public {
        vm.expectRevert(bytes("template id not exists"));
        string[] memory result = emailAuth.getSubjectTemplate(templateId);

        vm.startPrank(deployer);
        this.testInsertSubjectTemplate();
        vm.stopPrank();

        result = emailAuth.getSubjectTemplate(templateId);
        assertEq(result, subjectTemplate);

        vm.startPrank(deployer);
        emailAuth.updateSubjectTemplate(templateId, newSubjectTemplate);
        vm.stopPrank();

        result = emailAuth.getSubjectTemplate(templateId);
        assertEq(result, newSubjectTemplate);
    }

    function testExpectRevertUpdateSubjectTemplateCallerIsNotTheOwner() public {
        vm.expectRevert(
            abi.encodeWithSelector(
                OwnableUpgradeable.OwnableUnauthorizedAccount.selector,
                address(this)
            )
        );
        emailAuth.updateSubjectTemplate(templateId, subjectTemplate);
    }

    function testExpectRevertUpdateSubjectTemplateSubjectTemplateIsEmpty()
        public
    {
        vm.startPrank(deployer);

        string[] memory emptySubjectTemplate = new string[](0);
        vm.expectRevert(bytes("subject template is empty"));
        emailAuth.updateSubjectTemplate(templateId, emptySubjectTemplate);

        vm.stopPrank();
    }

    function testExpectRevertUpdateSubjectTemplateTemplateIdNotExists() public {
        vm.startPrank(deployer);

        vm.expectRevert(bytes("template id not exists"));
        emailAuth.updateSubjectTemplate(templateId, subjectTemplate);

        vm.stopPrank();
    }

    function testDeleteSubjectTemplate() public {
        vm.startPrank(deployer);
        this.testInsertSubjectTemplate();
        vm.stopPrank();

        string[] memory result = emailAuth.getSubjectTemplate(templateId);
        assertEq(result, subjectTemplate);

        vm.startPrank(deployer);
        emailAuth.deleteSubjectTemplate(templateId);
        vm.stopPrank();

        vm.expectRevert(bytes("template id not exists"));
        emailAuth.getSubjectTemplate(templateId);
    }

    function testExpectRevertDeleteSubjectTemplateCallerIsNotTheOwner() public {
        vm.expectRevert(
            abi.encodeWithSelector(
                OwnableUpgradeable.OwnableUnauthorizedAccount.selector,
                address(this)
            )
        );
        emailAuth.deleteSubjectTemplate(templateId);
    }

    function testExpectRevertDeleteSubjectTemplateTemplateIdNotExists() public {
        vm.startPrank(deployer);
        vm.expectRevert(bytes("template id not exists"));
        emailAuth.deleteSubjectTemplate(templateId);
        vm.stopPrank();
    }

    function testComputeMsgHash() public view {
        bytes[] memory subjectParams = new bytes[](2);
        subjectParams[0] = abi.encode(1);
        subjectParams[1] = abi.encode(vm.addr(1));
        bytes32 msgHash = emailAuth.computeMsgHash(
            accountSalt,
            true,
            templateId,
            subjectParams
        );
        assertEq(
            msgHash,
            0x9eb0ca41b745b7ff94a261435d5746b08d6ecf68ba68630911958e3bb9bab8a1
        );
    }

    function testAuthEmail() public {
        vm.startPrank(deployer);
        this.testInsertSubjectTemplate();
        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        vm.stopPrank();

        assertEq(
            emailAuth.usedNullifiers(emailAuthMsg.proof.emailNullifier),
            false
        );
        assertEq(emailAuth.lastTimestamp(), 0);
        assertEq(emailAuth.authedHash(emailAuthMsg.proof.emailNullifier), 0x0);

        vm.startPrank(deployer);
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

    function testExpectRevertAuthEmailCallerIsNotTheOwner() public {
        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();

        assertEq(
            emailAuth.usedNullifiers(emailAuthMsg.proof.emailNullifier),
            false
        );
        assertEq(emailAuth.lastTimestamp(), 0);
        assertEq(emailAuth.authedHash(emailAuthMsg.proof.emailNullifier), 0x0);

        vm.expectRevert(
            abi.encodeWithSelector(
                OwnableUpgradeable.OwnableUnauthorizedAccount.selector,
                address(this)
            )
        );
        emailAuth.authEmail(emailAuthMsg);
    }

    function testExpectRevertAuthEmailTemplateIdNotExists() public {
        vm.startPrank(deployer);
        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        vm.stopPrank();

        assertEq(
            emailAuth.usedNullifiers(emailAuthMsg.proof.emailNullifier),
            false
        );
        assertEq(emailAuth.lastTimestamp(), 0);
        assertEq(emailAuth.authedHash(emailAuthMsg.proof.emailNullifier), 0x0);

        vm.startPrank(deployer);
        vm.expectRevert(bytes("template id not exists"));
        emailAuth.authEmail(emailAuthMsg);
        vm.stopPrank();
    }

    function testExpectRevertAuthEmailInvalidDkimPublicKeyHash() public {
        vm.startPrank(deployer);
        this.testInsertSubjectTemplate();
        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        vm.stopPrank();

        assertEq(
            emailAuth.usedNullifiers(emailAuthMsg.proof.emailNullifier),
            false
        );
        assertEq(emailAuth.lastTimestamp(), 0);
        assertEq(emailAuth.authedHash(emailAuthMsg.proof.emailNullifier), 0x0);

        vm.startPrank(deployer);
        emailAuthMsg.proof.domainName = "invalid.com";
        vm.expectRevert(bytes("invalid dkim public key hash"));
        emailAuth.authEmail(emailAuthMsg);
        vm.stopPrank();
    }

    function testExpectRevertAuthEmailEmailNullifierAlreadyUsed() public {
        vm.startPrank(deployer);
        this.testInsertSubjectTemplate();
        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        vm.stopPrank();

        assertEq(
            emailAuth.usedNullifiers(emailAuthMsg.proof.emailNullifier),
            false
        );
        assertEq(emailAuth.lastTimestamp(), 0);
        assertEq(emailAuth.authedHash(emailAuthMsg.proof.emailNullifier), 0x0);

        vm.startPrank(deployer);
        emailAuth.authEmail(emailAuthMsg);
        vm.expectRevert(bytes("email nullifier already used"));
        emailAuth.authEmail(emailAuthMsg);
        vm.stopPrank();
    }

    function testExpectRevertAuthEmailInvalidAccountSalt() public {
        vm.startPrank(deployer);
        this.testInsertSubjectTemplate();
        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        vm.stopPrank();

        assertEq(
            emailAuth.usedNullifiers(emailAuthMsg.proof.emailNullifier),
            false
        );
        assertEq(emailAuth.lastTimestamp(), 0);
        assertEq(emailAuth.authedHash(emailAuthMsg.proof.emailNullifier), 0x0);

        vm.startPrank(deployer);
        emailAuthMsg.proof.accountSalt = bytes32(uint256(1234));
        vm.expectRevert(bytes("invalid account salt"));
        emailAuth.authEmail(emailAuthMsg);
        vm.stopPrank();
    }

    function testExpectRevertAuthEmailInvalidTimestamp() public {
        vm.startPrank(deployer);
        this.testInsertSubjectTemplate();
        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        bytes32 msgHash = emailAuth.authEmail(emailAuthMsg);
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

        vm.startPrank(deployer);
        emailAuthMsg.proof.emailNullifier = 0x0;
        emailAuthMsg.proof.timestamp = 1694989812;
        vm.expectRevert(bytes("invalid timestamp"));
        emailAuth.authEmail(emailAuthMsg);

        vm.stopPrank();
    }

    function testExpectRevertAuthEmailInvalidSubject() public {
        vm.startPrank(deployer);
        this.testInsertSubjectTemplate();
        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        vm.stopPrank();

        assertEq(
            emailAuth.usedNullifiers(emailAuthMsg.proof.emailNullifier),
            false
        );
        assertEq(emailAuth.lastTimestamp(), 0);
        assertEq(emailAuth.authedHash(emailAuthMsg.proof.emailNullifier), 0x0);

        vm.startPrank(deployer);
        emailAuthMsg.subjectParams[0] = abi.encode(2 ether);
        vm.expectRevert(bytes("invalid subject"));
        emailAuth.authEmail(emailAuthMsg);
        vm.stopPrank();
    }

    function testExpectRevertAuthEmailInvalidEmailProof() public {
        vm.startPrank(deployer);
        this.testInsertSubjectTemplate();
        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        vm.stopPrank();

        assertEq(
            emailAuth.usedNullifiers(emailAuthMsg.proof.emailNullifier),
            false
        );
        assertEq(emailAuth.lastTimestamp(), 0);
        assertEq(emailAuth.authedHash(emailAuthMsg.proof.emailNullifier), 0x0);

        vm.startPrank(deployer);
        vm.mockCall(
            address(verifier),
            abi.encodeWithSelector(
                Verifier.verifyEmailProof.selector,
                emailAuthMsg.proof
            ),
            abi.encode(false)
        );
        vm.expectRevert(bytes("invalid email proof"));
        emailAuth.authEmail(emailAuthMsg);
        vm.stopPrank();
    }

    function testIsValidSignature() public {
        testAuthEmail();
        bytes32 msgHash = 0x07db5f3c5c23bea55c416ae251bfb8a2128d110aa1738eefa90e7c84e1e0afd5;
        bytes memory signature = abi.encodePacked(emailNullifier);
        bytes4 result = emailAuth.isValidSignature(msgHash, signature);
        assertEq(result, bytes4(0x1626ba7e));
    }

    function testIsValidSignatureReturnsFalse() public {
        testAuthEmail();
        bytes32 msgHash = 0x0;
        bytes memory signature = abi.encodePacked(emailNullifier);
        bytes4 result = emailAuth.isValidSignature(msgHash, signature);
        assertEq(result, bytes4(0xffffffff));
    }

    function testSetTimestampCheckEnabled() public {
        vm.startPrank(deployer);

        assertTrue(emailAuth.timestampCheckEnabled());
        emailAuth.setTimestampCheckEnabled(false);
        assertFalse(emailAuth.timestampCheckEnabled());

        vm.stopPrank();
    }

    function testExpectRevertSetTimestampCheckEnabled() public {
        vm.expectRevert(
            abi.encodeWithSelector(
                OwnableUpgradeable.OwnableUnauthorizedAccount.selector,
                address(this)
            )
        );
        emailAuth.setTimestampCheckEnabled(false);
    }
}
