// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "./helpers/DeploymentHelper.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

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

        assertEq(address(this).balance, 1 ether);
        assertEq(receiver.balance, 0 ether);

        vm.startPrank(deployer);
        this.transfer(receiver, 1 ether);
        vm.stopPrank();

        assertEq(address(this).balance, 0 ether);
        assertEq(receiver.balance, 1 ether);
    }

    function testExpectRevertTransferOnlyOwner() public {
        setUpForPublic();

        assertEq(address(this).balance, 1 ether);
        assertEq(receiver.balance, 0 ether);

        vm.expectRevert(bytes("only owner"));
        this.transfer(receiver, 1 ether);
    }

    function testExpectRevertTransferOnlyOwnerInsufficientBalance() public {
        setUpForPublic();

        assertEq(address(this).balance, 1 ether);
        assertEq(receiver.balance, 0 ether);

        vm.startPrank(deployer);
        assertEq(receiver.balance, 0 ether);
        vm.expectRevert(bytes("insufficient balance"));
        this.transfer(receiver, 2 ether);
        vm.stopPrank();
    }

    function testWithdraw() public {
        setUpForPublic();

        assertEq(address(this).balance, 1 ether);
        assertEq(deployer.balance, 0 ether);

        vm.startPrank(deployer);
        this.withdraw(1 ether);
        vm.stopPrank();

        assertEq(address(this).balance, 0 ether);
        assertEq(deployer.balance, 1 ether);
    }

    function testExpectRevertWithdrawOnlyOwner() public {
        setUpForPublic();

        assertEq(address(this).balance, 1 ether);
        assertEq(deployer.balance, 0 ether);

        vm.startPrank(receiver);
        vm.expectRevert(bytes("only owner"));
        this.withdraw(1 ether);
        vm.stopPrank();
    }

    function testExpectRevertWithdrawInsufficientBalance() public {
        setUpForPublic();

        assertEq(address(this).balance, 1 ether);
        assertEq(deployer.balance, 0 ether);

        vm.startPrank(deployer);
        vm.expectRevert(bytes("insufficient balance"));
        this.withdraw(10 ether);
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

        require(guardians[guardian] == GuardianStatus.NONE);

        vm.startPrank(deployer);
        requestGuardian(guardian);
        vm.stopPrank();

        require(guardians[guardian] == GuardianStatus.REQUESTED);
    }

    function testExpectRevertRequestGuardianOnlyOwner() public {
        setUpForPublic();

        require(this.guardians(guardian) == GuardianStatus.NONE);

        vm.startPrank(receiver);
        vm.expectRevert(bytes("only owner"));
        this.requestGuardian(guardian);
        vm.stopPrank();
    }

    function testExpectRevertRequestGuardianInvalidGuardian() public {
        setUpForPublic();

        require(this.guardians(guardian) == GuardianStatus.NONE);

        vm.startPrank(deployer);
        vm.expectRevert(bytes("invalid guardian"));
        this.requestGuardian(address(0x0));
        vm.stopPrank();
    }

    function testExpectRevertRequestGuardianGuardianStatusMustBeNone() public {
        setUpForPublic();

        require(this.guardians(guardian) == GuardianStatus.NONE);

        vm.startPrank(deployer);
        this.requestGuardian(guardian);
        vm.expectRevert(bytes("guardian status must be NONE"));
        this.requestGuardian(guardian);
        vm.stopPrank();
    }

    function testAcceptGuardian() public {
        testRequestGuardian();

        require(guardians[guardian] == GuardianStatus.REQUESTED);

        vm.startPrank(deployer);
        uint templateIdx = 0;
        bytes[] memory subjectParams = new bytes[](1);
        subjectParams[0] = abi.encode(address(this));
        acceptGuardian(guardian, templateIdx, subjectParams, 0x0);
        vm.stopPrank();

        require(guardians[guardian] == GuardianStatus.ACCEPTED);
    }

    function testExpectRevertAcceptGuardianOnlyOwner() public {
        testRequestGuardian();

        require(guardians[guardian] == GuardianStatus.REQUESTED);

        transferOwnership(receiver);
        vm.startPrank(receiver);
        uint templateIdx = 0;
        bytes[] memory subjectParams = new bytes[](1);
        subjectParams[0] = abi.encode(address(this));
        vm.expectRevert(bytes("only owner"));
        acceptGuardian(guardian, templateIdx, subjectParams, 0x0);
        vm.stopPrank();
    }

    function testExpectRevertAcceptGuardianInvalidGuardian() public {
        testRequestGuardian();

        require(guardians[guardian] == GuardianStatus.REQUESTED);

        vm.startPrank(deployer);
        uint templateIdx = 0;
        bytes[] memory subjectParams = new bytes[](1);
        subjectParams[0] = abi.encode(address(this));
        vm.expectRevert(bytes("invalid guardian"));
        acceptGuardian(address(0x0), templateIdx, subjectParams, 0x0);
        vm.stopPrank();
    }

    function testExpectRevertAcceptGuardianGuardianStatusMustBeRequested()
        public
    {
        testRequestGuardian();

        require(guardians[guardian] == GuardianStatus.REQUESTED);

        vm.startPrank(deployer);
        uint templateIdx = 0;
        bytes[] memory subjectParams = new bytes[](1);
        subjectParams[0] = abi.encode(address(this));
        vm.expectRevert(bytes("guardian status must be REQUESTED"));
        acceptGuardian(deployer, templateIdx, subjectParams, 0x0);
        vm.stopPrank();
    }

    function testExpectRevertAcceptGuardianInvalidTemplateIndex() public {
        testRequestGuardian();

        require(guardians[guardian] == GuardianStatus.REQUESTED);

        vm.startPrank(deployer);
        uint templateIdx = 1;
        bytes[] memory subjectParams = new bytes[](1);
        subjectParams[0] = abi.encode(address(this));
        vm.expectRevert(bytes("invalid template index"));
        acceptGuardian(guardian, templateIdx, subjectParams, 0x0);
        vm.stopPrank();
    }

    function testExpectRevertAcceptGuardianInvalidSubjectParams() public {
        testRequestGuardian();

        require(guardians[guardian] == GuardianStatus.REQUESTED);

        vm.startPrank(deployer);
        uint templateIdx = 0;
        bytes[] memory subjectParams = new bytes[](2);
        subjectParams[0] = abi.encode(address(this));
        subjectParams[1] = abi.encode(newSigner);
        vm.expectRevert(bytes("invalid subject params"));
        acceptGuardian(guardian, templateIdx, subjectParams, 0x0);
        vm.stopPrank();
    }

    function testExpectRevertAcceptGuardianInvalidWalletAddressInEmail()
        public
    {
        testRequestGuardian();

        require(guardians[guardian] == GuardianStatus.REQUESTED);

        vm.startPrank(deployer);
        uint templateIdx = 0;
        bytes[] memory subjectParams = new bytes[](1);
        subjectParams[0] = abi.encode(deployer);
        vm.expectRevert(bytes("invalid wallet address in email"));
        acceptGuardian(guardian, templateIdx, subjectParams, 0x0);
        vm.stopPrank();
    }

    function testRecoverWallet() public {
        testAcceptGuardian();

        assertEq(isRecovering, false);
        assertEq(timelock, 0);
        assertEq(owner(), msg.sender);
        assertEq(newSignerCandidate, address(0x0));

        vm.startPrank(deployer);
        uint templateIdx = 0;
        bytes[] memory subjectParams = new bytes[](2);
        subjectParams[0] = abi.encode(address(this));
        subjectParams[1] = abi.encode(newSigner);
        processRecovery(guardian, templateIdx, subjectParams, 0x0);
        vm.stopPrank();

        assertEq(isRecovering, true);
        assertEq(timelock, block.timestamp + 3 days);
        assertEq(owner(), msg.sender);
        assertEq(newSignerCandidate, newSigner);
    }

    function testExpectRevertRecoverWalletInvalidGuardian() public {
        testAcceptGuardian();

        assertEq(isRecovering, false);
        assertEq(timelock, 0);
        assertEq(owner(), msg.sender);
        assertEq(newSignerCandidate, address(0x0));

        vm.startPrank(deployer);
        uint templateIdx = 0;
        bytes[] memory subjectParams = new bytes[](2);
        subjectParams[0] = abi.encode(address(this));
        subjectParams[1] = abi.encode(newSigner);
        vm.expectRevert(bytes("invalid guardian"));
        processRecovery(address(0x0), templateIdx, subjectParams, 0x0);
        vm.stopPrank();
    }

    function testExpectRevertRecoverWalletGuardianStatusMustBeAccepted()
        public
    {
        testAcceptGuardian();

        assertEq(isRecovering, false);
        assertEq(timelock, 0);
        assertEq(owner(), msg.sender);
        assertEq(newSignerCandidate, address(0x0));

        vm.startPrank(deployer);
        uint templateIdx = 0;
        bytes[] memory subjectParams = new bytes[](2);
        subjectParams[0] = abi.encode(address(this));
        subjectParams[1] = abi.encode(newSigner);
        vm.expectRevert(bytes("guardian status must be ACCEPTED"));
        processRecovery(deployer, templateIdx, subjectParams, 0x0);
        vm.stopPrank();
    }

    function testExpectRevertRecoverWalletInvalidTemplateIndex() public {
        testAcceptGuardian();

        assertEq(isRecovering, false);
        assertEq(timelock, 0);
        assertEq(owner(), msg.sender);
        assertEq(newSignerCandidate, address(0x0));

        vm.startPrank(deployer);
        uint templateIdx = 1;
        bytes[] memory subjectParams = new bytes[](2);
        subjectParams[0] = abi.encode(address(this));
        subjectParams[1] = abi.encode(newSigner);
        vm.expectRevert(bytes("invalid template index"));
        processRecovery(guardian, templateIdx, subjectParams, 0x0);
        vm.stopPrank();
    }

    function testExpectRevertRecoverWalletInvalidSubjectParams() public {
        testAcceptGuardian();

        assertEq(isRecovering, false);
        assertEq(timelock, 0);
        assertEq(owner(), msg.sender);
        assertEq(newSignerCandidate, address(0x0));

        vm.startPrank(deployer);
        uint templateIdx = 0;
        bytes[] memory subjectParams = new bytes[](1);
        subjectParams[0] = abi.encode(address(this));
        vm.expectRevert(bytes("invalid subject params"));
        processRecovery(guardian, templateIdx, subjectParams, 0x0);
        vm.stopPrank();
    }

    function testExpectRevertRecoverWalletInvalidWalletAddressInEmail() public {
        testAcceptGuardian();

        assertEq(isRecovering, false);
        assertEq(timelock, 0);
        assertEq(owner(), msg.sender);
        assertEq(newSignerCandidate, address(0x0));

        vm.startPrank(deployer);
        uint templateIdx = 0;
        bytes[] memory subjectParams = new bytes[](2);
        subjectParams[0] = abi.encode(deployer);
        subjectParams[1] = abi.encode(newSigner);
        vm.expectRevert(bytes("invalid guardian in email"));
        processRecovery(guardian, templateIdx, subjectParams, 0x0);
        vm.stopPrank();
    }

    function testExpectRevertRecoverWalletInvalidNewSigner() public {
        testAcceptGuardian();

        assertEq(isRecovering, false);
        assertEq(timelock, 0);
        assertEq(owner(), msg.sender);
        assertEq(newSignerCandidate, address(0x0));

        vm.startPrank(deployer);
        uint templateIdx = 0;
        bytes[] memory subjectParams = new bytes[](2);
        subjectParams[0] = abi.encode(address(this));
        subjectParams[1] = abi.encode(address(0x0));
        vm.expectRevert(bytes("invalid new signer"));
        processRecovery(guardian, templateIdx, subjectParams, 0x0);
        vm.stopPrank();
    }

    function testRejectRecovery() public {
        testRecoverWallet();

        assertEq(isRecovering, true);
        assertEq(timelock, block.timestamp + 3 days);
        assertEq(owner(), msg.sender);
        assertEq(newSignerCandidate, newSigner);

        vm.startPrank(deployer);
        rejectRecovery();
        vm.stopPrank();

        assertEq(isRecovering, false);
        assertEq(timelock, 0);
        assertEq(owner(), msg.sender);
        assertEq(newSignerCandidate, address(0x0));
    }

    function testExpectRevertRejectRecoveryOwnableUnauthorizedAccount() public {
        testRecoverWallet();
        transferOwnership(receiver);

        assertEq(isRecovering, true);
        assertEq(timelock, block.timestamp + 3 days);
        assertEq(owner(), receiver);
        assertEq(newSignerCandidate, newSigner);

        vm.startPrank(deployer);
        vm.expectRevert(
            abi.encodeWithSelector(
                OwnableUpgradeable.OwnableUnauthorizedAccount.selector,
                msg.sender
            )
        );
        rejectRecovery();
        vm.stopPrank();
    }

    function testExpectRevertRejectRecoveryRecoveryNotInProgress() public {
        testAcceptGuardian();

        assertEq(isRecovering, false);
        assertEq(timelock, 0);
        assertEq(owner(), msg.sender);
        assertEq(newSignerCandidate, address(0x0));

        vm.startPrank(deployer);
        vm.expectRevert(bytes("recovery not in progress"));
        rejectRecovery();
        vm.stopPrank();
    }

    function testExpectRevertRejectRecovery() public {
        testRecoverWallet();

        assertEq(isRecovering, true);
        assertEq(timelock, block.timestamp + 3 days);
        assertEq(owner(), msg.sender);
        assertEq(newSignerCandidate, newSigner);

        vm.startPrank(deployer);
        vm.warp(4 days);
        vm.expectRevert(bytes("timelock expired"));
        rejectRecovery();
        vm.stopPrank();
    }

    function testCompleteRecovery() public {
        testRecoverWallet();

        assertEq(isRecovering, true);
        assertEq(timelock, block.timestamp + 3 days);
        assertEq(owner(), msg.sender);
        assertEq(newSignerCandidate, newSigner);

        vm.startPrank(deployer);
        vm.warp(4 days);
        completeRecovery();
        vm.stopPrank();

        assertEq(isRecovering, false);
        assertEq(timelock, 0);
        assertEq(owner(), newSigner);
        assertEq(newSignerCandidate, address(0x0));
    }

    function testExpectRevertCompleteRecoveryRecoveryNotInProgress() public {
        testAcceptGuardian();

        assertEq(isRecovering, false);
        assertEq(timelock, 0);
        assertEq(owner(), msg.sender);
        assertEq(newSignerCandidate, address(0x0));

        vm.startPrank(deployer);
        vm.warp(4 days);
        vm.expectRevert(bytes("recovery not in progress"));
        completeRecovery();
        vm.stopPrank();
    }

    function testExpectRevertCompleteRecovery() public {
        testRecoverWallet();

        assertEq(isRecovering, true);
        assertEq(timelock, block.timestamp + 3 days);
        assertEq(owner(), msg.sender);
        assertEq(newSignerCandidate, newSigner);

        vm.startPrank(deployer);
        vm.expectRevert(bytes("timelock not expired"));
        completeRecovery();
        vm.stopPrank();
    }
}
