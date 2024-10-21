// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "../helpers/StructHelper.sol";

contract EmailAccountRecoveryTest_general is Test, StructHelper {
    function test_erifier() public {
        assertEq(recoveryController.verifier(), address(verifier));
    }

    function test_DKIM() public {
        assertEq(recoveryController.dkim(), address(dkim));
    }

    function test_EmailAuthImplementation() public {
        assertEq(recoveryController.emailAuthImplementation(), address(emailAuth));
    }
}