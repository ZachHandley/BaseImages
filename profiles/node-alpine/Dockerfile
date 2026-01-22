# BaseImages - Node Alpine Profile
# Alpine Linux with Node.js LTS
# ghcr.io.zachhandley/baseimages/node-alpine

FROM ghcr.io/zachhandley/baseimages/alpine

LABEL org.opencontainers.image.source="https://github.com/ZachHandley/BaseImages"
LABEL org.opencontainers.image.description="Alpine image with Node.js LTS for CI"
LABEL org.opencontainers.image.licenses="MIT"
LABEL maintainer="Zach Handley <zachhandley@gmail.com>"

# Set environment variables
ENV NODE_MAJOR=22

# Copy install scripts
COPY scripts/install-node-alpine.sh /tmp/scripts/

# Run installation
RUN chmod +x /tmp/scripts/*.sh && \
    /tmp/scripts/install-node-alpine.sh && \
    rm -rf /tmp/scripts

# Set the working directory
WORKDIR /workspace

# Default to bash
CMD ["/bin/bash"]
