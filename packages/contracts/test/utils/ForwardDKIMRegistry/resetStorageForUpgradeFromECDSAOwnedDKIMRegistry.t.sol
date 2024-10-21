// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "../../../src/utils/ForwardDKIMRegistry.sol";
import "./base.t.sol"; // Import the MockDKIMRegistry

contract ForwardDKIMRegistryTest_resetStorageForUpgradeFromECDSAOwnedDKIMRegistry is
    Test
{
    ForwardDKIMRegistry forwardDKIMRegistry;
    MockDKIMRegistry mockDKIMRegistry;
    address newSourceDKIMRegistry;

    function setUp() public {
        mockDKIMRegistry = new MockDKIMRegistry();
        forwardDKIMRegistry = new ForwardDKIMRegistry();
        forwardDKIMRegistry.initialize(
            address(this),
            address(mockDKIMRegistry)
        );
        newSourceDKIMRegistry = address(new MockDKIMRegistry());
    }

    function testResetStorageForUpgradeFromECDSAOwnedDKIMRegistry() public {
        // Set a new source DKIMRegistry
        forwardDKIMRegistry.resetStorageForUpgradeFromECDSAOwnedDKIMRegistry(
            newSourceDKIMRegistry
        );

        // Verify that the sourceDKIMRegistry is updated
        assertEq(
            address(forwardDKIMRegistry.sourceDKIMRegistry()),
            newSourceDKIMRegistry,
            "The source DKIMRegistry should be updated."
        );

        // Verify that the storage slot for signer is reset
        bytes32 signerSlot = keccak256(abi.encodePacked(uint256(1)));
        bytes32 expectedSignerValue = bytes32(0);
        bytes32 actualSignerValue;
        assembly {
            actualSignerValue := sload(signerSlot)
        }
        assertEq(
            actualSignerValue,
            expectedSignerValue,
            "The signer storage slot should be reset to zero."
        );
    }
}
