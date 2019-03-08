#!/bin/bash

set -e

cd "$(dirname "$(readlink -f "$0")")"
source ./common.bashrc


echo "$DOCKER_PASSWORD" | run sudo -E docker login --username catchyrime --password-stdin
