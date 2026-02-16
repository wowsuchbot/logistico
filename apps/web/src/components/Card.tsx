import React from 'react';

export interface CardProps {
  /** Card content */
  children: React.ReactNode;
  /** Card title */
  title?: string;
  /** Card subtitle */
  subtitle?: string;
  /** Card footer content */
  footer?: React.ReactNode;
  /** Card variant */
  variant?: 'default' | 'bordered' | 'elevated' | 'flat';
  /** Padding size */
  padding?: 'none' | 'sm' | 'md' | 'lg';
  /** Hover effect */
  hoverable?: boolean;
  /** Click handler */
  onClick?: () => void;
  /** Custom className */
  className?: string;
}

export const Card: React.FC<CardProps> = ({
  children,
  title,
  subtitle,
  footer,
  variant = 'default',
  padding = 'md',
  hoverable = false,
  onClick,
  className = '',
}) => {
  const baseStyles = 'rounded-lg transition-all duration-200';
  
  const variantStyles = {
    default: 'bg-white border border-gray-200',
    bordered: 'bg-white border-2 border-gray-300',
    elevated: 'bg-white shadow-lg',
    flat: 'bg-gray-50',
  };
  
  const paddingStyles = {
    none: '',
    sm: 'p-3',
    md: 'p-4',
    lg: 'p-6',
  };
  
  const hoverStyles = hoverable ? 'hover:shadow-xl hover:scale-[1.02] cursor-pointer' : '';
  const clickStyles = onClick ? 'cursor-pointer' : '';
  
  const cardClassName = `
    ${baseStyles}
    ${variantStyles[variant]}
    ${paddingStyles[padding]}
    ${hoverStyles}
    ${clickStyles}
    ${className}
  `.trim().replace(/\s+/g, ' ');
  
  return (
    <div className={cardClassName} onClick={onClick}>
      {(title || subtitle) && (
        <div className="mb-4">
          {title && <h3 className="text-xl font-semibold text-gray-900">{title}</h3>}
          {subtitle && <p className="text-sm text-gray-600 mt-1">{subtitle}</p>}
        </div>
      )}
      <div className="text-gray-700">{children}</div>
      {footer && (
        <div className="mt-4 pt-4 border-t border-gray-200">
          {footer}
        </div>
      )}
    </div>
  );
};
