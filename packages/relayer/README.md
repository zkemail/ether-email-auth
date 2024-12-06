# Generic Relayer

## Build

make sure to build the contracts before building the relayer

```
cd ../contracts
yarn && yarn build
```

cd back into the relayer and build it

```
cargo build
```

## Setup the local development environment

cd into the root directory and run

```
docker compose up --build
```

This will build the docker images for the node, bundler, scanner, smtp, and imap services.

## Applying the migrations

```
cd packages/relayer
DATABASE_URL=postgres://relayer:relayer_password@localhost:5432/relayer sqlx migrate run
```
