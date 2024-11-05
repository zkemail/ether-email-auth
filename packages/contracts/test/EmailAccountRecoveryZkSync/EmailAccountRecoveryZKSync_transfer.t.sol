// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {EmailAuth, EmailAuthMsg} from "../../src/EmailAuth.sol";
import {RecoveryControllerZKSync} from "../helpers/RecoveryControllerZKSync.sol";
import {StructHelper} from "../helpers/StructHelper.sol";
import {SimpleWallet} from "../helpers/SimpleWallet.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract EmailAccountRecoveryZKSyncTest_transfer is StructHelper {
    constructor() {}

    function setUp() public override {
        super.setUp();
    }

    function testTransfer() public {
        skipIfNotZkSync();

        setUp();

        vm.deal(address(simpleWallet), 1 ether);
        assertEq(address(simpleWallet).balance, 1 ether);

        vm.deal(receiver, 0 ether);
        assertEq(receiver.balance, 0 ether);
        vm.startPrank(deployer);
        simpleWallet.transfer(receiver, 1 ether);
        vm.stopPrank();

        assertEq(address(simpleWallet).balance, 0 ether);
        assertEq(receiver.balance, 1 ether);
    }

    function testExpectRevertTransferOnlyOwner() public {
        skipIfNotZkSync();

        setUp();

        vm.deal(address(simpleWallet), 1 ether);
        assertEq(address(simpleWallet).balance, 1 ether);

        vm.deal(receiver, 0 ether);
        assertEq(receiver.balance, 0 ether);

        vm.startPrank(receiver);
        vm.expectRevert(
            abi.encodeWithSelector(
                OwnableUpgradeable.OwnableUnauthorizedAccount.selector,
                receiver
            )
        );
        simpleWallet.transfer(receiver, 1 ether);
        vm.stopPrank();
    }

    function testExpectRevertTransferOnlyOwnerInsufficientBalance() public {
        skipIfNotZkSync();

        setUp();
        vm.deal(address(simpleWallet), 1 ether);
        assertEq(address(simpleWallet).balance, 1 ether);

        vm.deal(receiver, 0 ether);
        assertEq(receiver.balance, 0 ether);

        vm.startPrank(deployer);
        vm.expectRevert(bytes("insufficient balance"));
        simpleWallet.transfer(receiver, 2 ether);
        vm.stopPrank();
    }
}
