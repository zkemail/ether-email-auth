// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "../src/EmailAuth.sol";
import {ZKSyncCreate2Factory} from "../src/utils/ZKSyncCreate2Factory.sol";

contract Deploy is Script {
    using ECDSA for *;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        if (deployerPrivateKey == 0) {
            console.log("PRIVATE_KEY env var not set");
            return;
        }

        vm.startBroadcast(deployerPrivateKey);

        EmailAuth emailAuth = new EmailAuth();

        address recoveredAccount = address(0x1);
        bytes32 accountSalt = 0x0;

        ERC1967Proxy proxy = new ERC1967Proxy(
            address(emailAuth), 
            abi.encodeCall(emailAuth.initialize, (recoveredAccount, accountSalt, address(this)))
        );
        console.log("normal deployed proxyAddress %s", address(proxy));

        ZKSyncCreate2Factory factory = new ZKSyncCreate2Factory();
        string memory artifact = vm.readFile("zkout/ERC1967Proxy.sol/ERC1967Proxy.json");
        bytes32 bytecodeHash = vm.parseJsonBytes32(artifact, ".hash");
        console.log("bytecodeHash");
        console.logBytes32(bytes32(bytecodeHash));

        bytes memory emailAuthInit = abi.encode(
            address(emailAuth), abi.encodeCall(EmailAuth.initialize, (recoveredAccount, accountSalt, address(this)))
        );

        address computedAddress = factory.computeAddress(accountSalt, bytecodeHash, emailAuthInit);
        console.log("computedAddress", computedAddress);

        (bool success, bytes memory returnData) = factory.deploy(accountSalt, bytecodeHash, emailAuthInit);

        address payable proxyAddress = abi.decode(returnData, (address));
        console.log("proxyAddress %s", proxyAddress);

        EmailAuth emailAuthProxy = EmailAuth(proxyAddress);
        console.log("emailAuthProxy.controller() %s", emailAuthProxy.controller());
        vm.stopBroadcast();
    }
}
