import React from 'react';
import { Card } from './Card';
import { Button } from './Button';

export interface ServiceCardProps {
  /** Service title */
  title: string;
  /** Service description */
  description: string;
  /** Service category */
  category: string;
  /** Price in ETH */
  price: string;
  /** Provider address */
  provider: string;
  /** Provider reputation score (0-5) */
  rating?: number;
  /** Number of reviews */
  reviewCount?: number;
  /** Delivery time */
  deliveryTime?: string;
  /** Service scope */
  scope?: 'global' | 'regional' | 'local';
  /** Service image URL */
  imageUrl?: string;
  /** Available zones (for regional/local) */
  availableZones?: string[];
  /** Click handler */
  onPurchase?: () => void;
  /** View details handler */
  onViewDetails?: () => void;
}

export const ServiceCard: React.FC<ServiceCardProps> = ({
  title,
  description,
  category,
  price,
  provider,
  rating = 0,
  reviewCount = 0,
  deliveryTime,
  scope = 'global',
  imageUrl,
  availableZones = [],
  onPurchase,
  onViewDetails,
}) => {
  const scopeColors = {
    global: 'bg-blue-100 text-blue-800',
    regional: 'bg-green-100 text-green-800',
    local: 'bg-purple-100 text-purple-800',
  };

  const renderStars = (rating: number) => {
    return (
      <div className="flex items-center gap-1">
        {[1, 2, 3, 4, 5].map((star) => (
          <svg
            key={star}
            className={`w-4 h-4 ${star <= rating ? 'text-warning-500' : 'text-gray-300'}`}
            fill="currentColor"
            viewBox="0 0 20 20"
          >
            <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
          </svg>
        ))}
        <span className="text-sm text-gray-600 ml-1">
          {rating.toFixed(1)} ({reviewCount})
        </span>
      </div>
    );
  };

  return (
    <Card variant="elevated" hoverable padding="none">
      {imageUrl && (
        <img
          src={imageUrl}
          alt={title}
          className="w-full h-48 object-cover"
        />
      )}
      
      <div className="p-4 space-y-3">
        <div className="flex items-start justify-between gap-2">
          <div className="flex-1">
            <h3 className="text-lg font-semibold text-gray-900 line-clamp-1">
              {title}
            </h3>
            <p className="text-sm text-gray-600">{category}</p>
          </div>
          <span className={`px-2 py-1 text-xs font-medium rounded-full ${scopeColors[scope]}`}>
            {scope}
          </span>
        </div>

        <p className="text-sm text-gray-700 line-clamp-2">{description}</p>

        <div className="flex items-center gap-4 text-sm text-gray-600">
          {rating > 0 && renderStars(rating)}
          {deliveryTime && (
            <>
              <span>•</span>
              <span>{deliveryTime}</span>
            </>
          )}
        </div>

        {availableZones.length > 0 && (
          <div className="flex items-center gap-2 text-xs text-gray-600">
            <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
            </svg>
            <span>{availableZones.length} zone{availableZones.length !== 1 ? 's' : ''}</span>
          </div>
        )}

        <div className="pt-3 border-t border-gray-200">
          <div className="flex items-center justify-between">
            <div>
              <div className="text-2xl font-bold text-primary-600">{price} ETH</div>
              <div className="text-xs text-gray-500 truncate max-w-[150px]" title={provider}>
                by {provider.slice(0, 6)}...{provider.slice(-4)}
              </div>
            </div>
            <div className="flex gap-2">
              {onViewDetails && (
                <Button size="sm" variant="outline" onClick={onViewDetails}>
                  Details
                </Button>
              )}
              {onPurchase && (
                <Button size="sm" onClick={onPurchase}>
                  Purchase
                </Button>
              )}
            </div>
          </div>
        </div>
      </div>
    </Card>
  );
};
