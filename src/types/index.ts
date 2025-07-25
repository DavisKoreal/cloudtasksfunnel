export interface Product {
  id: string;
  name: string;
  description: string;
  price: number;
  contractId: string;
}

export interface Task {
  id: string;
  title: string;
  description: string;
  status: 'pending' | 'completed';
  dueDate: string;
}

export interface User {
  id: string;
  name: string;
  email: string;
}
