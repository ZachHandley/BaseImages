#!/bin/bash
set -e

# Install .NET SDK (latest LTS)
# Uses official Microsoft repository

echo "=== Installing .NET SDK ==="

export DEBIAN_FRONTEND=noninteractive

# Determine .NET version (default to 9 - latest LTS)
DOTNET_VERSION="${DOTNET_VERSION:-9.0}"

# Install dependencies
apt-get update
apt-get install -y --no-install-recommends \
    wget \
    apt-transport-https \
    software-properties-common

# Get Ubuntu version
UBUNTU_VERSION=$(lsb_release -rs)

# Add Microsoft package repository
wget -q https://packages.microsoft.com/config/ubuntu/${UBUNTU_VERSION}/packages-microsoft-prod.deb -O /tmp/packages-microsoft-prod.deb
dpkg -i /tmp/packages-microsoft-prod.deb
rm -f /tmp/packages-microsoft-prod.deb

# Update and install .NET SDK
apt-get update
apt-get install -y --no-install-recommends dotnet-sdk-${DOTNET_VERSION}

# Install common global tools
dotnet tool install --global dotnet-ef || true
dotnet tool install --global dotnet-outdated-tool || true

# Create profile.d script for PATH
cat > /etc/profile.d/dotnet.sh << 'EOF'
export DOTNET_ROOT=/usr/share/dotnet
export PATH="$PATH:$HOME/.dotnet/tools"
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export DOTNET_NOLOGO=1
EOF

chmod +x /etc/profile.d/dotnet.sh

# Clean up
apt-get clean
rm -rf /var/lib/apt/lists/*

# Verify installation
echo ".NET SDK version: $(dotnet --version)"
echo ".NET SDKs installed:"
dotnet --list-sdks

echo "=== .NET SDK installed ==="
