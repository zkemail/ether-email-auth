// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "../src/utils/Verifier.sol";
import "../src/utils/ECDSAOwnedDKIMRegistry.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {UserOverrideableDKIMRegistry} from "@zk-email/contracts/UserOverrideableDKIMRegistry.sol";

contract Upgrades is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        if (deployerPrivateKey == 0) {
            console.log("PRIVATE_KEY env var not set");
            return;
        }
        address verifier = vm.envOr("VERIFIER", address(0));
        address ecdsaDkim = vm.envOr("ECDSA_DKIM", address(0));
        address dkim = vm.envOr("DKIM", address(0));

        vm.startBroadcast(deployerPrivateKey);
        if (verifier != address(0)) {
            Verifier newVerifierImpl = new Verifier();
            UUPSUpgradeable(verifier).upgradeToAndCall(
                address(newVerifierImpl),
                bytes("")
            );
        }
        if (ecdsaDkim != address(0)) {
            ECDSAOwnedDKIMRegistry newECDSAOwnedDKIMRegistryImpl = new ECDSAOwnedDKIMRegistry();
            UUPSUpgradeable(ecdsaDkim).upgradeToAndCall(
                address(newECDSAOwnedDKIMRegistryImpl),
                bytes("")
            );
        }
        if (dkim != address(0)) {
            UserOverrideableDKIMRegistry newDkimImpl = new UserOverrideableDKIMRegistry();
            UUPSUpgradeable(dkim).upgradeToAndCall(
                address(newDkimImpl),
                bytes("")
            );
        }
        vm.stopBroadcast();
    }
}
