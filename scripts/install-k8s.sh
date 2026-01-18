#!/bin/bash
set -e

# Install Kubernetes tools
# kubectl, helm

echo "=== Installing Kubernetes tools ==="

export DEBIAN_FRONTEND=noninteractive

# Detect architecture
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        K8S_ARCH="amd64"
        ;;
    aarch64|arm64)
        K8S_ARCH="arm64"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

# Install kubectl
echo "Installing kubectl..."
KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${K8S_ARCH}/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/kubectl

# Install Helm
echo "Installing Helm..."
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Install additional useful tools
apt-get update
apt-get install -y --no-install-recommends \
    gettext-base  # For envsubst in k8s manifests

# Clean up
apt-get clean
rm -rf /var/lib/apt/lists/*

# Create profile.d script for kubectl completion
cat > /etc/profile.d/k8s.sh << 'EOF'
# Enable kubectl completion
if command -v kubectl &>/dev/null; then
    source <(kubectl completion bash)
    alias k=kubectl
    complete -o default -F __start_kubectl k
fi

# Enable helm completion
if command -v helm &>/dev/null; then
    source <(helm completion bash)
fi
EOF

chmod +x /etc/profile.d/k8s.sh

# Verify installation
echo "kubectl version: $(kubectl version --client --short 2>/dev/null || kubectl version --client)"
echo "Helm version: $(helm version --short)"

echo "=== Kubernetes tools installed ==="
