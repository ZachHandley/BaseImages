# BaseImages - Node + .NET Profile
# Ubuntu 22.04 with Node.js LTS and .NET SDK
# ghcr.io/zachhandley/baseimages/node-dotnet

FROM ubuntu:22.04

LABEL org.opencontainers.image.source="https://github.com/ZachHandley/BaseImages"
LABEL org.opencontainers.image.description="Ubuntu image with Node.js and .NET for full-stack CI"
LABEL org.opencontainers.image.licenses="MIT"
LABEL maintainer="Zach Handley <zachhandley@gmail.com>"

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV TZ=UTC
ENV NODE_MAJOR=22
ENV DOTNET_VERSION=9.0
ENV DOTNET_ROOT=/usr/share/dotnet
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
ENV DOTNET_NOLOGO=1
ENV PATH="$PATH:/root/.dotnet/tools"

# Copy install scripts
COPY scripts/install-base.sh /tmp/scripts/
COPY scripts/install-dotnet.sh /tmp/scripts/
COPY scripts/setup-user.sh /tmp/scripts/

# Run installation (node is included in install-base.sh)
RUN chmod +x /tmp/scripts/*.sh && \
    /tmp/scripts/install-base.sh && \
    /tmp/scripts/install-dotnet.sh && \
    /tmp/scripts/setup-user.sh && \
    rm -rf /tmp/scripts

# Set the working directory
WORKDIR /workspace

# Default to bash
CMD ["/bin/bash"]
