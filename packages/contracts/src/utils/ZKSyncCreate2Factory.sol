// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import {ZKSyncCreate2FactoryBase} from "./ZKSyncCreate2FactoryBase.sol";
// // FOR_ZKSYNC:START
// import {L2ContractHelper} from "@matterlabs/zksync-contracts/l2/contracts/L2ContractHelper.sol";
// import {SystemContractsCaller} from "@matterlabs/zksync-contracts/l2/system-contracts/libraries/SystemContractsCaller.sol";
// import {DEPLOYER_SYSTEM_CONTRACT} from "@matterlabs/zksync-contracts/l2/system-contracts/Constants.sol";
// // FOR_ZKSYNC:END

contract ZKSyncCreate2Factory is ZKSyncCreate2FactoryBase {
    // // FOR_ZKSYNC:START
    // function computeAddress(bytes32 salt, bytes32 bytecodeHash, bytes memory input) external override view returns (address) {
    //     return L2ContractHelper.computeCreate2Address(address(this), salt, bytes32(bytecodeHash), keccak256(input));
    // }
    // function deploy(bytes32 salt, bytes32 bytecodeHash, bytes memory input)
    //     external
    //     override
    //     returns (bool success, bytes memory returnData)
    // {
    //     (success, returnData) = SystemContractsCaller.systemCallWithReturndata(
    //         uint32(gasleft()),
    //         address(DEPLOYER_SYSTEM_CONTRACT),
    //         uint128(0),
    //         abi.encodeCall(DEPLOYER_SYSTEM_CONTRACT.create2, (salt, bytecodeHash, input))
    //     );
    // }
    // // FOR_ZKSYNC:END
}
