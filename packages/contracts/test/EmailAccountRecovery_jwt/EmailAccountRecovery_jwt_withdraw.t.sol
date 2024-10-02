// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {EmailAuth, EmailAuthMsg} from "../../src/EmailAuth.sol";
import {RecoveryController} from "../helpers/RecoveryController.sol";
import {StructHelper} from "../helpers/StructHelper.sol";
import {SimpleWallet} from "../helpers/SimpleWallet.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract EmailAccountRecoveryTest_jwt_withdraw is StructHelper {
    constructor() {}

    function setUp() public override {
        super.setUp();
    }

    function testWithdraw() public {
        skipIfZkSync();

        setUp();

        assertEq(address(jwtSimpleWallet).balance, 1 ether);
        assertEq(deployer.balance, 0 ether);

        vm.startPrank(deployer);
        jwtSimpleWallet.withdraw(1 ether);
        vm.stopPrank();

        assertEq(address(jwtSimpleWallet).balance, 0 ether);
        assertEq(deployer.balance, 1 ether);
    }

    function testExpectRevertWithdrawOnlyOwner() public {
        skipIfZkSync();

        setUp();

        assertEq(address(jwtSimpleWallet).balance, 1 ether);
        assertEq(deployer.balance, 0 ether);

        vm.startPrank(receiver);
        vm.expectRevert(
            abi.encodeWithSelector(
                OwnableUpgradeable.OwnableUnauthorizedAccount.selector,
                address(receiver)
            )
        );
        jwtSimpleWallet.withdraw(1 ether);
        vm.stopPrank();
    }

    function testExpectRevertWithdrawInsufficientBalance() public {
        skipIfZkSync();

        setUp();

        assertEq(address(jwtSimpleWallet).balance, 1 ether);
        assertEq(deployer.balance, 0 ether);

        vm.startPrank(deployer);
        vm.expectRevert(bytes("insufficient balance"));
        jwtSimpleWallet.withdraw(10 ether);
        vm.stopPrank();
    }
}
