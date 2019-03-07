#!/bin/bash

set -v

set -e

echo "TRAVIS_EVENT_TYPE: $TRAVIS_EVENT_TYPE"
echo "TRAVIS_BRANCH: $TRAVIS_BRANCH"
echo "TRAVIS_COMMIT: $TRAVIS_COMMIT"
echo "TRAVIS_BUILD_DIR: $TRAVIS_BUILD_DIR"


if [ ! -d "$TRAVIS_BUILD_DIR" ]; then
    echo "ERROR: TRAVIS_BUILD_DIR not exists or not a directory: $TRAVIS_BUILD_DIR"
    exit 1
fi


case "$TRAVIS_BRANCH" in
master):
    # Currently we are on master branch
    # Force sync master branch to other branches: daily, weekly, monthly
    TMPREPO="/tmp/$(cat /dev/random | tr -dc 'a-zA-Z0-9' | head -c 16)"
    git clone "https://runtask:$GITHUB_PAT@github.com/runtask/runtask" "$TMPREPO"
    pushd "$TMPREPO"
    for branch in daily weekly monthly; do
        echo "INFO: Force sync master branch to $branch"
        git checkout "$branch"
        git reset --hard origin/master
        git push -f origin "$branch"
    done
    popd
    exit 0
    ;;

daily|weekly|monthly):
    # Only do "api" build and "cron" build
    if [ "$TRAVIS_EVENT_TYPE" = "api" ] || [ "$TRAVIS_EVENT_TYPE" = "cron" ]; then
        echo "INFO: Run build for $TRAVIS_BRANCH (reason: $TRAVIS_EVENT_TYPE)"
        echo -e "\n================================================================\n\n\n"
    else
        echo "INFO: Ignore build for $TRAVIS_BRANCH (reason: $TRAVIS_EVENT_TYPE)"
        #exit 0
    fi
    ;;

*):
    echo "ERROR: Unknown branch: $TRAVIS_BRANCH"
    exit 1
    ;;
esac


export RUNTASK_CONTEXT=""
dotnet --version
time dotnet run --configuration Release -- "@$TRAVIS_BRANCH"


exit 0
