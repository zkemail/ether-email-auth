// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {L2ContractHelper} from "@matterlabs/zksync-contracts/l2/contracts/L2ContractHelper.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

import "../src/EmailAuth.sol";
import "./helpers/StructHelper.sol";
// import "./helpers/SimpleWallet.sol";

contract ComputeCreate2AddressTest is StructHelper {
    constructor() {}

    function testComputeCreate2Address() public {
        bytes32 accountSalt = 0x0;

        string memory artifact = vm.readFile(
            "zkout/ERC1967Proxy.sol/artifacts.json"
        );
        bytes32 bytecodeHash = vm.parseJsonBytes32(
            artifact,
            '.contracts.["../../node_modules/@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol"].ERC1967Proxy.hash'
        );
        console.log("bytecodeHash");
        console.logBytes32(bytes32(bytecodeHash));

        address computedAddress = L2ContractHelper.computeCreate2Address(
                    address(this),
                    accountSalt,
                    bytes32(bytecodeHash),
                    keccak256(
                        abi.encode(
                            simpleWallet.emailAuthImplementation(),
                            abi.encodeCall(
                                EmailAuth.initialize,
                                (address(this), accountSalt)
                            )
                        )
                    )
        );

        console.log("computedAddress", computedAddress);

        ERC1967Proxy proxy = new ERC1967Proxy{
            salt: accountSalt
        }(
            simpleWallet.emailAuthImplementation(),
            abi.encodeCall(
                EmailAuth.initialize,
                (address(this), accountSalt)
            )
        );
        console.log("proxy", address(proxy));
        assertEq(computedAddress, address(proxy));
    }
}