# BaseImages - Java Profile
# Ubuntu 22.04 with OpenJDK 21, Maven, and Gradle
# ghcr.io/zachhandley/baseimages/java

FROM ubuntu:22.04

LABEL org.opencontainers.image.source="https://github.com/ZachHandley/BaseImages"
LABEL org.opencontainers.image.description="Ubuntu image with Java (OpenJDK 21), Maven, and Gradle for CI"
LABEL org.opencontainers.image.licenses="MIT"
LABEL maintainer="Zach Handley <zachhandley@gmail.com>"

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV TZ=UTC
ENV JAVA_VERSION=21
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
ENV GRADLE_HOME=/opt/gradle
ENV PATH="$GRADLE_HOME/bin:$JAVA_HOME/bin:$PATH"

# Copy install scripts
COPY scripts/install-base.sh /tmp/scripts/
COPY scripts/install-java.sh /tmp/scripts/
COPY scripts/setup-user.sh /tmp/scripts/

# Run installation
RUN chmod +x /tmp/scripts/*.sh && \
    /tmp/scripts/install-base.sh && \
    /tmp/scripts/install-java.sh && \
    /tmp/scripts/setup-user.sh && \
    rm -rf /tmp/scripts

# Set the working directory
WORKDIR /workspace

# Default to bash
CMD ["/bin/bash"]
