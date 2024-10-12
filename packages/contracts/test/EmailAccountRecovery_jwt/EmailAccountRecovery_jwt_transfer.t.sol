// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {EmailAuth, EmailAuthMsg} from "../../src/EmailAuth.sol";
import {RecoveryController} from "../helpers/RecoveryController.sol";
import {StructHelper} from "../helpers/StructHelper.sol";
import {SimpleWallet} from "../helpers/SimpleWallet.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract EmailAccountRecoveryTest_jwt_transfer is StructHelper {
    constructor() {}

    function setUp() public override {
        super.setUp();
    }

    function testTransfer() public {
        skipIfZkSync();

        setUp();

        assertEq(address(jwtSimpleWallet).balance, 1 ether);
        assertEq(receiver.balance, 0 ether);

        vm.startPrank(deployer);
        jwtSimpleWallet.transfer(receiver, 1 ether);
        vm.stopPrank();

        assertEq(address(jwtSimpleWallet).balance, 0 ether);
        assertEq(receiver.balance, 1 ether);
    }

    function testExpectRevertTransferOnlyOwner() public {
        skipIfZkSync();

        setUp();

        assertEq(address(jwtSimpleWallet).balance, 1 ether);
        assertEq(receiver.balance, 0 ether);

        vm.startPrank(receiver);
        vm.expectRevert(
            abi.encodeWithSelector(
                OwnableUpgradeable.OwnableUnauthorizedAccount.selector,
                receiver
            )
        );
        jwtSimpleWallet.transfer(receiver, 1 ether);
        vm.stopPrank();
    }

    function testExpectRevertTransferOnlyOwnerInsufficientBalance() public {
        skipIfZkSync();

        setUp();

        assertEq(address(jwtSimpleWallet).balance, 1 ether);
        assertEq(receiver.balance, 0 ether);

        vm.startPrank(deployer);
        assertEq(receiver.balance, 0 ether);
        vm.expectRevert(bytes("insufficient balance"));
        jwtSimpleWallet.transfer(receiver, 2 ether);
        vm.stopPrank();
    }
}
