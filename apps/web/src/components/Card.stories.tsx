import type { Meta, StoryObj } from '@storybook/react';
import { Card } from '../components/Card';
import { Button } from '../components/Button';
import { fn } from '@storybook/test';

const meta = {
  title: 'Core/Card',
  component: Card,
  parameters: {
    layout: 'padded',
  },
  tags: ['autodocs'],
  argTypes: {
    variant: {
      control: 'select',
      options: ['default', 'bordered', 'elevated', 'flat'],
      description: 'Card style variant',
    },
    padding: {
      control: 'select',
      options: ['none', 'sm', 'md', 'lg'],
      description: 'Card padding size',
    },
    hoverable: {
      control: 'boolean',
      description: 'Enable hover effect',
    },
  },
  args: { onClick: fn() },
} satisfies Meta<typeof Card>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {
  args: {
    title: 'Card Title',
    subtitle: 'Card subtitle',
    children: 'This is the card content. It can contain any React elements.',
  },
};

export const Bordered: Story = {
  args: {
    title: 'Bordered Card',
    variant: 'bordered',
    children: 'Card with a thicker border for emphasis.',
  },
};

export const Elevated: Story = {
  args: {
    title: 'Elevated Card',
    variant: 'elevated',
    children: 'Card with shadow elevation effect.',
  },
};

export const Flat: Story = {
  args: {
    title: 'Flat Card',
    variant: 'flat',
    children: 'Card with subtle gray background.',
  },
};

export const WithFooter: Story = {
  args: {
    title: 'Service Listing',
    subtitle: 'Web Development',
    children: 'Professional full-stack web development services. React, Node.js, and modern frameworks.',
    footer: (
      <div className="flex justify-between items-center">
        <span className="text-lg font-bold text-primary-600">0.5 ETH</span>
        <Button size="sm">Purchase</Button>
      </div>
    ),
  },
};

export const Hoverable: Story = {
  args: {
    title: 'Hoverable Card',
    subtitle: 'Hover to see effect',
    hoverable: true,
    children: 'This card scales up and shows shadow on hover.',
  },
};

export const Clickable: Story = {
  args: {
    title: 'Clickable Card',
    subtitle: 'Click me!',
    children: 'This card has an onClick handler attached.',
    onClick: fn(),
    hoverable: true,
  },
};

export const NoPadding: Story = {
  args: {
    padding: 'none',
    children: (
      <div className="overflow-hidden">
        <img 
          src="https://via.placeholder.com/400x200/0ea5e9/ffffff?text=Service+Image" 
          alt="Service" 
          className="w-full h-48 object-cover"
        />
        <div className="p-4">
          <h3 className="text-lg font-semibold">Service with Image</h3>
          <p className="text-gray-600 mt-2">Card with no padding for custom layouts.</p>
        </div>
      </div>
    ),
  },
};

export const SmallPadding: Story = {
  args: {
    title: 'Compact Card',
    padding: 'sm',
    children: 'Card with small padding for compact layouts.',
  },
};

export const LargePadding: Story = {
  args: {
    title: 'Spacious Card',
    padding: 'lg',
    children: 'Card with large padding for more breathing room.',
  },
};

export const ServiceCard: Story = {
  render: () => (
    <Card
      title="Premium Logo Design"
      subtitle="Graphic Design"
      variant="elevated"
      hoverable
    >
      <div className="space-y-3">
        <p className="text-gray-700">
          Professional logo design services with unlimited revisions. 
          Includes brand guidelines and multiple file formats.
        </p>
        <div className="flex items-center gap-2 text-sm text-gray-600">
          <span className="inline-flex items-center">
            <svg className="w-4 h-4 mr-1 text-warning-500" fill="currentColor" viewBox="0 0 20 20">
              <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
            </svg>
            4.9 (127 reviews)
          </span>
          <span>•</span>
          <span>24h delivery</span>
        </div>
      </div>
    </Card>
  ),
};

export const CardGrid: Story = {
  render: () => (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
      {[1, 2, 3, 4, 5, 6].map((i) => (
        <Card
          key={i}
          title={`Service ${i}`}
          subtitle="Category"
          variant="elevated"
          hoverable
          footer={
            <div className="flex justify-between items-center">
              <span className="font-bold text-primary-600">{(i * 0.1).toFixed(1)} ETH</span>
              <Button size="sm">View</Button>
            </div>
          }
        >
          <p className="text-sm text-gray-600">
            Description for service {i}. High quality work delivered on time.
          </p>
        </Card>
      ))}
    </div>
  ),
};
