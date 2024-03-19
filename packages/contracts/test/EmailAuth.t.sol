// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "../src/EmailAuth.sol";
import "../src/utils/Verifier.sol";
import "../src/utils/ECDSAOwnedDKIMRegistry.sol";

contract EmailAuthTest is Test {
    using ECDSA for *;

    EmailAuth emailAuth;
    Verifier verifier;
    ECDSAOwnedDKIMRegistry dkim;

    bytes32 accountSalt;
    uint templateId;
    string[] subjectTemplate;
    string[] newSubjectTemplate;
    bytes mockProof = abi.encodePacked(bytes1(0x01));

    string selector = "12345";
    string domainName = "gmail.com";
    bytes32 publicKeyHash =
        0x0ea9c777dc7110e5a9e89b13f0cfc540e3845ba120b2b6dc24024d61488d4788;
    bytes32 emailNullifier =
        0x00a83fce3d4b1c9ef0f600644c1ecc6c8115b57b1596e0e3295e2c5105fbfd8a;
    function setUp() public {
        address signer = vm.addr(1);

        // Create DKIM registry
        dkim = new ECDSAOwnedDKIMRegistry(signer);
        string memory signedMsg = dkim.computeSignedMsg(
            dkim.SET_PREFIX(),
            selector,
            domainName,
            publicKeyHash
        );
        bytes32 digest = bytes(signedMsg).toEthSignedMessageHash();
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(1, digest);
        bytes memory signature = abi.encodePacked(r, s, v);
        dkim.setDKIMPublicKeyHash(
            selector,
            domainName,
            publicKeyHash,
            signature
        );

        // Create Verifier
        verifier = new Verifier();
        accountSalt = 0x2c3abbf3d1171bfefee99c13bf9c47f1e8447576afd89096652a34f27b297971;

        // Create EmailAuth
        emailAuth = new EmailAuth(accountSalt);
        emailAuth.updateVerifier(address(verifier));
        emailAuth.updateDKIMRegistry(address(dkim));

        templateId = 1;
        subjectTemplate = ["Send", "{decimals}", "ETH", "to", "{string}"];
        newSubjectTemplate = ["Send", "{decimals}", "USDC", "to", "{string}"];
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
            0xe7f92de45c5ad2716ecefebf444d57aba480764d104b92d2a1bb7820f344bb22
        );
    }

    function testAuthEmail() public {
        this.testInsertSubjectTemplate();

        bytes[] memory subjectParams = new bytes[](2);
        subjectParams[0] = abi.encode(1);
        subjectParams[1] = abi.encode("alice@gmail.com");

        EmailProof memory emailProof = EmailProof({
            domainName: "gmail.com",
            publicKeyHash: publicKeyHash,
            timestamp: 1694989812,
            maskedSubject: "Send 1 ETH to alice@gmail.com",
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
            0x8f11137c4bc94c224197349b9ebc44da5e5b9786d4a0117ea5794b5a90d51968
        );
    }

    function testIsValidSignature() public {
        testAuthEmail();
        bytes32 msgHash = 0x8f11137c4bc94c224197349b9ebc44da5e5b9786d4a0117ea5794b5a90d51968;
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
