// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {Address} from "@openzeppelin/contracts/utils/Address.sol";
import {RecoveryModule} from "./RecoveryModule.sol";

contract SimpleWallet is OwnableUpgradeable {
    enum GuardianStatus {
        NONE,
        REQUESTED,
        ACCEPTED
    }

    /// @notice Fallback function to receive ETH
    fallback() external payable {}

    /// @notice Function to receive ETH
    receive() external payable {}

    address public recoveryModule;

    constructor() {}

    function initialize(
        address _initialOwner,
        address _recoveryModule
    ) public initializer {
        __Ownable_init(_initialOwner);
        recoveryModule = _recoveryModule;
        RecoveryModule(_recoveryModule).configureTimelockPeriod(
            RecoveryModule(_recoveryModule).DEFAULT_TIMELOCK_PERIOD()
        );
    }

    function transfer(address to, uint256 amount) public onlyOwner {
        require(address(this).balance >= amount, "insufficient balance");
        Address.sendValue(payable(to), amount);
    }

    function withdraw(uint256 amount) public onlyOwner {
        transfer(msg.sender, amount);
    }

    function changeOwner(address newOwner) public {
        require(
            msg.sender == owner() || msg.sender == recoveryModule,
            "only owner or recovery module"
        );
        _transferOwnership(newOwner);
    }
}
