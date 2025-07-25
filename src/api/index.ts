import { Product, Task } from '../types';
import { mockProducts, mockTasks } from '../mock/data';

// Simulate API delay
const delay = (ms: number) => new Promise(resolve => setTimeout(resolve, ms));

export const getProducts = async (): Promise<Product[]> => {
  await delay(500); // Simulate network delay
  return mockProducts;
};

export const getTasks = async (): Promise<Task[]> => {
  await delay(500); // Simulate network delay
  return mockTasks;
};

export const completeTask = async (taskId: string): Promise<Task> => {
  await delay(300);
  const task = mockTasks.find(t => t.id === taskId);
  if (!task) throw new Error('Task not found');
  task.status = 'completed';
  return task;
};
