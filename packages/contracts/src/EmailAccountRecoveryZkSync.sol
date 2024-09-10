// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import {EmailAuth} from "./EmailAuth.sol";
import {EmailAccountRecovery} from "./EmailAccountRecovery.sol";
import {ZKSyncCreate2Factory} from "./utils/ZKSyncCreate2Factory.sol";

/// @title Email Account Recovery Contract
/// @notice Provides mechanisms for email-based account recovery, leveraging guardians and template-based email verification.
/// @dev This contract is abstract and requires implementation of several methods for configuring a new guardian and recovering an account contract.
abstract contract EmailAccountRecoveryZkSync is EmailAccountRecovery {

    // This is the address of the zkSync factory contract
    address public factoryAddr;
    // The bytecodeHash is hardcoded here because type(ERC1967Proxy).creationCode doesn't work on eraVM currently
    // If you failed some test cases, check the bytecodeHash by yourself
    // see, test/ComputeCreate2Address.t.sol
    bytes32 public constant proxyBytecodeHash = 0x0100008338d33e12c716a5b695c6f7f4e526cf162a9378c0713eea5386c09951;

    /// @notice Returns the address of the zkSyncfactory contract.
    /// @dev This function is virtual and can be overridden by inheriting contracts.
    /// @return address The address of the zkSync factory contract.
    function factory() public view virtual returns (address) {
        return factoryAddr;
    }

    /// @notice Computes the address for email auth contract using the CREATE2 opcode.
    /// @dev This function utilizes the `ZKSyncCreate2Factory` to compute the address. The computation uses a provided account address to be recovered, account salt,
    /// and the hash of the encoded ERC1967Proxy creation code concatenated with the encoded email auth contract implementation
    /// address and the initialization call data. This ensures that the computed address is deterministic and unique per account salt.
    /// @param recoveredAccount The address of the account to be recovered.
    /// @param accountSalt A bytes32 salt value defined as a hash of the guardian's email address and an account code. This is assumed to be unique to a pair of the guardian's email address and the wallet address to be recovered.
    /// @return address The computed address.
    function computeProxyAddress(
        address recoveredAccount,
        bytes32 accountSalt
    ) public view override returns (address) {
        // If on zksync, we use another logic to calculate create2 address.
        return ZKSyncCreate2Factory(factory()).computeAddress(
            accountSalt,
            proxyBytecodeHash,
            abi.encode(
                emailAuthImplementation(),
                abi.encodeCall(
                    EmailAuth.initialize,
                    (recoveredAccount, accountSalt, address(this))
                )
            )
        );
    }

    /// @notice Deploys a proxy contract for email authentication using the CREATE2 opcode.
    /// @dev This function utilizes the `ZKSyncCreate2Factory` to deploy the proxy contract. The deployment uses a provided account address to be recovered, account salt,
    /// and the hash of the encoded ERC1967Proxy creation code concatenated with the encoded email auth contract implementation
    /// address and the initialization call data. This ensures that the deployed address is deterministic and unique per account salt.
    /// @param recoveredAccount The address of the account to be recovered.
    /// @param accountSalt A bytes32 salt value defined as a hash of the guardian's email address and an account code. This is assumed to be unique to a pair of the guardian's email address and the wallet address to be recovered.
    /// @return address The address of the deployed proxy contract.
    function deployProxy(
        address recoveredAccount, 
        bytes32 accountSalt
    ) public override returns (address) {
        (bool success, bytes memory returnData) = ZKSyncCreate2Factory(factory()).deploy(
            accountSalt, 
            proxyBytecodeHash, 
            abi.encode(
                emailAuthImplementation(),
                abi.encodeCall(
                    EmailAuth.initialize,
                    (
                        recoveredAccount,
                        accountSalt,
                        address(this)
                    )
                )
            )
        );
        address payable proxyAddress = abi.decode(returnData, (address));
        return proxyAddress;
    }
}