#!/bin/bash

set -e

cd "$(dirname "$0")/.."

if [ -z "$1" ]; then
    echo "run_local.sh <freq>"
    exit 1
fi


export TRAVIS_EVENT_TYPE=local
export TRAVIS_BRANCH="$1"
export TRAVIS_BUILD_DIR="$(pwd)"

exec ./main.sh
