#!/bin/bash

# RL-Swarm Setup Script
# This script automates the installation of dependencies and cloning of rl-swarm
# Run without sudo - it will prompt for password when needed

set -e  # Exit on error

echo "Starting RL-Swarm setup..."
echo "================================"

# Update and upgrade system
echo "Updating package lists..."
apt update && apt upgrade -y

# Install system dependencies
echo "Installing system dependencies..."
apt install screen curl iptables build-essential git wget lz4 jq make gcc nano \
    automake autoconf tmux htop nvme-cli libgbm1 pkg-config libssl-dev \
    libleveldb-dev tar clang bsdmainutils ncdu unzip -y

# Install Python3 and related packages
echo "Installing Python3 and pip..."
apt install python3 python3-pip python3-venv python3-dev -y

# Update again
echo "Running final apt update..."
apt update

# Install Node.js 22.x
echo "Installing Node.js 22.x..."
curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
apt install -y nodejs

# Verify Node.js installation
echo "Node.js version:"
node -v

# Install Yarn via npm
echo "Installing Yarn..."
npm install -g yarn

# Verify Yarn installation
echo "Yarn version:"
yarn -v

# Install Yarn via install script (alternative method)
echo "Installing Yarn via install script..."
curl -o- -L https://yarnpkg.com/install.sh | bash

# Update PATH for current session
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Add PATH to bashrc if not already present
if ! grep -q ".yarn/bin" ~/.bashrc; then
    echo 'export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"' >> ~/.bashrc
fi

# Source bashrc
source ~/.bashrc

# Clone rl-swarm repository
echo "Cloning rl-swarm repository..."
if [ -d "rl-swarm" ]; then
    echo "rl-swarm directory already exists. Skipping clone."
else
    git clone https://github.com/gensyn-ai/rl-swarm/
fi

echo "================================"
echo "Setup complete!"
echo "rl-swarm has been cloned to: $(pwd)/rl-swarm"
echo ""
echo "Note: You may need to run 'source ~/.bashrc' or restart your terminal"
echo "to ensure PATH changes take effect."
