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
        // bytes memory bytecode = type(ERC1967Proxy).creationCode;
        // // address computedAddress;
        // // assembly {
        // //     let bytecodeSize := mload(bytecode)
        // //     computedAddress := create2(0, add(bytecode, 32), bytecodeSize, accountSalt)
        // //     if iszero(extcodesize(computedAddress)) {
        // //         revert(0, 0)
        // //     }
        // // }
        // bytes memory creationCode = type(ERC1967Proxy).creationCode;
        // bytes memory bytecodeHash = abi.encodePacked(
        //     bytes32(
        //         0x0000000000000000000000000000000000000000000000000000000000000000
        //     )
        // );        
        // for (uint8 i = 0; i < 32; i++) {
        //     bytecodeHash[i] = creationCode[4 + 32 + i];
        // }
        // address computedAddress = vm.computeCreate2Address(
        //     accountSalt, 
        //     keccak256(abi.encodePacked(
        //                 type(ERC1967Proxy).creationCode, 
        //                 abi.encode(
        //                     simpleWallet.emailAuthImplementation(),
        //                     abi.encodeCall(
        //                         EmailAuth.initialize,
        //                         (address(this), accountSalt)
        //                     )
        //                 ))), 
        //     address(this)
        // );
        address computedAddress = L2ContractHelper.computeCreate2Address(
                    address(this),
                    accountSalt,
                    keccak256(type(ERC1967Proxy).creationCode),
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
        // bytes32 senderBytes = bytes32(uint256(uint160(address(this))));
        // bytes32 bytecodeHash = keccak256(type(ERC1967Proxy).creationCode);
        // bytes32 constructorInputHash = keccak256(
        //     abi.encode(
        //         simpleWallet.emailAuthImplementation(),
        //         abi.encodeCall(
        //             EmailAuth.initialize,
        //             (address(this), accountSalt)
        //         )
        //     )
        // );
        // bytes32 data = keccak256(
        //     bytes.concat(senderBytes, accountSalt, bytecodeHash, constructorInputHash)
        // );
        // computedAddress = address(uint160(uint256(data)));

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