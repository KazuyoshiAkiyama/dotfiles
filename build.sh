#!/usr/bin/env bash

export DOCKER_BUILDKIT=1

docker build \
  --build-arg DISTRO_VERSION=24.04 \
  --build-arg HOST_UID=$(id -u) \
  --progress=plain \
  -t devenv:ubuntu24.04 \
  .
