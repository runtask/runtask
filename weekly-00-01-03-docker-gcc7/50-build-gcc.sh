#!/bin/bash

set -e

source ../common/common.bashrc

export DOCKER_PUSH=true

GCC_VERSION=7.2 run ../common/docker-build-gcc/build.sh
GCC_VERSION=7.3 run ../common/docker-build-gcc/build.sh
GCC_VERSION=7.4 run ../common/docker-build-gcc/build.sh
