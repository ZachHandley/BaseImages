#!/bin/bash
set -e

# Install Rust stable toolchain
# Uses rustup for the official Rust distribution

echo "=== Installing Rust stable ==="

export RUSTUP_HOME="${RUSTUP_HOME:-/usr/local/rustup}"
export CARGO_HOME="${CARGO_HOME:-/usr/local/cargo}"

# Download and install rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable --profile minimal

# Add cargo to PATH for this script
export PATH="$CARGO_HOME/bin:$PATH"

# Install common components
rustup component add rustfmt clippy

# Install cargo-binstall for faster binary installs
curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash

# Install common cargo tools via binstall
cargo binstall -y cargo-watch cargo-edit cargo-audit

# Ensure binaries are accessible system-wide
chmod -R a+rX "$RUSTUP_HOME" "$CARGO_HOME"

# Create profile.d script for PATH
cat > /etc/profile.d/rust.sh << 'EOF'
export RUSTUP_HOME=/usr/local/rustup
export CARGO_HOME=/usr/local/cargo
export PATH="$CARGO_HOME/bin:$PATH"
EOF

chmod +x /etc/profile.d/rust.sh

# Verify installation
echo "Rust version: $(rustc --version)"
echo "Cargo version: $(cargo --version)"

echo "=== Rust stable installed ==="
