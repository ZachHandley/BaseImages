#!/bin/bash
set -e

# Install .NET SDK using official install script (supports all architectures)

echo "=== Installing .NET SDK ==="

export DEBIAN_FRONTEND=noninteractive

# Determine .NET version (default to 8 LTS - 9 not fully available on ARM64 yet)
DOTNET_VERSION="${DOTNET_VERSION:-8.0}"

# Install dependencies
apt-get update
apt-get install -y --no-install-recommends \
    wget \
    ca-certificates \
    libicu-dev \
    libssl-dev

# Download and run official install script
wget -q https://dot.net/v1/dotnet-install.sh -O /tmp/dotnet-install.sh
chmod +x /tmp/dotnet-install.sh

# Install to /usr/share/dotnet (system-wide)
/tmp/dotnet-install.sh --channel ${DOTNET_VERSION} --install-dir /usr/share/dotnet

# Create symlink
ln -sf /usr/share/dotnet/dotnet /usr/local/bin/dotnet

# Clean up
rm -f /tmp/dotnet-install.sh
apt-get clean
rm -rf /var/lib/apt/lists/*

# Create profile.d script for PATH
cat > /etc/profile.d/dotnet.sh << 'EOF'
export DOTNET_ROOT=/usr/share/dotnet
export PATH="$PATH:$HOME/.dotnet/tools"
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export DOTNET_NOLOGO=1
EOF

chmod +x /etc/profile.d/dotnet.sh

# Verify installation
echo ".NET SDK version: $(dotnet --version)"
echo ".NET SDKs installed:"
dotnet --list-sdks

echo "=== .NET SDK installed ==="
