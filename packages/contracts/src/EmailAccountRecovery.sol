// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "./EmailAuth.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Create2.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

abstract contract EmailAccountRecovery {
    uint8 constant EMAIL_ACCOUNT_RECOVERY_VERSION_ID = 1;

    function verifier() public view virtual returns (address) {
        return 0x0000000000000000000000000000000000000000;
    }

    function dkim() public view virtual returns (address) {
        return 0x0000000000000000000000000000000000000000;
    }

    function emailAuthImplementation() public view virtual returns (address) {
        return 0x0000000000000000000000000000000000000000;
    }

    function acceptanceSubjectTemplates()
        public
        view
        virtual
        returns (string[][] memory);

    function recoverySubjectTemplates()
        public
        view
        virtual
        returns (string[][] memory);

    function acceptGuardian(
        address guardian,
        uint templateIdx,
        bytes[] memory subjectParams,
        bytes32 emailNullifier
    ) public virtual;

    function recoverWallet(
        address guardian,
        uint templateIdx,
        bytes[] memory subjectParams,
        bytes32 emailNullifier
    ) public virtual;

    function computeEmailAuthAddress(bytes32 accountSalt)
        public
        view
        returns (address)
    {
        return Create2.computeAddress(
            accountSalt,
            keccak256(abi.encodePacked(
                type(ERC1967Proxy).creationCode,
                abi.encode(emailAuthImplementation(), abi.encodeCall(EmailAuth.initialize, (accountSalt)))
            ))
        );
    }

    function computeAcceptanceTemplateId(
        uint templateIdx
    ) public pure returns (uint) {
        return uint256(
            keccak256(
                abi.encode(
                    EMAIL_ACCOUNT_RECOVERY_VERSION_ID,
                    "ACCEPTANCE",
                    templateIdx
                )
            )
        );
    }

    function computeRecoveryTemplateId(
        uint templateIdx
    ) public pure returns (uint) {
        return uint256(
            keccak256(
                abi.encode(
                    EMAIL_ACCOUNT_RECOVERY_VERSION_ID,
                    "RECOVERY",
                    templateIdx
                )
            )
        );
    }

    function handleAcceptance(
        EmailAuthMsg memory emailAuthMsg,
        uint templateIdx
    ) external {
        address guardian = computeEmailAuthAddress(emailAuthMsg.proof.accountSalt);
        require(!Address.isContract(guardian), "guardian is already deployed");
        uint templateId = computeAcceptanceTemplateId(templateIdx);
        require(templateId == emailAuthMsg.templateId, "invalid template id");
        require(emailAuthMsg.proof.isCodeExist == true, "isCodeExist is false");

        // Deploy proxy of the guardian's EmailAuth contract
        ERC1967Proxy proxy = new ERC1967Proxy{salt: emailAuthMsg.proof.accountSalt}(
            emailAuthImplementation(),
            abi.encodeCall(EmailAuth.initialize, (emailAuthMsg.proof.accountSalt))
        );
        EmailAuth guardianEmailAuth = EmailAuth(address(proxy));
        guardianEmailAuth.updateDKIMRegistry(dkim());
        guardianEmailAuth.updateVerifier(verifier());
        for (uint idx = 0; idx < acceptanceSubjectTemplates().length; idx++) {
            guardianEmailAuth.insertSubjectTemplate(
                computeAcceptanceTemplateId(idx),
                acceptanceSubjectTemplates()[idx]
            );
        }
        for (uint idx = 0; idx < recoverySubjectTemplates().length; idx++) {
            guardianEmailAuth.insertSubjectTemplate(
                computeRecoveryTemplateId(idx),
                acceptanceSubjectTemplates()[idx]
            );
        }

        // An assertion to confirm that the authEmail function is executed successfully
        // and does not return an error.
        guardianEmailAuth.authEmail(emailAuthMsg);

        acceptGuardian(
            guardian,
            templateIdx,
            emailAuthMsg.subjectParams,
            emailAuthMsg.proof.emailNullifier
        );
    }

    function handleRecovery(
        EmailAuthMsg memory emailAuthMsg,
        uint templateIdx
    ) external {
        address guardian = Create2.computeAddress(
            emailAuthMsg.proof.accountSalt,
            bytes32(bytes20(emailAuthImplementation()))
        );
        require(Address.isContract(guardian), "guardian is not deployed");
        uint templateId = uint256(
            keccak256(
                abi.encode(
                    EMAIL_ACCOUNT_RECOVERY_VERSION_ID,
                    "RECOVERY",
                    templateIdx
                )
            )
        );
        require(templateId == emailAuthMsg.templateId, "invalid template id");

        EmailAuth guardianEmailAuth = EmailAuth(payable(address(guardian)));

        // An assertion to confirm that the authEmail function is executed successfully
        // and does not return an error.
        guardianEmailAuth.authEmail(emailAuthMsg);

        recoverWallet(
            guardian,
            templateIdx,
            emailAuthMsg.subjectParams,
            emailAuthMsg.proof.emailNullifier
        );
    }
    
}
