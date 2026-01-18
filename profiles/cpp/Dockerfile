# BaseImages - C/C++ Profile
# Ubuntu 22.04 with C/C++ toolchain (gcc, g++, clang, cmake, ninja)
# ghcr.io/zachhandley/baseimages/cpp

FROM ubuntu:22.04

LABEL org.opencontainers.image.source="https://github.com/ZachHandley/BaseImages"
LABEL org.opencontainers.image.description="Ubuntu image with C/C++ toolchain for CI"
LABEL org.opencontainers.image.licenses="MIT"
LABEL maintainer="Zach Handley <zachhandley@gmail.com>"

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV TZ=UTC
ENV CC=gcc
ENV CXX=g++
ENV PATH="/usr/lib/ccache:$PATH"

# Copy install scripts
COPY scripts/install-base.sh /tmp/scripts/
COPY scripts/install-cpp.sh /tmp/scripts/
COPY scripts/setup-user.sh /tmp/scripts/

# Run installation
RUN chmod +x /tmp/scripts/*.sh && \
    /tmp/scripts/install-base.sh && \
    /tmp/scripts/install-cpp.sh && \
    /tmp/scripts/setup-user.sh && \
    rm -rf /tmp/scripts

# Set the working directory
WORKDIR /workspace

# Default to bash
CMD ["/bin/bash"]
