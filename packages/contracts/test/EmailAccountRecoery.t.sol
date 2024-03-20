// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "./helpers/DeploymentHelper.sol";

contract EmailAccountRecoveryTest is DeploymentHelper {

    function setUp() public override {
        super.setUp();
    }

    function testTransfer() public {
        
        vm.startPrank(deployer);
        assertEq(receiver.balance, 0 ether);
        simpleWallet.transfer(receiver, 1 ether);
        assertEq(receiver.balance, 1 ether);
        vm.stopPrank();
    }

    function testFailTransfer() public {
        assertEq(receiver.balance, 0 ether);
        simpleWallet.transfer(receiver, 1 ether);
    }

    function testWithdraw() public {
        vm.startPrank(deployer);
        assertEq(deployer.balance, 0 ether);
        simpleWallet.withdraw(1 ether);
        assertEq(deployer.balance, 1 ether);
        vm.stopPrank();
    }   

   function testFailWithdraw() public {
        assertEq(deployer.balance, 0 ether);
        simpleWallet.withdraw(1 ether);
    }   

    function testAcceptanceSubjectTemplates() public {
        string[][] memory res = simpleWallet.acceptanceSubjectTemplates();
        assertEq(res[0][0], "Accept");
        assertEq(res[0][1], "guardian");
        assertEq(res[0][2], "request");
        assertEq(res[0][3], "for");
        assertEq(res[0][4], "{ethAddr}");
    }

    function testRecoverySubjectTemplates() public {
        string[][] memory res = simpleWallet.recoverySubjectTemplates();
        assertEq(res[0][0], "Set");
        assertEq(res[0][1], "the");
        assertEq(res[0][2], "new");
        assertEq(res[0][3], "signer");
        assertEq(res[0][4], "of");
        assertEq(res[0][5], "{ethAddr}");
        assertEq(res[0][6], "to");
        assertEq(res[0][7], "{ethAddr}");
    }

    function testRequestGuardian() public {
        vm.startPrank(deployer);
        simpleWallet.requestGuardian(guardian);
        vm.stopPrank();
    }

    function testFailRequestGuardian() public {
        simpleWallet.requestGuardian(guardian);
    }
}

