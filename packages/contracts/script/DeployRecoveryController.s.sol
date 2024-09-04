// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "../test/helpers/SimpleWallet.sol";
import "../test/helpers/RecoveryController.sol";
import "../src/utils/Verifier.sol";
import "../src/utils/ECDSAOwnedDKIMRegistry.sol";
// import "../src/utils/ForwardDKIMRegistry.sol";
import "../src/EmailAuth.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {UserOverrideableDKIMRegistry} from "@zk-email/contracts/UserOverrideableDKIMRegistry.sol";

contract Deploy is Script {
    using ECDSA for *;

    ECDSAOwnedDKIMRegistry dkim;
    Verifier verifier;
    EmailAuth emailAuthImpl;
    SimpleWallet simpleWallet;
    RecoveryController recoveryController;
    UserOverrideableDKIMRegistry userOverrideableDKIMRegistry;

    function run() external {

        // TODO: Change this to your salt
        bytes32 salt = "YOUR_SALT";

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

        // Deploy User Overrideable DKIM registry
        userOverrideableDKIMRegistry = new UserOverrideableDKIMRegistry{salt: salt}(signer, signer);
        console.log("UserOverrideableDKIMRegistry deployed at: %s", address(userOverrideableDKIMRegistry));
        vm.setEnv("USER_OVERRIDEABLE_DKIM_REGISTRY", vm.toString(address(userOverrideableDKIMRegistry)));

        // Deploy DKIM registry
        dkim = new ECDSAOwnedDKIMRegistry{salt: salt}();
        console.log("ECDSAOwnedDKIMRegistry deployed at: %s", address(dkim));
        vm.setEnv("DKIM", vm.toString(address(dkim)));

        // Deploy Verifier
        verifier = new Verifier{salt: salt}();
        console.log("Verifier deployed at: %s", address(verifier));
        vm.setEnv("VERIFIER", vm.toString(address(verifier)));

        // Deploy EmailAuth Implementation
        {
            emailAuthImpl = new EmailAuth{salt: salt}();
            console.log(
                "EmailAuth implementation deployed at: %s",
                address(emailAuthImpl)
            );
            vm.setEnv("EMAIL_AUTH_IMPL", vm.toString(address(emailAuthImpl)));
        }

        // Create RecoveryController as EmailAccountRecovery implementation
        {
            RecoveryController recoveryControllerImpl = new RecoveryController{salt: salt}();
            ERC1967Proxy recoveryControllerProxy = new ERC1967Proxy{salt: salt}(
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
            vm.setEnv("RECOVERY_CONTROLLER", vm.toString(address(recoveryController)));
        }

        // Deploy SimpleWallet Implementation
        {
            SimpleWallet simpleWalletImpl = new SimpleWallet{salt: salt}();
            console.log(
                "SimpleWallet implementation deployed at: %s",
                address(simpleWalletImpl)
            );
            vm.setEnv(
                "SIMPLE_WALLET_IMPL",
                vm.toString(address(simpleWalletImpl))
            );
            ERC1967Proxy simpleWalletProxy = new ERC1967Proxy{salt: salt}(
                address(simpleWalletImpl),
                abi.encodeCall(
                    simpleWalletImpl.initialize,
                    (
                        signer,
                        address(recoveryController)
                    )
                )
            );
            simpleWallet = SimpleWallet(
                payable(address(simpleWalletProxy))
            );
            console.log(
                "SimpleWallet deployed at: %s",
                address(simpleWallet)
            );
            vm.setEnv("SIMPLE_WALLET", vm.toString(address(simpleWallet)));
        }
        vm.stopBroadcast();
    }
}
