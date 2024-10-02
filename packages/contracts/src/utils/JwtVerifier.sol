// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import {EmailProof} from "../interfaces/IVerifier.sol";
import "../interfaces/IJwtGroth16Verifier.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import { strings } from "solidity-stringutils/src/strings.sol";

contract JwtVerifier is OwnableUpgradeable, UUPSUpgradeable {
    using strings for *;

    IJwtGroth16Verifier groth16Verifier;

    uint256 public constant ISS_FIELDS = 2;
    uint256 public constant ISS_BYTES = 32;
    uint256 public constant COMMAND_FIELDS = 20;
    uint256 public constant COMMAND_BYTES = 605;
    uint256 public constant AZP_FIELDS = 1;
    uint256 public constant AZP_BYTES = 14;

    constructor() {}

    /// @notice Initialize the contract with the initial owner and deploy Groth16Verifier
    /// @param _initialOwner The address of the initial owner
    function initialize(
        address _initialOwner,
        address _groth16Verifier
    ) public initializer {
        __Ownable_init(_initialOwner);
        groth16Verifier = IJwtGroth16Verifier(_groth16Verifier);
    }

    function verifyEmailProof(
        EmailProof memory proof
    ) public view returns (bool) {
        (
            uint256[2] memory pA,
            uint256[2][2] memory pB,
            uint256[2] memory pC
        ) = abi.decode(proof.proof, (uint256[2], uint256[2][2], uint256[2]));

        uint256[ISS_FIELDS + COMMAND_FIELDS + AZP_FIELDS + 6] memory pubSignals;
        
        // string[] = [kid, iss, azp]
        string[] memory parts = this.stringToArray(proof.domainName);
        
        // kid
        pubSignals[0] = uint256(stringToBytes32(parts[0]));        

        // iss
        uint256[] memory stringFields;
        stringFields = _packBytes2Fields(bytes(parts[1]), ISS_BYTES);
        for (uint256 i = 0; i < ISS_FIELDS; i++) {
            pubSignals[1 + i] = stringFields[i];
        }        
        // publicKeyHash;
        pubSignals[1 + ISS_FIELDS] = uint256(proof.publicKeyHash);
        // jwtNullifier;
        pubSignals[1 + ISS_FIELDS + 1] = uint256(proof.emailNullifier);
        // timestamp;
        pubSignals[1 + ISS_FIELDS + 2] = uint256(proof.timestamp);
        // maskedCommand[commandFieldLength];
        stringFields = _packBytes2Fields(
            bytes(proof.maskedCommand),
            COMMAND_BYTES
        );
        for (uint256 i = 0; i < COMMAND_FIELDS; i++) {
            pubSignals[1 + ISS_FIELDS + 3 + i] = stringFields[i];
        }
        // accountSalt;
        pubSignals[1 + ISS_FIELDS + 3 + COMMAND_FIELDS] = uint256(
            proof.accountSalt
        );
        // azp
        stringFields = _packBytes2Fields(
            bytes(parts[2]),
            AZP_BYTES
        );
        for (uint256 i = 0; i < AZP_FIELDS; i++) {
            pubSignals[1 + ISS_FIELDS + 3 + COMMAND_FIELDS + 1 + i] = stringFields[i];
        }
        // isCodeExist;
        pubSignals[1 + ISS_FIELDS + 3 + COMMAND_FIELDS + 1 + AZP_FIELDS] = proof.isCodeExist
            ? 1
            : 0;

        return groth16Verifier.verifyProof(pA, pB, pC, pubSignals);
    }

    function _packBytes2Fields(
        bytes memory _bytes,
        uint256 _paddedSize
    ) public pure returns (uint256[] memory) {
        uint256 remain = _paddedSize % 31;
        uint256 numFields = (_paddedSize - remain) / 31;
        if (remain > 0) {
            numFields += 1;
        }
        uint256[] memory fields = new uint[](numFields);
        uint256 idx = 0;
        uint256 byteVal = 0;
        for (uint256 i = 0; i < numFields; i++) {
            for (uint256 j = 0; j < 31; j++) {
                idx = i * 31 + j;
                if (idx >= _paddedSize) {
                    break;
                }
                if (idx >= _bytes.length) {
                    byteVal = 0;
                } else {
                    byteVal = uint256(uint8(_bytes[idx]));
                }
                if (j == 0) {
                    fields[i] = byteVal;
                } else {
                    fields[i] += (byteVal << (8 * j));
                }
            }
        }
        return fields;
    }

    /// @notice Upgrade the implementation of the proxy.
    /// @param newImplementation Address of the new implementation.
    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}

    function getCommandBytes() external pure returns (uint256) {
        return COMMAND_BYTES;
    }

    function stringToArray(string memory _strings) external pure returns (string[] memory) {
        strings.slice memory slicee = _strings.toSlice();
        strings.slice memory delim = "|".toSlice();
        string[] memory parts = new string[](slicee.count(delim) + 1);
        for (uint i = 0; i < parts.length; i++) {
            parts[i] = slicee.split(delim).toString();
        }
        require(parts.length == 3, "Invalid kid|iss|azp strings");
        return parts;
    }

    function stringToBytes32(string memory source) public pure returns (bytes32 result) {
        return bytes32(abi.encodePacked(source));
    }
}
