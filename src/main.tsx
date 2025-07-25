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
