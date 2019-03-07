#!/bin/bash

set -v

set -e

echo "TRAVIS_EVENT_TYPE: $TRAVIS_EVENT_TYPE"
echo "TRAVIS_BRANCH: $TRAVIS_BRANCH"

case "$TRAVIS_BRANCH" in
master):
    # Currently we are on master branch
    # Force sync master branch to other branches: daily, weekly, monthly
    for branch in daily weekly monthly; do
        echo "INFO: Force sync master branch to $branch"
    done
    ;;
daily|weekly|monthly):
    # Only do "api" build and "cron" build
    if [ "$TRAVIS_EVENT_TYPE" = "api" ] || [ "$TRAVIS_EVENT_TYPE" = "cron" ]; then
        echo "INFO: Run build for $TRAVIS_BRANCH (reason: $TRAVIS_EVENT_TYPE)"
        echo -e "\n================================================================\n\n\n"
    else
        echo "INFO: Ignore build for $TRAVIS_BRANCH (reason: $TRAVIS_EVENT_TYPE)"
    fi
    ;;
*):
    echo "ERROR: Unknown branch: $TRAVIS_BRANCH"
    exit 1
    ;;
esac

exit 0
