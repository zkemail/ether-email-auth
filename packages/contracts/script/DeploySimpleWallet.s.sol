// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// import "forge-std/Script.sol";

import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "../test/helpers/SimpleWallet.sol";
import {BaseDeployScript} from "./BaseDeployScript.sol";

contract Deploy is BaseDeployScript {
    function run() public override {
        super.run();
        address controller = vm.envAddress("RECOVERY_CONTROLLER");
        deploySimpleWallet(initialOwner, address(controller));
    }
}
