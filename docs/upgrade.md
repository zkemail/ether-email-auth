# Upgrading Contracts

Sometimes, we need to fix problems in our smart contracts. We can do this by upgrading contracts that use ERC1967Proxy. Here's how to do it:

## Upgrading the Verifier

1. Change the code in this file:
   `packages/contracts/src/utils/Verifier.sol`

2. Add this to your `.env` file:
   ```
   VERIFIER={DEPLOYED_VERIFIER_PROXY_ADDRESS}
   ```

3. Run this command:
   ```
   source .env
   forge script script/Upgrades.s.sol:Upgrades --rpc-url $RPC_URL --chain-id $CHAIN_ID --etherscan-api-key $ETHERSCAN_API_KEY --broadcast --verify -vvvv
   ```

## Upgrading Other Contracts

You can also upgrade ECDSAOwnedDKIMRegistry and UserOverrideableDKIMRegistry:

### For ECDSAOwnedDKIMRegistry:
1. Change the code in:
   `packages/contracts/src/utils/ECDSAOwnedDKIMRegistry.sol`

2. Add to `.env`:
   ```
   ECDSA_DKIM={DEPLOYED_ECDSA_DKIM_PROXY_ADDRESS}
   ```

### For UserOverrideableDKIMRegistry:
1. Change the code in:
   `@zk-email/contracts/UserOverrideableDKIMRegistry.sol`

2. Add to `.env`:
   ```
   DKIM={DEPLOYED_USEROVERRIDEABLE_DKIM_PROXY_ADDRESS}
   ```

Remember to be careful when changing these contracts. Always test your changes before using them.
