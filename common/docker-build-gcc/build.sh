#!/bin/bash

set -e

cd "$(dirname "$(readlink -f "$0")")"
source ../common.bashrc


if [ -z "$GCC_VERSION" ]; then
    GCC_VERSION="$1"
fi

if [ -z "$GCC_VERSION" ]; then
    echo "ERROR: GCC_VERSION is requried"
    exit 1
else
    echo "INFO: GCC_VERSION: $GCC_VERSION"
fi


if [ ! -d "./go" ]; then
    run wget -q https://dl.google.com/go/go1.11.4.linux-amd64.tar.gz
    run tar -xf go1.11.4.linux-amd64.tar.gz
    run rm -f go1.11.4.linux-amd64.tar.gz
fi

if [ ! -d "./go" ]; then
    echo "ERROR: go directory not found (should have been downloaded just now?!)"
    run ls -AhlF
    exit 2
fi


run sudo -E docker build \
    --network host \
    --no-cache --rm --force-rm \
    --build-arg GCC_VERSION="$GCC_VERSION" \
    --tag catchyrime/gcc:"$GCC_VERSION" \
    .

if option_true "$DOCKER_PUSH"; then
    retry_5_times sudo -E docker push catchyrime/gcc:"$GCC_VERSION"
fi

