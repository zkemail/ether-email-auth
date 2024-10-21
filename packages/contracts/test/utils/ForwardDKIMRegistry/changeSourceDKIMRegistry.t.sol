// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "./base.t.sol";
import "../../../src/utils/ForwardDKIMRegistry.sol";

contract ForwardDKIMRegistryTest_changeSourceDKIMRegistry is Test {
    ForwardDKIMRegistry forwardDKIMRegistry;
    MockDKIMRegistry mockDKIMRegistry;
    MockDKIMRegistry newMockDKIMRegistry;

    function setUp() public {
        mockDKIMRegistry = new MockDKIMRegistry();
        newMockDKIMRegistry = new MockDKIMRegistry();
        forwardDKIMRegistry = new ForwardDKIMRegistry();
        forwardDKIMRegistry.initialize(
            address(this),
            address(mockDKIMRegistry)
        );
    }

    function testChangeSourceDKIMRegistry_Success() public {
        forwardDKIMRegistry.changeSourceDKIMRegistry(
            address(newMockDKIMRegistry)
        );
        assertEq(
            address(forwardDKIMRegistry.sourceDKIMRegistry()),
            address(newMockDKIMRegistry),
            "The source DKIMRegistry should be updated."
        );
    }

    function testChangeSourceDKIMRegistry_InvalidAddress() public {
        vm.expectRevert("Invalid address");
        forwardDKIMRegistry.changeSourceDKIMRegistry(address(0));
    }

    function testChangeSourceDKIMRegistry_SameAddress() public {
        vm.expectRevert("Same source DKIMRegistry");
        forwardDKIMRegistry.changeSourceDKIMRegistry(address(mockDKIMRegistry));
    }

    function testChangeSourceDKIMRegistry_SelfAddress() public {
        vm.expectRevert("Cannot set self as source DKIMRegistry");
        forwardDKIMRegistry.changeSourceDKIMRegistry(
            address(forwardDKIMRegistry)
        );
    }
}
