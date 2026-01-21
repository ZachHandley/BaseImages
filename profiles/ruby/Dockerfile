# BaseImages - Ruby Profile
# Ubuntu 22.04 with Ruby 3.3
# ghcr.io/zachhandley/baseimages/ruby

FROM ubuntu:22.04

LABEL org.opencontainers.image.source="https://github.com/ZachHandley/BaseImages"
LABEL org.opencontainers.image.description="Ubuntu image with Ruby dev tools for CI"
LABEL org.opencontainers.image.licenses="MIT"
LABEL maintainer="Zach Handley <zachhandley@gmail.com>"

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV TZ=UTC
ENV PATH=/root/.local/bin:$PATH

# Allow Ruby version override via build arg
ARG RUBY_VERSION=3.3.0
ENV RUBY_VERSION=${RUBY_VERSION}

# Copy install scripts
COPY scripts/install-base.sh /tmp/scripts/
COPY scripts/install-ruby.sh /tmp/scripts/
COPY scripts/setup-user.sh /tmp/scripts/

# Run installation
RUN chmod +x /tmp/scripts/*.sh && \
    /tmp/scripts/install-base.sh && \
    /tmp/scripts/install-ruby.sh && \
    /tmp/scripts/setup-user.sh && \
    rm -rf /tmp/scripts

# Set the working directory
WORKDIR /workspace

# Default to bash
CMD ["/bin/bash"]
