__try () {
    local interactive=$1
    shift
    local EXE
    EXE=$(printf "%q" "${1/doas/$2}")
    local DB="@nixpkgs@/programs.sqlite"
    local QUERY="select package from Programs where system = \"@system@\" and name = \"$EXE\" and package <> \"busybox\""
    local -a CANDIDATES

    CANDIDATES=(${(f)"$(@sqlite@/bin/sqlite3 -init /dev/null -batch $DB "$QUERY")"})
    local choice=${CANDIDATES[1]}

    if [[ ${#CANDIDATES[@]} -eq 0 ]]; then
        printf "%s: command not found.\n" "$EXE"
        return 127
    fi

    printf "The program '%s' is currently not installed.\n" "$EXE"

    if [[ ${#CANDIDATES[@]} -gt 1  && $interactive != interactive ]]; then
        printf "Multiple packages provide the command '%s'\n" "$EXE"
        for p in "${CANDIDATES[@]}"; do
            printf "  %s\n" "$p"
        done
        printf "Run the folllowing command to select from them:\n  try %s\n" "$*"
        return 127
    fi

    if [[ ${#CANDIDATES[@]} -gt 1 ]]; then
        printf "These packages provide the command '%s'\n" "$EXE"
        printf "Which package do you want to try?\n"
        for p in "${CANDIDATES[@]}"; do
            printf "  %s\n" "$p"
        done
        local -a compcontext
        compcontext=(${CANDIDATES[@]})
        nocorrect vared -c -p "Enter choice: " choice
    fi
    printf "Starting '%s' from package '%s' via nix shell...\n" "$EXE" "$choice"
    nix shell "nixpkgs#${choice}" -c "$@"
}

command_not_found_handler() {
    __try noninteractive "$@"
}

try() {
    __try interactive "$@"
}
