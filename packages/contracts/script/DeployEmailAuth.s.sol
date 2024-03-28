// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "../src/EmailAuth.sol";
import "../src/utils/Verifier.sol";
import "../src/utils/ECDSAOwnedDKIMRegistry.sol";

contract DeployEmailAuth is Script {
    using ECDSA for *;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        if (deployerPrivateKey == 0) {
            console.log("PRIVATE_KEY env var not set");
            return;
        }
        vm.startBroadcast(deployerPrivateKey);

        // Deploy DKIM registry
        address signer = vm.envAddress("SIGNER");
        if (signer == address(0)) {
            console.log("SIGNER env var not set");
            return;
        }
        ECDSAOwnedDKIMRegistry dkim = new ECDSAOwnedDKIMRegistry(
            signer
        );
        console.log("ECDSAOwnedDKIMRegistry deployed at: %s", address(dkim));

        // Deploy Verifier
        Verifier verifier = new Verifier();
        console.log("ECDSAOwnedDKIMRegistry deployed at: %s", address(verifier));


        // Deploy EmailAuth
        EmailAuth emailAuth = new EmailAuth();
        console.log("EmailAuth deployed at: %s", address(emailAuth));
        emailAuth.updateVerifier(address(verifier));
        emailAuth.updateDKIMRegistry(address(dkim));
        vm.stopBroadcast();
    }
}
