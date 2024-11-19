// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "../test/helpers/SimpleWallet.sol";
import "../src/utils/Verifier.sol";
import "../src/utils/Groth16Verifier.sol";
import "../src/utils/ECDSAOwnedDKIMRegistry.sol";
import "../src/EmailAuth.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract RequestGuardian is Script {
    using ECDSA for *;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        if (deployerPrivateKey == 0) {
            console.log("PRIVATE_KEY env var not set");
            return;
        }

        address simpleWalletAddr = vm.envAddress("SIMPLE_WALLET");
        if (simpleWalletAddr == address(0)) {
            console.log("SIMPLE_WALLET env var not set");
            return;
        }

        address controllerAddr = vm.envAddress("RECOVERY_CONTROLLER");
        if (controllerAddr == address(0)) {
            console.log("RECOVERY_CONTROLLER env var not set");
            return;
        }

        bytes32 accountSalt = vm.envBytes32("ACCOUNT_SALT");
        if (accountSalt == 0) {
            console.log("ACCOUNT_SALT env var not set");
            return;
        }

        vm.startBroadcast(deployerPrivateKey);
        address initialOwner = vm.addr(deployerPrivateKey);
        console.log("Initial owner: %s", vm.toString(initialOwner));

        RecoveryController controller = RecoveryController(controllerAddr);
        address guardian = controller.computeEmailAuthAddress(
            simpleWalletAddr,
            accountSalt
        );
        console.log("Guardian: %s", vm.toString(guardian));
        SimpleWallet wallet = SimpleWallet(payable(simpleWalletAddr));
        wallet.requestGuardian(guardian);
        vm.stopBroadcast();
    }
}
