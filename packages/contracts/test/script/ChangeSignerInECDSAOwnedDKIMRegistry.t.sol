// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {Deploy} from "../../script/DeployCommons.s.sol";
import {ChangeSigner} from "../../script/ChangeSignerInECDSAOwnedDKIMRegistry.s.sol";
import {ECDSAOwnedDKIMRegistry} from "../../src/utils/ECDSAOwnedDkimRegistry.sol";

contract ChangeSignerInECDSAOwnedDKIMRegistryTest is Test {
    function setUp() public {
        vm.setEnv(
            "PRIVATE_KEY",
            "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"
        );
        vm.setEnv("SIGNER", "0x69bec2dd161d6bbcc91ec32aa44d9333ebc864c0");
        vm.setEnv("NEW_SIGNER", "0xa1bec2dd161d6bbcc91ec32aa44d9333e2a864c0");
    }

    function test_run() public {
        Deploy deploy = new Deploy();
        deploy.run();
        ChangeSigner changeSigner = new ChangeSigner();
        changeSigner.run();
        address ecdsaDkimAddr = vm.envAddress("ECDSA_DKIM");
        ECDSAOwnedDKIMRegistry ecdsaDkim = ECDSAOwnedDKIMRegistry(
            ecdsaDkimAddr
        );
        assertEq(ecdsaDkim.signer(), vm.envAddress("NEW_SIGNER"));
    }
}
