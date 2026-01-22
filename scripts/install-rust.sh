#!/bin/bash
set -e

# Install Rust toolchain
# Uses Ubuntu packages when available for faster installs; falls back to rustup otherwise.

echo "=== Installing Rust stable ==="

INSTALL_CARGO_TOOLS="${INSTALL_CARGO_TOOLS:-0}"

if command -v apt-get >/dev/null 2>&1; then
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install -y --no-install-recommends \
        rustc \
        cargo \
        rustfmt \
        rust-clippy
    apt-get clean
    rm -rf /var/lib/apt/lists/*
    if [ "$INSTALL_CARGO_TOOLS" = "1" ]; then
        if ! cargo install --locked cargo-edit cargo-watch cargo-audit; then
            echo "Warning: failed to install cargo tools; continuing."
        fi
    fi
elif command -v apk >/dev/null 2>&1; then
    apk update
    apk add --no-cache \
        rust \
        cargo
    if apk search -q -e rustfmt >/dev/null 2>&1; then
        apk add --no-cache rustfmt
    fi
    if apk search -q -e clippy >/dev/null 2>&1; then
        apk add --no-cache clippy
    fi
    rm -rf /var/cache/apk/*
    if [ "$INSTALL_CARGO_TOOLS" = "1" ]; then
        if ! cargo install --locked cargo-edit cargo-watch cargo-audit; then
            echo "Warning: failed to install cargo tools; continuing."
        fi
    fi
else
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
fi

# Verify installation
echo "Rust version: $(rustc --version)"
echo "Cargo version: $(cargo --version)"

echo "=== Rust stable installed ==="
