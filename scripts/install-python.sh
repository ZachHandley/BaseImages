#!/bin/bash
set -e

# Install Python 3 with common tools
# Uses system Python with pip and uv

echo "=== Installing Python ==="

export DEBIAN_FRONTEND=noninteractive

# Install Python and pip
apt-get update
apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev

# Upgrade pip
python3 -m pip install --upgrade pip

# Install uv (fast Python package installer)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Add uv to PATH for verification
export PATH="$HOME/.cargo/bin:$PATH"

# Install common Python tools
python3 -m pip install --no-cache-dir \
    pipx \
    virtualenv \
    poetry

# Clean up
apt-get clean
rm -rf /var/lib/apt/lists/*

# Verify installation
echo "Python version: $(python3 --version)"
echo "pip version: $(pip3 --version)"

echo "=== Python installed ==="
