#!/bin/bash

# MONGO DOCKER IS DANGEROUS WITHOUT THIS PATCH!
# By default DOCKER ON LINUX will open the mongo port to the world!
# Improved version will make sure that IPtables does not get messed with on linux systems!

CONTAINER_NAME="mongo-dev"
VOLUME_NAME="mongo-dev-data"
MONGO_IMAGE="mongo:latest"
MONGO_PORT="27017:27017"
MONGO_ROOT_PW="asdasdasdaasd"
MONGO_ROOT_USER="adminperson"
DAEMON_CONFIG="/etc/docker/daemon.json"
DEFAULT_CONTENT="{"iptables": false}"

set -x

# If the file doesn't exist, create it with the default content.
if [ ! -f "$DAEMON_CONFIG" ]; then
    echo "$DEFAULT_CONTENT" > "$DAEMON_CONFIG" || { 
        echo "Error: Failed to create file $DAEMON_CONFIG" >&2; 
        exit 1; 
    }
else
    # If the file exists, check if it already contains the key-value pair.
    if grep -q '"iptables":[[:space:]]*false' "$DAEMON_CONFIG"; then
        # The required key-value pair is present; nothing to do.
	echo "File $DAEMON_CONFIG is correct"
    else
        # Try to update the file.
        if command -v jq >/dev/null 2>&1; then
            TMP=$(mktemp) || { 
                echo "Error: Could not create a temporary file" >&2; 
                exit 1; 
            }
            if ! jq '.iptables = false' "$DAEMON_CONFIG" > "$TMP"; then
                echo "Error: Failed to modify file $DAEMON_CONFIG" >&2
                rm -f "$TMP"
                exit 1
            fi
            if ! mv "$TMP" "$DAEMON_CONFIG"; then
                echo "Error: Failed to update file $DAEMON_CONFIG" >&2
                rm -f "$TMP"
                exit 1
            fi
        else
            # Fallback: rewrite the file with default content (may override other modifications).
            echo "$DEFAULT_CONTENT" > "$DAEMON_CONFIG" || { 
                echo "Error: Failed to update file $DAEMON_CONFIG" >&2; 
                exit 1; 
            }
        fi
    fi
fi

# Insure docker is running

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
    # Volume does not exist, create a new one
    echo "> Volume does not exist, creating a new one..."
    docker volume create $VOLUME_NAME
fi

echo "* Volume $VOLUME_NAME is ready."

# Check if the container exists
container_exists=$(docker ps -a --format "{{.Names}}" | grep -w "$CONTAINER_NAME")

if [ -n "$container_exists" ]; then
    # Container exists, check if it's running
    is_running=$(docker inspect --format="{{.State.Running}}" $CONTAINER_NAME 2>/dev/null)

    if [ "$is_running" == "false" ]; then
        echo "Container exists but is not running, starting it..."
        docker start $CONTAINER_NAME
    else
        echo "Container is already running."
    fi
else
    # Container does not exist, run a new one
    echo "Container does not exist, running a new one..."
    docker run --name $CONTAINER_NAME -d -p $MONGO_PORT -e MONGO_INITDB_ROOT_USERNAME=$MONGO_ROOT_USER -e MONGO_INITDB_ROOT_PASSWORD=$MONGO_ROOT_PW -v $VOLUME_NAME:/data/db $MONGO_IMAGE 
#    docker run -d -p $MONGO_PORT --name $CONTAINER_NAME -v $VOLUME_NAME:/data/db $MONGO_IMAGE
fi
