#!/bin/bash

set -e

source ../common/common.bashrc

export DOCKER_PUSH=true

#GCC_VERSION=4.8 run ../common/docker-build-gcc/build.sh
#GCC_VERSION=4.9 run ../common/docker-build-gcc/build.sh

GCC_VERSION=5.3 run ../common/docker-build-gcc/build.sh
GCC_VERSION=5.4 run ../common/docker-build-gcc/build.sh
GCC_VERSION=5.5 run ../common/docker-build-gcc/build.sh

GCC_VERSION=6.3 run ../common/docker-build-gcc/build.sh
GCC_VERSION=6.4 run ../common/docker-build-gcc/build.sh
GCC_VERSION=6.5 run ../common/docker-build-gcc/build.sh
