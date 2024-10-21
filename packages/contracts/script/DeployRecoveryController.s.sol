// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "../test/helpers/SimpleWallet.sol";
import "../test/helpers/RecoveryController.sol";
import "../src/utils/Verifier.sol";
import "../src/utils/Groth16Verifier.sol";
import "../src/EmailAuth.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {UserOverrideableDKIMRegistry} from "@zk-email/contracts/UserOverrideableDKIMRegistry.sol";

contract Deploy is Script {
    using ECDSA for *;

    UserOverrideableDKIMRegistry dkim;
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

        vm.startBroadcast(deployerPrivateKey);
        address initialOwner = vm.addr(deployerPrivateKey);

        // Deploy Useroverridable and Forward DKIM registries
        dkim = UserOverrideableDKIMRegistry(vm.envOr("DKIM", address(0)));
        uint setTimeDelay = vm.envOr("DKIM_DELAY", uint(0));
        console.log("DKIM_DELAY: %s", setTimeDelay);
        if (address(dkim) == address(0)) {
            UserOverrideableDKIMRegistry dkimImpl = new UserOverrideableDKIMRegistry();
            console.log(
                "UserOverrideableDKIMRegistry implementation deployed at: %s",
                address(dkimImpl)
            );
            ERC1967Proxy dkimProxy = new ERC1967Proxy(
                address(dkimImpl),
                abi.encodeCall(
                    dkimImpl.initialize,
                    (initialOwner, signer, setTimeDelay)
                )
            );
            dkim = UserOverrideableDKIMRegistry(address(dkimProxy));
            console.log(
                "UseroverrideableDKIMRegistry proxy deployed at: %s",
                address(dkim)
            );
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
            // vm.setEnv("VERIFIER", vm.toString(address(verifier)));
        }

        // Deploy EmailAuth Implementation
        emailAuthImpl = EmailAuth(vm.envOr("EMAIL_AUTH_IMPL", address(0)));
        if (address(emailAuthImpl) == address(0)) {
            emailAuthImpl = new EmailAuth();
            console.log(
                "EmailAuth implementation deployed at: %s",
                address(emailAuthImpl)
            );
            // vm.setEnv("EMAIL_AUTH_IMPL", vm.toString(address(emailAuthImpl)));
        }

        // Create RecoveryController as EmailAccountRecovery implementation
        {
            RecoveryController recoveryControllerImpl = new RecoveryController();
            ERC1967Proxy recoveryControllerProxy = new ERC1967Proxy(
                address(recoveryControllerImpl),
                abi.encodeCall(
                    recoveryControllerImpl.initialize,
                    (
                        initialOwner,
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
            // vm.setEnv(
            //     "RECOVERY_CONTROLLER",
            //     vm.toString(address(recoveryController))
            // );
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
                    (initialOwner, address(recoveryController))
                )
            );
            simpleWallet = SimpleWallet(payable(address(simpleWalletProxy)));
            console.log("SimpleWallet deployed at: %s", address(simpleWallet));
            // vm.setEnv("SIMPLE_WALLET", vm.toString(address(simpleWallet)));
        }
        vm.stopBroadcast();
    }
}
