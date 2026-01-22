#!/bin/bash
set -e

# Install Python development headers for native builds (pyo3, etc.)

echo "=== Installing Python dev headers ==="

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y --no-install-recommends \
    python3-dev

# Install maturin for Rust/Python builds
uv pip install --system maturin

apt-get clean
rm -rf /var/lib/apt/lists/*

echo "=== Python dev headers installed ==="
