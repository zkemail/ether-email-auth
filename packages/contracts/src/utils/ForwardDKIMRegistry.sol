// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@zk-email/contracts/DKIMRegistry.sol";
import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

/// @title Forward DKIM Registry
/// @notice This contract forwards outputs from a source DKIMRegistry contract.
contract ForwardDKIMRegistry is
    IDKIMRegistry,
    OwnableUpgradeable,
    UUPSUpgradeable
{
    IDKIMRegistry public sourceDKIMRegistry;

    event sourceDKIMRegistryChanged(
        address indexed oldRegistry,
        address indexed newRegistry
    );
    event StorageReset(address indexed sourceDKIMRegistry);

    constructor() {}

    /// @notice Initializes the contract with a predefined signer and deploys a new DKIMRegistry.
    /// @param _initialOwner The address of the initial owner of the contract.
    /// @param _sourceDKIMRegistry The address of the source DKIMRegistry contract to forward outputs from.
    function initialize(
        address _initialOwner,
        address _sourceDKIMRegistry
    ) public initializer {
        __Ownable_init(_initialOwner);
        sourceDKIMRegistry = IDKIMRegistry(_sourceDKIMRegistry);
    }

    /// @notice Checks if a DKIM public key hash is valid and not revoked for a given domain name.
    /// @param domainName The domain name to check the DKIM public key hash for.
    /// @param publicKeyHash The DKIM public key hash to validate.
    /// @return bool Returns true if the public key hash is valid and not revoked, false otherwise.
    function isDKIMPublicKeyHashValid(
        string memory domainName,
        bytes32 publicKeyHash
    ) public view returns (bool) {
        return
            sourceDKIMRegistry.isDKIMPublicKeyHashValid(
                domainName,
                publicKeyHash
            );
    }

    /// @notice Sets a new souce DKIMRegistry contract to forward outputs from.
    /// @param _newSourceDKIMRegistry The address of the new source DKIMRegistry contract.
    function changeSourceDKIMRegistry(
        address _newSourceDKIMRegistry
    ) public onlyOwner {
        require(_newSourceDKIMRegistry != address(0), "Invalid address");
        require(
            _newSourceDKIMRegistry != address(sourceDKIMRegistry),
            "Same source DKIMRegistry"
        );
        require(
            _newSourceDKIMRegistry != address(this),
            "Cannot set self as source DKIMRegistry"
        );
        address oldRegistryAddr = address(sourceDKIMRegistry);
        sourceDKIMRegistry = IDKIMRegistry(_newSourceDKIMRegistry);
        emit sourceDKIMRegistryChanged(oldRegistryAddr, _newSourceDKIMRegistry);
    }

    /// @notice Upgrade the implementation of the proxy from the ECDSAOwnedDKIMRegistry.
    /// @param _sourceDKIMRegistry The address of the source DKIMRegistry contract to forward outputs from.
    /// @dev This function resets the storage at sourceDKIMRegistry.slot+1, which is `signer` in the ECDSAOwnedDKIMRegistry contract.
    function resetStorageForUpgradeFromECDSAOwnedDKIMRegistry(
        address _sourceDKIMRegistry
    ) public onlyOwner {
        assembly {
            sstore(sourceDKIMRegistry.slot, _sourceDKIMRegistry)
            sstore(add(sourceDKIMRegistry.slot, 1), 0)
        }
        emit StorageReset(_sourceDKIMRegistry);
    }

    /// @notice Upgrade the implementation of the proxy.
    /// @param newImplementation Address of the new implementation.
    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}
}
