# Logistics vSaaS – Multi-Tenant Agent Logistics Platform

Logistics-as-a-Service where **Laborers** (Bikes, Drones, or AI Bots) and **Orders** are ERC-721 NFTs with **ERC-6551 Token Bound Accounts (TBA)**. The system is multi-tenant: a Factory deploys isolated Logistics Zones per company. Autonomous agents can accept orders and accrue **Job Soulbound Tokens (SBTs)** as verifiable reputation.

## Architecture (Turborepo)

| Path | Stack | Role |
|------|-------|------|
| `packages/contracts` | Foundry (Solidity) | Factory, Zone, LaborerNFT, OrderNFT, JobSBT, ERC-6551 |
| `packages/shared` | TypeScript | Shared types and ABI definitions |
| `apps/api` | Phoenix (Elixir) | Multi-tenant API, Agent API, real-time indexer |
| `apps/web` | SolidJS | Dashboard for fleet managers and customers |

## Smart Contracts

- **LogisticsFactory**: Uses OpenZeppelin `Clones` (ERC-1167) to deploy tenant-specific `LogisticsZone` instances.
- **LogisticsZone**: Manages `LaborerNFT`, `OrderNFT`, and `JobSBT`; emits `JobStarted`, `JobAttested`, `JobCompleted` for indexing.
- **LaborerNFT** / **OrderNFT**: ERC-721 with TBA per token; Laborer supports `zk_proof_commitment` for Personhood/Bot certification.
- **JobSBT**: Non-transferable tokens minted to a Laborer's TBA on order completion.

### Build & Test (Contracts)

```bash
cd packages/contracts
forge build
forge test
```

## Backend (Phoenix)

- **Tenant resolution**: `ApiWeb.Plugs.TenantResolver` resolves tenant from subdomain (e.g. `agency1.vsaas.io`) and assigns `tenant_id` and `zone_address`.
- **Agent API** (REST):  
  - `GET /api/agent/orders` – available orders in the zone  
  - `POST /api/agent/proof` – submit proof of work / ZK proof  
  - `GET /api/agent/zone` – zone info (for TBA/ERC-4337 relayers)
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

## UI Development (Storybook)

### Overview

Logistico includes a comprehensive **Storybook** setup for developing and testing UI components in isolation. This allows you to:

- Build and test components without running the full blockchain/backend stack
- Verify all component states and variants instantly
- Ensure accessibility compliance (WCAG 2.1 AA)
- Share components with designers and stakeholders
- Test responsive layouts across viewports

### Quick Start

```bash
# Install dependencies
npm install

# Run Storybook (opens at http://localhost:6006)
npm run storybook

# Build static Storybook for deployment
npm run build-storybook

# Run automated tests (interactions + accessibility)
npm run test-storybook
```

### Component Library

#### Core Components

**Button** (`Button.tsx` + `Button.stories.tsx`)
- 5 variants: primary, secondary, outline, danger, success
- 3 sizes: sm, md, lg
- States: default, loading, disabled, hover, active
- Features: full width, left/right icons
- 15+ interactive stories

**Card** (`Card.tsx` + `Card.stories.tsx`)
- 4 variants: default, bordered, elevated, flat
- Configurable padding: sm, md, lg, xl
- Optional header, footer, and content sections
- Interactive states: hoverable, clickable
- 12+ stories including nested layouts

#### Marketplace Components

**ServiceCard** (`ServiceCard.tsx` + `ServiceCard.stories.tsx`)
- Service listing display with images
- Integrated rating display
- Scope badges: global, regional, local
- Provider information and pricing
- Available zones list
- 12+ stories including grid layouts

#### Reputation Components

**RatingDisplay** (`RatingDisplay.tsx` + `RatingDisplay.stories.tsx`)
- Star ratings with partial fill support
- Interactive rating input mode
- 3 sizes: sm, md, lg
- Optional review count display
- 12+ stories covering all states

**ReputationBadge** (`ReputationBadge.tsx` + `ReputationBadge.stories.tsx`)
- 4 badge levels: verified, trusted, elite, legendary
- Icon + label or icon-only modes
- Badge progression visualizations
- 10+ stories for all badge types

### Storybook Configuration

**Main Configuration** (`main.ts`)
- Framework: React with Vite builder
- TypeScript support enabled
- Autodocs generation configured
- Stories location: `../src/**/*.stories.@(js|jsx|ts|tsx)`

**Preview Configuration** (`preview.tsx`)
- Global decorators: Tailwind CSS styling
- Viewport presets: mobile, tablet, desktop
- Background options: light, dark, brand colors
- Controls sorting and documentation

**Test Runner** (`test-runner.ts`)
- Automated interaction testing
- Accessibility checks (a11y addon)
- WCAG 2.1 AA compliance verification

**Tailwind Configuration** (`tailwind.config.ts`)
- Custom color palette matching Logistico brand
- Responsive breakpoints
- Extended spacing and typography
- Content paths configured for Storybook

### Addons Configured

- **@storybook/addon-essentials**: Controls, actions, docs, viewport, backgrounds
- **@storybook/addon-a11y**: Real-time accessibility testing
- **@storybook/addon-interactions**: User flow testing
- **@storybook/addon-links**: Navigate between related stories

### Design System

**Color Palette**
- Primary: Blue (#0ea5e9) - Main actions, links
- Success: Green (#22c55e) - Positive actions, confirmations
- Warning: Amber (#f59e0b) - Caution, alerts
- Error: Red (#ef4444) - Destructive actions, errors
- Neutral: Slate scale - Text, borders, backgrounds

**Typography**
- Font: Inter (system fallbacks: -apple-system, BlinkMacSystemFont, Segoe UI)
- Sizes: sm (0.875rem), base (1rem), lg (1.125rem), xl (1.25rem)
- Weights: 400 (normal), 500 (medium), 600 (semibold), 700 (bold)

**Spacing System**
- sm: 0.75rem (12px)
- md: 1rem (16px)
- lg: 1.5rem (24px)
- xl: 2rem (32px)

### Testing & Quality

**Automated Testing**
```bash
npm run test-storybook
```
- Runs interaction tests for all stories
- Verifies accessibility compliance
- Checks component states and user flows

**Accessibility**
- WCAG 2.1 AA compliance
- Color contrast validation
- Keyboard navigation support
- Screen reader compatibility
- Focus management

**Browser Testing**
- Chrome/Edge (Chromium)
- Firefox
- Safari
- Mobile browsers (iOS Safari, Chrome Android)

### Development Workflow

1. **Create Component**: Build your React component in `src/components/`
2. **Add Types**: Define TypeScript interfaces for props
3. **Write Stories**: Create `ComponentName.stories.tsx` with all variants
4. **Test Interactions**: Add play functions for user flow testing
5. **Verify Accessibility**: Use a11y addon to check WCAG compliance
6. **Document**: Add JSDoc comments for auto-generated docs

### File Structure

```
apps/web/
├── .storybook/
│   ├── main.ts              # Core Storybook config
│   ├── preview.tsx          # Global settings, decorators
│   ├── test-runner.ts       # Test configuration
│   └── tailwind.config.ts   # Tailwind for Storybook
├── src/
│   └── components/
│       ├── Button.tsx
│       ├── Button.stories.tsx
│       ├── Card.tsx
│       ├── Card.stories.tsx
│       ├── ServiceCard.tsx
│       ├── ServiceCard.stories.tsx
│       ├── RatingDisplay.tsx
│       ├── RatingDisplay.stories.tsx
│       ├── ReputationBadge.tsx
│       └── ReputationBadge.stories.tsx
└── package.json             # Storybook dependencies
```

### Best Practices

**Component Development**
- Build components in isolation first
- Test all states and variants
- Ensure accessibility from the start
- Document props with TypeScript + JSDoc

**Story Writing**
- Create a story for each significant variant
- Use args for interactive controls
- Add play functions for complex interactions
- Include edge cases and error states

**Accessibility**
- Use semantic HTML elements
- Provide ARIA labels where needed
- Ensure keyboard navigation works
- Test with screen readers
- Maintain color contrast ratios

### Documentation

For detailed Storybook usage, component APIs, and development guidelines, see:
- `docs/STORYBOOK_GUIDE.md` - Comprehensive Storybook documentation
- Component stories - Live examples with editable props
- Storybook Docs - Auto-generated from TypeScript interfaces

### Deployment

Build and deploy Storybook as a static site:

```bash
npm run build-storybook
```

The output in `storybook-static/` can be deployed to any static hosting service (Vercel, Netlify, GitHub Pages, etc.).

## Metadata & Identity

- **ZK-Identity**: Laborer TBAs support a `zk_proof_commitment` field (on-chain or metadata) to verify Personhood or Bot Certification without revealing underlying data.
- **Account Abstraction**: TBA funds can be managed via ERC-4337 relayers; the Agent API is designed to integrate with such relayers.

---

## Phase 2: Hardware

Future integration with edge hardware for offline-capable notarization and mesh connectivity:

- **nRF52840**: BLE/Thread SoC for low-power laborer devices
- **ESP32-S3**: WiFi/BLE module for mesh networks
- **Raspberry Pi**: Edge gateway for proof aggregation

---

## License

MIT