// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {L2ContractHelper} from "@matterlabs/zksync-contracts/l2/contracts/L2ContractHelper.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
// import {SystemContractsCaller} from "@matterlabs/zksync-contracts/l2/system-contracts/libraries/SystemContractsCaller.sol";
// import {DEPLOYER_SYSTEM_CONTRACT} from "@matterlabs/zksync-contracts/l2/system-contracts/Constants.sol";

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

        // See the example code
        // https://github.com/matter-labs/foundry-zksync/blob/13497a550e4a097c57bec7430435ab810a6d10fc/zk-tests/src/Contracts.t.sol#L195
        string memory artifact = vm.readFile(
            "zkout/ERC1967Proxy.sol/ERC1967Proxy.json"
        );
        bytes32 bytecodeHash = vm.parseJsonBytes32(
            artifact,
            '.hash'
        );
        console.log("bytecodeHash");
        console.logBytes32(bytes32(bytecodeHash));
        address computedAddress = L2ContractHelper.computeCreate2Address(
            address(this),
            accountSalt,
            bytes32(bytecodeHash),
            keccak256(
                abi.encode(
                    address(emailAuth),
                    abi.encodeCall(
                        EmailAuth.initialize,
                        (recoveredAccount, accountSalt, address(this))
                    )
                )
            )
        );

        console.log("computedAddress", computedAddress);

        // This is the previous way to deploy the proxy -> test has been passed but not working actually by clave side
        // ERC1967Proxy proxy = new ERC1967Proxy{salt: accountSalt}(
        //     address(emailAuth),
        //     abi.encodeCall(
        //         EmailAuth.initialize,
        //         (recoveredAccount, accountSalt, address(this))
        //     )
        // );
        // console.log("proxy", address(proxy));
        // assertEq(computedAddress, address(proxy));

        // (bool success, bytes memory returnData) = SystemContractsCaller
        //     .systemCallWithReturndata(
        //         uint32(gasleft()),
        //         address(DEPLOYER_SYSTEM_CONTRACT),
        //         uint128(0),
        //         abi.encodeCall(
        //             DEPLOYER_SYSTEM_CONTRACT.create2,
        //             (
        //                 accountSalt,
        //                 bytecodeHash,
        //                 abi.encode(
        //                     address(emailAuth),
        //                     abi.encodeCall(
        //                         EmailAuth.initialize,
        //                         (
        //                             recoveredAccount,
        //                             accountSalt,
        //                             address(this)
        //                         )
        //                     )
        //                 )
        //             )
        //         )
        //     );
        // address payable proxyAddress = abi.decode(returnData, (address));
    }
}
