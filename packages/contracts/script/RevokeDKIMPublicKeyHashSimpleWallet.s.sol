// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "../test/helpers/SimpleWallet.sol";
import "../test/helpers/RecoveryController.sol";
import "../src/utils/Verifier.sol";
import "../src/utils/Groth16Verifier.sol";
import "../src/EmailAuth.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {UserOverrideableDKIMRegistry} from "@zk-email/contracts/UserOverrideableDKIMRegistry.sol";
import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

contract RevokePublicKeyHash is Script {
    using ECDSA for *;

    UserOverrideableDKIMRegistry dkim;
    RecoveryController recoveryController;

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
        address walletAddr = vm.envAddress("SIMPLE_WALLET");
        if (walletAddr == address(0)) {
            console.log("SIMPLE_WALLET env var not set");
            return;
        }
        dkim = UserOverrideableDKIMRegistry(dkimAddr);
        string memory domainName = vm.envString("DOMAIN");
        if (bytes(domainName).length == 0) {
            console.log("DOMAIN env var not set");
            return;
        }
        bytes32 publicKeyHash = vm.envBytes32("PUBLIC_KEY_HASH");
        if (publicKeyHash == bytes32(0)) {
            console.log("PUBLIC_KEY_HASH env var not set");
            return;
        }
        string memory signedMsg = dkim.computeSignedMsg(
            dkim.REVOKE_PREFIX(),
            domainName,
            publicKeyHash
        );
        bytes32 digest = MessageHashUtils.toEthSignedMessageHash(
            bytes(signedMsg)
        );
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(deployerPrivateKey, digest);
        bytes memory signature = abi.encodePacked(r, s, v);
        vm.startBroadcast(deployerPrivateKey);
        dkim.revokeDKIMPublicKeyHash(
            domainName,
            publicKeyHash,
            walletAddr,
            signature
        );
        vm.stopBroadcast();
    }
}
