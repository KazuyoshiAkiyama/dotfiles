#!/usr/bin/env bash

docker run -it --rm -v "$(pwd):/workspace" devenv:ubuntu24.04 $@
