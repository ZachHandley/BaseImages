# BaseImages - Rust Profile
# Ubuntu 22.04 with Rust stable
# ghcr.io/zachhandley/baseimages/rust

FROM ubuntu:22.04

LABEL org.opencontainers.image.source="https://github.com/ZachHandley/BaseImages"
LABEL org.opencontainers.image.description="Ubuntu image with Rust stable for CI"
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

# Run installation
RUN chmod +x /tmp/scripts/*.sh && \
    /tmp/scripts/install-base.sh && \
    /tmp/scripts/install-rust.sh && \
    /tmp/scripts/setup-user.sh && \
    rm -rf /tmp/scripts

# Set the working directory
WORKDIR /workspace

# Default to bash
CMD ["/bin/bash"]
