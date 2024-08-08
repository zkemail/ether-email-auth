// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "../test/helpers/SimpleWallet.sol";
import "../test/helpers/RecoveryController.sol";
import "../src/utils/Verifier.sol";
import "../src/utils/ECDSAOwnedDKIMRegistry.sol";
import "../src/EmailAuth.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract Deploy is Script {
    using ECDSA for *;

    ECDSAOwnedDKIMRegistry dkimImpl;
    ECDSAOwnedDKIMRegistry dkim;
    Verifier verifierImpl;
    Verifier verifier;
    EmailAuth emailAuthImpl;
    SimpleWallet simpleWallet;
    RecoveryController recoveryController;

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

        bool isUpgradable = vm.envOr("UPGRADABLE", true);
        address initialOwner = address(0);
        if (isUpgradable) {
            initialOwner = signer;
        }

        vm.startBroadcast(deployerPrivateKey);

        // Deploy DKIM registry
        {
            dkimImpl = new ECDSAOwnedDKIMRegistry();
            console.log(
                "ECDSAOwnedDKIMRegistry implementation deployed at: %s",
                address(dkimImpl)
            );
            ERC1967Proxy dkimProxy = new ERC1967Proxy(
                address(dkimImpl),
                abi.encodeCall(dkimImpl.initialize, (initialOwner, signer))
            );
            dkim = ECDSAOwnedDKIMRegistry(address(dkimProxy));
            console.log(
                "ECDSAOwnedDKIMRegistry deployed at: %s",
                address(dkim)
            );
            vm.setEnv("DKIM", vm.toString(address(dkim)));
        }

        // Deploy Verifier
        {
            verifierImpl = new Verifier();
            console.log(
                "Verifier implementation deployed at: %s",
                address(verifierImpl)
            );
            ERC1967Proxy verifierProxy = new ERC1967Proxy(
                address(verifierImpl),
                abi.encodeCall(verifierImpl.initialize, (initialOwner))
            );
            verifier = Verifier(address(verifierProxy));
            console.log("Verifier deployed at: %s", address(verifier));
            vm.setEnv("VERIFIER", vm.toString(address(verifier)));
        }

        // Deploy EmailAuth Implementation
        {
            emailAuthImpl = new EmailAuth();
            console.log(
                "EmailAuth implementation deployed at: %s",
                address(emailAuthImpl)
            );
            vm.setEnv("EMAIL_AUTH_IMPL", vm.toString(address(emailAuthImpl)));
        }

        // Create RecoveryController as EmailAccountRecovery implementation
        {
            RecoveryController recoveryControllerImpl = new RecoveryController();
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
            console.log(
                "RecoveryController deployed at: %s",
                address(recoveryController)
            );
            vm.setEnv(
                "RECOVERY_CONTROLLER",
                vm.toString(address(recoveryController))
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
                    (signer, address(recoveryController))
                )
            );
            simpleWallet = SimpleWallet(payable(address(simpleWalletProxy)));
            console.log("SimpleWallet deployed at: %s", address(simpleWallet));
            vm.setEnv("SIMPLE_WALLET", vm.toString(address(simpleWallet)));
        }
        vm.stopBroadcast();
    }
}
