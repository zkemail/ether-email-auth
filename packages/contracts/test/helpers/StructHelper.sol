// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "./DeploymentHelper.sol";

contract StructHelper is DeploymentHelper {
    function buildEmailAuthMsg()
        public
        returns (EmailAuthMsg memory emailAuthMsg)
    {
        bytes[] memory subjectParams = new bytes[](2);
        subjectParams[0] = abi.encode(1 ether);
        subjectParams[1] = abi.encode(
            "0x0000000000000000000000000000000000000020"
        );

        EmailProof memory emailProof = EmailProof({
            domainName: "gmail.com",
            publicKeyHash: publicKeyHash,
            timestamp: 1694989812,
            maskedSubject: "Send 1 ETH to 0x0000000000000000000000000000000000000020",
            emailNullifier: emailNullifier,
            accountSalt: accountSalt,
            isCodeExist: true,
            proof: mockProof
        });

        emailAuthMsg = EmailAuthMsg({
            templateId: templateId,
            subjectParams: subjectParams,
            skipedSubjectPrefix: 0,
            proof: emailProof
        });

        vm.mockCall(
            address(verifier),
            abi.encodeWithSelector(
                Verifier.verifyEmailProof.selector,
                emailProof
            ),
            abi.encode(true)
        );
    }
}