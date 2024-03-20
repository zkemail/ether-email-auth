// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "../src/EmailAuth.sol";
import "../src/utils/Verifier.sol";
import "../src/utils/ECDSAOwnedDKIMRegistry.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "./helpers/DeploymentHelper.sol";

contract EmailAuthTest is DeploymentHelper {

    function setUp() public override{
        super.setUp();
    }

    function testDkimRegistryAddr() public {
        address dkimAddr = emailAuth.dkimRegistryAddr();
        assertEq(dkimAddr, address(dkim));
    }

    function testVerifierAddr() public {
        address verifierAddr = emailAuth.verifierAddr();
        assertEq(verifierAddr, address(verifier));
    }

    function testUpdateDKIMRegistry() public {
        ECDSAOwnedDKIMRegistry newDKIM = new ECDSAOwnedDKIMRegistry(msg.sender);
        emailAuth.updateDKIMRegistry(address(newDKIM));
        assertEq(emailAuth.dkimRegistryAddr(), address(newDKIM));
    }

    function testUpdateVerifier() public {
        Verifier newVerifier = new Verifier();
        emailAuth.updateVerifier(address(newVerifier));
        assertEq(emailAuth.verifierAddr(), address(newVerifier));
    }

    function testInsertSubjectTemplate() public {
        emailAuth.insertSubjectTemplate(templateId, subjectTemplate);
    }

    function testUpdateSubjectTemplate() public {
        this.testInsertSubjectTemplate();
        emailAuth.updateSubjectTemplate(templateId, newSubjectTemplate);
    }

    function testDeleteSubjectTemplate() public {
        this.testInsertSubjectTemplate();
        emailAuth.deleteSubjectTemplate(templateId);
    }

    function testComputeMsgHash() public {
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
            0x8fa6859241092e7cf73d038bc981b370be69b49dc7bfcd91015308ed2c72d979
        );
    }

    function testAuthEmail() public {
        this.testInsertSubjectTemplate();

        bytes[] memory subjectParams = new bytes[](2);
        subjectParams[0] = abi.encode(1 ether);
        subjectParams[1] = abi.encode("0x0000000000000000000000000000000000000020");

        EmailProof memory emailProof = EmailProof({
            domainName: "gmail.com",
            publicKeyHash: publicKeyHash,
            timestamp: 1694989812,
            maskedSubject: "Send 1 ETH to 0x0000000000000000000000000000000000000020",
            emailNullifier: emailNullifier,
            accountSalt: accountSalt,
            isCodeExist: true,
            proof: mockProof
        });

        EmailAuthMsg memory emailAuthMsg = EmailAuthMsg({
            templateId: templateId,
            subjectParams: subjectParams,
            skipedSubjectPrefix: 0,
            proof: emailProof
        });

        vm.mockCall(
            address(verifier),
            abi.encodeWithSelector(
                Verifier.verifyEmailProof.selector,
                emailProof
            ),
            abi.encode(true)
        );
        bytes32 msgHash = emailAuth.authEmail(emailAuthMsg);
        assertEq(
            msgHash,
            0x97728a843151c01762d4f116e4d630f769faceda03589271805006ab8c512bcb
        );
    }

    function testIsValidSignature() public {
        testAuthEmail();
        bytes32 msgHash = 0x97728a843151c01762d4f116e4d630f769faceda03589271805006ab8c512bcb;
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
}
