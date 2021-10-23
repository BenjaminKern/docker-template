#!/bin/bash
set -uo pipefail
shopt -s nullglob globstar

container_shell=sh

container_name=${PROJECT_DOCKER_NAME}-dev-container_name

docker container inspect $container_name > /dev/null 2>&1
ret=$?
[[ $ret -eq 0 ]] && docker exec -it $container_name $container_shell

docker run --rm -it \
  --network host \
  --name $container_name \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v ${PROJECT_DOCKER_WORKSPACE}:/workspace \
  ${PROJECT_DOCKER_NAME}-dev:latest $container_shell
