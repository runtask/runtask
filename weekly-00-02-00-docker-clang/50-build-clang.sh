#!/bin/bash

set -e

source ../common/common.bashrc

export DOCKER_PUSH=true

CLANG_VERSION=3.9 run ../common/docker-build-clang/build.sh
CLANG_VERSION=4.0 run ../common/docker-build-clang/build.sh
CLANG_VERSION=5.0 run ../common/docker-build-clang/build.sh
CLANG_VERSION=6.0 run ../common/docker-build-clang/build.sh
CLANG_VERSION=7 run ../common/docker-build-clang/build.sh
