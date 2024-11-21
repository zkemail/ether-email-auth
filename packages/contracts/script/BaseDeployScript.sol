// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {UserOverrideableDKIMRegistry} from "@zk-email/contracts/UserOverrideableDKIMRegistry.sol";

import {ZKSyncCreate2Factory} from "../src/utils/ZKSyncCreate2Factory.sol";
import {Verifier} from "../src/utils/Verifier.sol";
import {Groth16Verifier} from "../src/utils/Groth16Verifier.sol";
import {ECDSAOwnedDKIMRegistry} from "../src/utils/ECDSAOwnedDKIMRegistry.sol";
import {EmailAuth} from "../src/EmailAuth.sol";

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
        address dkimProxyAddress;
        UserOverrideableDKIMRegistry dkimImpl = new UserOverrideableDKIMRegistry();
        dkimProxyAddress = address(
            new ERC1967Proxy(
                address(dkimImpl),
                abi.encodeCall(
                    UserOverrideableDKIMRegistry.initialize,
                    (owner, dkimSigner, timeDelay)
                )
            )
        );
        console.log(
            "UseroverrideableDKIMRegistry proxy deployed at: %s",
            dkimProxyAddress
        );
        return dkimProxyAddress;
    }

    /// @notice Deploys an ECDSAOwnedDKIMRegistry contract with a specified owner and dkim signer
    function deployECDSAOwnedDKIMRegistry(
        address owner,
        address dkimSigner
    ) public returns (address) {
        address ecdsaDkimProxyAddress;
        ECDSAOwnedDKIMRegistry ecdsaDkimImpl = new ECDSAOwnedDKIMRegistry();
        ecdsaDkimProxyAddress = address(
            new ERC1967Proxy(
                address(ecdsaDkimImpl),
                abi.encodeCall(ecdsaDkimImpl.initialize, (owner, dkimSigner))
            )
        );
        console.log(
            "ECDSAOwnedDKIMRegistry proxy deployed at: %s",
            ecdsaDkimProxyAddress
        );
        return ecdsaDkimProxyAddress;
    }

    /// @notice Deploys a Verifier contract with a specified owner and Groth16 verifier
    function deployVerifier(address owner) public returns (address) {
        address verifierProxyAddress;
        Verifier verifierImpl = new Verifier();
        Groth16Verifier groth16Verifier = new Groth16Verifier();
        console.log("Groth16Verifier deployed at: %s", address(groth16Verifier));
        verifierProxyAddress = address(
            new ERC1967Proxy(
                address(verifierImpl),
                abi.encodeCall(
                    verifierImpl.initialize,
                    (owner, address(groth16Verifier))
                )
            )
        );
        console.log("Verifier deployed at: %s", verifierProxyAddress);
        return verifierProxyAddress;
    }

    /// @notice Deploys an EmailAuth implementation contract
    function deployEmailAuthImplementation() public returns (address) {
        address emailAuthImplAddress;
        emailAuthImplAddress = address(new EmailAuth());
        console.log(
            "EmailAuth implementation deployed at: %s",
            emailAuthImplAddress
        );
        return emailAuthImplAddress;
    }

    /// @notice Deploys a ZK Sync Create2 factory contract
    function deployZKSyncCreate2Factory() public returns (address) {
        address factoryImplAddress;
        factoryImplAddress = address(new ZKSyncCreate2Factory());
        console.log("ZKSyncCreate2Factory deployed at: %s", factoryImplAddress);
        return factoryImplAddress;
    }
}
