#!/bin/bash

set -e

cd "$(dirname "$0")/.."

if [ -z "$1" ]; then
    echo "run_travis.sh <freq>: run all stages in specific <freq> (daily, weekly, monthly)"
    echo "run_travis.sh <stage>: run specific <stage>"
    exit 1
fi


case "$1" in
daily|weekly|monthly):
    export BRANCH="$1"
    export RUNTASK_CURRENT_STAGE=""
    export RUNTASK_NEXT_STAGE=""
    ;;
daily-*):
    export BRANCH="daily"
    export RUNTASK_CURRENT_STAGE="$1"
    export RUNTASK_NEXT_STAGE="stop"
    ;;
weekly-*):
    export BRANCH="weekly"
    export RUNTASK_CURRENT_STAGE="$1"
    export RUNTASK_NEXT_STAGE="stop"
    ;;
monthly-*):
    export BRANCH="monthly"
    export RUNTASK_CURRENT_STAGE="$1"
    export RUNTASK_NEXT_STAGE="stop"
    ;;
*):
    echo "ERROR: Unknown <freq> or <stage>: $1"
    exit 1
    ;;
esac


if [ -z "$TRAVIS_ACCESS_TOKEN" ]; then
    echo "ERROR: TRAVIS_ACCESS_TOKEN is empty"
    exit 1
fi

body="{
  \"request\": {
    \"branch\": \"$BRANCH\",
    \"config\": {
      \"merge_mode\": \"deep_merge\"
    },
    \"env\": {
      \"RUNTASK_CURRENT_STAGE\": \"$RUNTASK_CURRENT_STAGE\",
      \"RUNTASK_NEXT_STAGE\": \"$RUNTASK_NEXT_STAGE\"
    }
  }
}"

curl -s -X POST \
   -H "Content-Type: application/json" \
   -H "Accept: application/json" \
   -H "Travis-API-Version: 3" \
   -H "Authorization: token $TRAVIS_ACCESS_TOKEN" \
   -d "$body" \
   https://api.travis-ci.com/repo/runtask%2Fruntask/requests

