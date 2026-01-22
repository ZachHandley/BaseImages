#!/bin/sh
set -e

# Install Ruby via apk on Alpine

echo "=== Installing Ruby on Alpine ==="

echo "==> Installing Ruby packages..."
apk update
apk add --no-cache \
    ruby \
    ruby-dev \
    ruby-bundler \
    ruby-rake \
    ruby-irb \
    ruby-json \
    ruby-bigdecimal \
    git

echo "==> Installing common gems..."
gem install rspec rubocop pry solargraph ruby-lsp

# Clean up
rm -rf /var/cache/apk/*

# Verify installation
echo "Ruby version: $(ruby --version)"
echo "Bundler version: $(bundler --version)"

echo "=== Ruby installed on Alpine ==="
