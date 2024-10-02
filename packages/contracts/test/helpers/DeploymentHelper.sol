// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {EmailAuth, EmailAuthMsg} from "../../src/EmailAuth.sol";
import {IVerifier} from "../../src/interfaces/IVerifier.sol";
import {Verifier} from "../../src/utils/Verifier.sol";
import {JwtVerifier} from "../../src/utils/JwtVerifier.sol";
import {EmailProof} from "../../src/interfaces/IVerifier.sol";
import {Groth16Verifier} from "../../src/utils/Groth16Verifier.sol";
import {JwtGroth16Verifier} from "../../src/utils/JwtGroth16Verifier.sol";
import {ECDSAOwnedDKIMRegistry} from "../../src/utils/ECDSAOwnedDKIMRegistry.sol";
import {UserOverrideableDKIMRegistry} from "@zk-email/contracts/UserOverrideableDKIMRegistry.sol";
import {JwtRegistry} from "../../src/utils/JwtRegistry.sol";
import {SimpleWallet} from "./SimpleWallet.sol";
import {RecoveryController, EmailAccountRecovery} from "./RecoveryController.sol";
import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

// // FOR_ZKSYNC:START
// import {ZKSyncCreate2Factory} from "../../src/utils/ZKSyncCreate2Factory.sol";
// import "../../src/utils/ForwardDKIMRegistry.sol";
// import {RecoveryControllerZKSync, EmailAccountRecoveryZKSync} from "./RecoveryControllerZKSync.sol";
// // FOR_ZKSYNC:END

contract DeploymentHelper is Test {
    using ECDSA for *;

    EmailAuth emailAuth;
    IVerifier verifier;
    IVerifier jwtVerifier;
    ECDSAOwnedDKIMRegistry dkim;
    UserOverrideableDKIMRegistry overrideableDkim;
    JwtRegistry jwtRegistry;
    RecoveryController recoveryController;
    RecoveryController jwtRecoveryController;
    SimpleWallet simpleWalletImpl;
    SimpleWallet simpleWallet;

    // // FOR_ZKSYNC:START
    // RecoveryControllerZKSync recoveryControllerZKSync;
    // // FOR_ZKSYNC:END

    address deployer = vm.addr(1);
    address receiver = vm.addr(2);
    address guardian;
    address newSigner = vm.addr(4);
    address someRelayer = vm.addr(5);

    bytes32 accountSalt;
    uint templateId;
    string[] commandTemplate;
    string[] newCommandTemplate;
    bytes mockProof = abi.encodePacked(bytes1(0x01));

    string selector = "12345";
    string domainName = "gmail.com";
    bytes32 publicKeyHash =
        0x0ea9c777dc7110e5a9e89b13f0cfc540e3845ba120b2b6dc24024d61488d4788;
    bytes32 emailNullifier =
        0x00a83fce3d4b1c9ef0f600644c1ecc6c8115b57b1596e0e3295e2c5105fbfd8a;

    function setUp() public virtual {
        vm.startPrank(deployer);
        address signer = deployer;

        // Create DKIM registry
        {
            ECDSAOwnedDKIMRegistry ecdsaDkimImpl = new ECDSAOwnedDKIMRegistry();
            ERC1967Proxy ecdsaDkimProxy = new ERC1967Proxy(
                address(ecdsaDkimImpl),
                abi.encodeCall(ecdsaDkimImpl.initialize, (deployer, signer))
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

        // Create userOverrideable dkim registry
        overrideableDkim = new UserOverrideableDKIMRegistry(deployer, deployer);
        overrideableDkim.setDKIMPublicKeyHash(
            domainName,
            publicKeyHash,
            deployer,
            new bytes(0)
        );

        // Create jwt dkim registry
        jwtRegistry = new JwtRegistry(deployer);
        jwtRegistry.setDKIMPublicKeyHash(
            "12345|https://example.com|client-id-12345",
            publicKeyHash
        );


        // Create Verifier
        {
            Verifier verifierImpl = new Verifier();
            console.log(
                "Verifier implementation deployed at: %s",
                address(verifierImpl)
            );
            Groth16Verifier groth16Verifier = new Groth16Verifier();
            ERC1967Proxy verifierProxy = new ERC1967Proxy(
                address(verifierImpl),
                abi.encodeCall(
                    verifierImpl.initialize,
                    (msg.sender, address(groth16Verifier))
                )
            );
            verifier = IVerifier(address(verifierProxy));
        }
        // Create JwtVerifier
        {
            JwtVerifier verifierImpl = new JwtVerifier();
            console.log(
                "JwtVerifier implementation deployed at: %s",
                address(verifierImpl)
            );
            JwtGroth16Verifier groth16Verifier = new JwtGroth16Verifier();
            ERC1967Proxy verifierProxy = new ERC1967Proxy(
                address(verifierImpl),
                abi.encodeCall(
                    verifierImpl.initialize,
                    (msg.sender, address(groth16Verifier))
                )
            );
            jwtVerifier = IVerifier(address(verifierProxy));
        }

        accountSalt = 0x2c3abbf3d1171bfefee99c13bf9c47f1e8447576afd89096652a34f27b297971;

        // Create EmailAuth implementation
        EmailAuth emailAuthImpl = new EmailAuth();
        emailAuth = emailAuthImpl;

        uint templateIdx = 0;
        templateId = uint256(keccak256(abi.encodePacked("TEST", templateIdx)));
        commandTemplate = ["Send", "{decimals}", "ETH", "to", "{ethAddr}"];
        newCommandTemplate = ["Send", "{decimals}", "USDC", "to", "{ethAddr}"];

        // Create RecoveryController as EmailAccountRecovery implementation
        RecoveryController recoveryControllerImpl = new RecoveryController();
        {
            ERC1967Proxy recoveryControllerProxy = new ERC1967Proxy(
                address(recoveryControllerImpl),
                abi.encodeCall(
                    recoveryControllerImpl.initialize,
                    (
                        signer,
                        address(verifier),
                        address(dkim),
                        address(emailAuthImpl)
                    )
                )
            );
            recoveryController = RecoveryController(
                payable(address(recoveryControllerProxy))
            );
        }
        // Create RecoveryController for JWT as EmailAccountRecovery implementation
        {
            ERC1967Proxy recoveryControllerProxy = new ERC1967Proxy(
                address(recoveryControllerImpl),
                abi.encodeCall(
                    recoveryControllerImpl.initialize,
                    (
                        signer,
                        address(jwtVerifier),
                        address(jwtRegistry),
                        address(emailAuthImpl)
                    )
                )
            );
            jwtRecoveryController = RecoveryController(
                payable(address(recoveryControllerProxy))
            );
        }

        // Create SimpleWallet
        simpleWalletImpl = new SimpleWallet();
        address recoveryControllerAddress = address(recoveryController);

        // // FOR_ZKSYNC:START
        // // Create zkSync Factory implementation
        // if (isZkSync()) {
        //     ZKSyncCreate2Factory factoryImpl = new ZKSyncCreate2Factory();
        //     // Create RecoveryControllerZKSync as EmailAccountRecovery implementation
        //     RecoveryControllerZKSync recoveryControllerZKSyncImpl = new RecoveryControllerZKSync();
        //     ERC1967Proxy recoveryControllerZKSyncProxy = new ERC1967Proxy(
        //         address(recoveryControllerZKSyncImpl),
        //         abi.encodeCall(
        //             recoveryControllerZKSyncImpl.initialize,
        //             (
        //                 signer,
        //                 address(verifier),
        //                 address(dkim),
        //                 address(emailAuthImpl),
        //                 address(factoryImpl)
        //             )
        //         )
        //     );
        //     recoveryControllerZKSync = RecoveryControllerZKSync(
        //         payable(address(recoveryControllerZKSyncProxy))
        //     );
        //     recoveryControllerAddress = address(recoveryControllerZKSync);
        // }
        // // FOR_ZKSYNC:END

        ERC1967Proxy simpleWalletProxy = new ERC1967Proxy(
            address(simpleWalletImpl),
            abi.encodeCall(
                simpleWalletImpl.initialize,
                (signer, recoveryControllerAddress)
            )
        );
        simpleWallet = SimpleWallet(payable(address(simpleWalletProxy)));
        vm.deal(address(simpleWallet), 1 ether);

        // Set guardian address
        guardian = EmailAccountRecovery(address(recoveryController))
            .computeEmailAuthAddress(address(simpleWallet), accountSalt);
        // // FOR_ZKSYNC:START
        // if (isZkSync()) {
        //     guardian = EmailAccountRecoveryZKSync(address(recoveryControllerZKSync))
        //         .computeEmailAuthAddress(address(simpleWallet), accountSalt);
        // }
        // // FOR_ZKSYNC:END

        vm.stopPrank();
    }

    function isZkSync() public view returns (bool) {
        return block.chainid == 324 || block.chainid == 300;
    }

    function skipIfZkSync() public {
        if (isZkSync()) {
            vm.skip(true);
        } else {
            vm.skip(false);
        }
    }

    function skipIfNotZkSync() public {
        if (!isZkSync()) {
            vm.skip(true);
        } else {
            vm.skip(false);
        }
    }
}
