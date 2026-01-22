# BaseImages - Rust + uv Profile
# Ubuntu 22.04 with Rust and uv tooling
# ghcr.io.zachhandley/baseimages/rust-uv

FROM ghcr.io/zachhandley/baseimages/base

LABEL org.opencontainers.image.source="https://github.com/ZachHandley/BaseImages"
LABEL org.opencontainers.image.description="Ubuntu image with Rust and uv for Python-native builds"
LABEL org.opencontainers.image.licenses="MIT"
LABEL maintainer="Zach Handley <zachhandley@gmail.com>"

# Copy install scripts
COPY scripts/install-rust.sh /tmp/scripts/
COPY scripts/install-python-dev.sh /tmp/scripts/

# Run installation
RUN chmod +x /tmp/scripts/*.sh && \
    /tmp/scripts/install-rust.sh && \
    /tmp/scripts/install-python-dev.sh && \
    rm -rf /tmp/scripts

# Set the working directory
WORKDIR /workspace

# Default to bash
CMD ["/bin/bash"]
