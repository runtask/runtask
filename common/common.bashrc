
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

