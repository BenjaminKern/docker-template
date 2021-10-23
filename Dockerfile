FROM ubuntu:focal

RUN apt-get update -qq && \
  DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y cmake ninja-build build-essential ca-certificates curl libarchive-tools && \
  rm -rf /var/lib/apt/lists/*

ARG USER=dockerusr
ARG UID=1000
ARG DOCKER_GID=1234
RUN addgroup --gid "${DOCKER_GID}" docker && \
  useradd -c "" --no-log-init -u ${UID} -m -G docker "${USER}"

USER ${USER}
WORKDIR /workspace
