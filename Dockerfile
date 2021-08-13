FROM alpine:latest as devenv
RUN apk add --no-cache cmake gcc g++ libstdc++ ninja
ARG USER=dockerusr
ARG UID=1000
ARG DOCKER_GID=1234
RUN addgroup --gid "${DOCKER_GID}" docker && \
  adduser --disabled-password --gecos "" --uid "${UID}" "${USER}" && \ 
  addgroup -S "${USER}" docker

USER ${USER}
WORKDIR /workspace
