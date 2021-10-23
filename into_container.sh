#!/bin/bash
set -uo pipefail
shopt -s nullglob globstar

IMAGE_PREFIX=$1
CONTAINER_NAME=${IMAGE_PREFIX}-container

docker container inspect $CONTAINER_NAME > /dev/null 2>&1
ret=$?
[[ $ret -eq 0 ]] && docker exec -it $CONTAINER_NAME bash

docker run --rm -it \
  --network host \
  --name $CONTAINER_NAME \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $(pwd)/workspace:/workspace \
  ${IMAGE_PREFIX}-dev:latest bash
