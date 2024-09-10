// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {Deploy} from "../../script/DeployCommons.s.sol";
import {Deploy as Deploy2} from "../../script/DeployForwardDKIMRegistry.s.sol";
import {Upgrades} from "../../script/Upgrades.s.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract UpgradesScriptTest is Test {
    uint256 internal constant IMPLEMENTATION_SLOT =
        0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    function setUp() public {
        vm.setEnv(
            "PRIVATE_KEY",
            "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"
        );
        vm.setEnv("SIGNER", "0x69bec2dd161d6bbcc91ec32aa44d9333ebc864c0");
    }

    function test_run() public {
        Deploy deploy = new Deploy();
        deploy.run();
        vm.setEnv("SOURCE_DKIM", vm.toString(vm.envAddress("ECDSA_DKIM")));
        Deploy2 deploy2 = new Deploy2();
        deploy2.run();
        // address verifier = vm.envAddress("VERIFIER");
        // address ecdsaDkimAddr = vm.envAddress("ECDSA_DKIM");
        // address dkim = vm.envAddress("DKIM");
        // address verifierImpl = _readAddressFromSlot(
        //     verifier,
        //     IMPLEMENTATION_SLOT
        // );
        // address ecdsaDkimImpl = _readAddressFromSlot(
        //     ecdsaDkimAddr,
        //     IMPLEMENTATION_SLOT
        // );
        // address dkimImpl = _readAddressFromSlot(dkim, IMPLEMENTATION_SLOT);
        Upgrades upgrades = new Upgrades();
        upgrades.run();
        // assertNotEq(
        //     verifierImpl,
        //     _readAddressFromSlot(verifier, IMPLEMENTATION_SLOT)
        // );
        // assertNotEq(
        //     ecdsaDkimImpl,
        //     _readAddressFromSlot(ecdsaDkimAddr, IMPLEMENTATION_SLOT)
        // );
        // assertNotEq(dkimImpl, _readAddressFromSlot(dkim, IMPLEMENTATION_SLOT));
    }

    // function _readAddressFromSlot(
    //     address contractAddress,
    //     uint256 slot
    // ) private view returns (address) {
    //     address value;
    //     assembly {
    //         // Create a pointer to the slot
    //         let ptr := mload(0x40)
    //         mstore(ptr, slot)
    //         // Read the value from the slot
    //         value := sload(add(ptr, contractAddress))
    //     }
    //     return value;
    // }
}
