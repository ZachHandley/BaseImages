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
    # Build essentials
    build-essential \
    pkg-config \
    cmake \
    ninja-build \
    autoconf \
    automake \
    libtool \
    # LLVM toolchain (used by Rust, Flutter, C++)
    llvm \
    lld \
    clang \
    libclang-dev \
    # Common libraries
    libssl-dev \
    libsqlite3-dev \
    libffi-dev \
    libreadline-dev \
    libncurses-dev \
    libxml2-dev \
    libyaml-dev \
    # Python (needed by many build scripts)
    python3 \
    python3-pip \
    python3-venv \
    pipx \
    # DB clients
    postgresql-client \
    redis-tools

# Generate locales
locale-gen en_US.UTF-8

# Install astral uv (fast Python package manager)
echo "Installing astral uv..."
curl -LsSf https://astral.sh/uv/install.sh | sh
# Make uv available system-wide
cp /root/.local/bin/uv /usr/local/bin/uv
cp /root/.local/bin/uvx /usr/local/bin/uvx

# Clean up apt cache
apt-get clean
rm -rf /var/lib/apt/lists/*

echo "=== Base prerequisites installed ==="
echo "uv version: $(uv --version)"
