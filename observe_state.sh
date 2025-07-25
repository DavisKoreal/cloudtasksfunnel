#!/bin/bash

# Exit on error
set -e

# Navigate to project directory
cd /home/davis/Desktop/cloudtasksfunnel || { echo "Directory not found"; exit 1; }

# Remove existing state.txt if it exists
rm -f state.txt

# Print contents of all source files to state.txt
echo "Dumping contents of source files to state.txt..."
{
  echo "=== Project Source Files ==="
  echo "Generated on: $(date)"
  echo ""

  # Include root-level config files
  for file in *.cjs *.ts *.tsx index.html; do
    if [ -f "$file" ]; then
      echo "=== $file ==="
      cat "$file"
      echo ""
    fi
  done

  # Include src directory files
  for file in src/**/*.{ts,tsx,css}; do
    if [ -f "$file" ]; then
      echo "=== $file ==="
      cat "$file"
      echo ""
    fi
  done
} > state.txt

# Verify state.txt was created
echo "Verifying state.txt..."
if [ -f state.txt ]; then
  echo "state.txt created successfully. Contents:"
  ls -l state.txt
else
  echo "Failed to create state.txt"
  exit 1
fi