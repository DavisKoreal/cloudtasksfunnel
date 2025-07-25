import React from 'react';
import { useQuery } from '@tanstack/react-query';
import { getProducts } from '../api';
import { Product } from '../types';
import { Button } from '../components/Button';

export const Products: React.FC = () => {
  const { data: products, isLoading } = useQuery<Product[]>({
    queryKey: ['products'],
    queryFn: getProducts,
  });

  return (
    <div className="min-h-screen bg-gray-50 p-8">
      <div className="max-w-6xl mx-auto">
        <h1 className="text-3xl font-bold text-gray-800 mb-8">Available Products</h1>
        {isLoading ? (
          <div className="text-center">Loading...</div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {products?.map((product) => (
              <div key={product.id} className="bg-white rounded-xl shadow-lg p-6 hover:shadow-xl transition-all duration-300">
                <h2 className="text-xl font-semibold text-gray-800 mb-2">{product.name}</h2>
                <p className="text-gray-600 mb-4">{product.description}</p>
                <div className="flex justify-between items-center">
                  <span className="text-primary font-medium">${product.price}</span>
                  <Button variant="secondary" size="sm">View Details</Button>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
};
