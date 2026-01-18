#!/bin/bash
set -e

# Install Docker CLI (not the daemon, just CLI for docker build commands)
# For use in CI environments where Docker daemon is provided by the host

echo "=== Installing Docker CLI ==="

export DEBIAN_FRONTEND=noninteractive

# Install prerequisites
apt-get update
apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gnupg

# Add Docker's official GPG key
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

# Set up the repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker CLI and plugins (no docker-ce which includes daemon)
apt-get update
apt-get install -y --no-install-recommends \
    docker-ce-cli \
    docker-buildx-plugin \
    docker-compose-plugin

# Clean up
apt-get clean
rm -rf /var/lib/apt/lists/*

# Verify installation
echo "Docker CLI version: $(docker --version)"
echo "Docker Compose version: $(docker compose version)"
echo "Docker Buildx version: $(docker buildx version)"

echo "=== Docker CLI installed ==="
