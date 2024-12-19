// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {Deploy} from "../../script/DeployRecoveryController.s.sol";
import {ChangeOwners} from "../../script/ChangeOwners.s.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {StructHelper} from "../helpers/StructHelper.sol";

contract ChangeOwnersScriptTest is StructHelper {
    function setUp() public override {
        resetEnviromentVariables();
        super.setUp();
        vm.setEnv(
            "PRIVATE_KEY",
            "0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d"
        );
        vm.setEnv("DKIM_SIGNER", "0x69bec2dd161d6bbcc91ec32aa44d9333ebc864c0");
        vm.setEnv(
            "INITIAL_OWNER",
            "0x70997970C51812dc3A010C7d01b50e0d17dc79C8"
        );
        vm.setEnv("NEW_OWNER", "0xa1bec2dd161d6bbcc91ec32aa44d9333e2a864c0");
    }

    function test_run() public {
        skipIfZkSync();

        Deploy deploy = new Deploy();
        deploy.run();
        vm.setEnv("DKIM", "0x1445eb74cea4Be2FDc961646cc5e7F6b6eD96718");
        vm.setEnv("VERIFIER", "0xFa093e866780eE4A3546b5BC4Ffb38b186269C52");
        vm.setEnv(
            "EMAIL_AUTH_IMPL",
            "0x647e0FcF727a6DCec40c179a2E44Bde108b341d6"
        );
        vm.setEnv(
            "RECOVERY_CONTROLLER",
            "0x7bE0655b25E90e971Ca54f717250Bf6021bcA353"
        );
        deploy.deployECDSAOwnedDKIMRegistry(
            vm.envAddress("INITIAL_OWNER"),
            vm.envAddress("DKIM_SIGNER")
        );
        vm.setEnv("ECDSA_DKIM", "0x916B5308713E70bd53c1f9aF7F0d228B62736af9");
        ChangeOwners changeOwners = new ChangeOwners();
        changeOwners.run();
        address verifier = vm.envAddress("VERIFIER");
        address ecdsaDkimAddr = vm.envAddress("ECDSA_DKIM");
        address dkim = vm.envAddress("DKIM");
        assertEq(
            OwnableUpgradeable(verifier).owner(),
            vm.envAddress("NEW_OWNER")
        );
        assertEq(
            OwnableUpgradeable(ecdsaDkimAddr).owner(),
            vm.envAddress("NEW_OWNER")
        );
        assertEq(OwnableUpgradeable(dkim).owner(), vm.envAddress("NEW_OWNER"));
    }
}
