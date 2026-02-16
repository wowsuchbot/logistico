import type { Meta, StoryObj } from '@storybook/react';
import { ServiceCard } from '../components/ServiceCard';
import { fn } from '@storybook/test';

const meta = {
  title: 'Marketplace/ServiceCard',
  component: ServiceCard,
  parameters: {
    layout: 'padded',
  },
  tags: ['autodocs'],
  argTypes: {
    scope: {
      control: 'select',
      options: ['global', 'regional', 'local'],
      description: 'Service availability scope',
    },
    rating: {
      control: { type: 'range', min: 0, max: 5, step: 0.1 },
      description: 'Provider rating (0-5 stars)',
    },
  },
  args: { 
    onPurchase: fn(),
    onViewDetails: fn(),
  },
} satisfies Meta<typeof ServiceCard>;

export default meta;
type Story = StoryObj<typeof meta>;

export const GlobalService: Story = {
  args: {
    title: 'Professional Logo Design',
    description: 'High-quality logo design with unlimited revisions. Includes source files and brand guidelines.',
    category: 'Graphic Design',
    price: '0.5',
    provider: '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb0',
    rating: 4.8,
    reviewCount: 127,
    deliveryTime: '48h delivery',
    scope: 'global',
    imageUrl: 'https://via.placeholder.com/400x200/0ea5e9/ffffff?text=Logo+Design',
  },
};

export const RegionalService: Story = {
  args: {
    title: 'Local Delivery Service',
    description: 'Fast and reliable package delivery within the EU region. Same-day delivery available.',
    category: 'Logistics',
    price: '0.05',
    provider: '0x8ba1f109551bD432803012645Ac136ddd64DBA72',
    rating: 4.5,
    reviewCount: 89,
    deliveryTime: '24h delivery',
    scope: 'regional',
    availableZones: ['EU-WEST', 'EU-NORTH', 'EU-CENTRAL'],
    imageUrl: 'https://via.placeholder.com/400x200/22c55e/ffffff?text=Delivery+Service',
  },
};

export const LocalService: Story = {
  args: {
    title: 'NYC Photography Session',
    description: 'Professional photography services in New York City. Portrait, event, and commercial photography.',
    category: 'Photography',
    price: '0.3',
    provider: '0x1234567890123456789012345678901234567890',
    rating: 5.0,
    reviewCount: 42,
    deliveryTime: 'Flexible',
    scope: 'local',
    availableZones: ['NYC-MANHATTAN', 'NYC-BROOKLYN'],
    imageUrl: 'https://via.placeholder.com/400x200/a855f7/ffffff?text=Photography',
  },
};

export const NoRating: Story = {
  args: {
    title: 'New Service - Web Development',
    description: 'Full-stack web development using React, Node.js, and modern frameworks.',
    category: 'Software Development',
    price: '2.0',
    provider: '0xabcdef1234567890abcdef1234567890abcdef12',
    rating: 0,
    reviewCount: 0,
    deliveryTime: '1 week',
    scope: 'global',
  },
};

export const NoImage: Story = {
  args: {
    title: 'Content Writing Services',
    description: 'Professional content writing for blogs, websites, and marketing materials. SEO optimized.',
    category: 'Writing',
    price: '0.1',
    provider: '0x9876543210987654321098765432109876543210',
    rating: 4.3,
    reviewCount: 56,
    deliveryTime: '2-3 days',
    scope: 'global',
  },
};

export const HighPrice: Story = {
  args: {
    title: 'Enterprise Consulting Package',
    description: 'Comprehensive business consulting including strategy, operations, and digital transformation.',
    category: 'Consulting',
    price: '10.0',
    provider: '0x1111111111111111111111111111111111111111',
    rating: 4.9,
    reviewCount: 23,
    deliveryTime: '1 month',
    scope: 'global',
    imageUrl: 'https://via.placeholder.com/400x200/6366f1/ffffff?text=Consulting',
  },
};

export const LowPrice: Story = {
  args: {
    title: 'Quick Logo Sketch',
    description: 'Simple logo sketch for early-stage startups. Basic design concepts only.',
    category: 'Design',
    price: '0.01',
    provider: '0x2222222222222222222222222222222222222222',
    rating: 3.8,
    reviewCount: 145,
    deliveryTime: '24h',
    scope: 'global',
  },
};

export const ServiceGrid: Story = {
  render: () => (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <ServiceCard
        title="Logo Design Pro"
        description="Professional branding and logo design services"
        category="Design"
        price="0.5"
        provider="0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb0"
        rating={4.8}
        reviewCount={127}
        deliveryTime="48h"
        scope="global"
        imageUrl="https://via.placeholder.com/400x200/0ea5e9/ffffff?text=Design"
        onPurchase={fn()}
        onViewDetails={fn()}
      />
      <ServiceCard
        title="Web Development"
        description="Full-stack development with modern technologies"
        category="Development"
        price="2.0"
        provider="0x8ba1f109551bD432803012645Ac136ddd64DBA72"
        rating={4.9}
        reviewCount={89}
        deliveryTime="1 week"
        scope="global"
        imageUrl="https://via.placeholder.com/400x200/22c55e/ffffff?text=Development"
        onPurchase={fn()}
        onViewDetails={fn()}
      />
      <ServiceCard
        title="Content Writing"
        description="SEO-optimized content for your business"
        category="Writing"
        price="0.15"
        provider="0x1234567890123456789012345678901234567890"
        rating={4.5}
        reviewCount={234}
        deliveryTime="2-3 days"
        scope="global"
        imageUrl="https://via.placeholder.com/400x200/a855f7/ffffff?text=Writing"
        onPurchase={fn()}
        onViewDetails={fn()}
      />
      <ServiceCard
        title="Video Editing"
        description="Professional video editing and post-production"
        category="Media"
        price="0.8"
        provider="0xabcdef1234567890abcdef1234567890abcdef12"
        rating={4.7}
        reviewCount={156}
        deliveryTime="3-5 days"
        scope="global"
        imageUrl="https://via.placeholder.com/400x200/f59e0b/ffffff?text=Video"
        onPurchase={fn()}
        onViewDetails={fn()}
      />
      <ServiceCard
        title="Social Media Management"
        description="Complete social media strategy and management"
        category="Marketing"
        price="1.2"
        provider="0x9876543210987654321098765432109876543210"
        rating={4.6}
        reviewCount={78}
        deliveryTime="Ongoing"
        scope="global"
        imageUrl="https://via.placeholder.com/400x200/ef4444/ffffff?text=Social"
        onPurchase={fn()}
        onViewDetails={fn()}
      />
      <ServiceCard
        title="SEO Optimization"
        description="Boost your website ranking with proven SEO strategies"
        category="Marketing"
        price="0.6"
        provider="0x1111111111111111111111111111111111111111"
        rating={4.4}
        reviewCount={192}
        deliveryTime="1-2 weeks"
        scope="global"
        imageUrl="https://via.placeholder.com/400x200/14b8a6/ffffff?text=SEO"
        onPurchase={fn()}
        onViewDetails={fn()}
      />
    </div>
  ),
};

export const WithInteraction: Story = {
  args: {
    title: 'Interactive Service',
    description: 'Click the buttons to test interactions',
    category: 'Testing',
    price: '0.5',
    provider: '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb0',
    rating: 4.5,
    reviewCount: 50,
    deliveryTime: '24h',
    scope: 'global',
  },
  play: async ({ canvasElement }) => {
    // This will be used for interaction testing
  },
};

export const ResponsiveView: Story = {
  args: {
    title: 'Responsive Service Card',
    description: 'This card adapts to different screen sizes. Try changing the viewport!',
    category: 'UI/UX',
    price: '0.75',
    provider: '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb0',
    rating: 4.7,
    reviewCount: 99,
    deliveryTime: '48h',
    scope: 'global',
    imageUrl: 'https://via.placeholder.com/400x200/6366f1/ffffff?text=Responsive',
  },
  parameters: {
    viewport: {
      defaultViewport: 'mobile',
    },
  },
};
