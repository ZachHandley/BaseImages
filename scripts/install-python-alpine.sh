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

# Install common dev tools via uv in a dedicated venv
uv venv /opt/py-tools
uv pip install --python /opt/py-tools/bin/python \
    poetry \
    black \
    ruff \
    mypy \
    pytest

# Make tools available system-wide
for tool in poetry black ruff mypy pytest; do
    ln -sf /opt/py-tools/bin/$tool /usr/local/bin/$tool
done

# Clean up
rm -rf /var/cache/apk/*

# Verify installation
echo "Python version: $(python3 --version)"
echo "pip version: $(pip3 --version)"
echo "uv version: $(uv --version)"
echo "poetry version: $(poetry --version)"

echo "=== Python extras installed on Alpine ==="
