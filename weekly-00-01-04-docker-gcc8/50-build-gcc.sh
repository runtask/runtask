#!/bin/bash

set -e

source ../common/common.bashrc

export DOCKER_PUSH=true

GCC_VERSION=8.2 run ../common/docker-build-gcc/build.sh
GCC_VERSION=8.3 run ../common/docker-build-gcc/build.sh
