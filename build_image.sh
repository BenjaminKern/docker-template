#!/bin/bash
set -euo pipefail
shopt -s nullglob globstar

DOCKER_BUILDKIT=1 docker build . \
  --build-arg DOCKER_GID="$(getent group docker | cut -d : -f 3)" \
  --build-arg USER="${PROJECT_DOCKER_USER}" \
  --build-arg UID="${PROJECT_DOCKER_USER_UID}" \
  -t "${PROJECT_DOCKER_NAME}-dev:latest"
