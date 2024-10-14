// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "../test/helpers/SimpleWallet.sol";

contract Deploy is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        if (deployerPrivateKey == 0) {
            console.log("PRIVATE_KEY env var not set");
            return;
        }
        address initOwner = vm.addr(deployerPrivateKey);
        address controller = vm.envAddress("CONTROLLER");
        address simpleWalletImpl = vm.envAddress("SIMPLE_WALLET_IMPL");
        if (simpleWalletImpl == address(0)) {
            console.log("SIMPLE_WALLET_IMPL env var not set");
            return;
        }

        vm.startBroadcast(deployerPrivateKey);
        bytes memory data = abi.encodeWithSelector(
            SimpleWallet(payable(simpleWalletImpl)).initialize.selector,
            initOwner,
            controller
        );
        ERC1967Proxy proxy = new ERC1967Proxy(address(simpleWalletImpl), data);
        console.log("SimpleWallet deployed at: %s", address(proxy));
        vm.stopBroadcast();
    }
}
