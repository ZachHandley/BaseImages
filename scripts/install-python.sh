#!/bin/bash
set -e

# Install additional Python tools beyond what's in base
# Base already has: python3, pip, venv, pipx, uv

echo "=== Installing Python extras ==="

export DEBIAN_FRONTEND=noninteractive

# Install Python dev headers (needed for building native extensions)
apt-get update
apt-get install -y --no-install-recommends \
    python3-dev \
    python3-setuptools \
    python3-wheel

# Install poetry via pipx (isolated install)
pipx install poetry

# Install common dev tools via uv (fast!)
uv pip install --system \
    virtualenv \
    black \
    ruff \
    mypy \
    pytest

# Clean up
apt-get clean
rm -rf /var/lib/apt/lists/*

# Verify installation
echo "Python version: $(python3 --version)"
echo "pip version: $(pip3 --version)"
echo "uv version: $(uv --version)"
echo "poetry version: $(poetry --version)"

echo "=== Python extras installed ==="
