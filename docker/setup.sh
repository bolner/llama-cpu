#!/usr/bin/env bash

if [ "$EUID" -eq 0 ]; then
    >&2 echo "This script should not be run as root."
    exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
cd ${DIR}

###################################################
# Verify the model directory
###################################################
if [[ $# -ne 1 ]]; then
    >&2 printf "\nPlease provide the model directory as parameter.\n\n"
    exit 1
fi

if [[ ! -d $1 ]]; then
    >&2 printf "\nThe provided argument is not an existing directory. Please provide the model directory.\n\n"
    exit 1
fi

MODEL_DIR="$( cd "${1}" && pwd )"

###################################################
# Build image
###################################################
docker build --tag llama-cpu -f docker/Dockerfile ./

###################################################
# Create container and configure it
###################################################
docker run -d -h llama-cpu --restart unless-stopped \
    -v "${DIR}:/var/llama-cpu" -v "${MODEL_DIR}:/mnt/models" \
    --name llama-cpu llama-cpu

docker exec --user root -it llama-cpu bash -c \
    "useradd -m -s /bin/bash -u $(id -u) $(whoami) \
    && chown -R $(whoami):$(whoami) /var/venv \
    && printf "\nsource /var/venv/bin/activate\n" >> /home/$(whoami)/.bashrc
