#!/bin/bash

# Exit on error
set -e

# Function to handle errors
handle_error() {
    echo "Error on line $1: $2"
    exit 1
}

trap 'handle_error $LINENO "$BASH_COMMAND"' ERR

# Navigate to project directory
cd /home/davis/Desktop/cloudtasksfunnel || { echo "Directory not found"; exit 1; }

# Clear npm cache to avoid corrupted packages
echo "Clearing npm cache..."
npm cache clean --force

# Check if package.json exists
if [ -f "package.json" ]; then
    echo "Project already initialized, proceeding with setup..."
else
    echo "Initializing Vite project with TypeScript and React..."
    npm create vite@latest . -- --template react-ts --force
fi

# Install dependencies
echo "Installing dependencies..."
npm install

# Install additional dependencies for UI and state management
echo "Installing additional dependencies..."
npm install lucide-react tailwindcss@3.4.10 postcss autoprefixer @tanstack/react-query react-router-dom --save

# Ensure tailwindcss is installed
echo "Verifying tailwindcss installation..."
if ! npm list tailwindcss >/dev/null 2>&1; then
    echo "Tailwind CSS not found, reinstalling..."
    npm install tailwindcss@3.4.10 --save-dev
fi
npm list tailwindcss

# Clean up old configuration files
echo "Removing old configuration files..."
rm -f postcss.config.js tailwind.config.js

# Create Tailwind and PostCSS configurations
echo "Creating Tailwind CSS and PostCSS configurations..."
cat > tailwind.config.cjs << 'EOF'
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: '#4F46E5',
          dark: '#4338CA',
        },
        secondary: {
          DEFAULT: '#6B7280',
          dark: '#4B5563',
        },
      },
    },
  },
  plugins: [],
}
EOF

cat > postcss.config.cjs << 'EOF'
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
EOF

# Update tsconfig.app.json for proper module resolution
echo "Updating tsconfig.app.json..."
cat > tsconfig.app.json << 'EOF'
{
  "compilerOptions": {
    "target": "ESNext",
    "useDefineForClassFields": true,
    "lib": ["DOM", "DOM.Iterable", "ESNext"],
    "allowJs": false,
    "skipLibCheck": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "module": "ESNext",
    "moduleResolution": "Node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx"
  },
  "include": ["src"],
  "references": [{ "path": "./tsconfig.node.json" }]
}
EOF

# Create project structure
echo "Creating project structure..."
mkdir -p src/{components,pages,types,api,styles,hooks,mock}

# Verify project structure
echo "Verifying project structure..."
ls src

# Create main CSS file
cat > src/styles/index.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

body {
  @apply bg-gray-50 min-h-screen;
}
EOF

# Create types
cat > src/types/index.ts << 'EOF'
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
EOF

# Create mock data
cat > src/mock/data.ts << 'EOF'
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
EOF

# Create mock API service
cat > src/api/index.ts << 'EOF'
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
EOF

# Create Button component
cat > src/components/Button.tsx << 'EOF'
import React from 'react';

interface ButtonProps {
  variant?: 'primary' | 'secondary';
  size?: 'sm' | 'md' | 'lg';
  children: React.ReactNode;
  onClick?: () => void;
  disabled?: boolean;
  loading?: boolean;
}

export const Button: React.FC<ButtonProps> = ({
  variant = 'primary',
  size = 'md',
  children,
  onClick,
  disabled,
  loading,
}) => {
  const baseClasses = "font-medium rounded-lg transition-all duration-200 focus:outline-none focus:ring-2 relative overflow-hidden";
  const variantClasses = {
    primary: "bg-primary hover:bg-primary-dark text-white focus:ring-primary/30",
    secondary: "bg-secondary hover:bg-secondary-dark text-white focus:ring-secondary/30",
  };
  const sizeClasses = {
    sm: "px-3 py-1.5 text-sm",
    md: "px-4 py-2 text-base",
    lg: "px-6 py-3 text-lg",
  };

  return (
    <button
      className={`${baseClasses} ${variantClasses[variant]} ${sizeClasses[size]} ${disabled ? 'opacity-50 cursor-not-allowed' : ''}`}
      onClick={onClick}
      disabled={disabled || loading}
    >
      {loading && (
        <div className="absolute inset-0 flex items-center justify-center">
          <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin"></div>
        </div>
      )}
      <span className={loading ? 'opacity-0' : 'opacity-100'}>
        {children}
      </span>
    </button>
  );
};
EOF

# Create ErrorBoundary component
cat > src/components/ErrorBoundary.tsx << 'EOF'
import React, { Component, ReactNode } from 'react';

interface Props {
  children: ReactNode;
}

interface State {
  hasError: boolean;
  error: Error | null;
}

export class ErrorBoundary extends Component<Props, State> {
  state: State = {
    hasError: false,
    error: null,
  };

  static getDerivedStateFromError(error: Error): State {
    return { hasError: true, error };
  }

  componentDidCatch(error: Error, errorInfo: React.ErrorInfo) {
    console.error('Error caught in ErrorBoundary:', error, errorInfo);
  }

  render() {
    if (this.state.hasError) {
      return (
        <div className="min-h-screen flex items-center justify-center bg-gray-50">
          <div className="text-center p-8 bg-white rounded-xl shadow-lg">
            <h1 className="text-2xl font-bold text-red-600 mb-4">Something went wrong</h1>
            <p className="text-gray-600 mb-4">{this.state.error?.message || 'An unexpected error occurred'}</p>
            <button
              className="px-4 py-2 bg-primary text-white rounded-lg"
              onClick={() => window.location.reload()}
            >
              Reload Page
            </button>
          </div>
        </div>
      );
    }

    return this.props.children;
  }
}
EOF

# Create Login page
cat > src/pages/Login.tsx << 'EOF'
import React, { useState } from 'react';
import { Button } from '../components/Button';
import { useNavigate } from 'react-router-dom';

export const Login: React.FC = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const navigate = useNavigate();

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    // Mock login logic
    localStorage.setItem('user', JSON.stringify({ id: '1', name: 'Test User', email }));
    navigate('/dashboard');
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-primary to-secondary">
      <div className="bg-white p-8 rounded-xl shadow-lg w-full max-w-md">
        <h1 className="text-2xl font-bold text-gray-800 mb-6">Login</h1>
        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <label className="block text-sm font-medium text-gray-700">Email</label>
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-primary focus:ring-primary"
              required
            />
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700">Password</label>
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-primary focus:ring-primary"
              required
            />
          </div>
          <Button variant="primary" type="submit" className="w-full">
            Sign In
          </Button>
        </form>
      </div>
    </div>
  );
};
EOF

# Create Dashboard page
cat > src/pages/Dashboard.tsx << 'EOF'
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
EOF

# Create Products page
cat > src/pages/Products.tsx << 'EOF'
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
EOF

# Create Tasks page
cat > src/pages/Tasks.tsx << 'EOF'
import React from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { getTasks, completeTask } from '../api';
import { Task } from '../types';
import { Check, Clock } from 'lucide-react';
import { Button } from '../components/Button';

export const Tasks: React.FC = () => {
  const queryClient = useQueryClient();
  const { data: tasks, isLoading } = useQuery<Task[]>({
    queryKey: ['tasks'],
    queryFn: getTasks,
  });

  const completeMutation = useMutation({
    mutationFn: completeTask,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['tasks'] });
    },
  });

  return (
    <div className="min-h-screen bg-gray-50 p-8">
      <div className="max-w-6xl mx-auto">
        <h1 className="text-3xl font-bold text-gray-800 mb-8">Daily Tasks</h1>
        {isLoading ? (
          <div className="text-center">Loading...</div>
        ) : (
          <div className="space-y-4">
            {tasks?.map((task) => (
              <div key={task.id} className="bg-white rounded-xl shadow-lg p-6 flex items-center justify-between">
                <div>
                  <h2 className="text-lg font-semibold text-gray-800">{task.title}</h2>
                  <p className="text-gray-600">{task.description}</p>
                  <div className="flex items-center text-sm text-gray-500 mt-2">
                    <Clock className="w-4 h-4 mr-1" />
                    <span>Due: {new Date(task.dueDate).toLocaleDateString()}</span>
                  </div>
                </div>
                <Button
                  variant={task.status === 'completed' ? 'secondary' : 'primary'}
                  size="sm"
                  disabled={task.status === 'completed'}
                  onClick={() => completeMutation.mutate(task.id)}
                >
                  {task.status === 'completed' ? (
                    <><Check className="w-4 h-4 mr-1" /> Completed</>
                  ) : (
                    'Mark Complete'
                  )}
                </Button>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
};
EOF

# Create main.tsx
cat > src/main.tsx << 'EOF'
import React from 'react';
import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import './styles/index.css';
import App from './App';

console.log('Rendering application...');

const rootElement = document.getElementById('root');
if (!rootElement) {
  console.error('Root element not found');
} else {
  createRoot(rootElement).render(
    <StrictMode>
      <App />
    </StrictMode>,
  );
}
EOF

# Create App component with routing and error boundary
cat > src/App.tsx << 'EOF'
import React from 'react';
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { ErrorBoundary } from './components/ErrorBoundary';
import { Login } from './pages/Login';
import { Dashboard } from './pages/Dashboard';
import { Products } from './pages/Products';
import { Tasks } from './pages/Tasks';

const queryClient = new QueryClient();

function App() {
  return (
    <ErrorBoundary>
      <QueryClientProvider client={queryClient}>
        <BrowserRouter>
          <Routes>
            <Route path="/" element={<Login />} />
            <Route path="/dashboard" element={<Dashboard />} />
            <Route path="/products" element={<Products />} />
            <Route path="/tasks" element={<Tasks />} />
          </Routes>
        </BrowserRouter>
      </QueryClientProvider>
    </ErrorBoundary>
  );
}

export default App;
EOF

# Update index.html with fallback message
cat > index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>CloudTasks Funnel</title>
    <link rel="stylesheet" href="/src/styles/index.css" />
  </head>
  <body>
    <div id="root"></div>
    <div id="fallback" style="display: none; text-align: center; padding: 20px;">
      <h1>Loading...</h1>
      <p>If this persists, check the browser console (F12) for errors.</p>
    </div>
    <script type="module" src="/src/main.tsx"></script>
    <script>
      setTimeout(() => {
        const root = document.getElementById('root');
        const fallback = document.getElementById('fallback');
        if (root && root.children.length === 0) {
          fallback.style.display = 'block';
        }
      }, 3000);
    </script>
  </body>
</html>
EOF

# Remove default Vite files
echo "Removing default Vite files..."
rm -f src/App.css src/assets/react.svg src/index.css

# Clean Vite and TypeScript cache
echo "Cleaning Vite and TypeScript cache..."
rm -rf node_modules/.vite node_modules/.cache

# Verify main.tsx
echo "Verifying main.tsx..."
cat src/main.tsx

# Verify Tailwind and PostCSS configs
echo "Verifying Tailwind and PostCSS configurations..."
ls *.cjs

# Verify application files
echo "Verifying application files..."
ls src/{components,pages,api,mock,types}/*.ts*

# Verify tsconfig.app.json
echo "Verifying tsconfig.app.json..."
cat tsconfig.app.json

# Start the development server
echo "Starting development server..."
npm run dev