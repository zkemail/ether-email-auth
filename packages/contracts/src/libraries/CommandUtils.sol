// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Address} from "@openzeppelin/contracts/utils/Address.sol";
import "./DecimalUtils.sol";

library CommandUtils {
    bytes16 private constant LOWER_HEX_DIGITS = "0123456789abcdef";
    bytes16 private constant UPPER_HEX_DIGITS = "0123456789ABCDEF";
    string public constant STRING_MATCHER = "{string}";
    string public constant UINT_MATCHER = "{uint}";
    string public constant INT_MATCHER = "{int}";
    string public constant DECIMALS_MATCHER = "{decimals}";
    string public constant ETH_ADDR_MATCHER = "{ethAddr}";

    function addressToHexString(
        address addr,
        uint stringCase
    ) internal pure returns (string memory) {
        if (stringCase == 0) {
            return addressToChecksumHexString(addr);
        } else if (stringCase == 1) {
            return Strings.toHexString(addr);
        } else if (stringCase == 2) {
            return lowerToUpperCase(Strings.toHexString(addr));
        } else {
            revert("invalid stringCase");
        }
    }

    function addressToChecksumHexString(
        address addr
    ) internal pure returns (string memory) {
        string memory lowerCaseAddrWithOx = Strings.toHexString(addr);

        bytes memory lowerCaseAddr = new bytes(40); // Remove 0x added by the OZ lib
        for (uint8 i = 2; i < 42; i++) {
            lowerCaseAddr[i - 2] = bytes(lowerCaseAddrWithOx)[i];
        }

        // Hash of lowercase addr
        uint256 lowerCaseHash = uint256(
            keccak256(abi.encodePacked(lowerCaseAddr))
        );

        // Result hex = 42 chars with 0x prefix
        bytes memory result = new bytes(42);
        result[0] = "0";
        result[1] = "x";

        // Shift 24 bytes (96 bits) to the right; as we only need first 20 bytes of the hash to compare
        lowerCaseHash >>= 24 * 4;

        uint256 intAddr = uint256(uint160(addr));

        for (uint8 i = 41; i > 1; --i) {
            uint8 hashChar = uint8(lowerCaseHash & 0xf); // Get last char of the hex
            uint8 addrChar = uint8(intAddr & 0xf); // Get last char of the address

            if (hashChar >= 8) {
                result[i] = UPPER_HEX_DIGITS[addrChar];
            } else {
                result[i] = LOWER_HEX_DIGITS[addrChar];
            }

            // Remove last char from both hash and addr
            intAddr >>= 4;
            lowerCaseHash >>= 4;
        }

        return string(result);
    }

    function lowerToUpperCase(
        string memory hexStr
    ) internal pure returns (string memory) {
        bytes memory bytesStr = bytes(hexStr);
        for (uint i = 0; i < bytesStr.length; i++) {
            if (bytesStr[i] >= 0x61 && bytesStr[i] <= 0x66) {
                bytesStr[i] = bytes1(uint8(bytesStr[i]) - 32);
            }
        }
        return string(bytesStr);
    }

    /// @notice Convert bytes to hex string without 0x prefix
    /// @param data bytes to convert
    function bytesToHexString(
        bytes memory data
    ) public pure returns (string memory) {
        bytes memory hexChars = "0123456789abcdef";
        bytes memory hexString = new bytes(2 * data.length);

        for (uint256 i = 0; i < data.length; i++) {
            uint256 value = uint256(uint8(data[i]));
            hexString[2 * i] = hexChars[value >> 4];
            hexString[2 * i + 1] = hexChars[value & 0xf];
        }

        return string(hexString);
    }

    /// @notice Calculate the expected command.
    /// @param commandParams Params to be used in the command
    /// @param template Template to be used for the command
    /// @param stringCase Case of the ethereum address string to be used for the command - 0: checksum, 1: lowercase, 2: uppercase
    function computeExpectedCommand(
        bytes[] memory commandParams,
        string[] memory template,
        uint stringCase
    ) public pure returns (string memory expectedCommand) {
        // Construct an expectedCommand from template and the values of commandParams.
        uint8 nextParamIndex = 0;
        string memory stringParam;
        bool isParamExist;
        for (uint8 i = 0; i < template.length; i++) {
            isParamExist = true;
            if (Strings.equal(template[i], STRING_MATCHER)) {
                string memory param = abi.decode(
                    commandParams[nextParamIndex],
                    (string)
                );
                stringParam = param;
            } else if (Strings.equal(template[i], UINT_MATCHER)) {
                uint256 param = abi.decode(
                    commandParams[nextParamIndex],
                    (uint256)
                );
                stringParam = Strings.toString(param);
            } else if (Strings.equal(template[i], INT_MATCHER)) {
                int256 param = abi.decode(
                    commandParams[nextParamIndex],
                    (int256)
                );
                stringParam = Strings.toStringSigned(param);
            } else if (Strings.equal(template[i], DECIMALS_MATCHER)) {
                uint256 param = abi.decode(
                    commandParams[nextParamIndex],
                    (uint256)
                );
                stringParam = DecimalUtils.uintToDecimalString(param);
            } else if (Strings.equal(template[i], ETH_ADDR_MATCHER)) {
                address param = abi.decode(
                    commandParams[nextParamIndex],
                    (address)
                );
                stringParam = addressToHexString(param, stringCase);
            } else {
                isParamExist = false;
                stringParam = template[i];
            }

            if (i > 0) {
                expectedCommand = string(
                    abi.encodePacked(expectedCommand, " ")
                );
            }
            expectedCommand = string(
                abi.encodePacked(expectedCommand, stringParam)
            );
            if (isParamExist) {
                nextParamIndex++;
            }
        }
        return expectedCommand;
    }
}
