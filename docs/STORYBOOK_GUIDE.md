# Logistico UI Component Library - Storybook Guide

## Quick Start

```bash
# Install dependencies
npm install

# Run Storybook development server
npm run storybook

# Build static Storybook
npm run build-storybook

# Run interaction tests
npm run test-storybook
```

Storybook will be available at `http://localhost:6006`

---

## Component Library

### Core Components

#### Button
**Location:** `components/Button.tsx`  
**Stories:** `stories/Button.stories.tsx`

Multi-variant button component with loading states and accessibility support.

**Props:**
- `variant`: 'primary' | 'secondary' | 'outline' | 'danger' | 'success'
- `size`: 'sm' | 'md' | 'lg'
- `disabled`: boolean
- `loading`: boolean
- `fullWidth`: boolean
- `onClick`: () => void

**Usage:**
```tsx
<Button variant="primary" size="md" onClick={handleClick}>
  Purchase Service
</Button>

<Button variant="danger" loading={isDeleting}>
  Delete
</Button>
```

**Stories Available:**
- Primary, Secondary, Outline, Danger, Success variants
- Small, Medium, Large sizes
- Disabled and Loading states
- Full width option
- All variants showcase
- All sizes comparison

---

#### Card
**Location:** `components/Card.tsx`  
**Stories:** `stories/Card.stories.tsx`

Flexible container component with header, footer, and multiple style variants.

**Props:**
- `variant`: 'default' | 'bordered' | 'elevated' | 'flat'
- `padding`: 'none' | 'sm' | 'md' | 'lg'
- `title`: string (optional)
- `subtitle`: string (optional)
- `footer`: ReactNode (optional)
- `hoverable`: boolean
- `onClick`: () => void

**Usage:**
```tsx
<Card
  title="Service Details"
  subtitle="Web Development"
  variant="elevated"
  hoverable
  footer={<Button>Purchase</Button>}
>
  Professional web development services...
</Card>
```

**Stories Available:**
- Default, Bordered, Elevated, Flat variants
- With/without footer
- Hoverable and Clickable states
- Different padding sizes
- Service card example
- Grid layout showcase

---

### Marketplace Components

#### ServiceCard
**Location:** `components/ServiceCard.tsx`  
**Stories:** `stories/ServiceCard.stories.tsx`

Specialized card for displaying marketplace service listings.

**Props:**
- `title`: string - Service name
- `description`: string - Service description
- `category`: string - Service category
- `price`: string - Price in ETH
- `provider`: string - Provider address
- `rating`: number (0-5) - Average rating
- `reviewCount`: number - Number of reviews
- `deliveryTime`: string - Estimated delivery
- `scope`: 'global' | 'regional' | 'local'
- `imageUrl`: string (optional)
- `availableZones`: string[] (optional)
- `onPurchase`: () => void
- `onViewDetails`: () => void

**Usage:**
```tsx
<ServiceCard
  title="Professional Logo Design"
  description="High-quality logo design with unlimited revisions"
  category="Graphic Design"
  price="0.5"
  provider="0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb0"
  rating={4.8}
  reviewCount={127}
  deliveryTime="48h delivery"
  scope="global"
  imageUrl="/services/logo-design.jpg"
  onPurchase={handlePurchase}
  onViewDetails={handleViewDetails}
/>
```

**Features:**
- Displays provider ratings with star visualization
- Shows scope badge (global/regional/local)
- Available zones for regional/local services
- Responsive image handling
- Truncates long descriptions
- Address formatting for provider

**Stories Available:**
- Global, Regional, Local services
- With/without ratings
- With/without images
- High/low price examples
- Grid layout showcase
- Responsive viewport testing
- Interactive purchase flows

---

### Reputation Components

#### RatingDisplay
**Location:** `components/RatingDisplay.tsx`  
**Stories:** `stories/RatingDisplay.stories.tsx`

Displays star ratings with optional numeric value and review count.

**Props:**
- `rating`: number (0-5) - Rating value
- `reviewCount`: number (optional) - Number of reviews
- `size`: 'sm' | 'md' | 'lg'
- `showNumeric`: boolean - Show rating number
- `interactive`: boolean - Enable rating selection
- `onChange`: (rating: number) => void

**Usage:**
```tsx
// Display only
<RatingDisplay rating={4.5} reviewCount={127} size="md" />

// Interactive rating input
<RatingDisplay
  rating={userRating}
  interactive={true}
  onChange={setUserRating}
/>
```

**Features:**
- Partial star rendering (e.g., 4.3 shows 4.3/5 stars)
- Hover effects for interactive mode
- Configurable sizes
- Optional review count display
- Accessible star icons

**Stories Available:**
- Various rating values (0-5)
- All size variations
- With/without numeric display
- With/without review count
- Interactive mode
- Complete rating scale showcase

---

#### ReputationBadge
**Location:** `components/ReputationBadge.tsx`  
**Stories:** `stories/ReputationBadge.stories.tsx`

Displays provider reputation badge based on achievements.

**Props:**
- `level`: 'verified' | 'trusted' | 'elite' | 'legendary' | 'none'
- `size`: 'sm' | 'md' | 'lg'
- `showLabel`: boolean - Show badge text

**Badge Levels:**
- **Verified Seller** (✓) - 5 orders, 0.1 ETH volume, 3.5+ rating
- **Trusted Provider** (★) - 25 orders, 1 ETH volume, 4.0+ rating
- **Elite Professional** (◆) - 100 orders, 10 ETH volume, 4.5+ rating
- **Legendary Seller** (♔) - 500 orders, 100 ETH volume, 4.75+ rating

**Usage:**
```tsx
<ReputationBadge level="elite" size="md" showLabel={true} />

// Icon only
<ReputationBadge level="trusted" showLabel={false} />
```

**Stories Available:**
- All badge levels
- All sizes
- Icon-only mode
- Badge progression visualization
- Inline with text examples
- Card integration example

---

## Testing & Accessibility

### Interaction Tests

The Storybook test runner automatically runs interaction tests on all stories. Tests verify:
- Component rendering
- Click handlers
- State changes
- User interactions

**Run tests:**
```bash
npm run test-storybook
```

### Accessibility Checks

All stories are automatically tested for accessibility using axe-playwright:
- ARIA attributes
- Color contrast
- Keyboard navigation
- Screen reader support
- Semantic HTML

**Accessibility rules checked:**
- WCAG 2.1 Level AA compliance
- Color contrast ratios
- Focus indicators
- Label associations
- Heading hierarchy

---

## Storybook Addons

### Configured Addons

1. **Essentials** - Core functionality
   - Controls: Interactive props editing
   - Actions: Event handler logging
   - Docs: Auto-generated documentation
   - Viewport: Responsive testing
   - Backgrounds: Background color switching

2. **A11y** - Accessibility testing
   - Real-time accessibility violations
   - WCAG compliance checking
   - Color contrast analysis

3. **Interactions** - User flow testing
   - Test user interactions
   - Verify component behavior
   - Debug interaction sequences

### Using Addons

**Controls Panel:**
Adjust component props in real-time without code changes.

**Actions Panel:**
View event handler calls and payloads.

**Viewport Toolbar:**
Test components at different screen sizes:
- Mobile (375px)
- Tablet (768px)
- Desktop (1440px)

**Backgrounds Toolbar:**
Test component appearance on different backgrounds:
- Light (white)
- Dark (#1a1a1a)
- Gray (#f5f5f5)

**Accessibility Tab:**
View and fix accessibility violations in real-time.

---

## Development Workflow

### Creating New Components

1. **Create component file:**
   ```tsx
   // components/MyComponent.tsx
   export interface MyComponentProps {
     // Define props with JSDoc comments
   }
   
   export const MyComponent: React.FC<MyComponentProps> = ({...}) => {
     // Implementation
   };
   ```

2. **Create stories file:**
   ```tsx
   // stories/MyComponent.stories.tsx
   import type { Meta, StoryObj } from '@storybook/react';
   import { MyComponent } from '../components/MyComponent';
   
   const meta = {
     title: 'Category/MyComponent',
     component: MyComponent,
     tags: ['autodocs'],
   } satisfies Meta<typeof MyComponent>;
   
   export default meta;
   type Story = StoryObj<typeof meta>;
   
   export const Default: Story = {
     args: {
       // Default props
     },
   };
   ```

3. **Run Storybook:**
   ```bash
   npm run storybook
   ```

4. **Iterate and test:**
   - Adjust props using Controls
   - Test interactions
   - Check accessibility
   - Verify responsive behavior

### Best Practices

**Component Design:**
- Keep components focused and reusable
- Use TypeScript for type safety
- Document props with JSDoc comments
- Support different sizes and variants
- Include disabled/loading states

**Story Organization:**
- Group related stories by category
- Create stories for each variant
- Include edge cases (empty, loading, error)
- Add interactive examples
- Showcase responsive behavior

**Accessibility:**
- Use semantic HTML elements
- Include ARIA labels where needed
- Ensure keyboard navigation
- Test with screen readers
- Maintain color contrast ratios

**Testing:**
- Add interaction tests for user flows
- Test error states
- Verify loading states
- Check responsive breakpoints

---

## File Structure

```
code/
├── .storybook/
│   ├── main.ts              # Storybook configuration
│   ├── preview.tsx          # Global settings & decorators
│   └── test-runner.ts       # Test configuration
├── components/
│   ├── Button.tsx           # Core components
│   ├── Card.tsx
│   ├── ServiceCard.tsx      # Marketplace components
│   ├── RatingDisplay.tsx    # Reputation components
│   └── ReputationBadge.tsx
├── stories/
│   ├── Button.stories.tsx   # Component stories
│   ├── Card.stories.tsx
│   ├── ServiceCard.stories.tsx
│   ├── RatingDisplay.stories.tsx
│   └── ReputationBadge.stories.tsx
├── package.json             # Dependencies
└── tailwind.config.ts       # Tailwind configuration
```

---

## Component Categories

### Core
Basic UI building blocks used across the application.
- Button
- Card

### Marketplace
Service listing and transaction components.
- ServiceCard

### Reputation
Provider trust and rating components.
- RatingDisplay
- ReputationBadge

---

## Next Steps

**Planned Components:**
- OrderFlow - Multi-step order process
- DisputeResolution - Dispute handling UI
- ProviderProfile - Provider profile cards
- SearchFilters - Service search and filtering
- TransactionHistory - Order history display
- WalletConnect - Web3 wallet integration

**Enhancements:**
- Dark mode support
- Animation system
- Form components
- Modal dialogs
- Toast notifications
- Loading skeletons

---

## Troubleshooting

**Storybook won't start:**
```bash
# Clear cache and reinstall
rm -rf node_modules package-lock.json
npm install
npm run storybook
```

**Stories not appearing:**
- Check file naming: `*.stories.tsx`
- Verify story is exported
- Check Storybook config paths in `main.ts`

**Type errors:**
```bash
# Regenerate TypeScript types
npm run build-storybook
```

**Accessibility violations:**
- Check the A11y addon panel
- Fix violations in order of severity
- Run test suite to verify fixes

---

## Resources

- [Storybook Documentation](https://storybook.js.org/docs/react/get-started/introduction)
- [Storybook Best Practices](https://storybook.js.org/docs/react/writing-stories/introduction)
- [Accessibility Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [Component Driven Development](https://www.componentdriven.org/)

---

**Version:** 1.0.0  
**Last Updated:** 2024-01-16
