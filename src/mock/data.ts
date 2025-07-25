import { Product, Task } from '../types';

export const mockProducts: Product[] = [
  {
    id: '1',
    name: 'Product A',
    description: 'High-quality product for enterprise use',
    price: 99.99,
    contractId: 'contract-001',
  },
  {
    id: '2',
    name: 'Product B',
    description: 'Cost-effective solution for small businesses',
    price: 49.99,
    contractId: 'contract-002',
  },
  {
    id: '3',
    name: 'Product C',
    description: 'Premium product with advanced features',
    price: 199.99,
    contractId: 'contract-003',
  },
];

export const mockTasks: Task[] = [
  {
    id: '1',
    title: 'Review Contract Terms',
    description: 'Read and understand contract details for Product A',
    status: 'pending',
    dueDate: '2025-07-25',
  },
  {
    id: '2',
    title: 'Complete Product Training',
    description: 'Finish the training module for Product B',
    status: 'pending',
    dueDate: '2025-07-26',
  },
  {
    id: '3',
    title: 'Submit Sales Report',
    description: 'Provide weekly sales report for all products',
    status: 'completed',
    dueDate: '2025-07-24',
  },
];
