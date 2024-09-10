// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {Deploy} from "../../script/DeployCommons.s.sol";
import {Deploy as Deploy2} from "../../script/DeployForwardDKIMRegistry.s.sol";
import {RenounceOwners} from "../../script/RenounceOwners.s.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {StructHelper} from "../helpers/StructHelper.sol";

contract RenounceOwnersTest is StructHelper {
    function setUp() public override {
        vm.setEnv(
            "PRIVATE_KEY",
            "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"
        );
        vm.setEnv("SIGNER", "0x69bec2dd161d6bbcc91ec32aa44d9333ebc864c0");
    }

    function test_run() public {
        skipIfZkSync();

        Deploy deploy = new Deploy();
        deploy.run();
        vm.setEnv("SOURCE_DKIM", vm.toString(vm.envAddress("ECDSA_DKIM")));
        Deploy2 deploy2 = new Deploy2();
        deploy2.run();
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
