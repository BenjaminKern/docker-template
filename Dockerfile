FROM ubuntu:focal

RUN apt-get update -qq && \
  DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y cmake sudo ninja-build build-essential ca-certificates curl libarchive-tools && \
  rm -rf /var/lib/apt/lists/*

ARG USER=dockerusr
ARG UID=1000
ARG GID=1000
ARG DOCKER_GID=1234
RUN groupadd --gid $GID $USER && \
  groupadd --gid ${DOCKER_GID} docker && \
  useradd -c "" --no-log-init -u ${UID} -g ${GID} -m -G docker ${USER} && \
  echo $USER ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USER

USER ${USER}
WORKDIR /workspace
