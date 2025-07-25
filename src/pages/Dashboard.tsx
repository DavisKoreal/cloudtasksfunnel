import React from 'react';
import { Link } from 'react-router-dom';
import { Button } from '../components/Button';

export const Dashboard: React.FC = () => {
  return (
    <div className="min-h-screen bg-gray-50 p-8">
      <div className="max-w-6xl mx-auto">
        <h1 className="text-3xl font-bold text-gray-800 mb-8">Dashboard</h1>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div className="bg-white rounded-xl shadow-lg p-6">
            <h2 className="text-xl font-semibold text-gray-800 mb-4">Products</h2>
            <p className="text-gray-600 mb-4">View and manage your available products</p>
            <Link to="/products">
              <Button variant="primary">View Products</Button>
            </Link>
          </div>
          <div className="bg-white rounded-xl shadow-lg p-6">
            <h2 className="text-xl font-semibold text-gray-800 mb-4">Daily Tasks</h2>
            <p className="text-gray-600 mb-4">Complete your tasks to stay eligible</p>
            <Link to="/tasks">
              <Button variant="primary">View Tasks</Button>
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
};
