#!/bin/bash

# === OS Check ===
if [[ "$(uname)" == "Linux" ]]; then
  echo "⚠️  This script is not safe to run on Linux!"
  exit 1
fi

CONTAINER_NAME="mongo-dev"
VOLUME_NAME="mongo-dev-data"
MONGO_IMAGE="mongo:latest"
MONGO_PORT="27017:27017"

# Ensure Docker is running
open -a Docker

until docker info &> /dev/null
do
  echo "> Docker is starting up..."
  sleep 1
done

echo "* Docker is running"

# Check if the volume exists
volume_exists=$(docker volume ls --format "{{.Name}}" | grep -w "$VOLUME_NAME")

if [ -z "$volume_exists" ]; then
    echo "> Volume does not exist, creating a new one..."
    docker volume create $VOLUME_NAME
fi

echo "* Volume $VOLUME_NAME is ready."

# Check if the container exists
container_exists=$(docker ps -a --format "{{.Names}}" | grep -w "$CONTAINER_NAME")

if [ -n "$container_exists" ]; then
    is_running=$(docker inspect --format="{{.State.Running}}" $CONTAINER_NAME 2>/dev/null)

    if [ "$is_running" == "false" ]; then
        echo "Container exists but is not running, starting it..."
        docker start $CONTAINER_NAME
    else
        echo "Container is already running."
    fi
else
    echo "Container does not exist, running a new one..."
    docker run -d -p $MONGO_PORT --name $CONTAINER_NAME -v $VOLUME_NAME:/data/db $MONGO_IMAGE
fi
