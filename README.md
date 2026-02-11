# Logistics vSaaS — Multi-Tenant Agent Logistics Platform

Logistics-as-a-Service where **Laborers** (Bikes, Drones, or AI Bots) and **Orders** are ERC-721 NFTs with **ERC-6551 Token Bound Accounts (TBA)**. The system is multi-tenant: a Factory deploys isolated Logistics Zones per company. Autonomous agents can accept orders and accrue **Job Soulbound Tokens (SBTs)** as verifiable reputation.

## Architecture (Turborepo)

| Path | Stack | Role |
|------|--------|------|
| `packages/contracts` | Foundry (Solidity) | Factory, Zone, LaborerNFT, OrderNFT, JobSBT, ERC-6551 |
| `packages/shared` | TypeScript | Shared types and ABI definitions |
| `apps/api` | Phoenix (Elixir) | Multi-tenant API, Agent API, real-time indexer |
| `apps/web` | SolidJS | Dashboard for fleet managers and customers |

## Smart Contracts

- **LogisticsFactory**: Uses OpenZeppelin `Clones` (ERC-1167) to deploy tenant-specific `LogisticsZone` instances.
- **LogisticsZone**: Manages `LaborerNFT`, `OrderNFT`, and `JobSBT`; emits `JobStarted`, `JobAttested`, `JobCompleted` for indexing.
- **LaborerNFT** / **OrderNFT**: ERC-721 with TBA per token; Laborer supports `zk_proof_commitment` for Personhood/Bot certification.
- **JobSBT**: Non-transferable tokens minted to a Laborer’s TBA on order completion.

### Build & Test (Contracts)

```bash
cd packages/contracts
forge build
forge test
```

## Backend (Phoenix)

- **Tenant resolution**: `ApiWeb.Plugs.TenantResolver` resolves tenant from subdomain (e.g. `agency1.vsaas.io`) and assigns `tenant_id` and `zone_address`.
- **Agent API** (REST):  
  - `GET /api/agent/orders` — available orders in the zone  
  - `POST /api/agent/proof` — submit proof of work / ZK proof  
  - `GET /api/agent/zone` — zone info (for TBA/ERC-4337 relayers)
- **Real-time indexer**: `Api.JobWatcher.Supervisor` runs one `JobWatcher` GenServer per LogisticsZone address; each watcher polls chain events and broadcasts to Phoenix PubSub. Subscribe via WebSocket channel `zone:{zone_address}`.

### Run API

```bash
cd apps/api
mix deps.get
mix phx.server
```

Configure `RPC_URL`, `FACTORY_ADDRESS`, and (optional) `TENANT_DOMAIN_SUFFIX` via env or `config/runtime.exs`. Add zones with `Api.JobWatcher.Supervisor.start_child(zone_address, tenant_id: "agency1")`.

## Frontend (SolidJS)

High-performance dashboard for fleet and customers. Uses `@logistics/shared` for types.

```bash
cd apps/web
npm install
npm run dev
```

## Metadata & Identity

- **ZK-Identity**: Laborer TBAs support a `zk_proof_commitment` field (on-chain or metadata) to verify Personhood or Bot Certification without revealing underlying data.
- **Account Abstraction**: TBA funds can be managed via ERC-4337 relayers; the Agent API is designed to integrate with such relayers.

---

## Phase 2: Hardware

Future integration with edge hardware for offline-capable notarization and mesh connectivity:

- **nRF52840**: BLE/Thread SoC for low-power laborer devices (bikes, drones, lockers). Firmware can sign attestations or collect sensor data; commitments can be submitted when back online.
- **LoRa mesh**: Long-range, low-bandwidth mesh for fleet units in areas with poor cellular coverage. Offline job completion proofs can be stored locally and notarized in batch when a gateway is reached.
- **Offline notarization**: Devices sign job completion payloads (order id, laborer id, nonce, hash). API accepts these with a “pending notarization” state; a background job or relay submits them on-chain when RPC is available, then updates indexer state and PubSub.

Suggested layout for a future `packages/firmware` or `apps/edge` repo:

- nRF52840: Zephyr or nRF Connect SDK; BLE GATT service for job ids and signing requests; secure storage for keys.
- LoRa: LoRaWAN or custom mesh stack; minimal payload (order + laborer ids + signature); gateway service that buffers and forwards to API/chain.

This keeps the current codebase focused on API and contracts while documenting the path to hardware-backed, offline-first attestations.

---

## Monorepo Commands

From repo root:

- `npm run build` — build all packages/apps  
- `npm run dev` — run dev for all (Turbo)  
- `npm run test` — run tests  
- `npm run lint` — lint
