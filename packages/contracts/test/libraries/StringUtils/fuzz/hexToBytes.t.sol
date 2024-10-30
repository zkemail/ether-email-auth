// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {console} from "forge-std/console.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {StringUtils} from "src/libraries/StringUtils.sol";
import {StructHelper} from "../../../helpers/StructHelper.sol";

contract StringUtils_HexToBytes_Fuzz_Test is StructHelper {
    using Strings for uint256;

    function setUp() public override {
        super.setUp();
    }

    /// @notice Helper function to convert bytes to hex string for testing
    function bytesToHexString(
        bytes memory data
    ) internal pure returns (string memory) {
        bytes memory alphabet = "0123456789abcdef";
        bytes memory str = new bytes(2 + data.length * 2);
        str[0] = "0";
        str[1] = "x";
        for (uint256 i = 0; i < data.length; i++) {
            str[2 + i * 2] = alphabet[uint256(uint8(data[i] >> 4))];
            str[3 + i * 2] = alphabet[uint256(uint8(data[i] & 0x0f))];
        }
        return string(str);
    }

    function testFuzz_hexToBytes_ComputesExpectedBytes(
        bytes memory expectedBytes
    ) public {
        vm.assume(expectedBytes.length > 0);
        string memory bytesString = bytesToHexString(expectedBytes);

        if (bytes(bytesString).length % 2 != 0) {
            vm.expectRevert("invalid hex string length");
        }
        bytes memory bytesResult = StringUtils.hexToBytes(bytesString);

        assertEq(bytesResult, expectedBytes);
    }

    function testFuzz_hexToBytes_ComputesExpectedAddressBytes(
        address addressToBytes
    ) public pure {
        bytes memory expectedBytes = abi.encodePacked(addressToBytes);
        string memory bytesString = bytesToHexString(expectedBytes);

        bytes memory bytesResult = StringUtils.hexToBytes(bytesString);

        assertEq(bytesResult, expectedBytes);
    }

    function testFuzz_hexToBytes_ComputesExpectedCalldataBytes(
        bytes4 selector,
        address addressValue1,
        address addressValue2,
        bytes memory bytesValue,
        uint256 uintValue
    ) public {
        bytes memory expectedCalldata = abi.encodeWithSelector(
            selector,
            addressValue1,
            addressValue2,
            bytesValue,
            uintValue
        );
        string memory bytesString = bytesToHexString(expectedCalldata);

        bytes memory bytesResult = StringUtils.hexToBytes(bytesString);

        assertEq(bytesResult, expectedCalldata);
    }
}
