// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "./DeploymentHelper.sol";

contract StructHelper is DeploymentHelper {
    function buildEmailAuthMsg()
        public
        returns (EmailAuthMsg memory emailAuthMsg)
    {
        bytes[] memory commandParams = new bytes[](2);
        commandParams[0] = abi.encode(1 ether);
        commandParams[1] = abi.encode(
            "0x0000000000000000000000000000000000000020"
        );

        EmailProof memory emailProof = EmailProof({
            domainName: "gmail.com",
            publicKeyHash: publicKeyHash,
            timestamp: 1694989812,
            maskedCommand: "Send 1 ETH to 0x0000000000000000000000000000000000000020",
            emailNullifier: emailNullifier,
            accountSalt: accountSalt,
            isCodeExist: true,
            proof: mockProof
        });

        emailAuthMsg = EmailAuthMsg({
            templateId: templateId,
            commandParams: commandParams,
            skippedCommandPrefix: 0,
            proof: emailProof
        });

        vm.mockCall(
            address(verifier),
            abi.encodeCall(IVerifier.verifyEmailProof, (emailProof)),
            abi.encode(true)
        );
    }

    function buildJwtMsg()
        public
        returns (EmailAuthMsg memory emailAuthMsg)
    {
        bytes[] memory commandParams = new bytes[](2);
        commandParams[0] = abi.encode(1 ether);
        commandParams[1] = abi.encode(
            "0x0000000000000000000000000000000000000020"
        );

        EmailProof memory emailProof = EmailProof({
            domainName: "12345|https://example.com|client-id-12345",
            publicKeyHash: publicKeyHash,
            timestamp: 1694989812,
            maskedCommand: "Send 1 ETH to 0x0000000000000000000000000000000000000020",
            emailNullifier: emailNullifier,
            accountSalt: accountSalt,
            isCodeExist: true,
            proof: mockProof
        });

        emailAuthMsg = EmailAuthMsg({
            templateId: templateId,
            commandParams: commandParams,
            skippedCommandPrefix: 0,
            proof: emailProof
        });

        vm.mockCall(
            address(jwtVerifier),
            abi.encodeCall(IVerifier.verifyEmailProof, (emailProof)),
            abi.encode(true)
        );
    }

}
