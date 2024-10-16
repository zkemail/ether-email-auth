// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import {EmailProof} from "./utils/Verifier.sol";
import {IDKIMRegistry} from "@zk-email/contracts/DKIMRegistry.sol";
import {Verifier} from "./utils/Verifier.sol";
import {CommandUtils} from "./libraries/CommandUtils.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

/// @notice Struct to hold the email authentication/authorization message.
struct EmailAuthMsg {
    /// @notice The ID of the command template that the command in the email body should satisfy.
    uint templateId;
    /// @notice The parameters in the command of the email body, which should be taken according to the specified command template.
    bytes[] commandParams;
    /// @notice The number of skipped bytes in the command.
    uint skippedCommandPrefix;
    /// @notice The email proof containing the zk proof and other necessary information for the email verification by the verifier contract.
    EmailProof proof;
}

/// @title Email Authentication/Authorization Contract
/// @notice This contract provides functionalities for the authentication of the email sender and the authentication of the message in the command part of the email body using DKIM and custom verification logic.
/// @dev Inherits from OwnableUpgradeable and UUPSUpgradeable for upgradeability and ownership management.
contract EmailAuth is OwnableUpgradeable, UUPSUpgradeable {
    /// The CREATE2 salt of this contract defined as a hash of an email address and an account code.
    bytes32 public accountSalt;
    /// An instance of the DKIM registry contract.
    IDKIMRegistry internal dkim;
    /// An instance of the Verifier contract.
    Verifier internal verifier;
    /// An address of a controller contract, defining the command templates supported by this contract.
    address public controller;
    /// A mapping of the supported command templates associated with its ID.
    mapping(uint => string[]) public commandTemplates;
    /// A mapping of the hash of the authorized message associated with its `emailNullifier`.
    uint public lastTimestamp;
    /// The latest `timestamp` in the verified `EmailAuthMsg`.
    mapping(bytes32 => bool) public usedNullifiers;
    /// A boolean whether timestamp check is enabled or not.
    bool public timestampCheckEnabled;

    event DKIMRegistryUpdated(address indexed dkimRegistry);
    event VerifierUpdated(address indexed verifier);
    event CommandTemplateInserted(uint indexed templateId);
    event CommandTemplateUpdated(uint indexed templateId);
    event CommandTemplateDeleted(uint indexed templateId);
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

    /// @notice Retrieves a command template by its ID.
    /// @param _templateId The ID of the command template to be retrieved.
    /// @return string[] The command template as an array of strings.
    function getCommandTemplate(
        uint _templateId
    ) public view returns (string[] memory) {
        require(
            commandTemplates[_templateId].length > 0,
            "template id not exists"
        );
        return commandTemplates[_templateId];
    }

    /// @notice Inserts a new command template.
    /// @dev This function can only be called by the controller of the contract.
    /// @param _templateId The ID for the new command template.
    /// @param _commandTemplate The command template as an array of strings.
    function insertCommandTemplate(
        uint _templateId,
        string[] memory _commandTemplate
    ) public onlyController {
        require(_commandTemplate.length > 0, "command template is empty");
        require(
            commandTemplates[_templateId].length == 0,
            "template id already exists"
        );
        commandTemplates[_templateId] = _commandTemplate;
        emit CommandTemplateInserted(_templateId);
    }

    /// @notice Updates an existing command template by its ID.
    /// @dev This function can only be called by the controller contract.
    /// @param _templateId The ID of the template to update.
    /// @param _commandTemplate The new command template as an array of strings.
    function updateCommandTemplate(
        uint _templateId,
        string[] memory _commandTemplate
    ) public onlyController {
        require(_commandTemplate.length > 0, "command template is empty");
        require(
            commandTemplates[_templateId].length > 0,
            "template id not exists"
        );
        commandTemplates[_templateId] = _commandTemplate;
        emit CommandTemplateUpdated(_templateId);
    }

    /// @notice Deletes an existing command template by its ID.
    /// @dev This function can only be called by the controller of the contract.
    /// @param _templateId The ID of the command template to be deleted.
    function deleteCommandTemplate(uint _templateId) public onlyController {
        require(
            commandTemplates[_templateId].length > 0,
            "template id not exists"
        );
        delete commandTemplates[_templateId];
        emit CommandTemplateDeleted(_templateId);
    }

    /// @notice Authenticate the email sender and authorize the message in the email command based on the provided email auth message.
    /// @dev This function can only be called by the controller contract.
    /// @param emailAuthMsg The email auth message containing all necessary information for authentication and authorization.
    function authEmail(EmailAuthMsg memory emailAuthMsg) public onlyController {
        string[] memory template = commandTemplates[emailAuthMsg.templateId];
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
        require(
            bytes(emailAuthMsg.proof.maskedCommand).length <=
                verifier.COMMAND_BYTES(),
            "invalid masked command length"
        );
        require(
            emailAuthMsg.skippedCommandPrefix < verifier.COMMAND_BYTES(),
            "invalid size of the skipped command prefix"
        );

        // Construct an expectedCommand from template and the values of emailAuthMsg.commandParams.
        string memory trimmedMaskedCommand = removePrefix(
            emailAuthMsg.proof.maskedCommand,
            emailAuthMsg.skippedCommandPrefix
        );
        string memory expectedCommand = "";
        for (uint stringCase = 0; stringCase < 3; stringCase++) {
            expectedCommand = CommandUtils.computeExpectedCommand(
                emailAuthMsg.commandParams,
                template,
                stringCase
            );
            if (Strings.equal(expectedCommand, trimmedMaskedCommand)) {
                break;
            }
            if (stringCase == 2) {
                revert("invalid command");
            }
        }

        require(
            verifier.verifyEmailProof(emailAuthMsg.proof) == true,
            "invalid email proof"
        );

        usedNullifiers[emailAuthMsg.proof.emailNullifier] = true;
        if (timestampCheckEnabled && emailAuthMsg.proof.timestamp != 0) {
            lastTimestamp = emailAuthMsg.proof.timestamp;
        }
        emit EmailAuthed(
            emailAuthMsg.proof.emailNullifier,
            emailAuthMsg.proof.accountSalt,
            emailAuthMsg.proof.isCodeExist,
            emailAuthMsg.templateId
        );
    }

    /// @notice Enables or disables the timestamp check.
    /// @dev This function can only be called by the controller.
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
