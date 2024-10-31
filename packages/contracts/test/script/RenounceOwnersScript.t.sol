// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {Deploy} from "../../script/DeployRecoveryController.s.sol";
import {RenounceOwners} from "../../script/RenounceOwners.s.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {StructHelper} from "../helpers/StructHelper.sol";

contract RenounceOwnersScriptTest is StructHelper {
    function setUp() public override {
        resetEnviromentVariables();
        super.setUp();
        vm.setEnv(
            "PRIVATE_KEY",
            "0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d"
        );
        vm.setEnv("DKIM_SIGNER", "0x69bec2dd161d6bbcc91ec32aa44d9333ebc864c0");
        vm.setEnv("INITIAL_OWNER", "0x70997970C51812dc3A010C7d01b50e0d17dc79C8");
    }

    function test_run() public {
        skipIfZkSync();
        Deploy deploy = new Deploy();
        deploy.run();
        deploy.deployECDSAOwnedDKIMRegistry(
            vm.addr(vm.envUint("PRIVATE_KEY")),
            vm.envAddress("DKIM_SIGNER")
        );
        RenounceOwners renounceOwners = new RenounceOwners();
        renounceOwners.run();
        address verifier = vm.envAddress("VERIFIER");
        address ecdsaDkimAddr = vm.envAddress("ECDSA_DKIM");
        address dkim = vm.envAddress("DKIM");
        assertEq(OwnableUpgradeable(verifier).owner(), address(0));
        assertEq(OwnableUpgradeable(ecdsaDkimAddr).owner(), address(0));
        assertEq(OwnableUpgradeable(dkim).owner(), address(0));
    }
}
