# BaseImages - Rust + Containerd Profile
# Ubuntu 22.04 with Rust stable + containerd for E2E testing
# ghcr.io/zachhandley/baseimages/rust-containerd

FROM ubuntu:22.04

LABEL org.opencontainers.image.source="https://github.com/ZachHandley/BaseImages"
LABEL org.opencontainers.image.description="Ubuntu image with Rust stable and containerd for CI E2E testing"
LABEL org.opencontainers.image.licenses="MIT"
LABEL maintainer="Zach Handley <zachhandley@gmail.com>"

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV TZ=UTC
ENV RUSTUP_HOME=/usr/local/rustup
ENV CARGO_HOME=/usr/local/cargo
ENV PATH=/usr/local/cargo/bin:$PATH
ENV INSTALL_CARGO_TOOLS=0

# Copy install scripts
COPY scripts/install-base.sh /tmp/scripts/
COPY scripts/install-rust.sh /tmp/scripts/
COPY scripts/setup-user.sh /tmp/scripts/

# Run base and rust installation
RUN chmod +x /tmp/scripts/*.sh && \
    /tmp/scripts/install-base.sh && \
    /tmp/scripts/install-rust.sh && \
    /tmp/scripts/setup-user.sh && \
    rm -rf /tmp/scripts

# Install containerd, runc, and related tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    containerd \
    runc \
    protobuf-compiler \
    iptables \
    iproute2 \
    fuse-overlayfs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create containerd config with native snapshotter (overlayfs doesn't work in nested containers)
RUN mkdir -p /etc/containerd && \
    containerd config default > /etc/containerd/config.toml && \
    sed -i 's/snapshotter = "overlayfs"/snapshotter = "native"/' /etc/containerd/config.toml

# Create required directories
RUN mkdir -p /run/containerd /var/lib/containerd

# Set the working directory
WORKDIR /workspace

# Default to bash
CMD ["/bin/bash"]
