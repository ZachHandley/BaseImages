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
    build-essential \
    pkg-config \
    libssl-dev \
    jq \
    unzip \
    zip \
    xz-utils \
    locales

# Generate locales
locale-gen en_US.UTF-8

# Clean up apt cache
apt-get clean
rm -rf /var/lib/apt/lists/*

echo "=== Base prerequisites installed ==="
