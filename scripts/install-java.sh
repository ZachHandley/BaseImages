#!/bin/bash
set -e

# Install Java (OpenJDK 21) with Maven and Gradle
# Uses official Ubuntu repositories and SDKMAN for Gradle

echo "=== Installing Java, Maven, and Gradle ==="

export DEBIAN_FRONTEND=noninteractive

# Determine Java version (default to 21 - latest LTS)
JAVA_VERSION="${JAVA_VERSION:-21}"

# Install OpenJDK
apt-get update
apt-get install -y --no-install-recommends \
    openjdk-${JAVA_VERSION}-jdk \
    openjdk-${JAVA_VERSION}-jdk-headless

# Install Maven
apt-get install -y --no-install-recommends maven

# Install Gradle via direct download (for latest version)
GRADLE_VERSION="${GRADLE_VERSION:-8.12}"
wget -q https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -O /tmp/gradle.zip
unzip -q /tmp/gradle.zip -d /opt
ln -sf /opt/gradle-${GRADLE_VERSION} /opt/gradle
rm -f /tmp/gradle.zip

# Create profile.d script for Java/Gradle
cat > /etc/profile.d/java.sh << 'EOF'
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
export GRADLE_HOME=/opt/gradle
export PATH="$GRADLE_HOME/bin:$JAVA_HOME/bin:$PATH"
EOF

chmod +x /etc/profile.d/java.sh

# Source for this script
export JAVA_HOME=/usr/lib/jvm/java-${JAVA_VERSION}-openjdk-amd64
export GRADLE_HOME=/opt/gradle
export PATH="$GRADLE_HOME/bin:$JAVA_HOME/bin:$PATH"

# Clean up
apt-get clean
rm -rf /var/lib/apt/lists/*

# Verify installation
echo "Java version: $(java --version | head -1)"
echo "Maven version: $(mvn --version | head -1)"
echo "Gradle version: $(gradle --version | grep Gradle)"

echo "=== Java, Maven, and Gradle installed ==="
