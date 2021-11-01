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
  && curl -Ls https://github.com/gitpod-io/openvscode-server/releases/download/openvscode-server-nightly-v1.62.0/openvscode-server-nightly-v1.62.0-linux-x64.tar.gz | tar xfz - --strip=1 -C /opt/openvscode-server \
  && curl -Ls https://github.com/gohugoio/hugo/releases/download/v0.88.1/hugo_extended_0.88.1_Linux-64bit.tar.gz  | tar xfz - -C /opt/bin \
  && curl -Ls https://github.com/caddyserver/caddy/releases/download/v2.4.5/caddy_2.4.5_linux_amd64.tar.gz | tar xfz - -C /opt/bin \
  && curl -Ls https://github.com/tsl0922/ttyd/releases/download/1.6.3/ttyd.x86_64 -o /opt/bin/ttyd \
  && chmod a+x /opt/bin/ttyd \
  && printf "#!/bin/bash\n/opt/bin/ttyd bash &> /tmp/ttyd-log.txt&\n/opt/openvscode-server/server.sh &> /tmp/openvscode-server-log.txt\nwait" > /entrypoint.sh \
  && chmod a+x /entrypoint.sh
COPY Caddyfile /tmp

USER ${USER}
WORKDIR /workspace
ENTRYPOINT ["/entrypoint.sh"]
