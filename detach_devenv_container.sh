#!/bin/bash
set -e

DOCKER_TAG=dev-$(git log -1 --pretty=%h)-devenv
CONTAINER_NAME=${DOCKER_TAG}-container

docker run --rm -d \
  -p 7681:7681 \
  -p 443:443 \
  -p 80:80 \
  --name $CONTAINER_NAME \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $(pwd)/workspace:/workspace \
  ${DOCKER_TAG}
