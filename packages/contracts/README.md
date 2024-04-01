## Set up

```bash
yarn install
```

## Requirements
- Newer than or equal to `forge 0.2.0 (b174c3a)`.

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

Before running integration tests, you need to make a `packages/contracts/test/build_integration` directory, download the zip file from the following link, and place its unziped files under that directory.
https://drive.google.com/file/d/1TUMhCp1cGqxQLZPQIwAcx4qMEJ5PkEjm/view?usp=sharing

Run each integration tests **one by one** as each test will consume lot of memory.
```bash
Eg: forge test --match-test 'testIntegration_Account_Recovery' -vvv --ffi
```
#### Deploy Common Contracts.
You need to deploy common contracts, i.e., `ECDSAOwnedDKIMRegistry`, `Verifier`, and implementations of `EmailAuth` and `SimpleWallet`, only once before deploying each wallet.
1. `cp .env.sample .env`. 
2. Write your private key in hex to the `PRIVATE_KEY` field in `.env`.
3. `source .env`
4. `forge script script/DeployCommons.s.sol:Deploy --rpc-url $RPC_URL --chain-id $CHAIN_ID --broadcast -vvvv`

#### Deploy Each Wallet.
After deploying common contracts, you can deploy a proxy contract of `SimpleWallet`.
1. Check that the env values of `DKIM`, `VERIFIER`, `EMAIL_AUTH_IMPL`, and `SIMPLE_WALLET_IMPL` are the same as those output by the `DeployCommons.s.sol` script.
2. `forge script script/DeploySimpleWallet.s.sol:Deploy --rpc-url $RPC_URL --chain-id $CHAIN_ID --broadcast -vvvv` 