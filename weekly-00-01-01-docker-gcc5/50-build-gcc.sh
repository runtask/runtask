#!/bin/bash

set -e

source ../common/common.bashrc

export DOCKER_PUSH=true

GCC_VERSION=5.3 run ../common/docker-build-gcc/build.sh
GCC_VERSION=5.4 run ../common/docker-build-gcc/build.sh
GCC_VERSION=5.5 run ../common/docker-build-gcc/build.sh
