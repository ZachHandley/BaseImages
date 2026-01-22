# BaseImages - Flutter Profile
# Ubuntu 22.04 with Flutter SDK
# ghcr.io.zachhandley/baseimages/flutter

FROM ghcr.io/zachhandley/baseimages/base

LABEL org.opencontainers.image.source="https://github.com/ZachHandley/BaseImages"
LABEL org.opencontainers.image.description="Ubuntu image with Flutter SDK for CI"
LABEL org.opencontainers.image.licenses="MIT"
LABEL maintainer="Zach Handley <zachhandley@gmail.com>"

# Copy install scripts
COPY scripts/install-flutter.sh /tmp/scripts/

# Run installation
RUN chmod +x /tmp/scripts/*.sh && \
    /tmp/scripts/install-flutter.sh && \
    rm -rf /tmp/scripts

# Set the working directory
WORKDIR /workspace

# Default to bash
CMD ["/bin/bash"]
