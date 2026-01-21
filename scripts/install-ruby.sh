#!/bin/bash
set -e

# Install Ruby via rbenv with version override support
# Usage: RUBY_VERSION=3.3.0 ./install-ruby.sh

echo "=== Installing Ruby ==="

# Determine Ruby version (default to latest stable)
RUBY_VERSION="${RUBY_VERSION:-3.3.0}"

echo "==> Installing Ruby dependencies..."
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y --no-install-recommends \
    libssl-dev \
    libreadline-dev \
    zlib1g-dev \
    libffi-dev \
    libyaml-dev \
    libgmp-dev

echo "==> Installing rbenv..."
git clone https://github.com/rbenv/rbenv.git /opt/rbenv
git clone https://github.com/rbenv/ruby-build.git /opt/rbenv/plugins/ruby-build

# Add rbenv to PATH for all users
cat > /etc/profile.d/rbenv.sh << 'EOF'
export RBENV_ROOT=/opt/rbenv
export PATH="$RBENV_ROOT/bin:$PATH"
eval "$(rbenv init - bash)"
EOF

# Source rbenv for current session
export RBENV_ROOT=/opt/rbenv
export PATH="$RBENV_ROOT/bin:$PATH"
eval "$(rbenv init - bash)"

echo "==> Installing Ruby ${RUBY_VERSION}..."
rbenv install "${RUBY_VERSION}"
rbenv global "${RUBY_VERSION}"

echo "==> Installing bundler and rake..."
gem install bundler rake

echo "==> Installing common gems..."
gem install rspec rubocop pry solargraph ruby-lsp

# Clean up
apt-get clean
rm -rf /var/lib/apt/lists/*

# Verify installation
echo "Ruby version: $(ruby --version)"
echo "Bundler version: $(bundler --version)"

echo "=== Ruby ${RUBY_VERSION} installed ==="
