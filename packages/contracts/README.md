## Set up

```bash
yarn install
```

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
https://drive.google.com/file/d/14J9Dhu3sJ_hd19HiVUeN3DHnlCqcrDPh/view?usp=sharing

Run each integration tests **one by one** as each test will consume lot of memory.
```bash
Eg: forge test --match-test 'testIntegration_Account_Recovery' -vvv --ffi
```
