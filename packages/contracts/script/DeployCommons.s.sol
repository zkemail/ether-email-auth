// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "../test/helpers/SimpleWallet.sol";
import "../src/utils/Verifier.sol";
import "../src/utils/ECDSAOwnedDKIMRegistry.sol";
import "../src/utils/ForwardDKIMRegistry.sol";
import "../src/EmailAuth.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract Deploy is Script {
    using ECDSA for *;

    ECDSAOwnedDKIMRegistry ecdsaDkimImpl;
    ECDSAOwnedDKIMRegistry ecdsaDkim;
    ForwardDKIMRegistry dkimImpl;
    ForwardDKIMRegistry dkim;
    Verifier verifierImpl;
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
        address initialOwner = msg.sender;
        console.log("Initial owner: %s", vm.toString(initialOwner));
        // Deploy ECDSA DKIM registry
        {
            ecdsaDkimImpl = new ECDSAOwnedDKIMRegistry();
            console.log(
                "ECDSAOwnedDKIMRegistry implementation deployed at: %s",
                address(ecdsaDkimImpl)
            );
            ERC1967Proxy ecdsaDkimProxy = new ERC1967Proxy(
                address(ecdsaDkimImpl),
                abi.encodeCall(ecdsaDkimImpl.initialize, (initialOwner, signer))
            );
            ecdsaDkim = ECDSAOwnedDKIMRegistry(address(ecdsaDkimProxy));
            console.log(
                "ECDSAOwnedDKIMRegistry deployed at: %s",
                address(ecdsaDkim)
            );
            vm.setEnv("ECDSA_DKIM", vm.toString(address(ecdsaDkim)));
        }

        // Deploy Forward DKIM registry
        {
            dkimImpl = new ForwardDKIMRegistry();
            console.log(
                "ForwardDKIMRegistry implementation deployed at: %s",
                address(dkimImpl)
            );
            ERC1967Proxy dkimProxy = new ERC1967Proxy(
                address(dkimImpl),
                abi.encodeCall(dkimImpl.initialize, (initialOwner, signer))
            );
            dkim = ForwardDKIMRegistry(address(dkimProxy));
            console.log("ForwardDKIMRegistry deployed at: %s", address(dkim));
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
