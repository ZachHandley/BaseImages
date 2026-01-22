#!/bin/sh
set -e

# Install Ruby via rbenv on Alpine
# Usage: RUBY_VERSION=3.3.0 ./install-ruby-alpine.sh

echo "=== Installing Ruby on Alpine ==="

# Determine Ruby version (default to latest stable)
RUBY_VERSION="${RUBY_VERSION:-3.3.0}"

echo "==> Installing Ruby dependencies..."
apk update
apk add --no-cache \
    libssl-dev \
    readline-dev \
    zlib-dev \
    libffi-dev \
    yaml-dev \
    gmp-dev \
    build-base \
    git

echo "==> Installing rbenv..."
git clone https://github.com/rbenv/rbenv.git /opt/rbenv
git clone https://github.com/rbenv/ruby-build.git /opt/rbenv/plugins/ruby-build

# Add rbenv to PATH for all users
cat > /etc/profile.d/rbenv.sh << 'EOF'
export RBENV_ROOT=/opt/rbenv
export PATH="$RBENV_ROOT/bin:$PATH"
eval "$(rbenv init - sh)"
EOF

# Source rbenv for current session
export RBENV_ROOT=/opt/rbenv
export PATH="$RBENV_ROOT/bin:$PATH"
eval "$(rbenv init - sh)"

echo "==> Installing Ruby ${RUBY_VERSION}..."
rbenv install "${RUBY_VERSION}"
rbenv global "${RUBY_VERSION}"

echo "==> Installing bundler and rake..."
gem install bundler rake

echo "==> Installing common gems..."
gem install rspec rubocop pry solargraph ruby-lsp

# Clean up
rm -rf /var/cache/apk/*

# Verify installation
echo "Ruby version: $(ruby --version)"
echo "Bundler version: $(bundler --version)"

echo "=== Ruby ${RUBY_VERSION} installed on Alpine ==="
