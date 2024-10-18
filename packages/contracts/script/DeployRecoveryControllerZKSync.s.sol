// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "../test/helpers/SimpleWallet.sol";
import "../test/helpers/RecoveryControllerZKSync.sol";
import "../src/utils/Verifier.sol";
import "../src/utils/Groth16Verifier.sol";
import "../src/utils/ECDSAOwnedDKIMRegistry.sol";
// import "../src/utils/ForwardDKIMRegistry.sol";
import "../src/EmailAuth.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {ZKSyncCreate2Factory} from "../src/utils/ZKSyncCreate2Factory.sol";

contract Deploy is Script {
    using ECDSA for *;

    ECDSAOwnedDKIMRegistry dkim;
    Verifier verifier;
    EmailAuth emailAuthImpl;
    SimpleWallet simpleWallet;
    RecoveryControllerZKSync recoveryControllerZKSync;
    ZKSyncCreate2Factory factoryImpl;

    // UPDATE THIS: You must update this line
    bytes32 public proxyBytecodeHash = 0x0000000000000000000000000000000000000000000000000000000000000000;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        if (deployerPrivateKey == 0) {
            console.log("PRIVATE_KEY env var not set");
            return;
        }
        address signer = vm.envAddress("SIGNER");
        if (signer == address(0)) {
            console.log("SIGNER env var not set");
            return;
        }

        vm.startBroadcast(deployerPrivateKey);
        address initialOwner = vm.addr(deployerPrivateKey);

        // Deploy ECDSAOwned DKIM registry
        dkim = ECDSAOwnedDKIMRegistry(vm.envOr("ECDSA_DKIM", address(0)));
        if (address(dkim) == address(0)) {
            ECDSAOwnedDKIMRegistry ecdsaDkimImpl = new ECDSAOwnedDKIMRegistry();
            console.log(
                "ECDSAOwnedDKIMRegistry implementation deployed at: %s",
                address(ecdsaDkimImpl)
            );
            ERC1967Proxy ecdsaDkimProxy = new ERC1967Proxy(
                address(ecdsaDkimImpl),
                abi.encodeCall(ecdsaDkimImpl.initialize, (initialOwner, signer))
            );
            dkim = ECDSAOwnedDKIMRegistry(address(ecdsaDkimProxy));
            console.log(
                "ECDSAOwnedDKIMRegistry deployed at: %s",
                address(dkim)
            );
            vm.setEnv("ECDSA_DKIM", vm.toString(address(dkim)));
            // dkimImpl = new ForwardDKIMRegistry();
            // console.log(
            //     "ForwardDKIMRegistry implementation deployed at: %s",
            //     address(dkimImpl)
            // );
            // ERC1967Proxy dkimProxy = new ERC1967Proxy(
            //     address(dkimImpl),
            //     abi.encodeCall(dkimImpl.initialize, (initialOwner, signer))
            // );
            // dkim = ForwardDKIMRegistry(address(dkimProxy));
            // console.log("ForwardDKIMRegistry deployed at: %s", address(dkim));
            // vm.setEnv("DKIM", vm.toString(address(dkim)));
        }
        // Deploy Verifier
        verifier = Verifier(vm.envOr("VERIFIER", address(0)));
        if (address(verifier) == address(0)) {
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
                    (initialOwner, address(groth16Verifier))
                )
            );
            verifier = Verifier(address(verifierProxy));
            console.log("Verifier deployed at: %s", address(verifier));
            vm.setEnv("VERIFIER", vm.toString(address(verifier)));
        }

        // Deploy EmailAuth Implementation
        emailAuthImpl = EmailAuth(vm.envOr("EMAIL_AUTH_IMPL", address(0)));
        if (address(emailAuthImpl) == address(0)) {
            emailAuthImpl = new EmailAuth();
            console.log(
                "EmailAuth implementation deployed at: %s",
                address(emailAuthImpl)
            );
            vm.setEnv("EMAIL_AUTH_IMPL", vm.toString(address(emailAuthImpl)));
        }

        // Deploy Factory
        factoryImpl = ZKSyncCreate2Factory(vm.envOr("FACTORY", address(0)));
        if (address(factoryImpl) == address(0)) {
            factoryImpl = new ZKSyncCreate2Factory();
            console.log(
                "Factory implementation deployed at: %s",
                address(factoryImpl)
            );
            vm.setEnv("FACTORY", vm.toString(address(factoryImpl)));
        }

        // Create RecoveryControllerZKSync as EmailAccountRecovery implementation
        {
            RecoveryControllerZKSync recoveryControllerZKSyncImpl = new RecoveryControllerZKSync();
            ERC1967Proxy recoveryControllerZKSyncProxy = new ERC1967Proxy(
                address(recoveryControllerZKSyncImpl),
                abi.encodeCall(
                    recoveryControllerZKSyncImpl.initialize,
                    (
                        initialOwner,
                        address(verifier),
                        address(dkim),
                        address(emailAuthImpl),
                        address(factoryImpl),
                        proxyBytecodeHash
                    )
                )
            );
            recoveryControllerZKSync = RecoveryControllerZKSync(
                payable(address(recoveryControllerZKSyncProxy))
            );
            console.log(
                "RecoveryControllerZKSync deployed at: %s",
                address(recoveryControllerZKSync)
            );
            vm.setEnv(
                "RECOVERY_CONTROLLER_ZKSYNC",
                vm.toString(address(recoveryControllerZKSync))
            );
        }

        // Deploy SimpleWallet Implementation
        {
            SimpleWallet simpleWalletImpl = new SimpleWallet();
            console.log(
                "SimpleWallet implementation deployed at: %s",
                address(simpleWalletImpl)
            );
            vm.setEnv(
                "SIMPLE_WALLET_IMPL",
                vm.toString(address(simpleWalletImpl))
            );
            ERC1967Proxy simpleWalletProxy = new ERC1967Proxy(
                address(simpleWalletImpl),
                abi.encodeCall(
                    simpleWalletImpl.initialize,
                    (initialOwner, address(recoveryControllerZKSync))
                )
            );
            simpleWallet = SimpleWallet(payable(address(simpleWalletProxy)));
            console.log("SimpleWallet deployed at: %s", address(simpleWallet));
            vm.setEnv("SIMPLE_WALLET", vm.toString(address(simpleWallet)));
        }
        vm.stopBroadcast();
    }
}
