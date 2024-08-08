// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "../src/utils/ForwardDKIMRegistry.sol";

contract ChangeSource is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        if (deployerPrivateKey == 0) {
            console.log("PRIVATE_KEY env var not set");
            return;
        }
        address dkimAddr = vm.envAddress("DKIM");
        if (dkimAddr == address(0)) {
            console.log("DKIM env var not set");
            return;
        }
        address newSource = vm.envAddress("NEW_SOURCE");
        if (newSource == address(0)) {
            console.log("NEW_SOURCE env var not set");
            return;
        }
        vm.startBroadcast(deployerPrivateKey);
        ForwardDKIMRegistry dkim = ForwardDKIMRegistry(dkimAddr);
        dkim.changeSourceDKIMRegistry(newSource);
        vm.stopBroadcast();
    }
}
