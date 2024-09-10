// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

contract ZKSyncCreate2FactoryBase {
    function computeAddress(bytes32 salt, bytes32 bytecodeHash, bytes memory input) external virtual view returns (address) {
        return address(0);
    }

    function deploy(bytes32 salt, bytes32 bytecodeHash, bytes memory input)
        external
        virtual
        returns (bool success, bytes memory returnData)
    {
        return (false, "");
    }
}
