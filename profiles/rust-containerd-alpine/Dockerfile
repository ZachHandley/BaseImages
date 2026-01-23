# BaseImages - Rust + Containerd Alpine Profile
# Alpine Linux with Rust stable + containerd for E2E testing
# ghcr.io/zachhandley/baseimages/rust-containerd-alpine

FROM ghcr.io/zachhandley/baseimages/alpine

LABEL org.opencontainers.image.source="https://github.com/ZachHandley/BaseImages"
LABEL org.opencontainers.image.description="Alpine image with Rust stable and containerd for CI E2E testing"
LABEL org.opencontainers.image.licenses="MIT"
LABEL maintainer="Zach Handley <zachhandley@gmail.com>"

# Set environment variables
ENV RUSTUP_HOME=/usr/local/rustup
ENV CARGO_HOME=/usr/local/cargo
ENV PATH=/usr/local/cargo/bin:$PATH
ENV INSTALL_CARGO_TOOLS=0

# Copy install scripts
COPY scripts/install-rust.sh /tmp/scripts/

# Run rust installation
RUN chmod +x /tmp/scripts/*.sh && \
    /tmp/scripts/install-rust.sh && \
    rm -rf /tmp/scripts

# Install containerd, runc, and related tools
RUN apk add --no-cache \
    containerd \
    containerd-ctr \
    runc \
    protobuf \
    iptables \
    iproute2 \
    fuse-overlayfs

# Create containerd config for nested container operation (use native snapshotter)
RUN mkdir -p /etc/containerd && \
    containerd config default > /etc/containerd/config.toml && \
    sed -i 's/snapshotter = "overlayfs"/snapshotter = "native"/g' /etc/containerd/config.toml && \
    sed -i 's/\[plugins\."io\.containerd\.snapshotter\.v1\.overlayfs"\]/[plugins."io.containerd.snapshotter.v1.native"]/g' /etc/containerd/config.toml

# Create required directories
RUN mkdir -p /run/containerd /var/lib/containerd

# Set the working directory
WORKDIR /workspace

# Default to sh (Alpine default)
CMD ["/bin/sh"]
