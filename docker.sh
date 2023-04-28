#!/bin/bash

# Uninstall older versions
sudo apt-get remove docker docker-engine docker.io containerd runc
# Define the path to the program
PROGRAM_PATH=/opt/myprogram

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Install Docker Compose version 1
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o ${PROGRAM_PATH}/docker-compose-v1
sudo chmod +x ${PROGRAM_PATH}/docker-compose-v1

# Install Docker Compose version 2
sudo curl -L "https://github.com/docker/compose-cli/releases/download/v2.1.1/docker-compose-$(uname -s)-$(uname -m)" -o ${PROGRAM_PATH}/docker-compose-v2
sudo chmod +x ${PROGRAM_PATH}/docker-compose-v2

# Create symbolic links based on the current version
CURRENT_VERSION=$(readlink ${PROGRAM_PATH}/current)
ln -sf ${CURRENT_VERSION}/docker-compose-v1 /usr/local/bin/docker-compose
ln -sf ${CURRENT_VERSION}/docker-compose-v2 /usr/local/bin/docker-compose-v2

# Add current user to docker group
sudo usermod -aG docker $(whoami)

# Grant sudo privileges for Docker commands to current user
sudo sh -c 'echo "$(whoami) ALL=(ALL) NOPASSWD: /usr/bin/docker" >> /etc/sudoers.d/docker'
