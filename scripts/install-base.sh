#!/bin/bash
set -e

# Install base prerequisites for all images
# This sets up the foundation that all other tools build upon

echo "=== Installing base prerequisites ==="

export DEBIAN_FRONTEND=noninteractive

# Update package lists
apt-get update

# Install essential packages
apt-get install -y --no-install-recommends \
    sudo \
    git \
    git-lfs \
    curl \
    wget \
    ca-certificates \
    gnupg \
    lsb-release \
    locales \
    jq \
    unzip \
    zip \
    xz-utils \
    zstd \
    build-essential \
    pkg-config \
    cmake \
    ninja-build \
    autoconf \
    automake \
    libtool \
    llvm \
    lld \
    clang \
    libclang-dev \
    libssl-dev \
    libsqlite3-dev \
    libffi-dev \
    libreadline-dev \
    libncurses-dev \
    libxml2-dev \
    libyaml-dev \
    python3 \
    python3-pip \
    python3-venv \
    pipx \
    postgresql-client \
    redis-tools

# Generate locales
locale-gen en_US.UTF-8

# Install Node.js LTS (needed for many CI workflows)
echo "Installing Node.js LTS..."
NODE_MAJOR="${NODE_MAJOR:-22}"
curl -fsSL https://deb.nodesource.com/setup_${NODE_MAJOR}.x | bash -
apt-get install -y nodejs

# Install pnpm, yarn, and bun globally
npm install -g pnpm yarn
curl -fsSL https://bun.sh/install | bash
cp /root/.bun/bin/bun /usr/local/bin/bun
cp /root/.bun/bin/bunx /usr/local/bin/bunx

# Install astral uv (fast Python package manager)
echo "Installing astral uv..."
curl -LsSf https://astral.sh/uv/install.sh | sh
cp /root/.local/bin/uv /usr/local/bin/uv
cp /root/.local/bin/uvx /usr/local/bin/uvx

# Clean up apt cache
apt-get clean
rm -rf /var/lib/apt/lists/*

echo "=== Base prerequisites installed ==="
echo "Node.js version: $(node --version)"
echo "npm version: $(npm --version)"
echo "pnpm version: $(pnpm --version)"
echo "bun version: $(bun --version)"
echo "uv version: $(uv --version)"
