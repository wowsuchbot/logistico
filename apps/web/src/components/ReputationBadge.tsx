import React from 'react';

export type BadgeLevel = 'verified' | 'trusted' | 'elite' | 'legendary' | 'none';

export interface ReputationBadgeProps {
  /** Badge level */
  level: BadgeLevel;
  /** Badge size */
  size?: 'sm' | 'md' | 'lg';
  /** Show label text */
  showLabel?: boolean;
}

export const ReputationBadge: React.FC<ReputationBadgeProps> = ({
  level,
  size = 'md',
  showLabel = true,
}) => {
  const badgeConfig = {
    verified: {
      label: 'Verified Seller',
      color: 'text-blue-600 bg-blue-100',
      icon: '✓',
    },
    trusted: {
      label: 'Trusted Provider',
      color: 'text-green-600 bg-green-100',
      icon: '★',
    },
    elite: {
      label: 'Elite Professional',
      color: 'text-purple-600 bg-purple-100',
      icon: '◆',
    },
    legendary: {
      label: 'Legendary Seller',
      color: 'text-warning-600 bg-warning-100',
      icon: '♔',
    },
    none: {
      label: 'No Badge',
      color: 'text-gray-600 bg-gray-100',
      icon: '',
    },
  };

  const sizeStyles = {
    sm: 'text-xs px-2 py-1',
    md: 'text-sm px-3 py-1.5',
    lg: 'text-base px-4 py-2',
  };

  if (level === 'none') return null;

  const config = badgeConfig[level];

  return (
    <span
      className={`inline-flex items-center gap-1.5 rounded-full font-medium ${config.color} ${sizeStyles[size]}`}
    >
      <span className="font-bold">{config.icon}</span>
      {showLabel && <span>{config.label}</span>}
    </span>
  );
};