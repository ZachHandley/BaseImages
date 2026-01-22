#!/bin/sh
set -e

# Install Node.js LTS on Alpine
# Uses official Node.js packages from Alpine community repository

echo "=== Installing Node.js LTS on Alpine ==="

# Determine Node.js major version (LTS)
NODE_MAJOR="${NODE_MAJOR:-22}"

# Update package index
apk update

# Install Node.js and npm from Alpine repositories
apk add --no-cache nodejs npm

# Install pnpm globally
npm install -g pnpm

# Install yarn globally
npm install -g yarn

# Clean up
rm -rf /var/cache/apk/*

# Verify installation
echo "Node.js version: $(node --version)"
echo "npm version: $(npm --version)"
echo "pnpm version: $(pnpm --version)"
echo "yarn version: $(yarn --version)"

echo "=== Node.js LTS installed on Alpine ==="
