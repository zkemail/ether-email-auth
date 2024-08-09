// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "../src/utils/ForwardDKIMRegistry.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract Deploy is Script {
    ForwardDKIMRegistry dkimImpl;
    ForwardDKIMRegistry dkim;
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        if (deployerPrivateKey == 0) {
            console.log("PRIVATE_KEY env var not set");
            return;
        }
        address sourceDKIMRegistry = vm.envAddress("SOURCE_DKIM");
        if (sourceDKIMRegistry == address(0)) {
            console.log("SOURCE_DKIM env var not set");
            return;
        }

        vm.startBroadcast(deployerPrivateKey);
        address initialOwner = vm.addr(deployerPrivateKey);
        console.log("Initial owner: %s", vm.toString(initialOwner));

        // Deploy Forward DKIM registry
        {
            dkimImpl = new ForwardDKIMRegistry();
            console.log(
                "ForwardDKIMRegistry implementation deployed at: %s",
                address(dkimImpl)
            );
            ERC1967Proxy dkimProxy = new ERC1967Proxy(
                address(dkimImpl),
                abi.encodeCall(
                    dkimImpl.initialize,
                    (initialOwner, sourceDKIMRegistry)
                )
            );
            dkim = ForwardDKIMRegistry(address(dkimProxy));
            console.log("ForwardDKIMRegistry deployed at: %s", address(dkim));
            vm.setEnv("DKIM", vm.toString(address(dkim)));
        }

        vm.stopBroadcast();
    }
}
