// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "@zk-email/contracts/DKIMRegistry.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../src/EmailAuth.sol";
import "../src/utils/Verifier.sol";
import "../src/utils/ECDSAOwnedDKIMRegistry.sol";
import "./helpers/SimpleWallet.sol";

import "forge-std/console.sol";

contract IntegrationTest is Test {
    using Strings for *;
    using console for *;
    // using SubjectUtils for *;
    using ECDSA for *;

    EmailAuth emailAuth;
    Verifier verifier;
    ECDSAOwnedDKIMRegistry dkim;
    SimpleWallet simpleWallet;

    address deployer = vm.addr(1);
    address receiver = vm.addr(2);
    address guardian = vm.addr(3);
    address relayer = deployer;

    bytes32 accountSalt;
    uint templateIdForAcceptance;
    uint templateIdForRecovery;
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
        vm.createSelectFork("https://mainnet.base.org");
        vm.warp(1711456824);

        vm.startPrank(deployer);
        address signer = deployer;

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
        // accountSalt = 0x2c3abbf3d1171bfefee99c13bf9c47f1e8447576afd89096652a34f27b297971;
        accountSalt = 0x0e3edbf1c5f3d1bd33504e7d71fc62134c2e92d56675eda1e2d515b6eb68021c;

        // Create EmailAuth
        EmailAuth emailAuthImpl = new EmailAuth();
        ERC1967Proxy emailAuthProxy = new ERC1967Proxy(
            address(emailAuthImpl),
            abi.encodeWithSelector(emailAuthImpl.initialize.selector, accountSalt)
        );
        emailAuth = EmailAuth(payable(address(emailAuthProxy)));
        emailAuth.updateVerifier(address(verifier));
        emailAuth.updateDKIMRegistry(address(dkim));

        // For integration testing we need to insert two templates
        uint templateIdx = 1;
        templateIdForAcceptance = uint256(keccak256(abi.encodePacked("ACCEPT", templateIdx)));
        subjectTemplate = ["Accept", "guardian", "request", "for", "{ethAddr}"];
        emailAuth.insertSubjectTemplate(templateIdForAcceptance, subjectTemplate);

        templateIdx = 2;
        templateIdForRecovery = uint256(keccak256(abi.encodePacked("RECOVERY", templateIdx)));
        subjectTemplate = ["Set", "the", "new", "signer", "of", "{ethAddr}", "to", "{ethAddr}"];
        emailAuth.insertSubjectTemplate(templateIdForRecovery, subjectTemplate);

        // Create SimpleWallet as EmailAccountRecovery implementation
        SimpleWallet simpleWalletImpl = new SimpleWallet(
            address(verifier),
            address(dkim),
            address(emailAuth)
        );
        ERC1967Proxy simpleWalletProxy = new ERC1967Proxy(
            address(simpleWalletImpl),
            abi.encodeWithSelector(simpleWalletImpl.initialize.selector)
        );
        simpleWallet = SimpleWallet(payable(address(simpleWalletProxy)));
        vm.deal(address(simpleWallet), 1 ether);
        vm.stopPrank();

    }

    function testIntegration_Account_Recovery() public {
        console.log("testIntegration_Account_Recovery");

        vm.startPrank(relayer);
        vm.deal(address(relayer), 1 ether);

        console.log("SimpleWallet is at ", address(simpleWallet));
        assertEq(address(simpleWallet), 0xaC361518Bb9535D0E3172DC45a4e56d71a7FDFc4);

        // Verify the email proof for acceptance
        string[] memory inputGenerationInput = new string[](3);
        inputGenerationInput[0] = string.concat(vm.projectRoot(), "/test/bin/accept.sh");
        inputGenerationInput[1] = string.concat(vm.projectRoot(), "/test/emails/accept.eml");
        // console.logString("function genEmailOpPartial");
        // console.logString("emailFile");
        // console.logString(emailFile);
        bytes32 accountCode = 0x1162ebff40918afe5305e68396f0283eb675901d0387f97d21928d423aaa0b54;
        inputGenerationInput[2] = uint256(accountCode).toHexString(32);
        vm.ffi(inputGenerationInput);

        string memory publicInputFile = vm.readFile(
            string.concat(vm.projectRoot(), "/test/build_integration/email_auth_public.json")
        );
        string[] memory pubSignals = abi.decode(vm.parseJson(publicInputFile), (string[]));
    
    
        EmailProof memory emailProof;
        emailProof.domainName = "gmail.com";
        emailProof.publicKeyHash = bytes32(vm.parseUint(pubSignals[9]));
        emailProof.timestamp = vm.parseUint(pubSignals[11]);
        emailProof.maskedSubject = "Accept guardian request for 0xaC361518Bb9535D0E3172DC45a4e56d71a7FDFc4";
        emailProof.emailNullifier = bytes32(vm.parseUint(pubSignals[10]));
        emailProof.accountSalt = bytes32(vm.parseUint(pubSignals[32]));
        emailProof.isCodeExist = vm.parseUint(pubSignals[33]) == 1;
        emailProof.proof = proofToBytes(
            string.concat(vm.projectRoot(), "/test/build_integration/email_auth_proof.json")
        );
        console.log("dkim public key hash: ");
        console.logBytes32(bytes32(vm.parseUint(pubSignals[9])));
        console.log("email nullifier: ");
        console.logBytes32(bytes32(vm.parseUint(pubSignals[10])));
        console.log("timestamp: ", vm.parseUint(pubSignals[11]));
        console.log("account salt: ");
        console.logBytes32(bytes32(vm.parseUint(pubSignals[32])));
        console.log("is code exist: ", vm.parseUint(pubSignals[33]));

        // Call Request guardian -> GuardianStatus.REQUESTED
        simpleWallet.requestGuardian(address(0xaC361518Bb9535D0E3172DC45a4e56d71a7FDFc4));

        // Call authEmail
        bytes[] memory subjectParamsForAcceptance = new bytes[](1);
        subjectParamsForAcceptance[0] = abi.encode(address(0xaC361518Bb9535D0E3172DC45a4e56d71a7FDFc4));
        EmailAuthMsg memory emailAuthMsg = EmailAuthMsg({
            templateId: templateIdForAcceptance,
            subjectParams: subjectParamsForAcceptance,
            skipedSubjectPrefix: 0,
            proof: emailProof
        });

        bytes32 messageHash = emailAuth.authEmail(emailAuthMsg);
        console.logBytes32(messageHash);
        assertEq(messageHash, 0x055636a81af06b90e75410636780ce041741567c7d8aef8e3bae3f5ee8d43102);

        // vm.removeFile(
        //     string.concat(vm.projectRoot(), "/test/build_integration/email_auth_public.json")
        // );
        // vm.removeFile(string.concat(vm.projectRoot(), "/test/build_integration/email_auth_proof.json"));

        // TODO: Accept guardian request -> GuardianStatus.ACCEPTED
        // simpleWallet.acceptGuardian(address(0xaC361518Bb9535D0E3172DC45a4e56d71a7FDFc4), templateIdForAccept, subjectParams, 0x0);
        
        // 
        // TODO: Process recovery 

        // Verify the email proof for recovery
        inputGenerationInput = new string[](3);
        inputGenerationInput[0] = string.concat(vm.projectRoot(), "/test/bin/recovery.sh");
        inputGenerationInput[1] = string.concat(vm.projectRoot(), "/test/emails/recovery.eml");
        accountCode = 0x1162ebff40918afe5305e68396f0283eb675901d0387f97d21928d423aaa0b54;
        inputGenerationInput[2] = uint256(accountCode).toHexString(32);
        vm.ffi(inputGenerationInput);

        publicInputFile = vm.readFile(
            string.concat(vm.projectRoot(), "/test/build_integration/email_auth_public.json")
        );
        pubSignals = abi.decode(vm.parseJson(publicInputFile), (string[]));

        emailProof.domainName = "gmail.com";
        emailProof.publicKeyHash = bytes32(vm.parseUint(pubSignals[9]));
        emailProof.timestamp = vm.parseUint(pubSignals[11]);
        emailProof.maskedSubject = "Set the new signer of 0xaC361518Bb9535D0E3172DC45a4e56d71a7FDFc4 to 0xa0Ee7A142d267C1f36714E4a8F75612F20a79720"; // 0xa0Ee7A142d267C1f36714E4a8F75612F20a79720 is account 9
        emailProof.emailNullifier = bytes32(vm.parseUint(pubSignals[10]));
        emailProof.accountSalt = bytes32(vm.parseUint(pubSignals[32]));
        emailProof.isCodeExist = vm.parseUint(pubSignals[33]) == 1;
        emailProof.proof = proofToBytes(
            string.concat(vm.projectRoot(), "/test/build_integration/email_auth_proof.json")
        );

        console.log("dkim public key hash: ");
        console.logBytes32(bytes32(vm.parseUint(pubSignals[9])));
        console.log("email nullifier: ");
        console.logBytes32(bytes32(vm.parseUint(pubSignals[10])));
        console.log("timestamp: ", vm.parseUint(pubSignals[11]));
        console.log("account salt: ");
        console.logBytes32(bytes32(vm.parseUint(pubSignals[32])));
        console.log("is code exist: ", vm.parseUint(pubSignals[33]));

        // Call authEmail
        bytes[] memory subjectParamsForRecovery = new bytes[](2);
        subjectParamsForRecovery[0] = abi.encode(address(0xaC361518Bb9535D0E3172DC45a4e56d71a7FDFc4));
        subjectParamsForRecovery[1] = abi.encode(address(0xa0Ee7A142d267C1f36714E4a8F75612F20a79720));
        emailAuthMsg = EmailAuthMsg({
            templateId: templateIdForRecovery,
            subjectParams: subjectParamsForRecovery,
            skipedSubjectPrefix: 0,
            proof: emailProof
        });

        messageHash = emailAuth.authEmail(emailAuthMsg);
        console.logBytes32(messageHash);
        assertEq(messageHash, 0x821374d786567df697f06246fb43c9d4d92998988733230baeb5ced4e7da7544);

        vm.stopPrank();
    }

    function proofToBytes(string memory proofPath) internal view returns (bytes memory) {
        string memory proofFile = vm.readFile(proofPath);
        string[] memory pi_a = abi.decode(vm.parseJson(proofFile, ".pi_a"), (string[]));
        uint256[2] memory pA = [vm.parseUint(pi_a[0]), vm.parseUint(pi_a[1])];
        string[][] memory pi_b = abi.decode(vm.parseJson(proofFile, ".pi_b"), (string[][]));
        uint256[2][2] memory pB = [
            [vm.parseUint(pi_b[0][1]), vm.parseUint(pi_b[0][0])],
            [vm.parseUint(pi_b[1][1]), vm.parseUint(pi_b[1][0])]
        ];
        string[] memory pi_c = abi.decode(vm.parseJson(proofFile, ".pi_c"), (string[]));
        uint256[2] memory pC = [vm.parseUint(pi_c[0]), vm.parseUint(pi_c[1])];
        bytes memory proof = abi.encode(pA, pB, pC);
        return proof;
    }


}
