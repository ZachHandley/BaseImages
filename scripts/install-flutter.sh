#!/bin/bash
set -e

# Install Flutter SDK (stable channel)

echo "=== Installing Flutter SDK ==="

FLUTTER_DIR=/opt/flutter

if [ -d "$FLUTTER_DIR" ]; then
    echo "Flutter already installed at $FLUTTER_DIR"
    exit 0
fi

git clone --depth 1 --branch stable https://github.com/flutter/flutter.git "$FLUTTER_DIR"

# Add Flutter to PATH for all users
cat > /etc/profile.d/flutter.sh << 'PROFILE'
export FLUTTER_HOME=/opt/flutter
export PATH="$FLUTTER_HOME/bin:$PATH"
PROFILE

# Verify installation
$FLUTTER_DIR/bin/flutter config --no-analytics
$FLUTTER_DIR/bin/flutter --version

echo "=== Flutter SDK installed ==="
