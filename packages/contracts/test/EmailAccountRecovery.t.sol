// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "./helpers/DeploymentHelper.sol";

contract EmailAccountRecoveryTest is SimpleWallet, Test {
    address deployer = vm.addr(1);
    address receiver = vm.addr(2);
    address guardian = vm.addr(3);
    address newSigner = vm.addr(4);

    constructor() SimpleWallet() {}

    function setUpForInternal() public {
        vm.startPrank(deployer);
        initialize(msg.sender, address(0x0), address(0x0), address(0x0));
        vm.stopPrank();
    }

    function setUpForPublic() public {
        vm.startPrank(deployer);
        this.initialize(deployer, address(0x0), address(0x0), address(0x0));
        vm.deal(address(this), 1 ether);
        vm.stopPrank();
    }

    function testTransfer() public {
        setUpForPublic();
        vm.startPrank(deployer);
        assertEq(receiver.balance, 0 ether);
        this.transfer(receiver, 1 ether);
        assertEq(receiver.balance, 1 ether);
        vm.stopPrank();
    }

    function testExpectRevertTransferOnlyOwner() public {
        setUpForPublic();
        vm.expectRevert(bytes("only owner"));
        this.transfer(receiver, 1 ether);
    }

    function testExpectRevertTransferOnlyOwnerInsufficientBalance() public {
        setUpForPublic();
        vm.startPrank(deployer);
        assertEq(receiver.balance, 0 ether);
        vm.expectRevert(bytes("insufficient balance"));
        this.transfer(receiver, 2 ether);
        vm.stopPrank();
    }

    function testFailTransfer() public {
        setUpForPublic();
        vm.startPrank(receiver);
        assertEq(receiver.balance, 0 ether);
        this.transfer(receiver, 1 ether);
        vm.stopPrank();
    }

    function testWithdraw() public {
        setUpForPublic();
        vm.startPrank(deployer);
        assertEq(deployer.balance, 0 ether);
        this.withdraw(1 ether);
        assertEq(deployer.balance, 1 ether);
        vm.stopPrank();
    }

    function testFailWithdraw() public {
        setUpForPublic();
        vm.startPrank(receiver);
        assertEq(deployer.balance, 0 ether);
        this.withdraw(1 ether);
        vm.stopPrank();
    }

    function testAcceptanceSubjectTemplates() public {
        setUpForPublic();
        string[][] memory res = acceptanceSubjectTemplates();
        assertEq(res[0][0], "Accept");
        assertEq(res[0][1], "guardian");
        assertEq(res[0][2], "request");
        assertEq(res[0][3], "for");
        assertEq(res[0][4], "{ethAddr}");
    }

    function testRecoverySubjectTemplates() public {
        setUpForPublic();
        string[][] memory res = recoverySubjectTemplates();
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
        setUpForInternal();

        vm.startPrank(deployer);
        requestGuardian(guardian);
        vm.stopPrank();
    }

    function testFailRequestGuardian() public {
        setUpForPublic();

        vm.startPrank(receiver);
        this.requestGuardian(guardian);
        vm.stopPrank();
    }

    function testAcceptGuardian() public {
        testRequestGuardian();

        vm.startPrank(deployer);
        uint templateIdx = 0;
        bytes[] memory subjectParams = new bytes[](1);
        subjectParams[0] = abi.encode(address(this));
        acceptGuardian(guardian, templateIdx, subjectParams, 0x0);
        vm.stopPrank();
    }

    function testRecoverWallet() public {
        testAcceptGuardian();

        vm.startPrank(deployer);
        uint templateIdx = 0;
        bytes[] memory subjectParams = new bytes[](2);
        subjectParams[0] = abi.encode(address(this));
        subjectParams[1] = abi.encode(newSigner);
        processRecovery(guardian, templateIdx, subjectParams, 0x0);
        vm.stopPrank();
    }

    function testRejectRecovery() public {
        testRecoverWallet();

        vm.startPrank(deployer);
        rejectRecovery();
        vm.stopPrank();
    }

    function testExpectRevertRejectRecovery() public {
        testRecoverWallet();

        vm.startPrank(deployer);
        vm.warp(4 days);
        vm.expectRevert(bytes("timelock expired"));
        rejectRecovery();

        vm.stopPrank();
    }

    function testCompleteRecovery() public {
        testRecoverWallet();

        vm.startPrank(deployer);
        vm.warp(4 days);
        completeRecovery();
        vm.stopPrank();
    }

    function testExpectRevertCompleteRecovery() public {
        testRecoverWallet();

        vm.startPrank(deployer);
        vm.expectRevert(bytes("timelock not expired"));
        completeRecovery();
        vm.stopPrank();
    }
}
