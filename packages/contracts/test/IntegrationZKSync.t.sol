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
import "../src/utils/Groth16Verifier.sol";
import "../src/utils/ECDSAOwnedDKIMRegistry.sol";
import "./helpers/SimpleWallet.sol";
import "./helpers/RecoveryControllerZKSync.sol";
import "forge-std/console.sol";
import "../src/utils/ZKSyncCreate2Factory.sol";

contract IntegrationZKSyncTest is Test {
    using Strings for *;
    using console for *;

    EmailAuth emailAuth;
    Verifier verifier;
    ECDSAOwnedDKIMRegistry dkim;

    RecoveryControllerZKSync recoveryControllerZKSync;
    SimpleWallet simpleWallet;

    address deployer = vm.addr(1);
    address receiver = vm.addr(2);
    address guardian = vm.addr(3);
    address relayer = deployer;

    bytes32 accountSalt;
    string selector = "12345";
    string domainName = "gmail.com";
    bytes32 publicKeyHash =
        0x0ea9c777dc7110e5a9e89b13f0cfc540e3845ba120b2b6dc24024d61488d4788;
    uint256 startTimestamp = 1723443691; // September 11, 2024, 17:34:51 UTC

    function setUp() public {
        vm.createSelectFork("http://127.0.0.1:8011");
    
        vm.warp(startTimestamp);

        vm.startPrank(deployer);
        address signer = deployer;

        // Create DKIM registry
        {
            ECDSAOwnedDKIMRegistry ecdsaDkimImpl = new ECDSAOwnedDKIMRegistry();
            ERC1967Proxy ecdsaDkimProxy = new ERC1967Proxy(
                address(ecdsaDkimImpl),
                abi.encodeCall(ecdsaDkimImpl.initialize, (msg.sender, signer))
            );
            dkim = ECDSAOwnedDKIMRegistry(address(ecdsaDkimProxy));
        }
        string memory signedMsg = dkim.computeSignedMsg(
            dkim.SET_PREFIX(),
            selector,
            domainName,
            publicKeyHash
        );
        bytes32 digest = MessageHashUtils.toEthSignedMessageHash(
            bytes(signedMsg)
        );
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(1, digest);
        bytes memory signature = abi.encodePacked(r, s, v);
        dkim.setDKIMPublicKeyHash(
            selector,
            domainName,
            publicKeyHash,
            signature
        );

        // Create Verifier
        {
            Verifier verifierImpl = new Verifier();
            Groth16Verifier groth16Verifier = new Groth16Verifier();
            ERC1967Proxy verifierProxy = new ERC1967Proxy(
                address(verifierImpl),
                abi.encodeCall(
                    verifierImpl.initialize,
                    (msg.sender, address(groth16Verifier))
                )
            );
            verifier = Verifier(address(verifierProxy));
        }

        // Create EmailAuth
        EmailAuth emailAuthImpl = new EmailAuth();
        console.log("emailAuthImpl");
        console.logAddress(address(emailAuthImpl));

        // Create zkSync Factory
        ZKSyncCreate2Factory factoryImpl = new ZKSyncCreate2Factory();
        console.log("factoryImpl");
        console.logAddress(address(factoryImpl));

        // Create RecoveryController as EmailAccountRecovery implementation
        RecoveryControllerZKSync recoveryControllerZKSyncImpl = new RecoveryControllerZKSync();
        ERC1967Proxy recoveryControllerZKSyncProxy = new ERC1967Proxy(
            address(recoveryControllerZKSyncImpl),
            abi.encodeCall(
                recoveryControllerZKSyncImpl.initialize,
                (
                    signer,
                    address(verifier),
                    address(dkim),
                    address(emailAuthImpl),
                    address(factoryImpl)
                )
            )
        );
        recoveryControllerZKSync = RecoveryControllerZKSync(
            payable(address(recoveryControllerZKSyncProxy))
        );

        // Create SimpleWallet as EmailAccountRecovery implementation
        SimpleWallet simpleWalletImpl = new SimpleWallet();
        ERC1967Proxy simpleWalletProxy = new ERC1967Proxy(
            address(simpleWalletImpl),
            abi.encodeCall(
                simpleWalletImpl.initialize,
                (signer, address(recoveryControllerZKSync))
            )
        );
        simpleWallet = SimpleWallet(payable(address(simpleWalletProxy)));
        // console.log(
        //     "emailAuthImplementation",
        //     simpleWallet.emailAuthImplementation()
        // );

        vm.stopPrank();
    }

    function testIntegration_Account_Recovery_ZkSync() public {
        console.log("testIntegration_Account_Recovery_ZKSync");

        bytes32 accountCode = 0x1162ebff40918afe5305e68396f0283eb675901d0387f97d21928d423aaa0b54;
        uint templateIdx = 0;

        vm.startPrank(relayer);
        vm.deal(address(relayer), 1 ether);

        console.log("SimpleWallet is at ", address(simpleWallet));
        assertEq(
            address(simpleWallet),
            0xc9a403a0f75924677Dc0b011Da7eD8dD902063A6
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
            "/test/emails/",
            block.chainid.toString(),
            "/accept.eml"
        );
        inputGenerationInput[2] = uint256(accountCode).toHexString(32);
        vm.ffi(inputGenerationInput);

        string memory publicInputFile = vm.readFile(
            string.concat(
                vm.projectRoot(),
                "/test/build_integration/email_auth_with_body_parsing_with_qp_encoding_public.json"
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
            .maskedCommand = "Accept guardian request for 0xc9a403a0f75924677Dc0b011Da7eD8dD902063A6";
        emailProof.emailNullifier = bytes32(vm.parseUint(pubSignals[10]));
        emailProof.accountSalt = bytes32(vm.parseUint(pubSignals[32]));
        accountSalt = emailProof.accountSalt;
        emailProof.isCodeExist = vm.parseUint(pubSignals[33]) == 1;
        emailProof.proof = proofToBytes(
            string.concat(
                vm.projectRoot(),
                "/test/build_integration/email_auth_with_body_parsing_with_qp_encoding_proof.json"
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

        // Call Request guardian -> GuardianStatus.REQUESTED
        guardian = recoveryControllerZKSync.computeEmailAuthAddress(
            address(simpleWallet),
            accountSalt
        );
        recoveryControllerZKSync.requestGuardian(guardian);
        require(
            recoveryControllerZKSync.guardians(guardian) ==
                RecoveryControllerZKSync.GuardianStatus.REQUESTED,
            "GuardianStatus should be REQUESTED"
        );

        // Call handleAcceptance -> GuardianStatus.ACCEPTED
        bytes[] memory commandParamsForAcceptance = new bytes[](1);
        commandParamsForAcceptance[0] = abi.encode(address(simpleWallet));
        EmailAuthMsg memory emailAuthMsg = EmailAuthMsg({
            templateId: recoveryControllerZKSync.computeAcceptanceTemplateId(
                templateIdx
            ),
            commandParams: commandParamsForAcceptance,
            skippedCommandPrefix: 0,
            proof: emailProof
        });
        recoveryControllerZKSync.handleAcceptance(emailAuthMsg, templateIdx);
        require(
            recoveryControllerZKSync.guardians(guardian) ==
                RecoveryControllerZKSync.GuardianStatus.ACCEPTED,
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
            "/test/emails/",
            block.chainid.toString(),
            "/recovery.eml"
        );
        inputGenerationInput[2] = uint256(accountCode).toHexString(32);
        vm.ffi(inputGenerationInput);

        publicInputFile = vm.readFile(
            string.concat(
                vm.projectRoot(),
                "/test/build_integration/email_auth_with_body_parsing_with_qp_encoding_public.json"
            )
        );
        pubSignals = abi.decode(vm.parseJson(publicInputFile), (string[]));

        // EmailProof memory emailProof;
        emailProof.domainName = "gmail.com";
        emailProof.publicKeyHash = bytes32(vm.parseUint(pubSignals[9]));
        emailProof.timestamp = vm.parseUint(pubSignals[11]);

        // 0xa0Ee7A142d267C1f36714E4a8F75612F20a79720 is account 9
        emailProof
            .maskedCommand = "Set the new signer of 0xc9a403a0f75924677Dc0b011Da7eD8dD902063A6 to 0xa0Ee7A142d267C1f36714E4a8F75612F20a79720";

        emailProof.emailNullifier = bytes32(vm.parseUint(pubSignals[10]));
        emailProof.accountSalt = bytes32(vm.parseUint(pubSignals[32]));
        require(
            emailProof.accountSalt == accountSalt,
            "accountSalt should be the same"
        );
        emailProof.isCodeExist = vm.parseUint(pubSignals[33]) == 1;
        emailProof.proof = proofToBytes(
            string.concat(
                vm.projectRoot(),
                "/test/build_integration/email_auth_with_body_parsing_with_qp_encoding_proof.json"
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
        bytes[] memory commandParamsForRecovery = new bytes[](2);
        commandParamsForRecovery[0] = abi.encode(address(simpleWallet));
        commandParamsForRecovery[1] = abi.encode(
            address(0xa0Ee7A142d267C1f36714E4a8F75612F20a79720)
        );
        emailAuthMsg = EmailAuthMsg({
            templateId: recoveryControllerZKSync.computeRecoveryTemplateId(
                templateIdx
            ),
            commandParams: commandParamsForRecovery,
            skippedCommandPrefix: 0,
            proof: emailProof
        });
        recoveryControllerZKSync.handleRecovery(emailAuthMsg, templateIdx);
        require(
            recoveryControllerZKSync.isRecovering(address(simpleWallet)),
            "isRecovering should be set"
        );
        require(
            recoveryControllerZKSync.newSignerCandidateOfAccount(
                address(simpleWallet)
            ) == 0xa0Ee7A142d267C1f36714E4a8F75612F20a79720,
            "newSignerCandidate should be set"
        );
        require(
            recoveryControllerZKSync.currentTimelockOfAccount(address(simpleWallet)) >
                0,
            "timelock should be set"
        );
        require(
            simpleWallet.owner() == simpleWalletOwner,
            "simpleWallet owner should be old one"
        );

        // Call completeRecovery
        // Warp at 3 days + 10 seconds later
        vm.warp(startTimestamp + (3 * 24 * 60 * 60) + 10);
        recoveryControllerZKSync.completeRecovery(
            address(simpleWallet),
            new bytes(0)
        );
        console.log("simpleWallet owner: ", simpleWallet.owner());
        require(
            !recoveryControllerZKSync.isRecovering(address(simpleWallet)),
            "isRecovering should be reset"
        );
        require(
            recoveryControllerZKSync.newSignerCandidateOfAccount(
                address(simpleWallet)
            ) == address(0),
            "newSignerCandidate should be reset"
        );
        require(
            recoveryControllerZKSync.currentTimelockOfAccount(
                address(simpleWallet)
            ) == 0,
            "timelock should be reset"
        );
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
