#!/bin/bash
set -e

# Set up a non-root user for CI operations
# This creates a 'runner' user with sudo access

echo "=== Setting up CI user ==="

CI_USER="${CI_USER:-runner}"
CI_UID="${CI_UID:-1000}"
CI_GID="${CI_GID:-1000}"

# Create group if it doesn't exist
if ! getent group "$CI_USER" > /dev/null 2>&1; then
    groupadd --gid "$CI_GID" "$CI_USER"
fi

# Create user if it doesn't exist
if ! id "$CI_USER" > /dev/null 2>&1; then
    useradd --uid "$CI_UID" --gid "$CI_GID" --create-home --shell /bin/bash "$CI_USER"
fi

# Add user to sudo group
usermod -aG sudo "$CI_USER"

# Allow passwordless sudo
echo "$CI_USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$CI_USER
chmod 0440 /etc/sudoers.d/$CI_USER

# Set up user's bashrc with PATH extensions
cat >> /home/$CI_USER/.bashrc << 'EOF'

# Source profile.d scripts for tool paths
for script in /etc/profile.d/*.sh; do
    [ -r "$script" ] && source "$script"
done
EOF

chown $CI_USER:$CI_USER /home/$CI_USER/.bashrc

echo "=== CI user '$CI_USER' created with sudo access ==="
