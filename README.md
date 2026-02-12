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

### Core Logistics System

- **LogisticsFactory**: Uses OpenZeppelin `Clones` (ERC-1167) to deploy tenant-specific `LogisticsZone` instances.
- **LogisticsZone**: Manages `LaborerNFT`, `OrderNFT`, and `JobSBT`; emits `JobStarted`, `JobAttested`, `JobCompleted` for indexing.
- **LaborerNFT** / **OrderNFT**: ERC-721 with TBA per token; Laborer supports `zk_proof_commitment` for Personhood/Bot certification.
- **JobSBT**: Non-transferable tokens minted to a Laborer's TBA on order completion.

### Global Marketplace (NEW)

- **ServiceMarketplace**: Enables service discovery beyond zone boundaries with three scopes:
  - `GLOBAL` — Services available worldwide (e.g., design, consulting, virtual work)
  - `REGIONAL` — Multi-zone services spanning geographic areas
  - `LOCAL` — Zone-specific services (backward compatible with existing system)
  
  Features: Escrow-based payments, platform fees (0-10%), delivery verification, order lifecycle management, and full compatibility with existing LogisticsZone contracts.

### Build & Test (Contracts)

```bash
cd packages/contracts
forge build
forge test

# Test ServiceMarketplace specifically
forge test --match-contract ServiceMarketplaceTest
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

- **nRF52840**: BLE/Thread SoC for low-power laborer tags
- **Raspberry Pi Zero 2 W**: Portable gateway node for offline mesh networks
- **Secure Element** (ATECC608B, SE050x): Secure key storage for TBA private keys