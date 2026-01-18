#!/bin/bash
set -e

# Install database clients
# PostgreSQL client, MySQL client, Redis CLI, SQLite

echo "=== Installing database clients ==="

export DEBIAN_FRONTEND=noninteractive

apt-get update

# Install PostgreSQL client
apt-get install -y --no-install-recommends \
    postgresql-client \
    libpq-dev

# Install MySQL/MariaDB client
apt-get install -y --no-install-recommends \
    default-mysql-client \
    libmysqlclient-dev

# Install Redis CLI
apt-get install -y --no-install-recommends \
    redis-tools

# Install SQLite
apt-get install -y --no-install-recommends \
    sqlite3 \
    libsqlite3-dev

# Install MongoDB shell (mongosh)
wget -qO- https://www.mongodb.org/static/pgp/server-7.0.asc | gpg --dearmor -o /usr/share/keyrings/mongodb-server-7.0.gpg
echo "deb [signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-7.0.list
apt-get update
apt-get install -y --no-install-recommends mongodb-mongosh

# Clean up
apt-get clean
rm -rf /var/lib/apt/lists/*

# Verify installation
echo "PostgreSQL client version: $(psql --version)"
echo "MySQL client version: $(mysql --version)"
echo "Redis CLI version: $(redis-cli --version)"
echo "SQLite version: $(sqlite3 --version)"
echo "MongoDB shell version: $(mongosh --version)"

echo "=== Database clients installed ==="
