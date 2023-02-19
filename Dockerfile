FROM ubuntu:focal as base

ARG USER=dockerusr
ARG UID=1000
ARG GID=1000
ARG DOCKER_GID=1234
ARG PACKAGES=
ENV PATH=$PATH:/usr/local/cargo/bin:/usr/local/go/bin

# COPY *.crt /usr/local/share/ca-certificates

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    RUST_VERSION=1.67.1

# ENV REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt

RUN : \
  && apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y sudo ca-certificates ${PACKAGES} \
  && rm -rf /var/lib/apt/lists/* \
  && groupadd --gid $GID $USER \
  && groupadd --gid ${DOCKER_GID} docker \
  && useradd -c "" --no-log-init -u ${UID} -g ${GID} -m -G docker ${USER} \
  && echo "Defaults env_keep += \"http_proxy HTTP_PROXY HTTPS_PROXY no_proxy NO_PROXY\"" >> /etc/sudoers \
  && echo $USER ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USER \
  && curl https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path --profile minimal --default-toolchain $RUST_VERSION \
  && curl -Ls https://go.dev/dl/go1.20.1.linux-amd64.tar.gz | tar xfz - -C /usr/local \
  && update-ca-certificates

ENV PATH="/usr/lib/ccache/:$PATH"
ENV CCACHE_DIR="/workspace/.ccache"

FROM base as devenv
RUN : \
  && mkdir /opt/bin \
  && mkdir /opt/openvscode-server \
  && curl -Ls https://github.com/Kitware/CMake/releases/download/v3.25.2/cmake-3.25.2-linux-x86_64.tar.gz | tar xfz - --strip=1 -C /usr/local \
  && curl -Ls https://github.com/gitpod-io/openvscode-server/releases/download/openvscode-server-v1.75.1/openvscode-server-v1.75.1-linux-x64.tar.gz | tar xfz - --strip=1 -C /opt/openvscode-server \
  && curl -Ls https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64 -o /opt/bin/ttyd \
  && chmod a+x /opt/bin/ttyd \
  && printf "#!/bin/bash\n/opt/bin/ttyd bash &> /tmp/ttyd-log.txt&\n/opt/openvscode-server/openvscode-server --accept-server-license-terms --without-connection-token --host 0.0.0.0 --port 8000 --disable-telemetry &> /tmp/openvscode-server-log.txt\nwait" > /entrypoint.sh \
  && chmod a+x /entrypoint.sh

USER ${USER}
WORKDIR /workspace
ENTRYPOINT ["/entrypoint.sh"]
