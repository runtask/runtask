#!/bin/bash

set -e

cd "$(dirname "$(readlink -f "$0")")"
source ../common.bashrc


if [ -z "$CLANG_VERSION" ]; then
    CLANG_VERSION="$1"
fi

if [ -z "$CLANG_VERSION" ]; then
    echo "ERROR: CLANG_VERSION is requried"
    exit 1
else
    echo "INFO: CLANG_VERSION: $CLANG_VERSION"
fi


run sudo -E docker build \
    --network host \
    --no-cache --rm --force-rm \
    --build-arg CLANG_VERSION="$CLANG_VERSION" \
    --tag catchyrime/clang:"$CLANG_VERSION" \
    .

if option_true "$DOCKER_PUSH"; then
    retry_5_times sudo -E docker push catchyrime/clang:"$CLANG_VERSION"
fi

