// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {EmailProof} from "./utils/Verifier.sol";
import {ECDSAOwnedDKIMRegistry} from "./utils/ECDSAOwnedDKIMRegistry.sol";
import {Verifier} from "./utils/Verifier.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

struct EmailAuthMsg{
    uint templateId;
    bytes[] subjectParams;
    uint skipedSubjectPrefix;
    EmailProof proof;
}

contract EmailAuth {

    address owner;
    ECDSAOwnedDKIMRegistry dkim;
    Verifier verifier;
    mapping(uint => string[]) subjectTemplates;
    mapping(bytes32 => bytes32) authedHash;
    uint lastTimestamp;
 
    constructor(address _dkim, address _verifier) {
        owner = msg.sender;
        dkim = ECDSAOwnedDKIMRegistry(_dkim);
        verifier = Verifier(_verifier);
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

    function computeMsgHash(bytes32 accountSalt, bool isCodeExist, uint templateId, bytes[] memory subjectParams) public pure returns (bytes32) {
        return keccak256(abi.encode(accountSalt, isCodeExist, templateId, subjectParams));
    }

    function authEmail(EmailAuthMsg memory emailAuthMsg) public returns (address, bytes32) {
        require(msg.sender == owner, "only owner can auth email");
        string[] memory template = subjectTemplates[emailAuthMsg.templateId];
        require(template.length > 0, "template id not exists");
        require(
            dkim.isDKIMPublicKeyHashValid(
                emailAuthMsg.proof.domainName, 
                emailAuthMsg.proof.publicKeyHash
            ) == true, 
            "invalid dkim public key hash");
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
        
 
        bytes32 msgHash = computeMsgHash(
            emailAuthMsg.proof.accountSalt, 
            emailAuthMsg.proof.isCodeExist, 
            emailAuthMsg.templateId, 
            emailAuthMsg.subjectParams
        );
        require(authedHash[emailAuthMsg.proof.emailNullifier] == bytes32(0), "email already authed");
        authedHash[emailAuthMsg.proof.emailNullifier] = msgHash;

        // TBD
    }

    function isValidSignature(bytes32 _hash, bytes memory _signature) public view returns (bytes4) {
        (
            bytes32 emailNullifier, 
            bytes32 accountSalt, 
            uint templateId, 
            bool isCodeExist, 
            bytes[] memory subjectParams
        ) = abi.decode(_signature, (bytes32, bytes32, uint, bool, bytes[]));

        bytes32 msgHash = computeMsgHash(accountSalt, isCodeExist, templateId, subjectParams);
        if(authedHash[emailNullifier] == msgHash) {
            return 0x1626ba7e;
        } else {
            return 0xffffffff;
        }
    }
}

