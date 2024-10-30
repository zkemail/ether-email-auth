// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";
import { StringUtils } from "src/libraries/StringUtils.sol";
import {StructHelper} from "../../helpers/StructHelper.sol";

contract StringUtils_HexToBytes_Test is StructHelper {
    function setUp() public override {
        super.setUp();
    }

    function test_HexToBytes_RevertWhen_InvalidHexPrefix() public {
        string memory bytesStringNoHexPrefix =
            "509d286573e85f37b51f178c1";

        vm.expectRevert("invalid hex prefix");
        StringUtils.hexToBytes(bytesStringNoHexPrefix);
    }

    function test_HexToBytes_RevertWhen_InvalidHexPrefix_EmptyString() public {
        string memory emptyString = "";

        vm.expectRevert("invalid hex prefix");
        StringUtils.hexToBytes(emptyString);
    }

    function test_HexToBytes_RevertWhen_InvalidHexPrefix_Zero() public {
        string memory shortBytesString = "0";

        vm.expectRevert("invalid hex prefix");
        StringUtils.hexToBytes(shortBytesString);
    }

    function test_HexToBytes_RevertWhen_IncorrectPrefix_CapitalLetter() public {
        string memory invalidPrefixBytesString =
            "0X509d376452ba746b093a149f9d733c145539771d";

        vm.expectRevert("invalid hex prefix");
        StringUtils.hexToBytes(invalidPrefixBytesString);
    }

    function test_HexToBytes_RevertWhen_InvalidHexPrefix_LeadingWhitespace() public {
        string memory bytesString =
            " 0x509d286573e85f37b51f178c1cf8376452ba746b093a149f9d733c145746b093a149f9d733c1539771d";

        vm.expectRevert("invalid hex prefix");
        StringUtils.hexToBytes(bytesString);
    }

    function test_HexToBytes_RevertWhen_InvalidHexStringLength_TrailingWhitespace() public {
        string memory bytesString =
            "0x509d286573e85f37b51f178c1cf8376452ba746b093a149f9d733c1455d286573e85f37b51f178c1cf8376452ba746b093Ca149f9d733c145539771d ";

        vm.expectRevert("invalid hex string length");
        StringUtils.hexToBytes(bytesString);
    }

    function test_HexToBytes_RevertWhen_InvalidHexStringLength_ZeroShortBytes() public {
        string memory shortBytesString = "0x";
        vm.expectRevert("invalid hex string length");
        StringUtils.hexToBytes(shortBytesString);
    }

    function test_HexToBytes_RevertWhen_InvalidHexStringLength_TooHigh() public {
        string memory invalidBytesString =
            "0x509D286573e85F37b51F178c1cf8376452ba746b093A149f9d733c145539771dd"; // extra character

        vm.expectRevert("invalid hex string length");
        StringUtils.hexToBytes(invalidBytesString);
    }

    function test_HexToBytes_RevertWhen_InvalidHexStringLength_TooLow() public {
        // hardcoded bytes memory value with final character removed
        string memory shortBytesString =
            "0xdbc39d6cd28b2a38b8af5d4892c194bea383af28e55e7430d26474150280f15";

        vm.expectRevert("invalid hex string length");
        StringUtils.hexToBytes(shortBytesString);
    }

    function test_HexToBytes_RevertWhen_InvalidHexChar_SingleNonHexChar() public {
        string memory invalidContentBytesString =
            "0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdeG"; // G

        vm.expectRevert("invalid hex char");
        StringUtils.hexToBytes(invalidContentBytesString);
    }

    function test_HexToBytes_RevertWhen_InvalidHexChar() public {
        string memory invalidBytesString =
            "0x509d2865zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz";

        vm.expectRevert("invalid hex char");
        StringUtils.hexToBytes(invalidBytesString);
    }

    function test_HexToBytes_SucceedsWhen_LongerInput() public {
        bytes memory expectedBytes = abi.encodePacked(
            hex"509d286573e85f37b51f178c1cf8376452509d286573e85f37b51f178c1cf8376452ba746b093a149f9d733c145539771d509d286573e85f37b51f178c1cf837509d286573e85f37b51f178c1cf8376452ba746b093a149f9d733c145539771d509d286573e85f37b51f178c1cf837509d286573e85f37b51f178c1cf8376452ba746b093a149f9d733c145539771d509d286573e85f37b51f178c1cf837ba746b093a149f9d733c145539771d509d286573e85509d286573e85f37b51f178c1cf8376452ba746b093a149f9d733c145539771d509d286573e85f37b51f178c1cf837f37b509d286573e85f37b51f178c1cf8376452ba746b093a149f9d733c145539771d509d286573e85f37b51f178c1cf83751f178c1cf837509d286573e85f37b51f178c1cf8376452ba746b093a149f9d733c145539771d509d286573e85f37b51f178c1cf83764"
        );
        string memory longBytesString =
            "0x509d286573e85f37b51f178c1cf8376452509d286573e85f37b51f178c1cf8376452ba746b093a149f9d733c145539771d509d286573e85f37b51f178c1cf837509d286573e85f37b51f178c1cf8376452ba746b093a149f9d733c145539771d509d286573e85f37b51f178c1cf837509d286573e85f37b51f178c1cf8376452ba746b093a149f9d733c145539771d509d286573e85f37b51f178c1cf837ba746b093a149f9d733c145539771d509d286573e85509d286573e85f37b51f178c1cf8376452ba746b093a149f9d733c145539771d509d286573e85f37b51f178c1cf837f37b509d286573e85f37b51f178c1cf8376452ba746b093a149f9d733c145539771d509d286573e85f37b51f178c1cf83751f178c1cf837509d286573e85f37b51f178c1cf8376452ba746b093a149f9d733c145539771d509d286573e85f37b51f178c1cf83764";

        bytes memory bytesResult = StringUtils.hexToBytes(longBytesString);

        assertEq(bytesResult, expectedBytes);
    }

    function test_HexToBytes_SucceesWhen_SingleCapitalLetter() public {
        // hardcoded bytes memory value with final character capitalized
        bytes memory expectedBytes =
            abi.encodePacked(hex"509d286573e85f37b51f178c1cf8376452ba746b093a149f9d733c145539771D");
        string memory bytesString =
            "0x509d286573e85f37b51f178c1cf8376452ba746b093a149f9d733c145539771D";

        bytes memory result = StringUtils.hexToBytes(bytesString);

        assertEq(result, expectedBytes);
    }


    function test_HexToBytes_SucceedsWhen_MixedCaseHex() public {
        bytes memory expectedMixedCaseBytes =
            abi.encodePacked(hex"509D286573e85F37b51F178c1cf8376452ba746b093A149f9d733c145539771d");
        string memory mixedCaseString =
            "0x509D286573e85F37b51F178c1cf8376452ba746b093A149f9d733c145539771d";

        bytes memory result = StringUtils.hexToBytes(mixedCaseString);

        assertEq(result, expectedMixedCaseBytes);
    }

    function test_HexToBytes_ConvertsZeroBytes() public pure {
        bytes memory zeroBytes =
            abi.encodePacked(hex"0000000000000000000000000000000000000000000000000000000000000000");
        string memory invalidBytesString =
            "0x0000000000000000000000000000000000000000000000000000000000000000";

        bytes memory result = StringUtils.hexToBytes(invalidBytesString);

        assertEq(result, zeroBytes);
    }

    function test_hexToBytes_ComputesExpectedBytes() public pure {
        bytes memory expectedBytes1 =
            abi.encodePacked(hex"509d");
        bytes memory expectedBytes2 =
            abi.encodePacked(hex"a2baeb0f5a80b8f086147ffc05236f2d243357d9240c080a821b2aa987cb150c");
        bytes memory expectedBytes3 =
            abi.encodePacked(hex"ac276f708bfba694fe2f7bfdc52e6b158a612c72f88a72bddacdfb33f190e9b9ac276f708bfba694fe2f7bfdc52e6b158a612c72f88a72bddacdfb33f190e9b9");
        string memory bytesString1 =
            "0x509d";
        string memory bytesString2 =
            "0xa2baeb0f5a80b8f086147ffc05236f2d243357d9240c080a821b2aa987cb150c";
        string memory bytesString3 =
            "0xac276f708bfba694fe2f7bfdc52e6b158a612c72f88a72bddacdfb33f190e9b9ac276f708bfba694fe2f7bfdc52e6b158a612c72f88a72bddacdfb33f190e9b9";

        bytes memory bytesResult1 = StringUtils.hexToBytes(bytesString1);
        bytes memory bytesResult2 = StringUtils.hexToBytes(bytesString2);
        bytes memory bytesResult3 = StringUtils.hexToBytes(bytesString3);

        assertEq(bytesResult1, expectedBytes1);
        assertEq(bytesResult2, expectedBytes2);
        assertEq(bytesResult3, expectedBytes3);
    }

    function test_hexToBytes_ComputesExpectedAddressBytes() public pure {
        address addressToBytes1 = 0x0000000000000000000000000000000000000001;
        address addressToBytes2 = 0xF9c73EedAd50dC6de889450c6469F4BA78a826dd;
        address addressToBytes3 = 0x328809Bc894f92807417D2dAD6b7C998c1aFdac6;
        bytes memory expectedBytes1 = abi.encodePacked(addressToBytes1);
        bytes memory expectedBytes2 = abi.encodePacked(addressToBytes2);
        bytes memory expectedBytes3 = abi.encodePacked(addressToBytes3);
        string memory bytesString1 = "0x0000000000000000000000000000000000000001";
        string memory bytesString2 = "0xf9c73eedad50dc6de889450c6469f4ba78a826dd";
        string memory bytesString3 = "0x328809bc894f92807417d2dad6b7c998c1afdac6";

        bytes memory bytesResult1 = StringUtils.hexToBytes(bytesString1);
        bytes memory bytesResult2 = StringUtils.hexToBytes(bytesString2);
        bytes memory bytesResult3 = StringUtils.hexToBytes(bytesString3);

        assertEq(bytesResult1, expectedBytes1);
        assertEq(bytesResult2, expectedBytes2);
        assertEq(bytesResult3, expectedBytes3);
    }

    function test_hexToBytes_ComputesExpectedCalldataBytes() public view {
        address owner = 0xCe9A87013DB006Dde79E7382bf48D45bF891e90D;
        address newOwner = 0x63aaF092604406C03E5B36ca1bEc1CDDF4a5Fa9d;
        address account = 0xF4F7b3D8e43a41833774CD6d962D10282f806017;
        address validator = 0x756e0562323ADcDA4430d6cb456d9151f605290B;

        bytes memory calldata1 = abi.encodeWithSignature(
            "swapOwner(address,address,address)", address(1), owner, newOwner
        );
        bytes memory recoveryData1 = abi.encode(account, calldata1);
        bytes memory recoveryDataBytes1 = recoveryData1;

        bytes memory calldata2 = abi.encodeWithSignature("changeOwner(address)", newOwner);
        bytes memory recoveryData2 = abi.encode(validator, calldata2);
        bytes memory recoveryDataBytes2 = recoveryData2;

        string memory bytesString1 =
            "0x000000000000000000000000f4f7b3d8e43a41833774cd6d962d10282f80601700000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000064e318b52b0000000000000000000000000000000000000000000000000000000000000001000000000000000000000000ce9a87013db006dde79e7382bf48d45bf891e90d00000000000000000000000063aaf092604406c03e5b36ca1bec1cddf4a5fa9d00000000000000000000000000000000000000000000000000000000";
        string memory bytesString2 =
            "0x000000000000000000000000756e0562323adcda4430d6cb456d9151f605290b00000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000024a6f9dae100000000000000000000000063aaf092604406c03e5b36ca1bec1cddf4a5fa9d00000000000000000000000000000000000000000000000000000000";

        bytes memory bytesResult1 = StringUtils.hexToBytes(bytesString1);
        bytes memory bytesResult2 = StringUtils.hexToBytes(bytesString2);

        assertEq(bytesResult1, recoveryDataBytes1);
        assertEq(bytesResult2, recoveryDataBytes2);
    }

    function test_HexToBytes_MaximumValue() public pure {
        bytes memory maxBytes32 =
            bytes(hex"ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff");
        string memory maxBytesString =
            "0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff";

        bytes memory result = StringUtils.hexToBytes(maxBytesString);

        assertEq(result, maxBytes32);
    }
}
