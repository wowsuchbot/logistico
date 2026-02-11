# Logistics Contracts (Foundry)

- **LogisticsFactory**: Deploys `LogisticsZone` clones via `Clones.cloneDeterministic`. Requires an ERC-6551 registry and TBA implementation address.
- **LogisticsZone**: One per tenant. Owns LaborerNFT, OrderNFT, JobSBT. Emits `JobStarted`, `JobAttested`, `JobCompleted` for the Phoenix indexer.
- **LaborerNFT** / **OrderNFT**: ERC-721 with TBA per token; Laborer has `zkProofCommitment` for ZK-identity.
- **JobSBT**: Soulbound; minted to Laborer TBA on job completion.

## Deploy

1. Deploy an ERC-6551 registry and TBA implementation (e.g. [tokenbound/contracts](https://github.com/tokenbound/contracts)).
2. Deploy `LogisticsFactory` with `(registry, tbaImplementation, chainId)`.
3. Call `deployZone(zoneId, tenantId, salt)` per tenant; `zoneId` can be `keccak256(abi.encode(tenantId))`.
