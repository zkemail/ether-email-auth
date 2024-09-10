// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {EmailAuth, EmailAuthMsg} from "../../src/EmailAuth.sol";
import {RecoveryControllerZKSync} from "../helpers/RecoveryControllerZKSync.sol";
import {StructHelper} from "../helpers/StructHelper.sol";
import {SimpleWallet} from "../helpers/SimpleWallet.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract EmailAccountRecoveryZKSyncTest_completeRecovery is StructHelper {
    constructor() {}

    function setUp() public override {
        super.setUp();
    }

    function requestGuardian() public {
        setUp();
        require(
            recoveryControllerZKSync.guardians(guardian) ==
                RecoveryControllerZKSync.GuardianStatus.NONE
        );

        vm.startPrank(deployer);
        recoveryControllerZKSync.requestGuardian(guardian);
        vm.stopPrank();

        require(
            recoveryControllerZKSync.guardians(guardian) ==
                RecoveryControllerZKSync.GuardianStatus.REQUESTED
        );
    }

    function handleAcceptance() public {
        requestGuardian();

        console.log("guardian", guardian);

        require(
            recoveryControllerZKSync.guardians(guardian) ==
                RecoveryControllerZKSync.GuardianStatus.REQUESTED
        );

        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        uint templateId = recoveryControllerZKSync.computeAcceptanceTemplateId(
            templateIdx
        );
        emailAuthMsg.templateId = templateId;
        bytes[] memory subjectParamsForAcceptance = new bytes[](1);
        subjectParamsForAcceptance[0] = abi.encode(address(simpleWallet));
        emailAuthMsg.subjectParams = subjectParamsForAcceptance;

        vm.mockCall(
            address(recoveryControllerZKSync.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        // acceptGuardian is internal, we call handleAcceptance, which calls acceptGuardian internally.
        vm.startPrank(someRelayer);
        recoveryControllerZKSync.handleAcceptance(emailAuthMsg, templateIdx);
        vm.stopPrank();

        require(
            recoveryControllerZKSync.guardians(guardian) ==
                RecoveryControllerZKSync.GuardianStatus.ACCEPTED
        );
    }

    function handleRecovery() public {
        handleAcceptance();

        assertEq(recoveryControllerZKSync.isRecovering(address(simpleWallet)), false);
        assertEq(
            recoveryControllerZKSync.currentTimelockOfAccount(address(simpleWallet)),
            0
        );
        assertEq(simpleWallet.owner(), deployer);
        assertEq(
            recoveryControllerZKSync.newSignerCandidateOfAccount(
                address(simpleWallet)
            ),
            address(0x0)
        );

        uint templateIdx = 0;

        EmailAuthMsg memory emailAuthMsg = buildEmailAuthMsg();
        uint templateId = recoveryControllerZKSync.computeRecoveryTemplateId(
            templateIdx
        );
        emailAuthMsg.templateId = templateId;
        bytes[] memory subjectParamsForRecovery = new bytes[](2);
        subjectParamsForRecovery[0] = abi.encode(simpleWallet);
        subjectParamsForRecovery[1] = abi.encode(newSigner);
        emailAuthMsg.subjectParams = subjectParamsForRecovery;

        vm.mockCall(
            address(recoveryControllerZKSync.emailAuthImplementationAddr()),
            abi.encodeWithSelector(EmailAuth.authEmail.selector, emailAuthMsg),
            abi.encode(0x0)
        );

        vm.startPrank(someRelayer);
        recoveryControllerZKSync.handleRecovery(emailAuthMsg, templateIdx);
        vm.stopPrank();

        assertEq(recoveryControllerZKSync.isRecovering(address(simpleWallet)), true);
        assertEq(simpleWallet.owner(), deployer);
        assertEq(
            recoveryControllerZKSync.newSignerCandidateOfAccount(
                address(simpleWallet)
            ),
            newSigner
        );
        assertEq(
            recoveryControllerZKSync.currentTimelockOfAccount(address(simpleWallet)),
            block.timestamp +
                recoveryControllerZKSync.timelockPeriodOfAccount(
                    address(simpleWallet)
                )
        );
    }

    function testCompleteRecovery() public {
        skipIfNotZkSync();

        handleRecovery();

        assertEq(recoveryControllerZKSync.isRecovering(address(simpleWallet)), true);
        assertEq(
            recoveryControllerZKSync.currentTimelockOfAccount(address(simpleWallet)),
            block.timestamp +
                recoveryControllerZKSync.timelockPeriodOfAccount(
                    address(simpleWallet)
                )
        );
        assertEq(simpleWallet.owner(), deployer);
        assertEq(
            recoveryControllerZKSync.newSignerCandidateOfAccount(
                address(simpleWallet)
            ),
            newSigner
        );

        vm.startPrank(someRelayer);
        vm.warp(4 days);
        recoveryControllerZKSync.completeRecovery(
            address(simpleWallet),
            new bytes(0)
        );
        vm.stopPrank();

        assertEq(recoveryControllerZKSync.isRecovering(address(simpleWallet)), false);
        assertEq(
            recoveryControllerZKSync.currentTimelockOfAccount(address(simpleWallet)),
            0
        );
        assertEq(simpleWallet.owner(), newSigner);
        assertEq(
            recoveryControllerZKSync.newSignerCandidateOfAccount(
                address(simpleWallet)
            ),
            address(0x0)
        );
    }

    function testExpectRevertCompleteRecoveryRecoveryNotInProgress() public {
        skipIfNotZkSync();

        handleAcceptance();

        assertEq(recoveryControllerZKSync.isRecovering(address(simpleWallet)), false);
        assertEq(
            recoveryControllerZKSync.currentTimelockOfAccount(address(simpleWallet)),
            0
        );
        assertEq(simpleWallet.owner(), deployer);
        assertEq(
            recoveryControllerZKSync.newSignerCandidateOfAccount(
                address(simpleWallet)
            ),
            address(0x0)
        );

        vm.startPrank(someRelayer);
        vm.warp(4 days);
        vm.expectRevert(bytes("recovery not in progress"));
        bytes memory recoveryCalldata;
        recoveryControllerZKSync.completeRecovery(
            address(simpleWallet),
            recoveryCalldata
        );

        vm.stopPrank();
    }

    function testExpectRevertCompleteRecovery() public {
        vm.warp(block.timestamp + 3 days);

        handleRecovery();

        assertEq(recoveryControllerZKSync.isRecovering(address(simpleWallet)), true);
        assertEq(
            recoveryControllerZKSync.currentTimelockOfAccount(address(simpleWallet)),
            block.timestamp +
                recoveryControllerZKSync.timelockPeriodOfAccount(
                    address(simpleWallet)
                )
        );
        assertEq(simpleWallet.owner(), deployer);
        assertEq(
            recoveryControllerZKSync.newSignerCandidateOfAccount(
                address(simpleWallet)
            ),
            newSigner
        );

        vm.warp(0);

        vm.startPrank(someRelayer);
        vm.expectRevert(bytes("timelock not expired"));
        bytes memory recoveryCalldata;
        recoveryControllerZKSync.completeRecovery(
            address(simpleWallet),
            recoveryCalldata
        );

        vm.stopPrank();
    }
}
