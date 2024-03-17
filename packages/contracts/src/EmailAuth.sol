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

    /// @notice Initialize the contract
    function initialize(bytes32 _accountSalt) public initializer {
        __Ownable_init();
        accountSalt = _accountSalt;
        timestampCheckEnabled = true;
    }

    function dkimRegistryAddr() public view returns (address) {
        return address(dkim);
    }

    function verifierAddr() public view returns (address) {
        return address(verifier);
    }

    function updateDKIMRegistry(address _dkimRegistryAddr) public {
        require(msg.sender == owner, "only owner can update dkim registry");
        require(_dkimRegistryAddr != address(0), "invalid dkim registry address");
        dkim = ECDSAOwnedDKIMRegistry(_dkimRegistryAddr);
    }

    function updateVerifier(address _verifierAddr) public {
        require(msg.sender == owner, "only owner can update verifier");
        require(_verifierAddr != address(0), "invalid verifier address");
        verifier = Verifier(_verifierAddr);
    }

    function insertSubjectTemplate(uint _templateId, string[] memory _subjectTemplate) public {
        require(msg.sender == owner, "only owner can insert subject template");
        require(_subjectTemplate.length > 0, "subject template is empty");
        require(
            subjectTemplates[_templateId].length == 0,
            "template id already exists"
        );
        subjectTemplates[_templateId] = _subjectTemplate;
    }

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

    function deleteSubjectTemplate(uint _templateId) public onlyOwner {
        require(
            subjectTemplates[_templateId].length > 0,
            "template id not exists"
        );
        delete subjectTemplates[_templateId];
    }

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
