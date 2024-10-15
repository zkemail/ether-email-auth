// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@zk-email/ether-email-auth-contracts/src/EmailAuth.sol";
import "@openzeppelin/contracts/utils/Create2.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

/// @title Example contract that emits an event for the command in the given email.
contract EmitEmailCommand {
    address public verifierAddr;
    address public dkimAddr;
    address public emailAuthImplementationAddr;

    event StringCommand(address indexed emailAuthAddr, string indexed command);
    event UintCommand(address indexed emailAuthAddr, uint indexed command);
    event IntCommand(address indexed emailAuthAddr, int indexed command);
    event DecimalsCommand(address indexed emailAuthAddr, uint indexed command);
    event EthAddrCommand(
        address indexed emailAuthAddr,
        address indexed command
    );

    constructor(
        address _verifierAddr,
        address _dkimAddr,
        address _emailAuthImplementationAddr
    ) {
        verifierAddr = _verifierAddr;
        dkimAddr = _dkimAddr;
        emailAuthImplementationAddr = _emailAuthImplementationAddr;
    }

    /// @notice Returns the address of the verifier contract.
    /// @dev This function is virtual and can be overridden by inheriting contracts.
    /// @return address The address of the verifier contract.
    function verifier() public view virtual returns (address) {
        return verifierAddr;
    }

    /// @notice Returns the address of the DKIM contract.
    /// @dev This function is virtual and can be overridden by inheriting contracts.
    /// @return address The address of the DKIM contract.
    function dkim() public view virtual returns (address) {
        return dkimAddr;
    }

    /// @notice Returns the address of the email auth contract implementation.
    /// @dev This function is virtual and can be overridden by inheriting contracts.
    /// @return address The address of the email authentication contract implementation.
    function emailAuthImplementation() public view virtual returns (address) {
        return emailAuthImplementationAddr;
    }

    /// @notice Computes the address for email auth contract using the CREATE2 opcode.
    /// @dev This function utilizes the `Create2` library to compute the address. The computation uses a provided account address to be recovered, account salt,
    /// and the hash of the encoded ERC1967Proxy creation code concatenated with the encoded email auth contract implementation
    /// address and the initialization call data. This ensures that the computed address is deterministic and unique per account salt.
    /// @param owner The address of the owner of the EmailAuth proxy.
    /// @param accountSalt A bytes32 salt value defined as a hash of the guardian's email address and an account code. This is assumed to be unique to a pair of the guardian's email address and the wallet address to be recovered.
    /// @return address The computed address.
    function computeEmailAuthAddress(
        address owner,
        bytes32 accountSalt
    ) public view returns (address) {
        return
            Create2.computeAddress(
                accountSalt,
                keccak256(
                    abi.encodePacked(
                        type(ERC1967Proxy).creationCode,
                        abi.encode(
                            emailAuthImplementation(),
                            abi.encodeCall(
                                EmailAuth.initialize,
                                (owner, accountSalt, address(this))
                            )
                        )
                    )
                )
            );
    }

    /// @notice Deploys a new proxy contract for email authentication.
    /// @dev This function uses the CREATE2 opcode to deploy a new ERC1967Proxy contract with a deterministic address.
    /// @param owner The address of the owner of the EmailAuth proxy.
    /// @param accountSalt A bytes32 salt value used to ensure the uniqueness of the deployed proxy address.
    /// @return address The address of the newly deployed proxy contract.
    function deployEmailAuthProxy(
        address owner,
        bytes32 accountSalt
    ) internal returns (address) {
        ERC1967Proxy proxy = new ERC1967Proxy{salt: accountSalt}(
            emailAuthImplementation(),
            abi.encodeCall(
                EmailAuth.initialize,
                (owner, accountSalt, address(this))
            )
        );
        return address(proxy);
    }

    /// @notice Calculates a unique command template ID for template provided by this contract.
    /// @dev Encodes the email account recovery version ID, "EXAMPLE", and the template index,
    /// then uses keccak256 to hash these values into a uint ID.
    /// @param templateIdx The index of the command template.
    /// @return uint The computed uint ID.
    function computeTemplateId(uint templateIdx) public pure returns (uint) {
        return uint256(keccak256(abi.encode("EXAMPLE", templateIdx)));
    }

    /// @notice Returns a two-dimensional array of strings representing the command templates.
    /// @return string[][] A two-dimensional array of strings, where each inner array represents a set of fixed strings and matchers for a command template.
    function commandTemplates() public pure returns (string[][] memory) {
        string[][] memory templates = new string[][](5); // Corrected size to 5
        templates[0] = new string[](3); // Corrected size to 3
        templates[0][0] = "Emit";
        templates[0][1] = "string";
        templates[0][2] = "{string}";

        templates[1] = new string[](3); // Added missing initialization
        templates[1][0] = "Emit";
        templates[1][1] = "uint";
        templates[1][2] = "{uint}";

        templates[2] = new string[](3); // Added missing initialization
        templates[2][0] = "Emit";
        templates[2][1] = "int";
        templates[2][2] = "{int}";

        templates[3] = new string[](3); // Added missing initialization
        templates[3][0] = "Emit";
        templates[3][1] = "decimals";
        templates[3][2] = "{decimals}";

        templates[4] = new string[](4); // Corrected size to 4
        templates[4][0] = "Emit";
        templates[4][1] = "ethereum";
        templates[4][2] = "address"; // Fixed typo: "adddress" to "address"
        templates[4][3] = "{ethAddr}";

        return templates;
    }

    /// @notice Emits an event for the command in the given email.
    function emitEmailCommand(
        EmailAuthMsg memory emailAuthMsg,
        address owner,
        uint templateIdx
    ) public {
        address emailAuthAddr = computeEmailAuthAddress(
            owner,
            emailAuthMsg.proof.accountSalt
        );
        uint templateId = computeTemplateId(templateIdx);
        require(templateId == emailAuthMsg.templateId, "invalid template id");

        EmailAuth emailAuth;
        if (emailAuthAddr.code.length == 0) {
            require(
                emailAuthMsg.proof.isCodeExist == true,
                "isCodeExist must be true for the first email"
            );
            address proxyAddress = deployEmailAuthProxy(
                owner,
                emailAuthMsg.proof.accountSalt
            );
            require(
                proxyAddress == emailAuthAddr,
                "proxy address does not match with emailAuthAddr"
            );
            emailAuth = EmailAuth(proxyAddress);
            emailAuth.initDKIMRegistry(dkim());
            emailAuth.initVerifier(verifier());
            string[][] memory templates = commandTemplates();
            for (uint idx = 0; idx < templates.length; idx++) {
                emailAuth.insertCommandTemplate(
                    computeTemplateId(idx),
                    templates[idx]
                );
            }
        } else {
            emailAuth = EmailAuth(payable(address(emailAuthAddr)));
            require(
                emailAuth.controller() == address(this),
                "invalid controller"
            );
        }
        emailAuth.authEmail(emailAuthMsg);
        _emitEvent(emailAuthAddr, emailAuthMsg.commandParams, templateIdx);
    }

    function _emitEvent(
        address emailAuthAddr,
        bytes[] memory commandParams,
        uint templateIdx
    ) private {
        if (templateIdx == 0) {
            string memory command = abi.decode(commandParams[0], (string));
            emit StringCommand(emailAuthAddr, command);
        } else if (templateIdx == 1) {
            uint command = abi.decode(commandParams[0], (uint));
            emit UintCommand(emailAuthAddr, command);
        } else if (templateIdx == 2) {
            int command = abi.decode(commandParams[0], (int));
            emit IntCommand(emailAuthAddr, command);
        } else if (templateIdx == 3) {
            uint command = abi.decode(commandParams[0], (uint));
            emit DecimalsCommand(emailAuthAddr, command);
        } else if (templateIdx == 4) {
            address command = abi.decode(commandParams[0], (address));
            emit EthAddrCommand(emailAuthAddr, command);
        } else {
            revert("invalid templateIdx");
        }
    }
}
