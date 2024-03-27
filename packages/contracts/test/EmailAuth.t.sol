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

    function setUp() public override {
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
        vm.startPrank(deployer);
        ECDSAOwnedDKIMRegistry newDKIM = new ECDSAOwnedDKIMRegistry(msg.sender);
        emailAuth.updateDKIMRegistry(address(newDKIM));
        assertEq(emailAuth.dkimRegistryAddr(), address(newDKIM));
        vm.stopPrank();
    }

    function testUpdateVerifier() public {
        vm.startPrank(deployer);
        Verifier newVerifier = new Verifier();
        emailAuth.updateVerifier(address(newVerifier));
        assertEq(emailAuth.verifierAddr(), address(newVerifier));
        vm.stopPrank();
    }

    function testInsertSubjectTemplate() public {
        emailAuth.insertSubjectTemplate(templateId, subjectTemplate);
    }

    function testUpdateSubjectTemplate() public {
        vm.startPrank(deployer);
        this.testInsertSubjectTemplate();
        emailAuth.updateSubjectTemplate(templateId, newSubjectTemplate);
        vm.stopPrank();
    }

    function testDeleteSubjectTemplate() public {
        vm.startPrank(deployer);
        this.testInsertSubjectTemplate();
        emailAuth.deleteSubjectTemplate(templateId);
        vm.stopPrank();
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
            0xa1cb9e60072a3f949d2dda5912f1285c5b6acbf5bbff2013f723b345f1103ec2
        );
    }

    function testAuthEmail() public {
        vm.startPrank(deployer);
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
            0x9e288817af47043777650e858a595796e8ecf234eea355776d985165eb59b599
        );
        vm.stopPrank();
    }

    function testIsValidSignature() public {
        testAuthEmail();
        bytes32 msgHash = 0x9e288817af47043777650e858a595796e8ecf234eea355776d985165eb59b599;
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
