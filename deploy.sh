#!/bin/bash

#!/bin/bash

# Exit immediately if a command fails
set -e

# Make sure Docker credentials are set via environment variables
if [ -z "$DOCKER_USERNAME" ] || [ -z "$DOCKER_PASSWORD" ]; then
    echo "ERROR: DOCKER_USERNAME or DOCKER_PASSWORD is not set"
    exit 1
fi

# Log in to Docker Hub
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

# Define your Docker image
IMAGE_NAME="$DOCKER_USERNAME/myapp:latest"
CONTAINER_NAME="myapp"

# Stop and remove existing container if it exists
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    echo "Stopping existing container..."
    docker stop $CONTAINER_NAME
fi

if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
    echo "Removing existing container..."
    docker rm $CONTAINER_NAME
fi

# Pull the latest image
echo "Pulling latest Docker image: $IMAGE_NAME"
docker pull $IMAGE_NAME

# Run the container
echo "Starting container: $CONTAINER_NAME"
docker run -d --name $CONTAINER_NAME -p 80:8000 $IMAGE_NAME

echo "Deployment successful!"
