#!/bin/bash

set -e

echo "=================================="
echo "BlockAssist Automated Setup Script"
echo "=================================="
echo ""

# Update and upgrade system
echo "[1/8] Updating system packages..."
sudo apt update -y
sudo apt upgrade -y

# Install dependencies
echo "[2/8] Installing system dependencies..."
sudo apt install -y \
  make build-essential gcc \
  libssl-dev zlib1g-dev libbz2-dev libreadline-dev \
  libsqlite3-dev libncursesw5-dev xz-utils tk-dev \
  libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \
  curl git unzip \
  libxi6 libxrender1 libxtst6 libxrandr2 libglu1-mesa libopenal1

# Clone repository
echo "[3/8] Cloning blockassist repository..."
if [ -d "blockassist" ]; then
  echo "Directory 'blockassist' already exists. Skipping clone."
else
  git clone https://github.com/gensyn-ai/blockassist.git
fi
cd blockassist

# Remove old Node.js
echo "[4/8] Removing old Node.js installations..."
sudo apt remove -y nodejs npm || true

# Install Node.js 20.x
echo "[5/8] Installing Node.js 20.x..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Install Yarn
echo "[6/8] Installing Yarn..."
curl -o- -L https://yarnpkg.com/install.sh | bash
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Run setup script
echo "[7/8] Running BlockAssist setup script..."
chmod +x setup.sh
./setup.sh

# Install pyenv
echo "[8/8] Installing pyenv and Python 3.10..."
curl https://pyenv.run | bash

# Add pyenv to current shell
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# Add pyenv to shell profile for persistence
echo '' >> ~/.bashrc
echo '# Pyenv configuration' >> ~/.bashrc
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init --path)"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc

# Install Python 3.10
echo "Installing Python 3.10 (this may take a few minutes)..."
pyenv install 3.10 -s
pyenv global 3.10

# Install Python packages
echo "Installing Python packages..."
pip install --upgrade pip
pip install -e . --no-cache-dir
pip install "mbag-gensyn[malmo]" --no-cache-dir
pip install psutil readchar

echo ""
echo "=================================="
echo "Setup Complete!"
echo "=================================="
echo ""
echo "Please run: exec \$SHELL"
echo "Or close and reopen your terminal to apply all changes."
echo ""
