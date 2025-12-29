#!/bin/bash

#!/bin/bash
set -e

# Install Docker if not installed
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    sudo apt-get update -y
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
        | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update -y
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
fi


# Install Docker Compose if not installed
if ! command -v docker-compose &> /dev/null; then
    echo "Installing Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

# Stop all running containers
if [ "$(docker ps -q)" ]; then
    echo "Stopping all running containers..."
    docker stop $(docker ps -q)
fi

# Optionally remove all stopped containers to avoid conflicts
if [ "$(docker ps -aq)" ]; then
    echo "Removing all stopped containers..."
    docker rm $(docker ps -aq)
fi

# Pull latest images and start containers
cd /home/ubuntu/two-tier-app
docker-compose pull
docker-compose up -d

echo "Deployment successful!"
