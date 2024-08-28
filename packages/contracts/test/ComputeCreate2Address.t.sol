// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {ZKSyncCreate2Factory} from "../src/utils/ZKSyncCreate2Factory.sol";
import "../src/EmailAuth.sol";
import "./helpers/StructHelper.sol";

contract ComputeCreate2AddressTest is StructHelper {
    constructor() {}

    function testComputeCreate2Address() public {
        // This test is not neccessary for non zkSync chains
        if (block.chainid != 324 && block.chainid != 300) {
            console.log("skip");
            return;
        }

        address recoveredAccount = address(0x1);
        bytes32 accountSalt = 0x0;
        ZKSyncCreate2Factory factory = new ZKSyncCreate2Factory();
        bytes memory emailAuthInit = abi.encode(
            address(emailAuth), abi.encodeCall(EmailAuth.initialize, (recoveredAccount, accountSalt, address(this)))
        );

        // See the example code
        // https://github.com/matter-labs/foundry-zksync/blob/13497a550e4a097c57bec7430435ab810a6d10fc/zk-tests/src/Contracts.t.sol#L195
        string memory artifact = vm.readFile("zkout/ERC1967Proxy.sol/ERC1967Proxy.json");
        bytes32 bytecodeHash = vm.parseJsonBytes32(artifact, ".hash");
        console.log("bytecodeHash");
        console.logBytes32(bytes32(bytecodeHash));

        address computedAddress = factory.computeAddress(accountSalt, bytecodeHash, emailAuthInit);
        console.log("computedAddress", computedAddress);

        (bool success, bytes memory returnData) = factory.deploy(accountSalt, bytecodeHash, emailAuthInit);

        address payable proxyAddress = abi.decode(returnData, (address));
        assertEq(proxyAddress, computedAddress);
    }
}