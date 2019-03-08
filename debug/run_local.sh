#!/bin/bash

set -e

cd "$(dirname "$0")/.."

if [ -z "$1" ]; then
    echo "run_local.sh <freq>: run all stages in specific <freq> (daily, weekly, monthly)"
    echo "run_local.sh <stage>: run specific <stage>"
    exit 1
fi



export TRAVIS_EVENT_TYPE=local
export TRAVIS_BUILD_DIR="$(pwd)"

case "$1" in
daily|weekly|monthly):
    export TRAVIS_BRANCH="$1"
    ;;
daily-*):
    export TRAVIS_BRANCH="daily"
    export RUNTASK_CURRENT_STAGE="$1"
    export RUNTASK_NEXT_STAGE="stop"
    ;;
weekly-*):
    export TRAVIS_BRANCH="weekly"
    export RUNTASK_CURRENT_STAGE="$1"
    export RUNTASK_NEXT_STAGE="stop"
    ;;
monthly-*):
    export TRAVIS_BRANCH="monthly"
    export RUNTASK_CURRENT_STAGE="$1"
    export RUNTASK_NEXT_STAGE="stop"
    ;;
*):
    echo "ERROR: Unknown <freq> or <stage>: $1"
    exit 1
    ;;
esac


exec ./main.sh
