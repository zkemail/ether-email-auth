// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import {EmailProof} from "./utils/Verifier.sol";
import {ECDSAOwnedDKIMRegistry} from "./utils/ECDSAOwnedDKIMRegistry.sol";
import {Verifier} from "./utils/Verifier.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

struct EmailAuthMsg {
    uint templateId;
    bytes[] subjectParams;
    uint skipedSubjectPrefix;
    EmailProof proof;
}

contract EmailAuth {

    address owner;
    bytes32 accountSalt;
    ECDSAOwnedDKIMRegistry dkim;
    Verifier verifier;
    mapping(uint => string[]) subjectTemplates;
    mapping(bytes32 => bytes32) authedHash;
    uint lastTimestamp;
    mapping(bytes32=>bool) usedNullifiers;
    bool timestampCheckEnabled;
 
    constructor(bytes32 _accountSalt) {
        owner = msg.sender;
        accountSalt = _accountSalt;
        timestampCheckEnabled = true;
    }

    function dkimRegistryAddr() public view returns (address) {
        return address(dkim);
    }

    function verifierAddr() public view returns (address) {
        return address(verifier);
    }

    function updateVerifier(address _verifierAddr) public {
        require(msg.sender == owner, "only owner can update verifier");
        require(_verifierAddr != address(0), "invalid verifier address");
        verifier = Verifier(_verifierAddr);
    }

    function updateDKIMRegistry(address _dkimRegistryAddr) public {
        require(msg.sender == owner, "only owner can update dkim registry");
        require(_dkimRegistryAddr != address(0), "invalid dkim registry address");
        dkim = ECDSAOwnedDKIMRegistry(_dkimRegistryAddr);
    }

    function insertSubjectTemplate(uint _templateId, string[] memory _subjectTemplate) public {
        require(msg.sender == owner, "only owner can insert subject template");
        require(_subjectTemplate.length > 0, "subject template is empty");
        require(subjectTemplates[_templateId].length == 0, "template id already exists");
        subjectTemplates[_templateId] = _subjectTemplate;
    }

    function updateSubjectTemplate(uint _templateId, string[] memory _subjectTemplate) public {
        require(msg.sender == owner, "only owner can update subject template");
        require(_subjectTemplate.length > 0, "subject template is empty");
        require(subjectTemplates[_templateId].length > 0, "template id not exists");
        subjectTemplates[_templateId] = _subjectTemplate;
    }

    function deleteSubjectTemplate(uint _templateId) public {
        require(msg.sender == owner, "only owner can delete subject template");
        require(subjectTemplates[_templateId].length > 0, "template id not exists");
        delete subjectTemplates[_templateId];
    }

    function computeMsgHash(bytes32 _accountSalt, bool _isCodeExist, uint _templateId, bytes[] memory _subjectParams) public pure returns (bytes32) {
        return keccak256(abi.encode(_accountSalt, _isCodeExist, _templateId, _subjectParams));
    }

    function authEmail(EmailAuthMsg memory emailAuthMsg) public returns (bytes32) {
        require(msg.sender == owner, "only owner can auth email");
        string[] memory template = subjectTemplates[emailAuthMsg.templateId];
        require(template.length > 0, "template id not exists");
        require(
            dkim.isDKIMPublicKeyHashValid(
                emailAuthMsg.proof.domainName, 
                emailAuthMsg.proof.publicKeyHash
            ) == true, 
            "invalid dkim public key hash");
        require(usedNullifiers[emailAuthMsg.proof.emailNullifier] == false, "email nullifier already used");
        usedNullifiers[emailAuthMsg.proof.emailNullifier] = true;
        require(accountSalt == emailAuthMsg.proof.accountSalt, "invalid account salt");
        require(emailAuthMsg.proof.timestamp > 0 && emailAuthMsg.proof.timestamp > lastTimestamp, "invalid timestamp");
        lastTimestamp = emailAuthMsg.proof.timestamp;
        
        // Construct an expectedSubject from template and the values of emailAuthMsg.subjectParams.
        string memory expectedSubject;
        uint8 nextParamIndex = 0;
        string memory stringParam;
        for (uint8 i = 0; i < template.length; i++) {

            if(Strings.equal(template[i], "{string}")) {
                string memory param = abi.decode(emailAuthMsg.subjectParams[nextParamIndex], (string));
                stringParam = param;
                // expectedSubject = string(abi.encodePacked(expectedSubject, param));
            } else if(Strings.equal(template[i], "{uint}")) {
                uint256 param = abi.decode(emailAuthMsg.subjectParams[nextParamIndex], (uint256));
                stringParam = Strings.toString(param);
                // expectedSubject = string(abi.encodePacked(expectedSubject, Strings.toString(param)));
            } else if(Strings.equal(template[i], "{int}")) {
                int256 param = abi.decode(emailAuthMsg.subjectParams[nextParamIndex], (int256));
                stringParam = Strings.toString(param);
                // expectedSubject = string(abi.encodePacked(expectedSubject, Strings.toString(param)));
            } else if(Strings.equal(template[i], "{decimals}")) {
                uint256 param = abi.decode(emailAuthMsg.subjectParams[nextParamIndex], (uint256));
                stringParam = Strings.toString(param);
                // expectedSubject = string(abi.encodePacked(expectedSubject, Strings.toString(param)));
            } else if(Strings.equal(template[i], "{decimals}")) {
                uint256 param = abi.decode(emailAuthMsg.subjectParams[nextParamIndex], (uint256));
                stringParam = Strings.toString(param);
                // expectedSubject = string(abi.encodePacked(expectedSubject, Strings.toString(param)));
            } else if(Strings.equal(template[i], "{ethAddr}")) {
                address param = abi.decode(emailAuthMsg.subjectParams[nextParamIndex], (address));
                stringParam = Strings.toHexString(param);
            } else {
                continue;
            }

            if(i > 0) {
                expectedSubject = string(abi.encodePacked(expectedSubject, " "));
            }
            expectedSubject = string(abi.encodePacked(expectedSubject, stringParam));
            nextParamIndex++;
        }
        string memory trimmedSubject = removePrefix(emailAuthMsg.proof.maskedSubject, emailAuthMsg.skipedSubjectPrefix);
        require(Strings.equal(expectedSubject, trimmedSubject), "invalid subject");
        require(verifier.verifyEmailProof(emailAuthMsg.proof) == true, "invalid email proof");

        bytes32 msgHash = computeMsgHash(
            emailAuthMsg.proof.accountSalt, 
            emailAuthMsg.proof.isCodeExist, 
            emailAuthMsg.templateId, 
            emailAuthMsg.subjectParams
        );

        require(authedHash[emailAuthMsg.proof.emailNullifier] == bytes32(0), "email already authed");
        authedHash[emailAuthMsg.proof.emailNullifier] = msgHash;

        return msgHash;
    }

    function isValidSignature(bytes32 _hash, bytes memory _signature) public view returns (bytes4) {
        (
            bytes32 _emailNullifier, 
            bytes32 _accountSalt, 
            uint _templateId, 
            bool _isCodeExist, 
            bytes[] memory _subjectParams
        ) = abi.decode(_signature, (bytes32, bytes32, uint, bool, bytes[]));

        bytes32 msgHash = computeMsgHash(_accountSalt, _isCodeExist, _templateId, _subjectParams);
        if(authedHash[_emailNullifier] == msgHash) {
            return 0x1626ba7e;
        } else {
            return 0xffffffff;
        }
    }
    
    function removePrefix(string memory str, uint numChars) private pure returns (string memory) {
        require(numChars <= bytes(str).length, "Invalid number of characters");

        bytes memory strBytes = bytes(str);
        bytes memory result = new bytes(strBytes.length - numChars);

        for (uint i = numChars; i < strBytes.length; i++) {
            result[i - numChars] = strBytes[i];
        }

        return string(result);
    }
}

