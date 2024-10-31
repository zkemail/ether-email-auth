// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {Defender, ApprovalProcessResponse} from "openzeppelin-foundry-upgrades/Defender.sol";
import {Upgrades, Options} from "openzeppelin-foundry-upgrades/Upgrades.sol";
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

contract BaseDeployScript is Script {
    address initialOwner;
    uint256 deployerPrivateKey;
    ApprovalProcessResponse upgradeApprovalProcess;
    Options opts;

    /// @notice Returns whether to use OpenZeppelin Defender for deployments
    function useDefender() internal view returns (bool) {
        bool _useDefender = vm.envOr("USE_DEFENDER", false);
        return _useDefender;
    }

    /// @notice Sets up deployment configuration based on whether using Defender or private key
    function run() public virtual {
        if (useDefender()) {
            upgradeApprovalProcess = Defender.getUpgradeApprovalProcess();

            if (upgradeApprovalProcess.via == address(0)) {
                revert(
                    string.concat(
                        "Upgrade approval process with id ",
                        upgradeApprovalProcess.approvalProcessId,
                        " has no assigned address"
                    )
                );
            }

            // Options memory opts;
            opts.defender.useDefenderDeploy = true;
            opts.defender.skipLicenseType = true;
            opts.unsafeSkipAllChecks = true;

            deployerPrivateKey = uint256(1); // dummy private key
            initialOwner = upgradeApprovalProcess.via;
        } else {
            deployerPrivateKey = vm.envUint("PRIVATE_KEY");
            if (deployerPrivateKey == 0) {
                console.log("PRIVATE_KEY env var not set");
                return;
            }

            initialOwner = vm.envAddress("INITIAL_OWNER");
            if (initialOwner == address(0)) {
                console.log("INITIAL_OWNER env var not set");
                return;
            }
        }
    }

    /// @notice Deploys a UserOverrideableDKIMRegistry contract with a specified owner, dkim signer and time delay
    function deployUserOverrideableDKIMRegistry(address owner, address dkimSigner, uint256 timeDelay)
        public
        returns (address)
    {
        address dkimProxyAddress;
        if (useDefender()) {
            dkimProxyAddress = Upgrades.deployUUPSProxy(
                "UserOverrideableDKIMRegistry.sol",
                abi.encodeCall(UserOverrideableDKIMRegistry.initialize, (owner, dkimSigner, timeDelay)),
                opts
            );
        } else {
            UserOverrideableDKIMRegistry dkimImpl = new UserOverrideableDKIMRegistry();
            dkimProxyAddress = address(
                new ERC1967Proxy(
                    address(dkimImpl),
                    abi.encodeCall(UserOverrideableDKIMRegistry.initialize, (owner, dkimSigner, timeDelay))
                )
            );
        }
        console.log("UseroverrideableDKIMRegistry proxy deployed at: %s", dkimProxyAddress);
        vm.setEnv("DKIM", vm.toString(dkimProxyAddress));
        return dkimProxyAddress;
    }

    /// @notice Deploys an ECDSAOwnedDKIMRegistry contract with a specified owner and dkim signer
    function deployECDSAOwnedDKIMRegistry(address owner, address dkimSigner) public returns (address) {
        address ecdsaDkimProxyAddress;
        if (useDefender()) {
            ecdsaDkimProxyAddress = Upgrades.deployUUPSProxy(
                "ECDSAOwnedDKIMRegistry.sol",
                abi.encodeCall(ECDSAOwnedDKIMRegistry.initialize, (owner, dkimSigner)),
                opts
            );
        } else {
            ECDSAOwnedDKIMRegistry ecdsaDkimImpl = new ECDSAOwnedDKIMRegistry();
            ecdsaDkimProxyAddress = address(
                new ERC1967Proxy(address(ecdsaDkimImpl), abi.encodeCall(ecdsaDkimImpl.initialize, (owner, dkimSigner)))
            );
        }
        console.log("ECDSAOwnedDKIMRegistry proxy deployed at: %s", ecdsaDkimProxyAddress);
        vm.setEnv("ECDSA_DKIM", vm.toString(ecdsaDkimProxyAddress));
        return ecdsaDkimProxyAddress;
    }

    /// @notice Deploys a Verifier contract with a specified owner and Groth16 verifier
    function deployVerifier(address owner) public returns (address) {
        address verifierProxyAddress;
        if (useDefender()) {
            address groth16Verifier = Defender.deployContract("Groth16Verifier.sol", opts.defender);
            verifierProxyAddress = Upgrades.deployUUPSProxy(
                "Verifier.sol", abi.encodeCall(Verifier.initialize, (owner, groth16Verifier)), opts
            );
        } else {
            Verifier verifierImpl = new Verifier();
            Groth16Verifier groth16Verifier = new Groth16Verifier();
            verifierProxyAddress = address(
                new ERC1967Proxy(
                    address(verifierImpl), abi.encodeCall(verifierImpl.initialize, (owner, address(groth16Verifier)))
                )
            );
        }
        console.log("Verifier deployed at: %s", verifierProxyAddress);
        vm.setEnv("VERIFIER", vm.toString(verifierProxyAddress));
        return verifierProxyAddress;
    }

    /// @notice Deploys an EmailAuth implementation contract
    function deployEmailAuthImplementation() public returns (address) {
        address emailAuthImplAddress;
        if (useDefender()) {
            emailAuthImplAddress = Upgrades.deployImplementation("EmailAuth.sol", opts);
        } else {
            emailAuthImplAddress = address(new EmailAuth());
        }
        console.log("EmailAuth implementation deployed at: %s", emailAuthImplAddress);
        vm.setEnv("EMAIL_AUTH_IMPL", vm.toString(emailAuthImplAddress));
        return emailAuthImplAddress;
    }

    /// @notice Deploys a RecoveryController contract with specified owner, verifier, DKIM registry and EmailAuth implementation
    function deployRecoveryController(address owner, address verifier, address dkim, address emailAuthImpl)
        public
        returns (address)
    {
        address recoveryControllerProxyAddress;
        if (useDefender()) {
            recoveryControllerProxyAddress = Upgrades.deployUUPSProxy(
                "RecoveryController.sol",
                abi.encodeCall(RecoveryController.initialize, (owner, verifier, dkim, emailAuthImpl)),
                opts
            );
        } else {
            RecoveryController recoveryControllerImpl = new RecoveryController();
            recoveryControllerProxyAddress = address(
                new ERC1967Proxy(
                    address(recoveryControllerImpl),
                    abi.encodeCall(RecoveryController.initialize, (owner, verifier, dkim, emailAuthImpl))
                )
            );
        }
        console.log("RecoveryController deployed at: %s", recoveryControllerProxyAddress);
        vm.setEnv("RECOVERY_CONTROLLER", vm.toString(recoveryControllerProxyAddress));
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
        if (useDefender()) {
            recoveryControllerProxyAddress = Upgrades.deployUUPSProxy(
                "RecoveryControllerZKSync.sol",
                abi.encodeCall(
                    RecoveryControllerZKSync.initialize,
                    (owner, verifier, dkim, emailAuthImpl, factoryImpl, proxyBytecodeHash)
                ),
                opts
            );
        } else {
            RecoveryControllerZKSync recoveryControllerZKSyncImpl = new RecoveryControllerZKSync();
            recoveryControllerProxyAddress = address(
                new ERC1967Proxy(
                    address(recoveryControllerZKSyncImpl),
                    abi.encodeCall(
                        recoveryControllerZKSyncImpl.initialize,
                        (owner, verifier, dkim, emailAuthImpl, factoryImpl, proxyBytecodeHash)
                    )
                )
            );
        }
        console.log("RecoveryControllerZKSync deployed at: %s", recoveryControllerProxyAddress);
        vm.setEnv("RECOVERY_CONTROLLER_ZKSYNC", vm.toString(recoveryControllerProxyAddress));
        return recoveryControllerProxyAddress;
    }

    /// @notice Deploys a ZK Sync Create2 factory contract
    function deployZKSyncCreate2Factory() public returns (address) {
        address factoryImplAddress;
        if (useDefender()) {
            factoryImplAddress = Defender.deployContract("ZKSyncCreate2Factory.sol", opts.defender);
        } else {
            factoryImplAddress = address(new ZKSyncCreate2Factory());
        }
        console.log("ZKSyncCreate2Factory deployed at: %s", factoryImplAddress);
        vm.setEnv("ZKSYNC_CREATE2_FACTORY", vm.toString(factoryImplAddress));
        return factoryImplAddress;
    }

    /// @notice Deploys a SimpleWallet contract with a specified owner and recovery controller
    function deploySimpleWallet(address owner, address recoveryController) public returns (address) {
        address simpleWalletProxyAddress;
        if (useDefender()) {
            simpleWalletProxyAddress = Upgrades.deployUUPSProxy(
                "SimpleWallet.sol", abi.encodeCall(SimpleWallet.initialize, (owner, recoveryController)), opts
            );
        } else {
            SimpleWallet simpleWalletImpl = new SimpleWallet();
            simpleWalletProxyAddress = address(
                new ERC1967Proxy(
                    address(simpleWalletImpl),
                    abi.encodeCall(simpleWalletImpl.initialize, (owner, address(recoveryController)))
                )
            );
        }
        console.log("SimpleWallet deployed at: %s", simpleWalletProxyAddress);
        vm.setEnv("SIMPLE_WALLET", vm.toString(simpleWalletProxyAddress));
        return simpleWalletProxyAddress;
    }
}
