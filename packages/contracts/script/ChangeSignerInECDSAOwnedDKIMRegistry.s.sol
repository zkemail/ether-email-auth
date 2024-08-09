// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import {ECDSAOwnedDKIMRegistry} from "../src/utils/ECDSAOwnedDkimRegistry.sol";

contract ChangeSigner is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        if (deployerPrivateKey == 0) {
            console.log("PRIVATE_KEY env var not set");
            return;
        }
        address ecdsaDkimAddr = vm.envAddress("ECDSA_DKIM");
        if (ecdsaDkimAddr == address(0)) {
            console.log("ECDSA_DKIM env var not set");
            return;
        }
        address newSigner = vm.envAddress("NEW_SIGNER");
        if (newSigner == address(0)) {
            console.log("NEW_SIGNER env var not set");
            return;
        }
        vm.startBroadcast(deployerPrivateKey);
        ECDSAOwnedDKIMRegistry ecdsaDkim = ECDSAOwnedDKIMRegistry(
            ecdsaDkimAddr
        );
        ecdsaDkim.changeSigner(newSigner);
        vm.stopBroadcast();
    }
}
