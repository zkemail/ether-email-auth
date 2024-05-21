// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

interface IAccountFactory {
    function deployAccount(
        bytes32 salt,
        bytes memory initializer
    ) external returns (address accountAddress);
}

