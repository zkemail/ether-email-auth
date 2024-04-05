// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import {EmailProof} from "./utils/Verifier.sol";
import {ECDSAOwnedDKIMRegistry} from "./utils/ECDSAOwnedDKIMRegistry.sol";
import {Verifier} from "./utils/Verifier.sol";
import {SubjectUtils} from "./libraries/SubjectUtils.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

struct EmailAuthMsg {
    uint templateId;
    bytes[] subjectParams;
    uint skipedSubjectPrefix;
    EmailProof proof;
}

/// @title Email Authentication Contract
/// @notice This contract provides functionalities for email authentication using DKIM and custom verification logic.
/// @dev Inherits from OwnableUpgradeable and UUPSUpgradeable for upgradeability and ownership management.
contract EmailAuth is OwnableUpgradeable, UUPSUpgradeable {
    bytes32 public accountSalt;
    ECDSAOwnedDKIMRegistry public dkim;
    Verifier public verifier;
    mapping(uint => string[]) public subjectTemplates;
    mapping(bytes32 => bytes32) public authedHash;
    uint public lastTimestamp;
    mapping(bytes32 => bool) public usedNullifiers;
    bool public timestampCheckEnabled;

    constructor() {}

    /// @notice Initialize the contract with an initial owner and an account salt
    /// @param _initialOwner The address of the initial owner
    /// @param _accountSalt The account salt for hashing purposes
    function initialize(
        address _initialOwner,
        bytes32 _accountSalt
    ) public initializer {
        __Ownable_init(_initialOwner);
        accountSalt = _accountSalt;
        timestampCheckEnabled = true;
    }

    /// @notice Returns the address of the DKIM registry contract
    /// @return Address of the DKIM registry contract
    function dkimRegistryAddr() public view returns (address) {
        return address(dkim);
    }

    /// @notice Returns the address of the verifier contract
    /// @return Address of the verifier contract
    function verifierAddr() public view returns (address) {
        return address(verifier);
    }

    /// @notice Updates the address of the DKIM registry contract
    /// @param _dkimRegistryAddr The new address of the DKIM registry contract
    function updateDKIMRegistry(address _dkimRegistryAddr) public onlyOwner {
        require(
            _dkimRegistryAddr != address(0),
            "invalid dkim registry address"
        );
        dkim = ECDSAOwnedDKIMRegistry(_dkimRegistryAddr);
    }

    /// @notice Updates the address of the verifier contract
    /// @param _verifierAddr The new address of the verifier contract
    function updateVerifier(address _verifierAddr) public onlyOwner {
        require(_verifierAddr != address(0), "invalid verifier address");
        verifier = Verifier(_verifierAddr);
    }

    /// @notice Retrieves a subject template by its ID
    /// @param _templateId The ID of the template to retrieve
    /// @return The subject template as an array of strings
    function getSubjectTemplate(
        uint _templateId
    ) public view returns (string[] memory) {
        require(
            subjectTemplates[_templateId].length > 0,
            "template id not exists"
        );
        return subjectTemplates[_templateId];
    }

    /// @notice Inserts a new subject template
    /// @param _templateId The ID for the new template
    /// @param _subjectTemplate The subject template as an array of strings
    function insertSubjectTemplate(
        uint _templateId,
        string[] memory _subjectTemplate
    ) public {
        require(_subjectTemplate.length > 0, "subject template is empty");
        require(
            subjectTemplates[_templateId].length == 0,
            "template id already exists"
        );
        subjectTemplates[_templateId] = _subjectTemplate;
    }

    /// @notice Updates an existing subject template by its ID
    /// @dev This function can only be called by the owner of the contract.
    /// @param _templateId The ID of the template to update
    /// @param _subjectTemplate The new subject template as an array of strings
    function updateSubjectTemplate(
        uint _templateId,
        string[] memory _subjectTemplate
    ) public onlyOwner {
        require(_subjectTemplate.length > 0, "subject template is empty");
        require(
            subjectTemplates[_templateId].length > 0,
            "template id not exists"
        );
        subjectTemplates[_templateId] = _subjectTemplate;
    }

    /// @notice Deletes an existing subject template by its ID
    /// @dev This function can only be called by the owner of the contract.
    /// @param _templateId The ID of the template 
    function deleteSubjectTemplate(uint _templateId) public onlyOwner {
        require(
            subjectTemplates[_templateId].length > 0,
            "template id not exists"
        );
        delete subjectTemplates[_templateId];
    }

    /// @notice Computes the hash of an email authentication message
    /// @dev This function takes into account the account salt, whether a code exists, the template ID, and the subject parameters to compute a unique hash for an email authentication message.
    /// @param _accountSalt The account salt used for hashing
    /// @param _isCodeExist A boolean indicating if a code exists
    /// @param _templateId The ID of the email template
    /// @param _subjectParams The parameters for the subject of the email
    /// @return The computed hash as a bytes32 value
    function computeMsgHash(
        bytes32 _accountSalt,
        bool _isCodeExist,
        uint _templateId,
        bytes[] memory _subjectParams
    ) public pure returns (bytes32) {
        return
            keccak256(
                abi.encode(
                    _accountSalt,
                    _isCodeExist,
                    _templateId,
                    _subjectParams
                )
            );
    }

    /// @notice Authenticates an email based on the provided email authentication message
    /// @dev This function can only be called by the owner of the contract.
    /// @param emailAuthMsg The email authentication message containing all necessary information for authentication
    /// @return The hash of the authenticated email message
    function authEmail(
        EmailAuthMsg memory emailAuthMsg
    ) public onlyOwner returns (bytes32) {
        string[] memory template = subjectTemplates[emailAuthMsg.templateId];
        require(template.length > 0, "template id not exists");
        require(
            dkim.isDKIMPublicKeyHashValid(
                emailAuthMsg.proof.domainName,
                emailAuthMsg.proof.publicKeyHash
            ) == true,
            "invalid dkim public key hash"
        );
        require(
            usedNullifiers[emailAuthMsg.proof.emailNullifier] == false,
            "email nullifier already used"
        );
        require(
            accountSalt == emailAuthMsg.proof.accountSalt,
            "invalid account salt"
        );
        require(
            timestampCheckEnabled == false ||
                emailAuthMsg.proof.timestamp == 0 ||
                emailAuthMsg.proof.timestamp > lastTimestamp,
            "invalid timestamp"
        );

        // Construct an expectedSubject from template and the values of emailAuthMsg.subjectParams.
        string memory expectedSubject = SubjectUtils.computeExpectedSubject(
            emailAuthMsg.subjectParams,
            template
        );
        string memory trimmedMaskedSubject = removePrefix(
            emailAuthMsg.proof.maskedSubject,
            emailAuthMsg.skipedSubjectPrefix
        );
        require(
            Strings.equal(expectedSubject, trimmedMaskedSubject),
            "invalid subject"
        );
        require(
            verifier.verifyEmailProof(emailAuthMsg.proof) == true,
            "invalid email proof"
        );

        bytes32 msgHash = computeMsgHash(
            emailAuthMsg.proof.accountSalt,
            emailAuthMsg.proof.isCodeExist,
            emailAuthMsg.templateId,
            emailAuthMsg.subjectParams
        );

        require(
            authedHash[emailAuthMsg.proof.emailNullifier] == bytes32(0),
            "email already authed"
        );
        usedNullifiers[emailAuthMsg.proof.emailNullifier] = true;
        lastTimestamp = emailAuthMsg.proof.timestamp;
        authedHash[emailAuthMsg.proof.emailNullifier] = msgHash;

        return msgHash;
    }

    /// @notice Validates the signature of an authenticated email
    /// @param _hash The hash of the email authentication message
    /// @param _signature The signature to validate, which is expected to be the email nullifier
    /// @return A status code where `0x1626ba7e` indicates a valid signature and `0xffffffff` indicates an invalid signature.
    function isValidSignature(
        bytes32 _hash,
        bytes memory _signature
    ) public view returns (bytes4) {
        bytes32 _emailNullifier = abi.decode(_signature, (bytes32));
        if (authedHash[_emailNullifier] == _hash) {
            return 0x1626ba7e;
        } else {
            return 0xffffffff;
        }
    }

    /// @notice Enables or disables the timestamp check for email authentication
    /// @dev This function can only be called by the contract owner.
    /// @param _enabled Boolean flag to enable or disable the timestamp check
    function setTimestampCheckEnabled(bool _enabled) public onlyOwner {
        timestampCheckEnabled = _enabled;
    }

    /// @notice Upgrade the implementation of the proxy
    /// @param newImplementation Address of the new implementation
    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}

    function removePrefix(
        string memory str,
        uint numChars
    ) private pure returns (string memory) {
        require(numChars <= bytes(str).length, "Invalid number of characters");

        bytes memory strBytes = bytes(str);
        bytes memory result = new bytes(strBytes.length - numChars);

        for (uint i = numChars; i < strBytes.length; i++) {
            result[i - numChars] = strBytes[i];
        }

        return string(result);
    }
}
