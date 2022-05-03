FROM ubuntu:focal as base

ARG USER=dockerusr
ARG UID=1000
ARG GID=1000
ARG DOCKER_GID=1234
ARG PACKAGES=

RUN : \
  && apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y sudo ${PACKAGES} \
  && rm -rf /var/lib/apt/lists/* \
  && groupadd --gid $GID $USER \
  && groupadd --gid ${DOCKER_GID} docker \
  && useradd -c "" --no-log-init -u ${UID} -g ${GID} -m -G docker ${USER} \
  && echo $USER ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USER

FROM base as devenv
RUN : \
  && mkdir /opt/bin \
  && mkdir /opt/openvscode-server \
  && curl -Ls https://github.com/Kitware/CMake/releases/download/v3.23.1/cmake-3.23.1-linux-x86_64.tar.gz | tar xfz - --strip=1 -C /usr/local \
  && curl -Ls https://github.com/gitpod-io/openvscode-server/releases/download/openvscode-server-v1.66.1/openvscode-server-v1.66.1-linux-x64.tar.gz | tar xfz - --strip=1 -C /opt/openvscode-server \
  && curl -Ls https://github.com/tsl0922/ttyd/releases/download/1.6.3/ttyd.x86_64 -o /opt/bin/ttyd \
  && chmod a+x /opt/bin/ttyd \
  && printf "#!/bin/bash\n/opt/bin/ttyd bash &> /tmp/ttyd-log.txt&\n/opt/openvscode-server/server.sh &> /tmp/openvscode-server-log.txt\nwait" > /entrypoint.sh \
  && chmod a+x /entrypoint.sh

USER ${USER}
WORKDIR /workspace
ENTRYPOINT ["/entrypoint.sh"]
