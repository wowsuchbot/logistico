import type { Meta, StoryObj } from '@storybook/react';
import { ReputationBadge } from '../components/ReputationBadge';

const meta = {
  title: 'Reputation/ReputationBadge',
  component: ReputationBadge,
  parameters: {
    layout: 'centered',
  },
  tags: ['autodocs'],
  argTypes: {
    level: {
      control: 'select',
      options: ['verified', 'trusted', 'elite', 'legendary', 'none'],
      description: 'Badge level',
    },
    size: {
      control: 'select',
      options: ['sm', 'md', 'lg'],
      description: 'Badge size',
    },
    showLabel: {
      control: 'boolean',
      description: 'Show label text',
    },
  },
} satisfies Meta<typeof ReputationBadge>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Verified: Story = {
  args: {
    level: 'verified',
  },
};

export const Trusted: Story = {
  args: {
    level: 'trusted',
  },
};

export const Elite: Story = {
  args: {
    level: 'elite',
  },
};

export const Legendary: Story = {
  args: {
    level: 'legendary',
  },
};

export const None: Story = {
  args: {
    level: 'none',
  },
};

export const SmallSize: Story = {
  args: {
    level: 'trusted',
    size: 'sm',
  },
};

export const MediumSize: Story = {
  args: {
    level: 'trusted',
    size: 'md',
  },
};

export const LargeSize: Story = {
  args: {
    level: 'trusted',
    size: 'lg',
  },
};

export const WithoutLabel: Story = {
  args: {
    level: 'elite',
    showLabel: false,
  },
};

export const AllBadges: Story = {
  render: () => (
    <div className="space-y-4">
      <div className="flex items-center gap-4">
        <span className="text-sm font-medium w-32">Verified Seller:</span>
        <ReputationBadge level="verified" />
      </div>
      <div className="flex items-center gap-4">
        <span className="text-sm font-medium w-32">Trusted Provider:</span>
        <ReputationBadge level="trusted" />
      </div>
      <div className="flex items-center gap-4">
        <span className="text-sm font-medium w-32">Elite Professional:</span>
        <ReputationBadge level="elite" />
      </div>
      <div className="flex items-center gap-4">
        <span className="text-sm font-medium w-32">Legendary Seller:</span>
        <ReputationBadge level="legendary" />
      </div>
    </div>
  ),
};

export const AllSizes: Story = {
  render: () => (
    <div className="space-y-4">
      <div>
        <p className="text-xs text-gray-500 mb-2">Small</p>
        <ReputationBadge level="trusted" size="sm" />
      </div>
      <div>
        <p className="text-xs text-gray-500 mb-2">Medium</p>
        <ReputationBadge level="trusted" size="md" />
      </div>
      <div>
        <p className="text-xs text-gray-500 mb-2">Large</p>
        <ReputationBadge level="trusted" size="lg" />
      </div>
    </div>
  ),
};

export const BadgeProgression: Story = {
  render: () => (
    <div className="space-y-6 max-w-2xl">
      <div className="space-y-2">
        <div className="flex items-center justify-between">
          <ReputationBadge level="verified" />
          <span className="text-sm text-gray-600">5 orders, 0.1 ETH, 3.5★</span>
        </div>
        <div className="w-full bg-gray-200 rounded-full h-2">
          <div className="bg-blue-600 h-2 rounded-full" style={{ width: '25%' }} />
        </div>
      </div>

      <div className="space-y-2">
        <div className="flex items-center justify-between">
          <ReputationBadge level="trusted" />
          <span className="text-sm text-gray-600">25 orders, 1 ETH, 4.0★</span>
        </div>
        <div className="w-full bg-gray-200 rounded-full h-2">
          <div className="bg-green-600 h-2 rounded-full" style={{ width: '50%' }} />
        </div>
      </div>

      <div className="space-y-2">
        <div className="flex items-center justify-between">
          <ReputationBadge level="elite" />
          <span className="text-sm text-gray-600">100 orders, 10 ETH, 4.5★</span>
        </div>
        <div className="w-full bg-gray-200 rounded-full h-2">
          <div className="bg-purple-600 h-2 rounded-full" style={{ width: '75%' }} />
        </div>
      </div>

      <div className="space-y-2">
        <div className="flex items-center justify-between">
          <ReputationBadge level="legendary" />
          <span className="text-sm text-gray-600">500 orders, 100 ETH, 4.75★</span>
        </div>
        <div className="w-full bg-gray-200 rounded-full h-2">
          <div className="bg-warning-600 h-2 rounded-full" style={{ width: '100%' }} />
        </div>
      </div>
    </div>
  ),
};

export const InlineWithText: Story = {
  render: () => (
    <div className="space-y-3">
      <p className="flex items-center gap-2">
        Provider status: <ReputationBadge level="verified" size="sm" />
      </p>
      <p className="flex items-center gap-2">
        This seller has achieved <ReputationBadge level="elite" size="sm" /> status
      </p>
      <p className="flex items-center gap-2">
        Only <ReputationBadge level="legendary" size="sm" /> sellers can offer premium services
      </p>
    </div>
  ),
};

export const CardWithBadge: Story = {
  render: () => (
    <div className="max-w-md p-6 bg-white rounded-lg shadow-lg">
      <div className="flex items-start justify-between mb-4">
        <div>
          <h3 className="text-xl font-bold text-gray-900">John Doe</h3>
          <p className="text-sm text-gray-600">0x742d...0bEb0</p>
        </div>
        <ReputationBadge level="elite" />
      </div>
      <div className="space-y-2 text-sm text-gray-700">
        <p>Total Orders: 156</p>
        <p>Total Volume: 15.8 ETH</p>
        <p>Average Rating: 4.6★</p>
        <p>Member Since: Jan 2024</p>
      </div>
    </div>
  ),
};