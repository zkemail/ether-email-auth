// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {Address} from "@openzeppelin/contracts/utils/Address.sol";
import {RecoveryController} from "./RecoveryController.sol";
import {IERC1271} from "@openzeppelin/contracts/interfaces/IERC1271.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract SimpleWallet is OwnableUpgradeable, IERC1271 {
    using ECDSA for *;

    enum GuardianStatus {
        NONE,
        REQUESTED,
        ACCEPTED
    }

    /// @notice Fallback function to receive ETH
    fallback() external payable {}

    /// @notice Function to receive ETH
    receive() external payable {}

    address public recoveryController;

    constructor() {}

        function initialize(
        address _initialOwner,
        address _recoveryController
    ) public initializer {
        __Ownable_init(_initialOwner);
        recoveryController = _recoveryController;
        RecoveryController(_recoveryController).configureTimelockPeriod(
            RecoveryController(_recoveryController).DEFAULT_TIMELOCK_PERIOD()
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
            msg.sender == owner() || msg.sender == recoveryController,
            "only owner or recovery controller"
        );
        _transferOwnership(newOwner);
    }

    function requestGuardian(address guardian) public {
        require(msg.sender == owner(), "only owner");
        RecoveryController(recoveryController).requestGuardian(guardian);
    }

    /**
     * @notice Verifies that the signer is the owner of the signing contract.
     */
    function isValidSignature(
        bytes32 _hash,
        bytes calldata _signature
    ) external view override returns (bytes4) {
        // Validate signatures
        if (_hash.recover(_signature) == owner()) {
            return 0x1626ba7e;
        } else {
            return 0xffffffff;
        }
    }
}
