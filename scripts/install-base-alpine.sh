#!/bin/sh
set -e

# BaseImages - Alpine Base Installation Script
# Installs common tools on Alpine Linux

echo "=== Installing Alpine base packages ==="

# Update and upgrade
apk update
apk upgrade

# Install essential build tools
apk add --no-cache \
    build-base \
    pkgconfig \
    cmake \
    ninja \
    autoconf \
    automake \
    libtool \
    git \
    git-lfs \
    curl \
    wget \
    ca-certificates \
    bash \
    jq \
    unzip \
    zip \
    xz \
    zstd \
    sudo

# Install LLVM/Clang toolchain
apk add --no-cache \
    llvm \
    lld \
    clang \
    compiler-rt

# Install development libraries
apk add --no-cache \
    openssl-dev \
    sqlite-dev \
    libffi-dev \
    readline-dev \
    ncurses-dev \
    libxml2-dev \
    yaml-dev \
    libxml2-dev \
    bsd-compat-headers \
    linux-headers

# Install Python
apk add --no-cache \
    python3 \
    py3-pip \
    py3-virtualenv

# Install Node.js LTS and common package managers
apk add --no-cache \
    nodejs \
    npm
npm install -g pnpm yarn

# Install Bun
curl -fsSL https://bun.sh/install | bash
cp /root/.bun/bin/bun /usr/local/bin/bun
cp /root/.bun/bin/bunx /usr/local/bin/bunx

# Install pipx if not available
pip3 install --break-system-packages --upgrade pipx

# Install uv (fast Python package installer)
pip3 install --break-system-packages uv

# Install database clients
apk add --no-cache \
    postgresql-client \
    redis

# Ensure sudoers directory exists before adding entries
mkdir -p /etc/sudoers.d

# Create runner user (non-root)
adduser -D -s /bin/bash runner
echo "runner ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/runner
chmod 0440 /etc/sudoers.d/runner

# Clean up
rm -rf /var/cache/apk/*

echo "=== Alpine base packages installed ==="
