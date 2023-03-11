#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

docker stop llama-cpu 2>/dev/null 2>&1
docker image rm llama-cpu --force
docker system prune --force
