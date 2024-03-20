// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Strings.sol";

/// @title DecimalUtils
/// @notice DecimalUtils library for converting uint256 to string with decimal places
library DecimalUtils {
    /// @notice Convert uint256 to human readable string with decimal places
    /// @param value uint256 value to convert
    /// @return string representation of value with decimal places
    function uintToDecimalString(uint256 value) public pure returns (string memory) {
        return uintToDecimalString(value, 18);
    }

    /// @notice Convert uint256 to human readable string with decimal places
    /// @param value uint256 value to convert
    /// @param decimal number of decimal places
    /// @return string representation of value with decimal places
    function uintToDecimalString(uint256 value, uint decimal) public pure returns (string memory) {
        // Convert value to string in wei format (no decimals)
        bytes memory valueBytes = bytes(Strings.toString(value));
        uint8 valueLength = uint8(valueBytes.length);

        // Create result array with max length
        // If less than 18 decimals, then 2 extra for "0.", otherwise one extra for "."
        bytes memory result = new bytes(valueLength > decimal ? valueLength + 1 : decimal + 2);
        uint8 resultLength = uint8(result.length);

        // We will be populating result array by copying from value array from last to first index
        // Difference between result and value array index when copying
        // If more than 18, then 1 index diff for ".", otherwise actual diff in length
        uint delta = valueLength > decimal ? 1 : resultLength - valueLength;

        // Boolean to indicate if we found a non-zero digit when scanning from last to first index
        bool foundNonZeroDecimal;

        uint8 actualResultLen = 0;

        // In each iteration we fill one index of result array (starting from end)
        for (uint8 i = resultLength - 1; i >= 0; i--) {
            // Check if we have reached the index where we need to add decimal point
            if (i == resultLength - decimal - 1) {
                // No need to add "." if there was no value in decimal places
                if (foundNonZeroDecimal) {
                    result[i] = ".";
                    actualResultLen++;
                }
                // Set delta to 0, as we have already added decimal point (only for valueLength > 18)
                delta = 0;
            }
            // If valueLength < 18 and we have copied everything, fill zeros
            else if (valueLength <= decimal && i < resultLength - valueLength) {
                result[i] = "0";
                actualResultLen++;
            }
            // If non-zero decimal is found, or decimal point inserted (delta == 0), copy from value array
            else if (foundNonZeroDecimal || delta == 0) {
                result[i] = valueBytes[i - delta];
                actualResultLen++;
            }
            // If we find non-zero decumal for the first time (trailing zeros are skipped)
            else if (valueBytes[i - delta] != "0") {
                result[i] = valueBytes[i - delta];
                actualResultLen++;
                foundNonZeroDecimal = true;
            }

            // To prevent the last i-- underflow
            if (i == 0) {
                break;
            }
        }

        // Create final result array with correct length
        bytes memory compactResult = new bytes(actualResultLen);
        for (uint8 i = 0; i < actualResultLen; i++) {
            compactResult[i] = result[i];
        }

        return string(compactResult);
    }
}

