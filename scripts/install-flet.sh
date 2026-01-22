#!/bin/bash
set -e

# Install Flet CLI and Python package

echo "=== Installing Flet ==="

uv pip install --system flet

python3 -m flet --version

echo "=== Flet installed ==="
