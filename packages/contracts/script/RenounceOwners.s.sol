// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "../src/utils/Verifier.sol";
import "../src/utils/ECDSAOwnedDKIMRegistry.sol";
import "../src/utils/ForwardDKIMRegistry.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract RenounceOwners is Script {
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
            OwnableUpgradeable(verifier).renounceOwnership();
        }
        if (ecdsaDkim != address(0)) {
            OwnableUpgradeable(ecdsaDkim).renounceOwnership();
        }
        if (dkim != address(0)) {
            OwnableUpgradeable(dkim).renounceOwnership();
            OwnableUpgradeable(
                address(ForwardDKIMRegistry(dkim).sourceDKIMRegistry())
            ).renounceOwnership();
        }
        vm.stopBroadcast();
    }
}
