// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {console} from "forge-std/console.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {SimpleWallet} from "../test/helpers/SimpleWallet.sol";
import {RecoveryController} from "../test/helpers/RecoveryController.sol";
import {Verifier} from "../src/utils/Verifier.sol";
import {EmailAuth} from "../src/EmailAuth.sol";
import {UserOverrideableDKIMRegistry} from "@zk-email/contracts/UserOverrideableDKIMRegistry.sol";
import {BaseDeployScript} from "./BaseDeployScript.sol";
import {SafeSingletonDeployer} from "safe-singleton-deployer/SafeSingletonDeployer.sol";

contract Deploy is BaseDeployScript {
    using ECDSA for *;

    address dkim;
    address verifier;
    address emailAuthImpl;
    address simpleWallet;
    address recoveryController;

    function deploySingleton(
        uint256 deployerPrivateKey,
        bytes memory creationCode,
        bytes memory initData,
        bytes32 salt
    ) private returns (address) {
        return
            SafeSingletonDeployer.broadcastDeploy(
                deployerPrivateKey,
                creationCode,
                initData,
                salt
            );
    }

    function run() public override {
        super.run();
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address initialOwner = vm.envOr("INITIAL_OWNER", address(0));

        // Deploy User-overrideable DKIM registry
        dkim = vm.envOr("DKIM", address(0));
        if (dkim == address(0)) {
            address dkimSigner = vm.envAddress("DKIM_SIGNER");
            require(dkimSigner != address(0), "DKIM_SIGNER env var not set");
            uint256 timeDelay = vm.envOr("DKIM_DELAY", uint256(0));

            dkim = deploySingleton(
                deployerPrivateKey,
                type(UserOverrideableDKIMRegistry).creationCode,
                abi.encode(initialOwner, dkimSigner, timeDelay),
                keccak256("DKIM_REGISTRY")
            );
        }
        console.log("UserOverrideableDKIMRegistry: %s", dkim);

        // Deploy Verifier
        verifier = vm.envOr("VERIFIER", address(0));
        if (verifier == address(0)) {
            verifier = deploySingleton(
                deployerPrivateKey,
                type(Verifier).creationCode,
                abi.encode(initialOwner),
                keccak256("VERIFIER")
            );
        }
        console.log("Verifier: %s", verifier);

        // Deploy EmailAuth Implementation
        emailAuthImpl = vm.envOr("EMAIL_AUTH_IMPL", address(0));
        if (emailAuthImpl == address(0)) {
            emailAuthImpl = deploySingleton(
                deployerPrivateKey,
                type(EmailAuth).creationCode,
                "",
                keccak256("EMAIL_AUTH_IMPL")
            );
        }
        console.log("EmailAuth: %s", emailAuthImpl);

        // Create RecoveryController
        recoveryController = deploySingleton(
            deployerPrivateKey,
            type(RecoveryController).creationCode,
            abi.encode(initialOwner, verifier, dkim, emailAuthImpl),
            keccak256("RECOVERY_CONTROLLER")
        );
        console.log("RecoveryController: %s", recoveryController);

        // Deploy SimpleWallet Implementation
        simpleWallet = deploySingleton(
            deployerPrivateKey,
            type(SimpleWallet).creationCode,
            abi.encode(initialOwner, recoveryController),
            keccak256("SIMPLE_WALLET")
        );
        console.log("SimpleWallet: %s", simpleWallet);
    }
}
