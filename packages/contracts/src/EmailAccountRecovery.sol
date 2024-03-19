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
        returns (string[][] memory)
    {
        return new string[][](0);
    }

    function recoverySubjectTemplates()
        public
        view
        virtual
        returns (string[][] memory)
    {
        return new string[][](0);
    }

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

    function handleAcceptance(
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
                    "ACCEPTANCE",
                    templateIdx
                )
            )
        );
        require(templateId == emailAuthMsg.templateId, "invalid template id");
        require(emailAuthMsg.proof.isCodeExist == true, "isCodeExist is false");

        // Deploy proxy
        ERC1967Proxy proxy = new ERC1967Proxy(
            address(emailAuthImplementation()),
            abi.encode(dkim(), verifier())
        );
        EmailAuth newEmailAuth = EmailAuth(payable(address(proxy)));
        EmailAuth guardianEmailAuth = EmailAuth(payable(address(guardian)));

        for (uint i = 0; i < acceptanceSubjectTemplates().length; i++) {
            guardianEmailAuth.insertSubjectTemplate(
                i,
                acceptanceSubjectTemplates()[i]
            );
        }

        for (uint i = 0; i < recoverySubjectTemplates().length; i++) {
            guardianEmailAuth.insertSubjectTemplate(
                i,
                acceptanceSubjectTemplates()[i]
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
