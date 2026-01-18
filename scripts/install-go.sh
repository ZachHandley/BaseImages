#!/bin/bash
set -e

# Install Go programming language
# Uses official Go binary distribution

echo "=== Installing Go ==="

# Determine Go version (default to latest stable)
GO_VERSION="${GO_VERSION:-1.23.5}"

# Detect architecture
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        GO_ARCH="amd64"
        ;;
    aarch64|arm64)
        GO_ARCH="arm64"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

# Download and install Go
curl -fsSL "https://go.dev/dl/go${GO_VERSION}.linux-${GO_ARCH}.tar.gz" -o /tmp/go.tar.gz
rm -rf /usr/local/go
tar -C /usr/local -xzf /tmp/go.tar.gz
rm /tmp/go.tar.gz

# Create profile.d script for PATH
cat > /etc/profile.d/go.sh << 'EOF'
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOROOT/bin:$GOPATH/bin:$PATH
EOF

chmod +x /etc/profile.d/go.sh

# Source it for this script
export GOROOT=/usr/local/go
export PATH=$GOROOT/bin:$PATH

# Verify installation
echo "Go version: $(go version)"

echo "=== Go installed ==="
