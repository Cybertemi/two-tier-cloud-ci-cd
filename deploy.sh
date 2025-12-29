#!/bin/bash
set -e

# Install Docker if missing
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    sudo apt-get update -y
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
    sudo apt-get update -y
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
fi

# Add ubuntu user to docker group
sudo usermod -aG docker ubuntu
newgrp docker

# Install docker compose if missing
if ! command -v docker-compose &> /dev/null; then
    sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-$(uname -s)-$(uname -m)" \
        -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

# Clone or update repo
APP_DIR="/home/ubuntu/two-tier-app"

if [ ! -d "$APP_DIR" ]; then
    git clone https://github.com/Cybertemi/two-tier-cloud-ci-cd.git $APP_DIR
else
    cd $APP_DIR
    git pull
fi

cd $APP_DIR

# Stop old containers
docker compose down || true

# Pull latest image & start
docker compose pull
docker compose up -d

echo "✅ Deployment completed successfully!"
