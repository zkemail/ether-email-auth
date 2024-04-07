// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "../test/helpers/SimpleWallet.sol";
import "../src/utils/Verifier.sol";
import "../src/utils/ECDSAOwnedDKIMRegistry.sol";
import "../src/EmailAuth.sol";

contract Deploy is Script {
    using ECDSA for *;

    ECDSAOwnedDKIMRegistry dkim;
    Verifier verifier;
    EmailAuth emailAuthImpl;
    SimpleWallet simpleWalletImpl;

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

        // Deploy DKIM registry
        dkim = new ECDSAOwnedDKIMRegistry(signer);
        console.log("ECDSAOwnedDKIMRegistry deployed at: %s", address(dkim));
        vm.setEnv("DKIM", vm.toString(address(dkim)));

        // Deploy Verifier
        verifier = new Verifier();
        console.log("Verifier deployed at: %s", address(verifier));
        vm.setEnv("VERIFIER", vm.toString(address(verifier)));

        // Deploy EmailAuth Implementation
        {
            emailAuthImpl = new EmailAuth();
            console.log(
                "EmailAuth implementation deployed at: %s",
                address(emailAuthImpl)
            );
            vm.setEnv("EMAIL_AUTH_IMPL", vm.toString(address(emailAuthImpl)));
        }

        // Deploy SimpleWallet Implementation
        {
            simpleWalletImpl = new SimpleWallet();
            console.log(
                "SimpleWallet implementation deployed at: %s",
                address(simpleWalletImpl)
            );
            vm.setEnv(
                "SIMPLE_WALLET_IMPL",
                vm.toString(address(simpleWalletImpl))
            );
        }
        vm.stopBroadcast();
    }
}
