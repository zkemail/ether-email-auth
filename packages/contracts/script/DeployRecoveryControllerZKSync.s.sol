// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {console} from "forge-std/console.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {SimpleWallet} from "../test/helpers/SimpleWallet.sol";
import {RecoveryControllerZKSync} from "../test/helpers/RecoveryControllerZKSync.sol";
import {Verifier} from "../src/utils/Verifier.sol";
import {Groth16Verifier} from "../src/utils/Groth16Verifier.sol";
import {EmailAuth} from "../src/EmailAuth.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {ZKSyncCreate2Factory} from "../src/utils/ZKSyncCreate2Factory.sol";
import {UserOverrideableDKIMRegistry} from "@zk-email/contracts/UserOverrideableDKIMRegistry.sol";
import {BaseDeployScript} from "./BaseDeployScript.sol";

contract Deploy is BaseDeployScript {
    using ECDSA for *;

    address dkim;
    address verifier;
    address emailAuthImpl;
    address simpleWallet;
    address recoveryControllerZKSync;
    address factory;

    function run() public override {
        super.run();

        bytes32 proxyBytecodeHash = vm.envBytes32("PROXY_BYTECODE_HASH");
        if (proxyBytecodeHash == bytes32(0)) {
            revert("PROXY_BYTECODE_HASH env var not set or invalid");
        }

        vm.startBroadcast(deployerPrivateKey);

        // Deploy Useroverrideable DKIM registry
        dkim = vm.envOr("DKIM", address(0));
        if (address(dkim) == address(0)) {
            address dkimSigner = vm.envAddress("DKIM_SIGNER");
            if (dkimSigner == address(0)) {
                console.log("DKIM_SIGNER env var not set");
                return;
            }
            uint256 timeDelay = vm.envOr("DKIM_DELAY", uint256(0));
            console.log("DKIM_DELAY: %s", timeDelay);

            dkim = deployUserOverrideableDKIMRegistry(initialOwner, dkimSigner, timeDelay);
        }

        // Deploy Verifier
        verifier = vm.envOr("VERIFIER", address(0));
        if (address(verifier) == address(0)) {
            verifier = deployVerifier(initialOwner);
        }

        // Deploy EmailAuth Implementation
        emailAuthImpl = vm.envOr("EMAIL_AUTH_IMPL", address(0));
        if (address(emailAuthImpl) == address(0)) {
            emailAuthImpl = deployEmailAuthImplementation();
        }

        // Deploy Factory
        factory = vm.envOr("ZKSYNC_CREATE2_FACTORY", address(0));
        if (address(factory) == address(0)) {
            factory = deployZKSyncCreate2Factory();
        }

        // Create RecoveryControllerZKSync as EmailAccountRecovery implementation
        recoveryControllerZKSync = deployRecoveryControllerZKSync(
            initialOwner, address(verifier), address(dkim), address(emailAuthImpl), address(factory), proxyBytecodeHash
        );

        // Deploy SimpleWallet Implementation
        simpleWallet = deploySimpleWallet(initialOwner, address(recoveryControllerZKSync));
        vm.stopBroadcast();
    }
}
