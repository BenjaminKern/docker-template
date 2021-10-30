#!/bin/bash
set -e

DOCKER_TAG=dev-$(git log -1 --pretty=%h)-base
CONTAINER_NAME=${DOCKER_TAG}-container

set +e
docker container inspect $CONTAINER_NAME > /dev/null 2>&1
ret=$?
[[ $ret -eq 0 ]] && docker exec -it $CONTAINER_NAME bash
set -e

docker run --rm -it \
  --network host \
  --name $CONTAINER_NAME \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $(pwd)/workspace:/workspace \
  ${DOCKER_TAG} bash
