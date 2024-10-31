// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "../src/EmailAuth.sol";
import {ZKSyncCreate2Factory} from "../src/utils/ZKSyncCreate2Factory.sol";
import "./BaseDeployScript.sol";

contract Deploy is BaseDeployScript {
    using ECDSA for *;

    function run() public override {
        super.run();
        vm.startBroadcast(deployerPrivateKey);

        EmailAuth emailAuth = EmailAuth(deployEmailAuthImplementation());

        address recoveredAccount = address(0x1);
        bytes32 accountSalt = 0x0;
        address controller = address(this);
        bytes memory emailAuthInit = abi.encode(
            address(emailAuth), abi.encodeCall(EmailAuth.initialize, (recoveredAccount, accountSalt, controller))
        );

        ZKSyncCreate2Factory factory = ZKSyncCreate2Factory(deployZKSyncCreate2Factory());
        string memory artifact = vm.readFile("zkout/ERC1967Proxy.sol/ERC1967Proxy.json");
        bytes32 bytecodeHash = vm.parseJsonBytes32(artifact, ".hash");
        console.log("bytecodeHash");
        console.logBytes32(bytes32(bytecodeHash));

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
