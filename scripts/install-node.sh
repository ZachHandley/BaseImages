#!/bin/bash
set -e

# Install Node.js LTS
# Uses NodeSource for the official Node.js distribution

echo "=== Installing Node.js LTS ==="

export DEBIAN_FRONTEND=noninteractive

# Determine Node.js major version (LTS)
NODE_MAJOR="${NODE_MAJOR:-22}"

# Install Node.js from NodeSource
curl -fsSL https://deb.nodesource.com/setup_${NODE_MAJOR}.x | bash -
apt-get install -y nodejs

# Install pnpm globally
npm install -g pnpm

# Install yarn globally
npm install -g yarn

# Clean up
apt-get clean
rm -rf /var/lib/apt/lists/*

# Verify installation
echo "Node.js version: $(node --version)"
echo "npm version: $(npm --version)"
echo "pnpm version: $(pnpm --version)"
echo "yarn version: $(yarn --version)"

echo "=== Node.js LTS installed ==="
