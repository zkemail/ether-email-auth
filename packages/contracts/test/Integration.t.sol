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
    string[] subjectTemplate;
    string[] newSubjectTemplate;
    bytes mockProof = abi.encodePacked(bytes1(0x01));

    string selector = "12345";
    string domainName = "gmail.com";
    bytes32 publicKeyHash =
        0x0ea9c777dc7110e5a9e89b13f0cfc540e3845ba120b2b6dc24024d61488d4788;
    bytes32 emailNullifier =
        0x00a83fce3d4b1c9ef0f600644c1ecc6c8115b57b1596e0e3295e2c5105fbfd8a;
    uint256 startTimestamp = 1711197564; // Tue Mar 26 2024 12:40:24 GMT+0000

    function setUp() public {
        vm.createSelectFork("https://mainnet.base.org");
        vm.warp(startTimestamp);

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
        accountSalt = 0x0e3edbf1c5f3d1bd33504e7d71fc62134c2e92d56675eda1e2d515b6eb68021c;

        // Create EmailAuth
        EmailAuth emailAuthImpl = new EmailAuth();
        console.log("emailAuthImpl");
        console.logAddress(address(emailAuthImpl));

        // Create SimpleWallet as EmailAccountRecovery implementation
        SimpleWallet simpleWalletImpl = new SimpleWallet();

        ERC1967Proxy simpleWalletProxy = new ERC1967Proxy(
            address(simpleWalletImpl),
            abi.encodeWithSelector(
                simpleWalletImpl.initialize.selector,
                address(verifier),
                address(dkim),
                address(emailAuthImpl)
            )
        );
        simpleWallet = SimpleWallet(payable(address(simpleWalletProxy)));
        // console.log(
        //     "emailAuthImplementation",
        //     simpleWallet.emailAuthImplementation()
        // );

        vm.stopPrank();
    }

    function testIntegration_Account_Recovery() public {
        console.log("testIntegration_Account_Recovery");

        bytes32 accountCode = 0x1162ebff40918afe5305e68396f0283eb675901d0387f97d21928d423aaa0b54;
        uint templateIdx = 0;

        vm.startPrank(relayer);
        vm.deal(address(relayer), 1 ether);

        console.log("SimpleWallet is at ", address(simpleWallet));
        assertEq(
            address(simpleWallet),
            0x91eB86019FD8D7c5a9E31143D422850A13F670A3
        );
        address simpleWalletOwner = simpleWallet.owner();

        // Verify the email proof for acceptance
        string[] memory inputGenerationInput = new string[](3);
        inputGenerationInput[0] = string.concat(
            vm.projectRoot(),
            "/test/bin/accept.sh"
        );
        inputGenerationInput[1] = string.concat(
            vm.projectRoot(),
            "/test/emails/accept.eml"
        );
        inputGenerationInput[2] = uint256(accountCode).toHexString(32);
        vm.ffi(inputGenerationInput);

        string memory publicInputFile = vm.readFile(
            string.concat(
                vm.projectRoot(),
                "/test/build_integration/email_auth_public.json"
            )
        );
        string[] memory pubSignals = abi.decode(
            vm.parseJson(publicInputFile),
            (string[])
        );

        EmailProof memory emailProof;
        emailProof.domainName = "gmail.com";
        emailProof.publicKeyHash = bytes32(vm.parseUint(pubSignals[9]));
        emailProof.timestamp = vm.parseUint(pubSignals[11]);
        emailProof
            .maskedSubject = "Accept guardian request for 0xB5A85e22f83D6669e99816f88bE51F72FBc04901";
        emailProof.emailNullifier = bytes32(vm.parseUint(pubSignals[10]));
        emailProof.accountSalt = bytes32(vm.parseUint(pubSignals[32]));
        emailProof.isCodeExist = vm.parseUint(pubSignals[33]) == 1;
        emailProof.proof = proofToBytes(
            string.concat(
                vm.projectRoot(),
                "/test/build_integration/email_auth_proof.json"
            )
        );

        // Call Request guardian -> GuardianStatus.REQUESTED
        simpleWallet.requestGuardian(
            simpleWallet.computeEmailAuthAddress(accountSalt)
        );
        require(
            simpleWallet.guardians(
                simpleWallet.computeEmailAuthAddress(accountSalt)
            ) == SimpleWallet.GuardianStatus.REQUESTED,
            "GuardianStatus should be REQUESTED"
        );

        // Call handleAcceptance -> GuardianStatus.ACCEPTED
        bytes[] memory subjectParamsForAcceptance = new bytes[](1);
        subjectParamsForAcceptance[0] = abi.encode(
            simpleWallet.computeEmailAuthAddress(accountSalt)
        );
        EmailAuthMsg memory emailAuthMsg = EmailAuthMsg({
            templateId: simpleWallet.computeAcceptanceTemplateId(templateIdx),
            subjectParams: subjectParamsForAcceptance,
            skipedSubjectPrefix: 0,
            proof: emailProof
        });
        simpleWallet.handleAcceptance(emailAuthMsg, templateIdx);
        require(
            simpleWallet.guardians(
                simpleWallet.computeEmailAuthAddress(accountSalt)
            ) == SimpleWallet.GuardianStatus.ACCEPTED,
            "GuardianStatus should be ACCEPTED"
        );

        // Verify the email proof for recovery
        inputGenerationInput = new string[](3);
        inputGenerationInput[0] = string.concat(
            vm.projectRoot(),
            "/test/bin/recovery.sh"
        );
        inputGenerationInput[1] = string.concat(
            vm.projectRoot(),
            "/test/emails/recovery.eml"
        );
        inputGenerationInput[2] = uint256(accountCode).toHexString(32);
        vm.ffi(inputGenerationInput);

        publicInputFile = vm.readFile(
            string.concat(
                vm.projectRoot(),
                "/test/build_integration/email_auth_public.json"
            )
        );
        pubSignals = abi.decode(vm.parseJson(publicInputFile), (string[]));

        // EmailProof memory emailProof;
        emailProof.domainName = "gmail.com";
        emailProof.publicKeyHash = bytes32(vm.parseUint(pubSignals[9]));
        emailProof.timestamp = vm.parseUint(pubSignals[11]);
        emailProof
            .maskedSubject = "Set the new signer of 0x91eB86019FD8D7c5a9E31143D422850A13F670A3 to 0xa0Ee7A142d267C1f36714E4a8F75612F20a79720"; // 0xa0Ee7A142d267C1f36714E4a8F75612F20a79720 is account 9
        emailProof.emailNullifier = bytes32(vm.parseUint(pubSignals[10]));
        emailProof.accountSalt = bytes32(vm.parseUint(pubSignals[32]));
        emailProof.isCodeExist = vm.parseUint(pubSignals[33]) == 1;
        emailProof.proof = proofToBytes(
            string.concat(
                vm.projectRoot(),
                "/test/build_integration/email_auth_proof.json"
            )
        );

        console.log("dkim public key hash: ");
        console.logBytes32(bytes32(vm.parseUint(pubSignals[9])));
        console.log("email nullifier: ");
        console.logBytes32(bytes32(vm.parseUint(pubSignals[10])));
        console.log("timestamp: ", vm.parseUint(pubSignals[11]));
        console.log("account salt: ");
        console.logBytes32(bytes32(vm.parseUint(pubSignals[32])));
        console.log("is code exist: ", vm.parseUint(pubSignals[33]));

        // Call handleRecovery -> isRecovering = true;
        bytes[] memory subjectParamsForRecovery = new bytes[](2);
        subjectParamsForRecovery[0] = abi.encode(address(simpleWallet));
        subjectParamsForRecovery[1] = abi.encode(
            address(0xa0Ee7A142d267C1f36714E4a8F75612F20a79720)
        );
        emailAuthMsg = EmailAuthMsg({
            templateId: simpleWallet.computeRecoveryTemplateId(templateIdx),
            subjectParams: subjectParamsForRecovery,
            skipedSubjectPrefix: 0,
            proof: emailProof
        });
        simpleWallet.handleRecovery(emailAuthMsg, templateIdx);
        require(simpleWallet.isRecovering(), "isRecovering should be set");
        require(simpleWallet.newSignerCandidate() == 0xa0Ee7A142d267C1f36714E4a8F75612F20a79720, "newSignerCandidate should be set");
        require(simpleWallet.timelock() > 0, "timelock should be set");
        require(
            simpleWallet.owner() == simpleWalletOwner,
            "simpleWallet owner should be old one"
        );

        // Call completeRecovery
        // Warp at 3 days + 10 seconds later
        vm.warp(startTimestamp + (3 * 24 * 60 * 60) + 10);
        simpleWallet.completeRecovery();
        console.log("simpleWallet owner: ", simpleWallet.owner());
        require(!simpleWallet.isRecovering(), "isRecovering should be reset");
        require(simpleWallet.newSignerCandidate() == address(0), "newSignerCandidate should be reset");
        require(simpleWallet.timelock() == 0, "timelock should be reset");
        require(
            simpleWallet.owner() == 0xa0Ee7A142d267C1f36714E4a8F75612F20a79720,
            "simpleWallet owner should be new one"
        );
        vm.stopPrank();
    }

    function proofToBytes(
        string memory proofPath
    ) internal view returns (bytes memory) {
        string memory proofFile = vm.readFile(proofPath);
        string[] memory pi_a = abi.decode(
            vm.parseJson(proofFile, ".pi_a"),
            (string[])
        );
        uint256[2] memory pA = [vm.parseUint(pi_a[0]), vm.parseUint(pi_a[1])];
        string[][] memory pi_b = abi.decode(
            vm.parseJson(proofFile, ".pi_b"),
            (string[][])
        );
        uint256[2][2] memory pB = [
            [vm.parseUint(pi_b[0][1]), vm.parseUint(pi_b[0][0])],
            [vm.parseUint(pi_b[1][1]), vm.parseUint(pi_b[1][0])]
        ];
        string[] memory pi_c = abi.decode(
            vm.parseJson(proofFile, ".pi_c"),
            (string[])
        );
        uint256[2] memory pC = [vm.parseUint(pi_c[0]), vm.parseUint(pi_c[1])];
        bytes memory proof = abi.encode(pA, pB, pC);
        return proof;
    }
}
