// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {UserOverrideableDKIMRegistry} from "@zk-email/contracts/UserOverrideableDKIMRegistry.sol";

import {SimpleWallet} from "../test/helpers/SimpleWallet.sol";
import {RecoveryController} from "../test/helpers/RecoveryController.sol";
import {RecoveryControllerZKSync} from "../test/helpers/RecoveryControllerZKSync.sol";
import {ZKSyncCreate2Factory} from "../src/utils/ZKSyncCreate2Factory.sol";
import {Verifier} from "../src/utils/Verifier.sol";
import {Groth16Verifier} from "../src/utils/Groth16Verifier.sol";
import {ECDSAOwnedDKIMRegistry} from "../src/utils/ECDSAOwnedDKIMRegistry.sol";
import {EmailAuth} from "../src/EmailAuth.sol";

import {SafeSingletonDeployer} from "safe-singleton-deployer/SafeSingletonDeployer.sol";

contract BaseDeployScript is Script {
    address initialOwner;
    uint256 deployerPrivateKey;

    /// @notice Sets up deployment configuration based on whether using Defender or private key
    function run() public virtual {
        deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        if (deployerPrivateKey == 0) {
            console.log("PRIVATE_KEY env var not set");
            return;
        }

        initialOwner = vm.envOr("INITIAL_OWNER", address(0));
        if (initialOwner == address(0)) {
            initialOwner = vm.addr(deployerPrivateKey);
        }
    }

    /// @notice Deploys a UserOverrideableDKIMRegistry contract with a specified owner, dkim signer and time delay
    function deployUserOverrideableDKIMRegistry(
        address owner,
        address dkimSigner,
        uint256 timeDelay
    ) public returns (address) {
        // Deploy implementation
        address dkimImpl = SafeSingletonDeployer.deploy(
            type(UserOverrideableDKIMRegistry).creationCode,
            "",
            keccak256("DKIM_REGISTRY_IMPL")
        );

        console.log(
            "UserOverrideableDKIMRegistry implementation deployed at: %s",
            dkimImpl
        );

        // Deploy proxy
        bytes memory initData = abi.encodeCall(
            UserOverrideableDKIMRegistry.initialize,
            (owner, dkimSigner, timeDelay)
        );

        address dkimProxyAddress = SafeSingletonDeployer.deploy(
            type(ERC1967Proxy).creationCode,
            abi.encode(dkimImpl, initData),
            keccak256("DKIM_REGISTRY_PROXY")
        );

        console.log(
            "UserOverrideableDKIMRegistry deployed at: %s",
            dkimProxyAddress
        );
        return dkimProxyAddress;
    }

    /// @notice Deploys an ECDSAOwnedDKIMRegistry contract with a specified owner and dkim signer
    function deployECDSAOwnedDKIMRegistry(
        address owner,
        address dkimSigner
    ) public returns (address) {
        // Deploy implementation
        address ecdsaDkimImpl = SafeSingletonDeployer.deploy(
            type(ECDSAOwnedDKIMRegistry).creationCode,
            "",
            keccak256("ECDSA_DKIM_IMPL")
        );

        console.log(
            "ECDSAOwnedDKIMRegistry implementation deployed at: %s",
            ecdsaDkimImpl
        );

        // Deploy proxy
        bytes memory initData = abi.encodeCall(
            ECDSAOwnedDKIMRegistry.initialize,
            (owner, dkimSigner)
        );

        address ecdsaDkimProxyAddress = SafeSingletonDeployer.deploy(
            type(ERC1967Proxy).creationCode,
            abi.encode(ecdsaDkimImpl, initData),
            keccak256("ECDSA_DKIM_PROXY")
        );

        console.log(
            "ECDSAOwnedDKIMRegistry proxy deployed at: %s",
            ecdsaDkimProxyAddress
        );
        return ecdsaDkimProxyAddress;
    }

    /// @notice Deploys a Verifier contract with a specified owner and Groth16 verifier
    function deployVerifier(address owner) public returns (address) {
        // Deploy implementation
        address verifierImpl = SafeSingletonDeployer.deploy(
            type(Verifier).creationCode,
            "",
            keccak256("VERIFIER_IMPL")
        );

        console.log("Verifier implementation deployed at: %s", verifierImpl);

        address groth16Verifier = SafeSingletonDeployer.deploy(
            type(Groth16Verifier).creationCode,
            "",
            keccak256("GROTH16_VERIFIER")
        );

        console.log("Groth16Verifier deployed at: %s", groth16Verifier);

        // Deploy proxy
        bytes memory initData = abi.encodeCall(
            Verifier.initialize,
            (owner, address(groth16Verifier))
        );

        address verifierProxyAddress = SafeSingletonDeployer.deploy(
            type(ERC1967Proxy).creationCode,
            abi.encode(verifierImpl, initData),
            keccak256("VERIFIER_PROXY")
        );

        console.log("Verifier deployed at: %s", verifierProxyAddress);
        return verifierProxyAddress;
    }

    /// @notice Deploys an EmailAuth implementation contract
    function deployEmailAuthImplementation() public returns (address) {
        address emailAuthImplAddress = SafeSingletonDeployer.deploy(
            type(EmailAuth).creationCode,
            "",
            keccak256("EMAIL_AUTH_IMPL")
        );

        console.log(
            "EmailAuth implementation deployed at: %s",
            emailAuthImplAddress
        );
        return emailAuthImplAddress;
    }

    /// @notice Deploys a RecoveryController contract with specified owner, verifier, DKIM registry and EmailAuth implementation
    function deployRecoveryController(
        address owner,
        address verifier,
        address dkim,
        address emailAuthImpl
    ) public returns (address) {
        // Deploy implementation
        address recoveryControllerImpl = SafeSingletonDeployer.deploy(
            type(RecoveryController).creationCode,
            "",
            keccak256("RECOVERY_CONTROLLER_IMPL")
        );

        console.log(
            "RecoveryController implementation deployed at: %s",
            recoveryControllerImpl
        );

        // Deploy proxy
        bytes memory initData = abi.encodeCall(
            RecoveryController.initialize,
            (owner, verifier, dkim, emailAuthImpl)
        );

        address recoveryControllerProxyAddress = SafeSingletonDeployer.deploy(
            type(ERC1967Proxy).creationCode,
            abi.encode(recoveryControllerImpl, initData),
            keccak256("RECOVERY_CONTROLLER_PROXY")
        );

        console.log(
            "RecoveryController deployed at: %s",
            recoveryControllerProxyAddress
        );
        return recoveryControllerProxyAddress;
    }

    /// @notice Deploys a ZK Sync specific RecoveryController with additional factory and proxy bytecode parameters
    function deployRecoveryControllerZKSync(
        address owner,
        address verifier,
        address dkim,
        address emailAuthImpl,
        address factoryImpl,
        bytes32 proxyBytecodeHash
    ) public returns (address) {
        address recoveryControllerProxyAddress;
        RecoveryControllerZKSync recoveryControllerZKSyncImpl = new RecoveryControllerZKSync();
        recoveryControllerProxyAddress = address(
            new ERC1967Proxy(
                address(recoveryControllerZKSyncImpl),
                abi.encodeCall(
                    recoveryControllerZKSyncImpl.initialize,
                    (
                        owner,
                        verifier,
                        dkim,
                        emailAuthImpl,
                        factoryImpl,
                        proxyBytecodeHash
                    )
                )
            )
        );
        console.log(
            "RecoveryControllerZKSync deployed at: %s",
            recoveryControllerProxyAddress
        );
        return recoveryControllerProxyAddress;
    }

    /// @notice Deploys a ZK Sync Create2 factory contract
    function deployZKSyncCreate2Factory() public returns (address) {
        address factoryImplAddress;
        factoryImplAddress = address(new ZKSyncCreate2Factory());
        console.log("ZKSyncCreate2Factory deployed at: %s", factoryImplAddress);
        return factoryImplAddress;
    }

    /// @notice Deploys a SimpleWallet contract with a specified owner and recovery controller
    function deploySimpleWallet(
        address owner,
        address recoveryController
    ) public returns (address) {
        // Deploy implementation
        address simpleWalletImpl = SafeSingletonDeployer.deploy(
            type(SimpleWallet).creationCode,
            "",
            keccak256("SIMPLE_WALLET_IMPL")
        );

        console.log(
            "SimpleWallet implementation deployed at: %s",
            simpleWalletImpl
        );

        // Deploy proxy
        bytes memory initData = abi.encodeCall(
            SimpleWallet.initialize,
            (owner, address(recoveryController))
        );

        address simpleWalletProxyAddress = SafeSingletonDeployer.deploy(
            type(ERC1967Proxy).creationCode,
            abi.encode(simpleWalletImpl, initData),
            keccak256("SIMPLE_WALLET_PROXY")
        );

        console.log("SimpleWallet deployed at: %s", simpleWalletProxyAddress);
        return simpleWalletProxyAddress;
    }
}
