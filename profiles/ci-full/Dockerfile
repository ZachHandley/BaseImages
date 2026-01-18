# BaseImages - CI Full Profile
# Ubuntu 22.04 with Node.js, Rust, Python, and Go
# ghcr.io/zachhandley/baseimages/ci-full

FROM ubuntu:22.04

LABEL org.opencontainers.image.source="https://github.com/ZachHandley/BaseImages"
LABEL org.opencontainers.image.description="Full CI image with Node.js, Rust, Python, and Go"
LABEL org.opencontainers.image.licenses="MIT"
LABEL maintainer="Zach Handley <zachhandley@gmail.com>"

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV TZ=UTC
ENV NODE_MAJOR=22
ENV RUSTUP_HOME=/usr/local/rustup
ENV CARGO_HOME=/usr/local/cargo
ENV GOROOT=/usr/local/go
ENV GOPATH=/root/go
ENV PATH=/usr/local/cargo/bin:/usr/local/go/bin:$PATH

# Copy install scripts
COPY scripts/install-base.sh /tmp/scripts/
COPY scripts/install-node.sh /tmp/scripts/
COPY scripts/install-rust.sh /tmp/scripts/
COPY scripts/install-python.sh /tmp/scripts/
COPY scripts/install-go.sh /tmp/scripts/
COPY scripts/setup-user.sh /tmp/scripts/

# Run installation
RUN chmod +x /tmp/scripts/*.sh && \
    /tmp/scripts/install-base.sh && \
    /tmp/scripts/install-node.sh && \
    /tmp/scripts/install-rust.sh && \
    /tmp/scripts/install-python.sh && \
    /tmp/scripts/install-go.sh && \
    /tmp/scripts/setup-user.sh && \
    rm -rf /tmp/scripts

# Set the working directory
WORKDIR /workspace

# Default to bash
CMD ["/bin/bash"]
