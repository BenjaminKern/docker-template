#!/bin/bash
set -euo pipefail
shopt -s nullglob globstar

IMAGE_PREFIX=$1

DOCKER_BUILDKIT=1 docker build . \
  --build-arg DOCKER_GID="$(getent group docker | cut -d : -f 3)" \
  --build-arg USER="$(whoami)" \
  --build-arg UID="$(id -u)" \
  --build-arg GID="$(id -g)" \
  --build-arg PACKAGES="$(cat packages.txt | tr '\n' ' ')"
  -t "${IMAGE_PREFIX}-dev:latest"
