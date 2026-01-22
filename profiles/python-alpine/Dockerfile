# BaseImages - Python Alpine Profile
# Alpine Linux with Python dev tools
# ghcr.io.zachhandley/baseimages/python-alpine

FROM ghcr.io/zachhandley/baseimages/alpine

LABEL org.opencontainers.image.source="https://github.com/ZachHandley/BaseImages"
LABEL org.opencontainers.image.description="Alpine image with Python dev tools for CI"
LABEL org.opencontainers.image.licenses="MIT"
LABEL maintainer="Zach Handley <zachhandley@gmail.com>"

# Set environment variables
ENV PATH=/root/.local/bin:$PATH

# Copy install scripts
COPY scripts/install-python-alpine.sh /tmp/scripts/

# Run installation
RUN chmod +x /tmp/scripts/*.sh && \
    /tmp/scripts/install-python-alpine.sh && \
    rm -rf /tmp/scripts

# Set the working directory
WORKDIR /workspace

# Default to bash
CMD ["/bin/bash"]
