import type { Meta, StoryObj } from '@storybook/react';
import { RatingDisplay } from '../components/RatingDisplay';
import { fn } from '@storybook/test';
import { useState } from 'react';

const meta = {
  title: 'Reputation/RatingDisplay',
  component: RatingDisplay,
  parameters: {
    layout: 'centered',
  },
  tags: ['autodocs'],
  argTypes: {
    rating: {
      control: { type: 'range', min: 0, max: 5, step: 0.1 },
      description: 'Rating value from 0 to 5',
    },
    size: {
      control: 'select',
      options: ['sm', 'md', 'lg'],
      description: 'Size of stars',
    },
    showNumeric: {
      control: 'boolean',
      description: 'Show numeric rating value',
    },
    interactive: {
      control: 'boolean',
      description: 'Enable interactive rating selection',
    },
  },
  args: { onChange: fn() },
} satisfies Meta<typeof RatingDisplay>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Perfect: Story = {
  args: {
    rating: 5.0,
    reviewCount: 127,
  },
};

export const Excellent: Story = {
  args: {
    rating: 4.8,
    reviewCount: 89,
  },
};

export const Good: Story = {
  args: {
    rating: 4.2,
    reviewCount: 45,
  },
};

export const Average: Story = {
  args: {
    rating: 3.5,
    reviewCount: 23,
  },
};

export const Poor: Story = {
  args: {
    rating: 2.1,
    reviewCount: 8,
  },
};

export const NoReviews: Story = {
  args: {
    rating: 0,
    reviewCount: 0,
  },
};

export const SmallSize: Story = {
  args: {
    rating: 4.5,
    reviewCount: 50,
    size: 'sm',
  },
};

export const MediumSize: Story = {
  args: {
    rating: 4.5,
    reviewCount: 50,
    size: 'md',
  },
};

export const LargeSize: Story = {
  args: {
    rating: 4.5,
    reviewCount: 50,
    size: 'lg',
  },
};

export const WithoutNumeric: Story = {
  args: {
    rating: 4.7,
    reviewCount: 100,
    showNumeric: false,
  },
};

export const WithoutReviewCount: Story = {
  args: {
    rating: 4.3,
  },
};

export const Interactive: Story = {
  args: {
    rating: 0,
    interactive: true,
    showNumeric: false,
  },
  render: (args) => {
    const [rating, setRating] = useState(args.rating);
    return (
      <div className="space-y-4">
        <RatingDisplay {...args} rating={rating} onChange={setRating} />
        <p className="text-sm text-gray-600">
          Current rating: {rating} stars
        </p>
      </div>
    );
  },
};

export const AllRatings: Story = {
  render: () => (
    <div className="space-y-4">
      <div>
        <p className="text-xs text-gray-500 mb-2">5.0 - Perfect</p>
        <RatingDisplay rating={5.0} reviewCount={200} />
      </div>
      <div>
        <p className="text-xs text-gray-500 mb-2">4.8 - Excellent</p>
        <RatingDisplay rating={4.8} reviewCount={150} />
      </div>
      <div>
        <p className="text-xs text-gray-500 mb-2">4.5 - Very Good</p>
        <RatingDisplay rating={4.5} reviewCount={100} />
      </div>
      <div>
        <p className="text-xs text-gray-500 mb-2">4.0 - Good</p>
        <RatingDisplay rating={4.0} reviewCount={75} />
      </div>
      <div>
        <p className="text-xs text-gray-500 mb-2">3.5 - Average</p>
        <RatingDisplay rating={3.5} reviewCount={50} />
      </div>
      <div>
        <p className="text-xs text-gray-500 mb-2">3.0 - Fair</p>
        <RatingDisplay rating={3.0} reviewCount={30} />
      </div>
      <div>
        <p className="text-xs text-gray-500 mb-2">2.5 - Below Average</p>
        <RatingDisplay rating={2.5} reviewCount={20} />
      </div>
      <div>
        <p className="text-xs text-gray-500 mb-2">2.0 - Poor</p>
        <RatingDisplay rating={2.0} reviewCount={10} />
      </div>
      <div>
        <p className="text-xs text-gray-500 mb-2">1.0 - Very Poor</p>
        <RatingDisplay rating={1.0} reviewCount={5} />
      </div>
    </div>
  ),
};

export const ComparisonSizes: Story = {
  render: () => (
    <div className="space-y-6">
      <div>
        <p className="text-sm font-medium mb-2">Small</p>
        <RatingDisplay rating={4.5} reviewCount={100} size="sm" />
      </div>
      <div>
        <p className="text-sm font-medium mb-2">Medium</p>
        <RatingDisplay rating={4.5} reviewCount={100} size="md" />
      </div>
      <div>
        <p className="text-sm font-medium mb-2">Large</p>
        <RatingDisplay rating={4.5} reviewCount={100} size="lg" />
      </div>
    </div>
  ),
};
