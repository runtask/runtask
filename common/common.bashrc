
run() {
    if [ -t 1 ]; then
        printf "\033[35m[%s]\033[0m \033[35;1m%s\033[0m\n" "$(pwd)" "$*"
    else
        printf "[%s] %s\n" "$(pwd)" "$*"
    fi
    "$@"
}

option_true() {
    option="$1"
    option="${option,,}"  # to lower-case
    case "$option" in
    yes|true|1|on):
        return 0
        ;;
    no|false|0|off|""):
        return 1
        ;;
    *):
        echo "WARN: Option is neither true-like nor false-like (assume: false): $1"
        return 1
        ;;
    esac
}

retry_5_times() {
    run "$@" ||
        (echo "Sleep 5 seconds and retry..."; sleep 5; run "$@") ||
        (echo "Sleep 20 seconds and retry..."; sleep 20; run "$@") ||
        (echo "Sleep 60 seconds and retry..."; sleep 60; run "$@") ||
        (echo "Sleep 120 seconds and retry..."; sleep 120; run "$@")
}

