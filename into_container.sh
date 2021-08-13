#!/bin/bash
set -euo pipefail
shopt -s nullglob globstar

docker run --rm -it \
  --network host \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v ${PROJECT_DOCKER_WORKSPACE}:/workspace \
  -v ~/.vscode-server:/home/${PROJECT_DOCKER_USER}/.vscode-server \
  ${PROJECT_DOCKER_NAME}-dev:latest sh
