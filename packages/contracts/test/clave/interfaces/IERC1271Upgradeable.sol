// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (interfaces/IERC1271.sol)

pragma solidity ^0.8.0;


interface IERC1271Upgradeable {

    function isValidSignature(bytes32 hash, bytes memory signature) external view returns (bytes4 magicValue);
}