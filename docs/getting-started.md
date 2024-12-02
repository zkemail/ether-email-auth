# Getting Started 

The following steps are for developers to implement account recovery using email-tx-builder.

## Prerequisites

First, install foundry by running the following command:

```sh
curl -L https://foundry.paradigm.xyz | bash
```

## Clone the repository

```sh
git clone https://github.com/zkemail/email-tx-builder.git
```

## Set up

Move to the `packages/contracts` directory and run the following command.

```sh
yarn install
```

Also, build the contract by running the following command.

```sh
yarn build
```

## SimpleWallet

First, implement a simple wallet.
Use the following implementation of SimpleWallet.
(SimpleWallet.sol)[../packages/contracts/contracts/SimpleWallet.sol]
This implementation inherits OwnableUpgradeable.

### changeOwner(address newOwner) 

This function is implemented to change the owner of this wallet.

```solidity
function changeOwner(address newOwner) public {
    require(
        msg.sender == owner() || msg.sender == recoveryController,
        "only owner or recovery controller"
    );
    _transferOwnership(newOwner);
}
```

## RecoveryController

Implement a RecoveryController to execute EmailAuth.
Implement the following implementation of RecoveryController.
(RecoveryController.sol)[../packages/contracts/contracts/RecoveryController.sol]

### Inheritance

The Controller account must inherit EmailAccountRecovery.sol.

```solidity
contract RecoveryController is OwnableUpgradeable, EmailAccountRecovery {
```

### GuardianStatus

Implement the status of the Guardian to execute Account Recovery.

```solidity
enum GuardianStatus {
    NONE,
    REQUESTED,
    ACCEPTED
}
```

### Mapping

Implement the following mapping.

```
    mapping(address => bool) public isRecovering; // Whether the account address is being recovered
    mapping(address => address) public newSignerCandidateOfAccount; // The new signer candidate of the account address
    mapping(address => GuardianStatus) public guardians; // The status of the guardian of the account address
    mapping(address => uint) public timelockPeriodOfAccount; // The timelock period of the account address
    mapping(address => uint) public currentTimelockOfAccount; // The current timelock of the account address
```

### acceptanceSubjectTemplates()

Define the subject of the email when the guardian requests.

```solidity
function acceptanceSubjectTemplates()
    public
    pure
    override
    returns (string[][] memory)
{
    string[][] memory templates = new string[][](1);
    templates[0] = new string[](5);
    templates[0][0] = "Accept";
    templates[0][1] = "guardian";
    templates[0][2] = "request";
    templates[0][3] = "for";
    templates[0][4] = "{ethAddr}";
    return templates;
}
```

### recoverySubjectTemplates()

Define the subject of the email when the recovery is executed.

```solidity
function recoverySubjectTemplates()
    public
    pure
    override
    returns (string[][] memory)
{
    string[][] memory templates = new string[][](1);
    templates[0] = new string[](8);
    templates[0][0] = "Set";
    templates[0][1] = "the";
    templates[0][2] = "new";
    templates[0][3] = "signer";
    templates[0][4] = "of";
    templates[0][5] = "{ethAddr}";
    templates[0][6] = "to";
    templates[0][7] = "{ethAddr}";
    return templates;
}
```

### extractRecoveredAccountFromAcceptanceSubject(bytes[] memory subjectParams, uint templateIdx)

Implement a method to return the account address to be recovered from AcceptanceSubject.
The account address to be recovered is stored in `templates[0][4]` in the implementation of `acceptanceSubjectTemplates`.
This is the first element of `subjectParams`, so return `subjectParams[0]`.

```solidity
function extractRecoveredAccountFromAcceptanceSubject(
    bytes[] memory subjectParams,
    uint templateIdx
) public pure override returns (address) {
    require(templateIdx == 0, "invalid template index");
    require(subjectParams.length == 1, "invalid subject params");
    return abi.decode(subjectParams[0], (address));
}
```

### extractRecoveredAccountFromRecoverySubject(bytes[] memory subjectParams, uint templateIdx)

Implement a method to return the account address to be recovered from RecoverySubject.
The account address to be recovered is stored in `templates[0][6]` in the implementation of `recoverySubjectTemplates`.
This is the first element of `subjectParams`, so return `subjectParams[0]`.

```solidity
function extractRecoveredAccountFromRecoverySubject(
    bytes[] memory subjectParams,
    uint templateIdx
) public pure override returns (address) {
    require(templateIdx == 0, "invalid template index");
    require(subjectParams.length == 2, "invalid subject params");
    return abi.decode(subjectParams[0], (address));
}
```

### acceptGuardian(address guardian, uint templateIdx, bytes[] memory subjectParams, bytes32)

Implement a method to accept the guardian.
If AcceptanceSubject is used, the account address to be recovered is stored in `subjectParams[0]`.
This address must not be in `isRecovering`.
Next, check if the guardian is in the `REQUESTED` status.
Finally, change the status of the guardian to `ACCEPTED`.

```solidity
function acceptGuardian(
    address guardian,
    uint templateIdx,
    bytes[] memory subjectParams,
    bytes32
) internal override {
    address account = abi.decode(subjectParams[0], (address));
    require(!isRecovering[account], "recovery in progress");
    require(guardian != address(0), "invalid guardian");

    require(
        guardians[guardian] == GuardianStatus.REQUESTED,
        "guardian status must be REQUESTED"
    );
    require(templateIdx == 0, "invalid template index");
    require(subjectParams.length == 1, "invalid subject params");
    guardians[guardian] = GuardianStatus.ACCEPTED;
}
```

### processRecovery(address guardian, uint templateIdx, bytes[] memory subjectParams, bytes32)

Implement a method to execute recovery.
If RecoverySubject is used, the new signer is stored in `subjectParams[1]`.
`subjectParams[0]` is the account address to be recovered.
Check if this address is not in `isRecovering`.
Next, check if the guardian is in the `ACCEPTED` status.
Finally, set `isRecovering` to true and update `newSignerCandidateOfAccount` and `currentTimelockOfAccount`.

```solidity
function processRecovery(
    address guardian,
    uint templateIdx,
    bytes[] memory subjectParams,
    bytes32
) internal override {
    address account = abi.decode(subjectParams[0], (address));
    require(!isRecovering[account], "recovery in progress");
    require(guardian != address(0), "invalid guardian");
    require(
        guardians[guardian] == GuardianStatus.ACCEPTED,
        "guardian status must be ACCEPTED"
    );
    require(templateIdx == 0, "invalid template index");
    require(subjectParams.length == 2, "invalid subject params");
    address newSignerInEmail = abi.decode(subjectParams[1], (address));
    require(newSignerInEmail != address(0), "invalid new signer");
    isRecovering[account] = true;
    newSignerCandidateOfAccount[account] = newSignerInEmail;
    currentTimelockOfAccount[account] =
        block.timestamp +
        timelockPeriodOfAccount[account];
}
```

### completeRecovery(address account, bytes memory recoveryCalldata)

Implement a method to complete recovery.
Check if this address is being recovered.
Next, check if the timelock is not expired.
Finally, set `isRecovering` to false and update `newSignerCandidateOfAccount` and `currentTimelockOfAccount`.
Then, call `SimpleWallet.changeOwner` to change the owner to the new signer.

```solidity
function completeRecovery(
    address account,
    bytes memory recoveryCalldata
) public override {
    require(account != address(0), "invalid account");
    require(isRecovering[account], "recovery not in progress");
    require(
        currentTimelockOfAccount[account] <= block.timestamp,
        "timelock not expired"
    );
    address newSigner = newSignerCandidateOfAccount[account];
    isRecovering[account] = false;
    currentTimelockOfAccount[account] = 0;
    newSignerCandidateOfAccount[account] = address(0);
    SimpleWallet(payable(account)).changeOwner(newSigner);
}
```

## Deploy to Base Sepolia

First, set the environment variables.
You should set the following environment variables to .env
Your `PRIVATE_KEY` needs some gas fees to deploy.

```sh
cp .env.example .env
```

Then, set the following environment variables to .env

```sh
PRIVATE_KEY= # Your private key with 0x prefix
ETHERSCAN_API_KEY= # Your Basescan API key
```

After that, deploy the contract by running the following command.

```sh
source .env
forge script script/DeployRecoveryController.s.sol:Deploy --rpc-url $SEPOLIA_RPC_URL --chain-id $CHAIN_ID --etherscan-api-key $ETHERSCAN_API_KEY --broadcast --verify -vvvv
```

That's all for the contracts side.

## Relayer API

Developers can use the relayer and prover we prepared for you.
Refer to the following API endpoint to send a request.

[relayer/README.md](../packages/relayer/README.md)
