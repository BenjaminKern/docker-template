#!/bin/bash
set -e

DOCKER_TAG=dev-$(git log -1 --pretty=%h)

DOCKER_BUILDKIT=1 docker build . \
  --build-arg DOCKER_GID="$(getent group docker | cut -d : -f 3)" \
  --build-arg USER="$(whoami)" \
  --build-arg UID="$(id -u)" \
  --build-arg GID="$(id -g)" \
  --build-arg PACKAGES="$(cat packages.txt | tr '\n' ' ')" \
  --target base \
  -t "${DOCKER_TAG}-base"

DOCKER_BUILDKIT=1 docker build . \
  --build-arg DOCKER_GID="$(getent group docker | cut -d : -f 3)" \
  --build-arg USER="$(whoami)" \
  --build-arg UID="$(id -u)" \
  --build-arg GID="$(id -g)" \
  --build-arg PACKAGES="$(cat packages.txt | tr '\n' ' ')" \
  --target devenv \
  -t "${DOCKER_TAG}-devenv"
