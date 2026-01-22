#!/bin/sh
set -e

# Install additional Python tools on Alpine
# Base already has: python3, pip, venv, pipx, uv

echo "=== Installing Python extras on Alpine ==="

# Update package index
apk update

# Install Python dev headers (needed for building native extensions)
apk add --no-cache \
    python3-dev \
    py3-setuptools \
    py3-wheel

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
rm -rf /var/cache/apk/*

# Verify installation
echo "Python version: $(python3 --version)"
echo "pip version: $(pip3 --version)"
echo "uv version: $(uv --version)"
echo "poetry version: $(poetry --version)"

echo "=== Python extras installed on Alpine ==="
