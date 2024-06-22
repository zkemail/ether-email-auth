// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import {EmailProof} from "./utils/Verifier.sol";
import {IDKIMRegistry} from "@zk-email/contracts/DKIMRegistry.sol";
import {Verifier} from "./utils/Verifier.sol";
import {SubjectUtils} from "./libraries/SubjectUtils.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

/// @notice Struct to hold the email authentication/authorization message.
struct EmailAuthMsg {
    /// @notice The ID of the subject template that the email subject should satisfy.
    uint templateId;
    /// @notice The parameters in the email subject, which should be taken according to the specified subject template.
    bytes[] subjectParams;
    /// @notice The number of skiiped bytes in the email subject.
    uint skipedSubjectPrefix;
    /// @notice The email proof containing the zk proof and other necessary information for the email verification by the verifier contract.
    EmailProof proof;
}

/// @title Email Authentication/Authorization Contract
/// @notice This contract provides functionalities for the authentication of the email sender and the authentication of the message in the email subject using DKIM and custom verification logic.
/// @dev Inherits from OwnableUpgradeable and UUPSUpgradeable for upgradeability and ownership management.
contract EmailAuth is OwnableUpgradeable, UUPSUpgradeable {
    bytes32 public accountSalt;
    IDKIMRegistry internal dkim;
    Verifier internal verifier;
    address public controller;
    mapping(uint => string[]) public subjectTemplates;
    uint public lastTimestamp;
    mapping(bytes32 => bool) public usedNullifiers;
    bool public timestampCheckEnabled;

    event DKIMRegistryUpdated(address indexed dkimRegistry);
    event VerifierUpdated(address indexed verifier);
    event SubjectTemplateInserted(uint indexed templateId);
    event SubjectTemplateUpdated(uint indexed templateId);
    event SubjectTemplateDeleted(uint indexed templateId);
    event EmailAuthed(
        bytes32 indexed emailNullifier,
        bytes32 indexed accountSalt,
        bool isCodeExist,
        uint templateId
    );
    event TimestampCheckEnabled(bool enabled);

    modifier onlyController() {
        require(msg.sender == controller, "only controller");
        _;
    }

    constructor() {}

    /// @notice Initialize the contract with an initial owner and an account salt.
    /// @param _initialOwner The address of the initial owner.
    /// @param _accountSalt The account salt to derive CREATE2 address of this contract.
    /// @param _controller The address of the controller contract.
    function initialize(
        address _initialOwner,
        bytes32 _accountSalt,
        address _controller
    ) public initializer {
        __Ownable_init(_initialOwner);
        accountSalt = _accountSalt;
        timestampCheckEnabled = true;
        controller = _controller;
    }

    /// @notice Returns the address of the DKIM registry contract.
    /// @return address The address of the DKIM registry contract.
    function dkimRegistryAddr() public view returns (address) {
        return address(dkim);
    }

    /// @notice Returns the address of the verifier contract.
    /// @return address The Address of the verifier contract.
    function verifierAddr() public view returns (address) {
        return address(verifier);
    }

    /// @notice Initializes the address of the DKIM registry contract.
    /// @param _dkimRegistryAddr The address of the DKIM registry contract.
    function initDKIMRegistry(address _dkimRegistryAddr) public onlyController {
        require(
            _dkimRegistryAddr != address(0),
            "invalid dkim registry address"
        );
        require(
            address(dkim) == address(0),
            "dkim registry already initialized"
        );
        dkim = IDKIMRegistry(_dkimRegistryAddr);
        emit DKIMRegistryUpdated(_dkimRegistryAddr);
    }

    /// @notice Initializes the address of the verifier contract.
    /// @param _verifierAddr The address of the verifier contract.
    function initVerifier(address _verifierAddr) public onlyController {
        require(_verifierAddr != address(0), "invalid verifier address");
        require(
            address(verifier) == address(0),
            "verifier already initialized"
        );
        verifier = Verifier(_verifierAddr);
        emit VerifierUpdated(_verifierAddr);
    }

    /// @notice Updates the address of the DKIM registry contract.
    /// @param _dkimRegistryAddr The new address of the DKIM registry contract.
    function updateDKIMRegistry(address _dkimRegistryAddr) public onlyOwner {
        require(
            _dkimRegistryAddr != address(0),
            "invalid dkim registry address"
        );
        dkim = IDKIMRegistry(_dkimRegistryAddr);
        emit DKIMRegistryUpdated(_dkimRegistryAddr);
    }

    /// @notice Updates the address of the verifier contract.
    /// @param _verifierAddr The new address of the verifier contract.
    function updateVerifier(address _verifierAddr) public onlyOwner {
        require(_verifierAddr != address(0), "invalid verifier address");
        verifier = Verifier(_verifierAddr);
        emit VerifierUpdated(_verifierAddr);
    }

    /// @notice Retrieves a subject template by its ID.
    /// @param _templateId The ID of the subject template to be retrieved.
    /// @return string[] The subject template as an array of strings.
    function getSubjectTemplate(
        uint _templateId
    ) public view returns (string[] memory) {
        require(
            subjectTemplates[_templateId].length > 0,
            "template id not exists"
        );
        return subjectTemplates[_templateId];
    }

    /// @notice Inserts a new subject template.
    /// @dev This function can only be called by the owner of the contract.
    /// @param _templateId The ID for the new subject template.
    /// @param _subjectTemplate The subject template as an array of strings.
    function insertSubjectTemplate(
        uint _templateId,
        string[] memory _subjectTemplate
    ) public onlyController {
        require(_subjectTemplate.length > 0, "subject template is empty");
        require(
            subjectTemplates[_templateId].length == 0,
            "template id already exists"
        );
        subjectTemplates[_templateId] = _subjectTemplate;
        emit SubjectTemplateInserted(_templateId);
    }

    /// @notice Updates an existing subject template by its ID.
    /// @dev This function can only be called by the controller contract.
    /// @param _templateId The ID of the template to update.
    /// @param _subjectTemplate The new subject template as an array of strings.
    function updateSubjectTemplate(
        uint _templateId,
        string[] memory _subjectTemplate
    ) public onlyController {
        require(_subjectTemplate.length > 0, "subject template is empty");
        require(
            subjectTemplates[_templateId].length > 0,
            "template id not exists"
        );
        subjectTemplates[_templateId] = _subjectTemplate;
        emit SubjectTemplateUpdated(_templateId);
    }

    /// @notice Deletes an existing subject template by its ID.
    /// @dev This function can only be called by the owner of the contract.
    /// @param _templateId The ID of the subject template to be deleted.
    function deleteSubjectTemplate(uint _templateId) public onlyController {
        require(
            subjectTemplates[_templateId].length > 0,
            "template id not exists"
        );
        delete subjectTemplates[_templateId];
        emit SubjectTemplateDeleted(_templateId);
    }

    /// @notice Authenticate the email sender and authorize the message in the email subject based on the provided email auth message.
    /// @dev This function can only be called by the controller contract.
    /// @param emailAuthMsg The email auth message containing all necessary information for authentication and authorization.
    function authEmail(EmailAuthMsg memory emailAuthMsg) public onlyOwner {
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

        usedNullifiers[emailAuthMsg.proof.emailNullifier] = true;
        lastTimestamp = emailAuthMsg.proof.timestamp;
        emit EmailAuthed(
            emailAuthMsg.proof.emailNullifier,
            emailAuthMsg.proof.accountSalt,
            emailAuthMsg.proof.isCodeExist,
            emailAuthMsg.templateId
        );
    }

    /// @notice Enables or disables the timestamp check.
    /// @dev This function can only be called by the contract owner.
    /// @param _enabled Boolean flag to enable or disable the timestamp check.
    function setTimestampCheckEnabled(bool _enabled) public onlyController {
        timestampCheckEnabled = _enabled;
        emit TimestampCheckEnabled(_enabled);
    }

    /// @notice Upgrade the implementation of the proxy.
    /// @param newImplementation Address of the new implementation.
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
