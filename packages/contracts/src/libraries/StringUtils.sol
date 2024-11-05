// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {strings} from "solidity-stringutils/src/strings.sol";

/**
 * @title StringUtils
 * @notice This library provides utility functions for converting hexadecimal strings to bytes.
 * @author Clave & ZK Email
 */
library StringUtils {
    using strings for *;

    /**
     * @dev Converts a hexadecimal string to bytes.
     * @param hexStr The hexadecimal string to convert. Must start with "0x" prefix.
     * @return bytes A bytes array representing the converted hexadecimal string.
     */
    function hexToBytes(
        string calldata hexStr
    ) public pure returns (bytes memory) {
        require(
            hexStr.toSlice().startsWith("0x".toSlice()),
            "invalid hex prefix"
        );
        string memory hexStrNoPrefix = hexStr[2:];
        bytes memory hexBytes = bytes(hexStrNoPrefix);
        require(
            hexBytes.length != 0 && hexBytes.length % 2 == 0,
            "invalid hex string length"
        );

        bytes memory result = new bytes(hexBytes.length / 2);
        for (uint256 i = 0; i < hexBytes.length / 2; i++) {
            result[i] = bytes1(
                (hexChar2Int(hexBytes[2 * i]) << 4) +
                    hexChar2Int(hexBytes[2 * i + 1])
            );
        }
        return result;
    }

    /**
     * @dev Converts a hexadecimal string to a bytes32 value.
     * @param hexStr The hexadecimal string to convert.
     * @return bytes32 A bytes32 value representing the converted hexadecimal string.
     */
    function hexToBytes32(
        string calldata hexStr
    ) public pure returns (bytes32) {
        bytes memory result = hexToBytes(hexStr);
        require(result.length == 32, "bytes length is not 32");
        return bytes32(result);
    }

    /**
     * @dev Converts a single hexadecimal character to its integer equivalent.
     * @param char The hexadecimal character to convert (0-9, A-F, or a-f).
     * @return uint8 The integer value of the hexadecimal character (0-15).
     */
    function hexChar2Int(bytes1 char) private pure returns (uint8) {
        uint8 charInt = uint8(char);
        if (charInt >= 48 && charInt <= 57) {
            return charInt - 48; // '0' - '9'
        } else if (charInt >= 65 && charInt <= 70) {
            return charInt - 55; // 'A' - 'F'
        } else if (charInt >= 97 && charInt <= 102) {
            return charInt - 87; // 'a' - 'f'
        } else {
            revert("invalid hex char");
        }
    }
}
