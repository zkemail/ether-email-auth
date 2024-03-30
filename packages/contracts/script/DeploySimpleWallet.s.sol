// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "../test/helpers/SimpleWallet.sol";
import "../src/utils/Verifier.sol";
import "../src/utils/ECDSAOwnedDKIMRegistry.sol";
import "../src/EmailAuth.sol";

contract Deploy is Script {
    using ECDSA for *;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        if (deployerPrivateKey == 0) {
            console.log("PRIVATE_KEY env var not set");
            return;
        }
        address dkim = vm.envAddress("DKIM");
        if (dkim == address(0)) {
            console.log("DKIM env var not set");
            return;
        }
        address verifier = vm.envAddress("VERIFIER");
        if (verifier == address(0)) {
            console.log("VERIFIER env var not set");
            return;
        }
        address emailAuthImpl = vm.envAddress("EMAIL_AUTH_IMPL");
        if (emailAuthImpl == address(0)) {
            console.log("EMAIL_AUTH_IMPL env var not set");
            return;
        }
        address simpleWalletImpl = vm.envAddress("SIMPLE_WALLET_IMPL");
        if (simpleWalletImpl == address(0)) {
            console.log("SIMPLE_WALLET_IMPL env var not set");
            return;
        }
        
        vm.startBroadcast(deployerPrivateKey);
        bytes memory data = abi.encodeWithSelector(
            SimpleWallet(payable(simpleWalletImpl)).initialize.selector,
            verifier,
            dkim,
            emailAuthImpl
        );
        ERC1967Proxy proxy = new ERC1967Proxy(address(simpleWalletImpl), data);
        console.log("SimpleWallet deployed at: %s", address(proxy));
        vm.stopBroadcast();
    }
}
