#!/bin/bash

#set -v

set -e

echo -e "\n\n"
echo "INFO: TRAVIS_EVENT_TYPE: $TRAVIS_EVENT_TYPE"
echo "INFO: TRAVIS_BRANCH: $TRAVIS_BRANCH"
echo "INFO: TRAVIS_COMMIT: $TRAVIS_COMMIT"
echo "INFO: TRAVIS_BUILD_DIR: $TRAVIS_BUILD_DIR"


if [ ! -d "$TRAVIS_BUILD_DIR" ]; then
    echo "ERROR: TRAVIS_BUILD_DIR not exists or not a directory: $TRAVIS_BUILD_DIR"
    exit 1
fi


case "$TRAVIS_BRANCH" in
master):
    # Currently we are on master branch
    if [ "$TRAVIS_EVENT_TYPE" == "local" ]; then
        echo "ERROR: Run local on master branch makes no sense!"
        exit 2
    fi

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
    if [ "$TRAVIS_EVENT_TYPE" = "api" ] || [ "$TRAVIS_EVENT_TYPE" = "cron" ] || [ "$TRAVIS_EVENT_TYPE" = "local" ]; then
        echo "INFO: Run build for $TRAVIS_BRANCH (reason: $TRAVIS_EVENT_TYPE)"
    else
        echo "INFO: Ignore build for $TRAVIS_BRANCH (reason: $TRAVIS_EVENT_TYPE)"
        exit 0
    fi
    ;;

*):
    echo "ERROR: Unknown branch: $TRAVIS_BRANCH"
    exit 1
    ;;
esac



#
# Checkout RUNTASK_USE_COMMIT (if not local)
#
if [ "$TRAVIS_EVENT_TYPE" != "local" ]; then
    if [ -z "$RUNTASK_USE_COMMIT" ]; then
        RUNTASK_USE_COMMIT="$TRAVIS_COMMIT"
    else
        git checkout -qf "$RUNTASK_USE_COMMIT"
    fi
fi


#
# Get all stages
#
shopt -s nullglob
STAGES=( )
for name in "${TRAVIS_BRANCH}-"*; do
    STAGES+=( "$name" )
done
shopt -u nullglob
STAGES_COUNT="${#STAGES[@]}"

echo "INFO: Stages count: $STAGES_COUNT"
for stage in "${STAGES[@]}"; do
    echo "INFO:     $stage"
done



#
# Get current stage for run
#
if [ -z "$RUNTASK_CURRENT_STAGE" ]; then
    if [ "$STAGES_COUNT" -eq 0 ]; then
        echo "INFO: No stages found..."
        exit 0
    fi
    RUNTASK_CURRENT_STAGE="${STAGES[0]}"
fi
echo "INFO: RUNTASK_CURRENT_STAGE: $RUNTASK_CURRENT_STAGE"
if [ ! -d "$RUNTASK_CURRENT_STAGE" ]; then
    echo "ERROR: Current stage directory not exists: $RUNTASK_CURRENT_STAGE"
    exit 2
fi


#
# Get next stage for run
#
if [ "$RUNTASK_NEXT_STAGE" != "stop" ]; then
    RUNTASK_NEXT_STAGE="stop"
    last_stage=""
    for stage in "${STAGES[@]}"; do
        if [ "$last_stage" = "$RUNTASK_CURRENT_STAGE" ]; then
            RUNTASK_NEXT_STAGE="$stage"
            break
        fi
        last_stage="$stage"
    done
    unset last_stage
fi
echo "INFO: RUNTASK_NEXT_STAGE: $RUNTASK_NEXT_STAGE"



#
# Run RUNTASK_CURRENT_STAGE
#
echo "INFO: Run stage: $RUNTASK_CURRENT_STAGE"
echo -e "\n============================= BEGIN ============================\n\n"

pushd "$RUNTASK_CURRENT_STAGE" >/dev/null
shopt -s nullglob
for file in *; do
    if [ ! -x "$file" ]; then
        echo "INFO: Skip file which is not executable: $file"
        continue
    fi
    echo -e "\n-------- Run $file --------\n"
    set +e
    time "./$file"
    ret="$?"
    set -e
    echo -e "\n-------- Run $file (done) --------\n"
    if [ "$ret" -ne 0 ]; then
        echo "ERROR: $file failed with $ret"
        exit 3
    fi
done
shopt -u nullglob
popd >/dev/null

echo -e "\nINFO: Run stage successfully: $RUNTASK_CURRENT_STAGE"
echo -e "============================== END =============================\n\n"



#
# Run next stage if it is not "stop"
#
if [ "$RUNTASK_NEXT_STAGE" != "stop" ]; then
    if [ "$TRAVIS_EVENT_TYPE" == "local" ]; then
        export RUNTASK_CURRENT_STAGE="$RUNTASK_NEXT_STAGE"
        exec ./main.sh
    else
        body="{
          \"request\": {
            \"branch\": \"$TRAVIS_BRANCH\",
            \"config\": {
              \"merge_mode\": \"deep_merge\",
              \"env\": {
                \"RUNTASK_USE_COMMIT\": \"$RUNTASK_USE_COMMIT\",
                \"RUNTASK_CURRENT_STAGE\": \"$RUNTASK_NEXT_STAGE\"
              }
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
        unset body
    fi
fi



exit 0
