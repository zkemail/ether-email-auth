// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {StringUtils} from "src/libraries/StringUtils.sol";
import {StructHelper} from "../../helpers/StructHelper.sol";

contract StringUtils_HexToBytes32_Test is StructHelper {
    function setUp() public override {
        super.setUp();
    }

    function test_HexToBytes32_RevertWhen_InvalidHexPrefix() public {
        string
            memory invalidPrefixHashString = "509d286573e85f37b51f178c1cf8376452ba746b093a149f9d733c145539771d";

        vm.expectRevert("invalid hex prefix");
        StringUtils.hexToBytes32(invalidPrefixHashString);
    }

    function test_HexToBytes32_RevertWhen_InvalidHexPrefix_EmptyString()
        public
    {
        string memory emptyString = "";

        vm.expectRevert("invalid hex prefix");
        StringUtils.hexToBytes32(emptyString);
    }

    function test_HexToBytes32_RevertWhen_InvalidHexPrefix_Zero() public {
        string memory shortHashString = "0";

        vm.expectRevert("invalid hex prefix");
        StringUtils.hexToBytes32(shortHashString);
    }

    function test_HexToBytes32_RevertWhen_IncorrectPrefix_CapitalLetter()
        public
    {
        string
            memory invalidPrefixHashString = "0X509d286573e85f37b51f178c1cf8376452ba746b093a149f9d733c145539771d";

        vm.expectRevert("invalid hex prefix");
        StringUtils.hexToBytes32(invalidPrefixHashString);
    }

    function test_HexToBytes32_RevertWhen_InvalidHexPrefix_LeadingWhitespace()
        public
    {
        string
            memory hashString = " 0x509d286573e85f37b51f178c1cf8376452ba746b093a149f9d733c145539771d";

        vm.expectRevert("invalid hex prefix");
        StringUtils.hexToBytes32(hashString);
    }

    function test_HexToBytes32_RevertWhen_InvalidHexStringLength_TrailingWhitespace()
        public
    {
        string
            memory hashString = "0x509d286573e85f37b51f178c1cf8376452ba746b093a149f9d733c145539771d ";

        vm.expectRevert("invalid hex string length");
        StringUtils.hexToBytes32(hashString);
    }

    function test_HexToBytes32_RevertWhen_InvalidHexStringLength_ZeroBytes()
        public
    {
        string memory shortHashString = "0x";

        vm.expectRevert("invalid hex string length");
        StringUtils.hexToBytes32(shortHashString);
    }

    function test_HexToBytes32_RevertWhen_InvalidHexStringLength_ZeroShortBytes()
        public
    {
        string memory shortHashString = "0x00";

        vm.expectRevert("bytes length is not 32");
        StringUtils.hexToBytes32(shortHashString);
    }

    function test_HexToBytes32_RevertWhen_InvalidHexStringLength_TooHigh()
        public
    {
        string memory stringToHash = "I'm a test string";
        bytes32 expectedHash = keccak256(abi.encodePacked(stringToHash));
        string
            memory invalidHashString = "0x00dbc39d6cd28b2a38b8af5d4892c194bea383af28e55e7430d26474150280f15e";

        vm.expectRevert("bytes length is not 32");
        StringUtils.hexToBytes32(invalidHashString);
    }

    function test_HexToBytes32_RevertWhen_InvalidHexStringLength_VeryLongInput()
        public
    {
        string
            memory longHashString = "0x509d286573e85f37b51f178c1cf8376452ba746b093a149f9d733c145539771d509d286573e85f37b51f178c1cf83764";

        vm.expectRevert("bytes length is not 32");
        StringUtils.hexToBytes32(longHashString);
    }

    function test_HexToBytes32_RevertWhen_InvalidHexStringLength_TooLow()
        public
    {
        // hardcoded bytes32 value with final character removed
        string
            memory shortHashString = "0xdbc39d6cd28b2a38b8af5d4892c194bea383af28e55e7430d26474150280f15";

        vm.expectRevert("invalid hex string length");
        StringUtils.hexToBytes32(shortHashString);
    }

    function test_HexToBytes32_RevertWhen_InvalidHexChar_SingleNonHexChar()
        public
    {
        string
            memory invalidContentHashString = "0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdeG"; // G

        vm.expectRevert("invalid hex char");
        StringUtils.hexToBytes32(invalidContentHashString);
    }

    function test_HexToBytes32_RevertWhen_InvalidHexChar() public {
        string
            memory invalidHashString = "0x509d2865zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz";

        vm.expectRevert("invalid hex char");
        StringUtils.hexToBytes32(invalidHashString);
    }

    function test_HexToBytes32_SucceedsWhen_MixedCaseHex() public {
        bytes32 expectedMixedCaseHash = 0x509D286573e85F37b51F178c1cf8376452ba746b093A149f9d733c145539771d;
        string
            memory mixedCaseHashString = "0x509D286573e85F37b51F178c1cf8376452ba746b093A149f9d733c145539771d";

        bytes32 result = StringUtils.hexToBytes32(mixedCaseHashString);

        assertEq(result, expectedMixedCaseHash);
    }

    function test_HexToBytes32_SucceedsWhen_SingleCapitalLetter() public {
        // hardcoded bytes32 value with final character capitalized
        bytes32 expectedHash = 0x509d286573e85f37b51f178c1cf8376452ba746b093a149f9d733c145539771D;
        string
            memory hashString = "0x509d286573e85f37b51f178c1cf8376452ba746b093a149f9d733c145539771D";

        bytes32 result = StringUtils.hexToBytes32(hashString);

        assertEq(result, expectedHash);
    }

    function test_HexToBytes32_ConvertsZeroHash() public pure {
        bytes32 zeroHash = bytes32(0);
        string
            memory invalidHashString = "0x0000000000000000000000000000000000000000000000000000000000000000";
        bytes32 result = StringUtils.hexToBytes32(invalidHashString);
        assertEq(result, zeroHash);
    }

    function test_hexToBytes32_ComputesExpectedHash() public pure {
        bytes32 expectedHash1 = 0x509d286573e85f37b51f178c1cf8376452ba746b093a149f9d733c145539771d;
        bytes32 expectedHash2 = 0xa2baeb0f5a80b8f086147ffc05236f2d243357d9240c080a821b2aa987cb150c;
        bytes32 expectedHash3 = 0xac276f708bfba694fe2f7bfdc52e6b158a612c72f88a72bddacdfb33f190e9b9;
        string
            memory hashString1 = "0x509d286573e85f37b51f178c1cf8376452ba746b093a149f9d733c145539771d";
        string
            memory hashString2 = "0xa2baeb0f5a80b8f086147ffc05236f2d243357d9240c080a821b2aa987cb150c";
        string
            memory hashString3 = "0xac276f708bfba694fe2f7bfdc52e6b158a612c72f88a72bddacdfb33f190e9b9";

        bytes32 hashResult1 = StringUtils.hexToBytes32(hashString1);
        bytes32 hashResult2 = StringUtils.hexToBytes32(hashString2);
        bytes32 hashResult3 = StringUtils.hexToBytes32(hashString3);

        assertEq(hashResult1, expectedHash1);
        assertEq(hashResult2, expectedHash2);
        assertEq(hashResult3, expectedHash3);
    }

    function test_hexToBytes32_ComputesExpectedAddressHash() public pure {
        address addressToHash1 = 0x0000000000000000000000000000000000000001;
        address addressToHash2 = 0xF9c73EedAd50dC6de889450c6469F4BA78a826dd;
        address addressToHash3 = 0x328809Bc894f92807417D2dAD6b7C998c1aFdac6;
        bytes32 expectedHash1 = keccak256(abi.encodePacked(addressToHash1));
        bytes32 expectedHash2 = keccak256(abi.encodePacked(addressToHash2));
        bytes32 expectedHash3 = keccak256(abi.encodePacked(addressToHash3));
        string
            memory hashString1 = "0x1468288056310c82aa4c01a7e12a10f8111a0560e72b700555479031b86c357d";
        string
            memory hashString2 = "0x74f5064398929fa4a58c46b60031ae3e0788e7e2e9294b06e0a82978f22ad502";
        string
            memory hashString3 = "0x72d7a3f1e9fa3953b9dfa6828dd4d4068abbe2041e121a61f102e1f7f9603d2a";

        bytes32 hashResult1 = StringUtils.hexToBytes32(hashString1);
        bytes32 hashResult2 = StringUtils.hexToBytes32(hashString2);
        bytes32 hashResult3 = StringUtils.hexToBytes32(hashString3);

        assertEq(hashResult1, expectedHash1);
        assertEq(hashResult2, expectedHash2);
        assertEq(hashResult3, expectedHash3);
    }

    function test_hexToBytes32_ComputesExpectedCalldataHash() public view {
        address owner = 0xCe9A87013DB006Dde79E7382bf48D45bF891e90D;
        address newOwner = 0x63aaF092604406C03E5B36ca1bEc1CDDF4a5Fa9d;
        address account = 0xF4F7b3D8e43a41833774CD6d962D10282f806017;
        address validator = 0x756e0562323ADcDA4430d6cb456d9151f605290B;

        bytes memory calldata1 = abi.encodeWithSignature(
            "swapOwner(address,address,address)",
            address(1),
            owner,
            newOwner
        );
        bytes memory recoveryData1 = abi.encode(account, calldata1);
        bytes32 recoveryDataHash1 = keccak256(recoveryData1);

        bytes memory calldata2 = abi.encodeWithSignature(
            "changeOwner(address)",
            newOwner
        );
        bytes memory recoveryData2 = abi.encode(validator, calldata2);
        bytes32 recoveryDataHash2 = keccak256(recoveryData2);

        string
            memory hashString1 = "0x268857b2318fd7eaa7e5be744cc041d64415d2df4588e3d234e7335ede6593a5";
        string
            memory hashString2 = "0x6ac9d4f1b3c69064f3f728b53ed1d38c79462138b4b03d5c2838a001233b7920";

        bytes32 hashResult1 = StringUtils.hexToBytes32(hashString1);
        bytes32 hashResult2 = StringUtils.hexToBytes32(hashString2);

        assertEq(hashResult1, recoveryDataHash1);
        assertEq(hashResult2, recoveryDataHash2);
    }

    function test_HexToBytes32_MaximumValue() public pure {
        bytes32 maxBytes32 = bytes32(
            0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
        );
        string
            memory maxHashString = "0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff";

        bytes32 result = StringUtils.hexToBytes32(maxHashString);

        assertEq(result, maxBytes32);
    }
}
