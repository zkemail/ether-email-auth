## Set up

```bash
yarn install
```

## Requirements
- Newer than or equal to `forge 0.2.0 (13497a5)`.

## Build and Test

Make sure you have [Foundry](https://github.com/foundry-rs/foundry) installed

Build the contracts using the below command.

```bash
$ yarn build
```

Run unit tests
```bash
$ yarn test
```

Run integration tests

Before running integration tests, you need to make a `packages/contracts/test/build_integration` directory, download the zip file from the following link, and place its unzipped directory under that directory.
https://drive.google.com/file/d/1XDPFIL5YK8JzLGoTjmHLXO9zMDjSQcJH/view?usp=sharing

Then, move `email_auth_with_body_parsing_with_qp_encoding.zkey` and `email_auth_with_body_parsing_with_qp_encoding.wasm` in the unzipped directory `params` to `build_integration`. 


Run each integration tests **one by one** as each test will consume a lot of memory.
```bash
Eg: contracts % forge test --skip '*ZKSync*' --match-contract "IntegrationTest" -vvv --chain 8453 --ffi
```
#### Deploy Common Contracts.
You need to deploy common contracts, i.e., `ECDSAOwnedDKIMRegistry`, `Verifier`, and implementations of `EmailAuth` and `SimpleWallet`, only once before deploying each wallet.
1. `cp .env.sample .env`. 
2. Write your private key in hex to the `PRIVATE_KEY` field in `.env`. If you want to verify your own contracts, you can set `ETHERSCAN_API_KEY` to your own key.
3. `source .env`
4. `forge script script/DeployCommons.s.sol:Deploy --rpc-url $RPC_URL --chain-id $CHAIN_ID --etherscan-api-key $ETHERSCAN_API_KEY --broadcast --verify -vvvv`

#### Deploy Each Wallet.
After deploying common contracts, you can deploy a proxy contract of `SimpleWallet`, which is an example contract supporting our email-based account recovery by `RecoveryController`.
1. Check that the env values of `DKIM`, `VERIFIER`, `EMAIL_AUTH_IMPL`, and `SIMPLE_WALLET_IMPL` are the same as those output by the `DeployCommons.s.sol` script.
2. `forge script script/DeployRecoveryController.s.sol:Deploy --rpc-url $RPC_URL --chain-id $CHAIN_ID --broadcast -vvvv` 

## Specification
There are four main contracts that developers should understand: `IDKIMRegistry`, `Verifier`, `EmailAuth` and `EmailAccountRecovery`.
While the first three contracts are agnostic to use cases of our SDK, the last one is an abstract contract only for our email-based account recovery.

### `IDKIMRegistry` Contract
It is an interface of the DKIM registry contract that traces public keys registered for each email domain in DNS.
It is defined in [the zk-email library](https://github.com/zkemail/zk-email-verify/blob/main/packages/contracts/interfaces/IDKIMRegistry.sol).
It requires a function `isDKIMPublicKeyHashValid(string domainName, bytes32 publicKeyHash) view returns (bool)`: it returns true if the given hash of the public key `publicKeyHash` is registered for the given email-domain name `domainName`.

One of its implementations is [`ECDSAOwnedDKIMRegistry`](https://github.com/zkemail/ether-email-auth/blob/main/packages/contracts/src/utils/ECDSAOwnedDKIMRegistry.sol).
It stores the Ethereum address `signer` who can update the registry.

We also provide another implementation called [`UserOverrideableDKIMRegistry`](https://github.com/zkemail/ether-email-auth/blob/main/packages/contracts/node_modules/@zk-email/contracts/UserOverrideableDKIMRegistry.sol). 

Key features of `UserOverrideableDKIMRegistry` include:
1. User-specific public key setting
2. Time-delayed activation of main authorizer's approvals
3. Dual revocation mechanism (user or main authorizer)
4. Reactivation of revoked keys (by users only)

This implementation provides a balance between centralized management and user autonomy in the DKIM registry system.

### `Verifier` Contract
It has the responsibility to verify a ZK proof for the [`email_auth_with_body_parsing_with_qp_encoding.circom` circuit](https://github.com/zkemail/ether-email-auth/blob/main/packages/circuits/src/email_auth_with_body_parsing_with_qp_encoding.circom).
It is implemented in [`utils/Verifier.sol`](https://github.com/zkemail/ether-email-auth/blob/main/packages/contracts/src/utils/Verifier.sol).

It defines a structure `EmailProof` consisting of the ZK proof and data of the instances necessary for proof verification as follows:
```
struct EmailProof {
    string domainName; // Domain name of the sender's email
    bytes32 publicKeyHash; // Hash of the DKIM public key used in email/proof
    uint timestamp; // Timestamp of the email
    string maskedCommand; // Masked command of the email
    bytes32 emailNullifier; // Nullifier of the email to prevent its reuse.
    bytes32 accountSalt; // Create2 salt of the account
    bool isCodeExist; // Check if the account code exists
    bytes proof; // ZK Proof of Email
}
```

Using that, it provides a function `function verifyEmailProof(EmailProof memory proof) public view returns (bool)`: it takes as input the `EmailProof proof` and returns true if the proof is valid. Notably, it internally calls [`Groth16Verifier.sol`](https://github.com/zkemail/ether-email-auth/blob/main/packages/contracts/src/utils/Groth16Verifier.sol) generated by snarkjs from the verifying key of the [`email_auth_with_body_parsing_with_qp_encoding.circom` circuit](https://github.com/zkemail/ether-email-auth/blob/main/packages/circuits/src/email_auth_with_body_parsing_with_qp_encoding.circom).

### `EmailAuth` Contract
It is a contract deployed for each email user to verify an email-auth message from that user. The structure of the email-auth message is defined as follows:
```
struct EmailAuthMsg {
    uint templateId; // The ID of the command template that the email command should satisfy.
    bytes[] commandParams; // The parameters in the email command, which should be taken according to the specified command template.
    uint skippedCommandPrefix; // The number of skipped bytes in the email command.
    EmailProof proof; // The email proof containing the zk proof and other necessary information for the email verification by the verifier contract.
} 
```

It has the following storage variables.
- `address owner`: an address of the contract owner.
- `bytes32 accountSalt`: an `accountSalt` used for the CREATE2 salt of this contract.
- `DKIMRegistry dkim`: an instance of the DKIM registry contract.
- `Verifier verifier`: an instance of the Verifier contract.
- `address controller`: an address of a controller contract, defining the command templates supported by this contract. 
- `mapping(uint=>string[]) commandTemplates`: a mapping of the supported command templates associated with its ID.  
- `mapping(bytes32⇒bytes32) authedHash`: a mapping of the hash of the authorized message associated with its `emailNullifier`. 
- `uint lastTimestamp`: the latest `timestamp` in the verified `EmailAuthMsg`. 
- `mapping(bytes32=>bool) usedNullifiers`: a mapping storing the used `emailNullifier` bytes. 
- `bool timestampCheckEnabled`: a boolean whether timestamp check is enabled or not.

It provides the following functions.
- `initialize(address _initialOwner, bytes32 _accountSalt, address _controller)`
    1. Set `owner=_initialOwner` .
    2. Set `accountSalt=_accountSalt`.
    3. Set `timestampCheckEnabled=true`.
    4. Set `controller=_controller`.
- `dkimRegistryAddr() view returns (address)`
    Return `address(dkim)`
- `verifierAddr() view returns (address)`
    Return `address(verifier)` .
- `initDKIMRegistry(address _dkimRegistryAddr)`
    1. Assert `msg.sender==controller`.
    2. Assert `dkim` is zero.
    3. Set `dkim=IDKIMRegistry(_dkimRegistryAddr)`.
- `initVerifier(address _verifierAddr)`
    1. Assert `msg.sender==controller`.
    2. Assert `verifier` is zero.
    3. Set `verifier=Verifier(_verifierAddr)`.
- `updateDKIMRegistry(address _dkimRegistryAddr)`
    1. Assert `msg.sender==owner`.
    2. Assert `_dkimRegistryAddr` is not zero.
    3. Set `dkim=DKIMRegistry(_dkimRegistryAddr)`.
- `updateVerifier(address _verifier)`
    1. Assert `msg.sender==owner`.
    2. Assert `_verifier` is not zero.
    3. Set `verifier=Verifier(_verifier)`.
- `updateVerifier(address _verifierAddr)`
    1. Assert `msg.sender==owner` .
    2. Assert `_verifierAddr!=0`.
    3. Update `verifier` to `Verifier(_verifierAddr)`.
- `updateDKIMRegistry(address _dkimRegistryAddr)`
    1. Assert `msg.sender==owner` .
    2. Assert `_dkimRegistryAddr!=0`.
    3. Update `dkim` to `DKIMRegistry(_dkimRegistryAddr)`.
- `getCommandTemplate(uint _templateId) public view returns (string[] memory)`
    1. Assert that the template for `_templateId` exists, i.e., `commandTemplates[_templateId].length >0` holds.
    2. Return `commandTemplates[_templateId]`.
- `insertCommandTemplate(uint _templateId, string[] _commandTemplate)`
    1. Assert `_commandTemplate.length>0` .
    2. Assert `msg.sender==controller`.
    3. Assert `commandTemplates[_templateId].length == 0`, i.e., no template has not been registered with `_templateId`.
    4. Set  `commandTemplates[_templateId]=_commandTemplate`.
- `updateCommandTemplate(uint _templateId, string[] _commandTemplate)`
    1. Assert `_commandTemplate.length>0` .
    2. Assert `msg.sender==controller`.
    3. Assert `commandTemplates[_templateId].length != 0` , i.e., any template has been already registered with `_templateId`.
    4. Set  `commandTemplates[_templateId]=_commandTemplate`.
- `deleteCommandTemplate(uint _templateId)`
    1. Assert `msg.sender==controller`.
    2. Assert `commandTemplates[_templateId].length > 0`, i.e., any template has been already registered with `_templateId`.
    3. `delete commandTemplates[_templateId]`.
- `authEmail(EmailAuthMsg emailAuthMsg) returns (bytes32)`
    1. Assert `msg.sender==controller`.
    2. Let `string[] memory template = commandTemplates[emailAuthMsg.templateId]`.
    3. Assert `template.length > 0`.
    4. Assert `dkim.isDKIMPublicKeyHashValid(emailAuthMsg.proof.domain, emailAuthMsg.proof.publicKeyHash)==true`.
    5. Assert `usedNullifiers[emailAuthMsg.proof.emailNullifier]==false` and set `usedNullifiers[emailAuthMsg.proof.emailNullifier]` to `true`. 
    6. Assert `accountSalt==emailAuthMsg.proof.accountSalt`.
    7. If `timestampCheckEnabled` is true, assert that `emailAuthMsg.proof.timestamp` is zero OR `lastTimestamp < emailAuthMsg.proof.timestamp`, and update `lastTimestamp` to `emailAuthMsg.proof.timestamp`.
    8. Construct an expected command `expectedCommand` from `template` and the values of `emailAuthMsg.commandParams`.
    9. Assert that `expectedCommand` is equal to `emailAuthMsg.proof.maskedCommand[skippedCommandPrefix:]` , i.e., the string of `emailAuthMsg.proof.maskedCommand` from the `skippedCommandPrefix`-th byte.
    10. Assert `verifier.verifyEmailProof(emailAuthMsg.proof)==true`.
- `isValidSignature(bytes32 _hash, bytes memory _signature) public view returns (bytes4 magicValue)`
    1. Parse `_signature` as `(bytes32 emailNullifier)`.
    2. If `authedHash[emailNullifier]== _hash`, return `0x1626ba7e`; otherwise return `0xffffffff`.
- `setTimestampCheckEnabled(bool enabled) public`
    1. Assert `msg.sender==controller`.
    2. Set `timestampCheckEnabled` to `enabled`.

### `EmailAccountRecovery` Contract
It is an abstract contract for each smart account brand to implement the email-based account recovery. **Each smart account provider only needs to implement the following functions in a new contract called controller.** In the following, the `templateIdx` is different from `templateId` in the email-auth contract in the sense that the `templateIdx` is an incremental index defined for each of the command templates in `acceptanceCommandTemplates()` and `recoveryCommandTemplates()`.

- `isActivated(address recoveredAccount) public view virtual returns (bool)`: it returns if the account to be recovered has already activated the controller (the contract implementing `EmailAccountRecovery`). 
- `acceptanceCommandTemplates() public view virtual returns (string[][])`: it returns multiple command templates for an email to accept becoming a guardian (acceptance email).
- `recoveryCommandTemplates() public view virtual returns (string[][])`: it returns multiple command templates for an email to confirm the account recovery (recovery email).
- `extractRecoveredAccountFromAcceptanceCommand(bytes[] memory commandParams, uint templateIdx) public view virtual returns (address)`: it takes as input the parameters `commandParams` and the index of the chosen command template `templateIdx` in those for acceptance emails.
- `extractRecoveredAccountFromRecoveryCommand(bytes[] memory commandParams, uint templateIdx) public view virtual returns (address)`: it takes as input the parameters `commandParams` and the index of the chosen command template `templateIdx` in those for recovery emails.
- `acceptGuardian(address guardian, uint templateIdx, bytes[] commandParams, bytes32 emailNullifier) internal virtual`: it takes as input the Ethereum address `guardian` corresponding to the guardian's email address, the index `templateIdx` of the command template in the output of `acceptanceCommandTemplates()`, the parameter values of the variable parts `commandParams` in the template `acceptanceCommandTemplates()[templateIdx]`, and an email nullifier `emailNullifier`. It is called after verifying the email-auth message to accept the role of the guardian; thus you can assume the arguments are already verified. 
- `processRecovery(address guardian, uint templateIdx, bytes[] commandParams, bytes32 emailNullifier) internal virtual`: it takes as input the Ethereum address `guardian` corresponding to the guardian's email address, the index `templateIdx` of the command template in the output of `recoveryCommandTemplates()`, the parameter values of the variable parts `commandParams` in the template `recoveryCommandTemplates()[templateIdx]`, and an email nullifier `emailNullifier`. It is called after verifying the email-auth message to confirm the recovery; thus you can assume the arguments are already verified.
- `completeRecovery(address account, bytes memory completeCalldata) external virtual`: it can be called by anyone, in particular a Relayer, when completing the account recovery. It should first check if the condition for the recovery of `account` holds and then update its owner's address in the wallet contract.

It also provides the following entry functions with their default implementations, called by the Relayer.
- `handleAcceptance(EmailAuthMsg emailAuthMsg, uint templateIdx) external`
    1. Extract an account address to be recovered `recoveredAccount` by calling `extractRecoveredAccountFromAcceptanceCommand`.
    2. Let `address guardian = CREATE2(emailAuthMsg.proof.accountSalt, ERC1967Proxy.creationCode, emailAuthImplementation(), (emailAuthMsg.proof.accountSalt))`.
    3. Let `uint templateId = keccak256(EMAIL_ACCOUNT_RECOVERY_VERSION_ID, "ACCEPTANCE", templateIdx)`.
    4. Assert that  `templateId` is equal to `emailAuthMsg.templateId`.
    5. Assert that `emailAuthMsg.proof.isCodeExist` is true.
    6. If the `EmailAuth` contract of `guardian` has not been deployed, deploy the proxy contract of `emailAuthImplementation()`. Its salt is `emailAuthMsg.proof.accountSalt` and its initialization parameter is `recoveredAccount`, `emailAuthMsg.proof.accountSalt`, and `address(this)`, which is a controller of the deployed contract.
    7. If the `EmailAuth` contract of `guardian` has not been deployed, call `EmailAuth(guardian).initDKIMRegistry(dkim())`.
    8. If the `EmailAuth` contract of `guardian` has not been deployed, call `EmailAuth(guardian).initVerifier(verifier())`.
    9. If the `EmailAuth` contract of `guardian` has not been deployed, for each `template` in `acceptanceCommandTemplates()` along with its index `idx`, call `EmailAuth(guardian).insertCommandTemplate(keccak256(EMAIL_ACCOUNT_RECOVERY_VERSION_ID, "ACCEPTANCE", idx), template)`.
    10. If the `EmailAuth` contract of `guardian` has not been deployed, for each `template` in `recoveryCommandTemplates()` along with its index `idx`, call `EmailAuth(guardian).insertCommandTemplate(keccak256(EMAIL_ACCOUNT_RECOVERY_VERSION_ID, "RECOVERY", idx), template)`.
    11. If the `EmailAuth` contract of `guardian` has been already deployed, assert that its `controller` is equal to `address(this)`.
    11. Assert that `EmailAuth(guardian).authEmail(emailAuthMsg)` returns no error.
    12. Call `acceptGuardian(guardian, templateIdx, emailAuthMsg.commandParams, emailAuthMsg.proof.emailNullifier)`.
- `handleRecovery(EmailAuthMsg emailAuthMsg, uint templateIdx) external`
    1. Extract an account address to be recovered `recoveredAccount` by calling `extractRecoveredAccountFromRecoveryCommand`.
    1. Let `address guardian = CREATE2(emailAuthMsg.proof.accountSalt, ERC1967Proxy.creationCode, emailAuthImplementation(), (emailAuthMsg.proof.accountSalt))`.
    2. Assert that the contract of `guardian` has been already deployed.
    3. Let `uint templateId=keccak256(EMAIL_ACCOUNT_RECOVERY_VERSION_ID, "RECOVERY", templateIdx)`.
    4. Assert that  `templateId` is equal to `emailAuthMsg.templateId`.
    5. Assert that `EmailAuth(guardian).authEmail(emailAuthMsg)` returns no error.
    6. Call `processRecovery(guardian, templateIdx, emailAuthMsg.commandParams, emailAuthMsg.proof.emailNullifier)`.

# For ZKsync

## Set up and build
```
# Install foundry
foundryup

cd packages/contracts
yarn build

# Install foundry-zksync, please follow this URL
https://foundry-book.zksync.io/getting-started/installation

# Install era-test-node
https://github.com/matter-labs/era-test-node
```

Next, you should uncomment the following lines in `foundry.toml`.

```
# via-ir = true 
```

Partial comment-out files can be found the following. Please uncomment them.
(Uncomment from `FOR_ZKSYNC:START` to `FOR_ZKSYNC:END`)

- src/utils/ZKSyncCreate2Factory.sol
- test/helpers/DeploymentHelper.sol

Run the era-test-node forking zksync sepolia

```
era_test_node fork https://sepolia.era.zksync.dev
```

At the first forge build, you need to detect the missing libraries.

```
forge build --zksync --zk-detect-missing-libraries
```

As you saw before, you need to deploy missing libraries.
You can deploy them by the following command for example.

```
$ forge build --zksync --zk-detect-missing-libraries
Missing libraries detected: src/libraries/CommandUtils.sol:CommandUtils, src/libraries/DecimalUtils.sol:DecimalUtils, src/libraries/StringUtils.sol:StringUtils
```

Run the following command in order to deploy each missing libraries:

```
export PRIVATE_KEY={YOUR_PRIVATE_KEY}
export RPC_URL=http://127.0.0.1:8011
export CHAIN_ID=260

forge create src/libraries/DecimalUtils.sol:DecimalUtils --private-key $PRIVATE_KEY --rpc-url $RPC_URL --chain $CHAIN_ID --zksync
forge create src/libraries/CommandUtils.sol:CommandUtils --private-key $PRIVATE_KEY --rpc-url $RPC_URL --chain $CHAIN_ID --zksync --libraries src/libraries/DecimalUtils.sol:DecimalUtils:{DECIMAL_UTILS_ADDRESS_YOU_DEPLOYED}
forge create src/libraries/StringUtils.sol:StringUtils --private-key $PRIVATE_KEY --rpc-url $RPC_URL --chain $CHAIN_ID --zksync
```

After that, you can see the following lines in the foundry.toml. Please replace `{PROJECT_DIR}` and `{DEPLOYED_ADDRESS}`.
Also, this lines are needed only for foundry-zksync, if you use normal foundry commands, please comment out. 


```
libraries = [
    "{PROJECT_DIR}/packages/contracts/src/libraries/DecimalUtils.sol:DecimalUtils:{DEPLOYED_ADDRESS}", 
    "{PROJECT_DIR}/packages/contracts/src/libraries/CommandUtils.sol:CommandUtils:{DEPLOYED_ADDRESS}"
    "{PROJECT_DIR}/packages/contracts/src/libraries/StringUtils.sol:StringUtils:{DEPLOYED_ADDRESS}"
]
```

About Create2, `L2ContractHelper.computeCreate2Address` should be used.
`type(ERC1967Proxy).creationCode` doesn't work correctly in ZKsync.
We need to use the bytecode hash intead of `type(ERC1967Proxy).creationCode`.
Perhaps that is a different value in each compiler version and library addresses.

Run the following commands, you'll get the bytecode hash.

```
forge test --match-test "testComputeCreate2Address" --no-match-contract ".*Script.*" --system-mode=true --zksync --gas-limit 1000000000 --chain 300 -vvv --fork-url http://127.0.0.1:8011
```

And then, you should replace `{YOUR_BYTECODE_HASH}` in the .env

```
PROXY_BYTECODE_HASH={YOUR_BYTECODE_HASH}
```

## Unit tests

Run the following commands

```
source .env
yarn zktest
```

Even if the contract size is fine for EVM, it may exceed the bytecode size limit for zksync, and the test may not be executed. If you encountered the contract size error, please consider the contract design.

## Integration tests

```
source .env
forge test --match-contract "IntegrationZKSyncTest" --system-mode=true --zksync --gas-limit 1000000000 --chain 300 -vvv --ffi
```

## Deployment (For zksync sepolia)

As you saw before, you need to deploy missing libraries.
You can deploy them by the following commands for example.

```
export PRIVATE_KEY={YOUR_PRIVATE_KEY}
export RPC_URL=https://sepolia.era.zksync.dev
export CHAIN_ID=300

forge create src/libraries/DecimalUtils.sol:DecimalUtils --private-key $PRIVATE_KEY --rpc-url $RPC_URL --chain $CHAIN_ID --zksync
forge create src/libraries/CommandUtils.sol:CommandUtils --private-key $PRIVATE_KEY --rpc-url $RPC_URL --chain $CHAIN_ID --zksync --libraries src/libraries/DecimalUtils.sol:DecimalUtils:{DECIMAL_UTILS_ADDRESS_YOU_DEPLOYED}
forge create src/libraries/StringUtils.sol:StringUtils --private-key $PRIVATE_KEY --rpc-url $RPC_URL --chain $CHAIN_ID --zksync
```

And then you need to replace `{PROJECT_DIR}` and `{DEPLOYED_ADDRESS}` in the foundy.toml.

```
libraries = [
    "{PROJECT_DIR}/packages/contracts/src/libraries/DecimalUtils.sol:DecimalUtils:{DEPLOYED_ADDRESS}", 
    "{PROJECT_DIR}/packages/contracts/src/libraries/CommandUtils.sol:CommandUtils:{DEPLOYED_ADDRESS}"]
    "{PROJECT_DIR}/packages/contracts/src/libraries/StringUtils.sol:StringUtils:{DEPLOYED_ADDRESS}"
```

Run this command again, you'll get the bytecode hash.

```
forge test --match-test "testComputeCreate2Address" --no-match-contract ".*Script.*" --system-mode=true --zksync --gas-limit 1000000000 --chain 300 -vvv --fork-url http://127.0.0.1:8011
```

And then, you should replace `{YOUR_BYTECODE_HASH}` in the .env

```
PROXY_BYTECODE_HASH={YOUR_BYTECODE_HASH}
```

Run the deploy script

```
source .env

export RPC_URL=https://sepolia.era.zksync.dev
export CHAIN_ID=300

forge script script/DeployRecoveryControllerZKSync.s.sol:Deploy --zksync --rpc-url $RPC_URL --broadcast --slow --via-ir --system-mode true -vvvv 
```

# Emergency Response

For information on how upgrade contracts for handling emergency situations, please refer to our [Upgrading Contracts](../../docs/upgrade.md).