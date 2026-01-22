# BaseImages - Ruby Alpine Profile
# Alpine Linux with Ruby 3.3
# ghcr.io.zachhandley/baseimages/ruby-alpine

FROM ghcr.io/zachhandley/baseimages/alpine

LABEL org.opencontainers.image.source="https://github.com/ZachHandley/BaseImages"
LABEL org.opencontainers.image.description="Alpine image with Ruby dev tools for CI"
LABEL org.opencontainers.image.licenses="MIT"
LABEL maintainer="Zach Handley <zachhandley@gmail.com>"

# Set environment variables
ENV PATH=/root/.local/bin:$PATH

# Allow Ruby version override via build arg
ARG RUBY_VERSION=3.3.0
ENV RUBY_VERSION=${RUBY_VERSION}

# Copy install scripts
COPY scripts/install-ruby-alpine.sh /tmp/scripts/

# Run installation
RUN chmod +x /tmp/scripts/*.sh && \
    /tmp/scripts/install-ruby-alpine.sh && \
    rm -rf /tmp/scripts

# Set the working directory
WORKDIR /workspace

# Default to bash
CMD ["/bin/bash"]
