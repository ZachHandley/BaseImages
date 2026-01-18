#!/bin/bash
set -e

# Install C/C++ toolchain
# gcc, g++, clang, cmake, ninja-build

echo "=== Installing C/C++ toolchain ==="

export DEBIAN_FRONTEND=noninteractive

# Install GCC and G++ (latest available in repos)
apt-get update
apt-get install -y --no-install-recommends \
    gcc \
    g++ \
    gdb \
    make \
    autoconf \
    automake \
    libtool \
    pkg-config

# Install Clang and LLVM
apt-get install -y --no-install-recommends \
    clang \
    clang-format \
    clang-tidy \
    llvm \
    lld

# Install build tools
apt-get install -y --no-install-recommends \
    cmake \
    ninja-build \
    meson \
    ccache

# Install common development libraries
apt-get install -y --no-install-recommends \
    libstdc++-12-dev \
    libc6-dev

# Create profile.d script for ccache
cat > /etc/profile.d/cpp.sh << 'EOF'
# Enable ccache by default
export PATH="/usr/lib/ccache:$PATH"
export CCACHE_DIR="$HOME/.ccache"
EOF

chmod +x /etc/profile.d/cpp.sh

# Clean up
apt-get clean
rm -rf /var/lib/apt/lists/*

# Verify installation
echo "GCC version: $(gcc --version | head -1)"
echo "G++ version: $(g++ --version | head -1)"
echo "Clang version: $(clang --version | head -1)"
echo "CMake version: $(cmake --version | head -1)"
echo "Ninja version: $(ninja --version)"

echo "=== C/C++ toolchain installed ==="
