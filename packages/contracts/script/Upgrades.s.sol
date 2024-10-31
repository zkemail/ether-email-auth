// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {console} from "forge-std/console.sol";
import "../src/utils/Verifier.sol";
import "../src/utils/ECDSAOwnedDKIMRegistry.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {ProposeUpgradeResponse, Defender, Options} from "openzeppelin-foundry-upgrades/Defender.sol";
import {Create2} from "@openzeppelin/contracts/utils/Create2.sol";
import {UserOverrideableDKIMRegistry} from "@zk-email/contracts/UserOverrideableDKIMRegistry.sol";
import {BaseDeployScript} from "./BaseDeployScript.sol";

contract Upgrades is BaseDeployScript {
    bytes32 verifierImplSalt = bytes32(uint256(0));
    bytes32 ecdsaDkimImplSalt = bytes32(uint256(0));
    bytes32 dkimImplSalt = bytes32(uint256(0));

    function run() public override {
        super.run();

        address verifierProxy = vm.envOr("VERIFIER", address(0));
        address ecdsaDkimProxy = vm.envOr("ECDSA_DKIM", address(0));
        address dkimProxy = vm.envOr("DKIM", address(0));

        vm.startBroadcast(deployerPrivateKey);
        if (verifierProxy != address(0)) {
            upgradeVerifier(verifierProxy);
        }
        if (ecdsaDkimProxy != address(0)) {
            upgradeECDSAOwnedDKIMRegistry(ecdsaDkimProxy);
        }
        if (dkimProxy != address(0)) {
            upgradeUserOverrideableDKIMRegistry(dkimProxy);
        }
        vm.stopBroadcast();
    }

    function upgradeVerifier(address verifierProxy) public {
        if (useDefender()) {
            opts.defender.salt = verifierImplSalt;
            string memory newImplContractName = "Verifier.sol";
            ProposeUpgradeResponse memory response = Defender.proposeUpgrade(
                verifierProxy,
                newImplContractName,
                opts
            );
            console.log("Verifier Upgrade Proposal id", response.proposalId);
            console.log("Verifier Upgrade Url", response.url);
        } else {
            Verifier newVerifierImpl = new Verifier();
            UUPSUpgradeable(verifierProxy).upgradeToAndCall(
                address(newVerifierImpl),
                bytes("")
            );
        }
    }
    function upgradeECDSAOwnedDKIMRegistry(address ecdsaDkimProxy) public {
        if (useDefender()) {
            opts.defender.salt = ecdsaDkimImplSalt;
            string memory newImplContractName = "ECDSAOwnedDKIMRegistry.sol";
            ProposeUpgradeResponse memory response = Defender.proposeUpgrade(
                ecdsaDkimProxy,
                newImplContractName,
                opts
            );
            console.log(
                "ECDSAOwnedDKIMRegistry Upgrade Proposal id",
                response.proposalId
            );
            console.log("ECDSAOwnedDKIMRegistry Upgrade Url", response.url);
        } else {
            ECDSAOwnedDKIMRegistry newECDSAOwnedDKIMRegistryImpl = new ECDSAOwnedDKIMRegistry();
            UUPSUpgradeable(ecdsaDkimProxy).upgradeToAndCall(
                address(newECDSAOwnedDKIMRegistryImpl),
                bytes("")
            );
        }
    }
    function upgradeUserOverrideableDKIMRegistry(address dkimProxy) public {
        if (useDefender()) {
            opts.defender.salt = dkimImplSalt;
            string
                memory newImplContractName = "UserOverrideableDKIMRegistry.sol";
            ProposeUpgradeResponse memory response = Defender.proposeUpgrade(
                dkimProxy,
                newImplContractName,
                opts
            );
            console.log(
                "UserOverrideableDKIMRegistry Upgrade Proposal id",
                response.proposalId
            );
            console.log(
                "UserOverrideableDKIMRegistry Upgrade Url",
                response.url
            );
        } else {
            UserOverrideableDKIMRegistry newDkimImpl = new UserOverrideableDKIMRegistry();
            UUPSUpgradeable(dkimProxy).upgradeToAndCall(
                address(newDkimImpl),
                bytes("")
            );
        }
    }
}
