# BaseImages - Rust + uv + Flutter Profile
# Ubuntu 22.04 with Rust, uv, and Flutter
# ghcr.io.zachhandley/baseimages/rust-uv-flutter

FROM ghcr.io/zachhandley/baseimages/base

LABEL org.opencontainers.image.source="https://github.com/ZachHandley/BaseImages"
LABEL org.opencontainers.image.description="Ubuntu image with Rust, uv, and Flutter for app builds"
LABEL org.opencontainers.image.licenses="MIT"
LABEL maintainer="Zach Handley <zachhandley@gmail.com>"

ENV INSTALL_CARGO_TOOLS=0

# Copy install scripts
COPY scripts/install-rust.sh /tmp/scripts/
COPY scripts/install-python-dev.sh /tmp/scripts/
COPY scripts/install-flutter.sh /tmp/scripts/

# Run installation
RUN chmod +x /tmp/scripts/*.sh && \
    /tmp/scripts/install-rust.sh && \
    /tmp/scripts/install-python-dev.sh && \
    /tmp/scripts/install-flutter.sh && \
    rm -rf /tmp/scripts

# Set the working directory
WORKDIR /workspace

# Default to bash
CMD ["/bin/bash"]
