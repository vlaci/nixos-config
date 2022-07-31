__try () {
    local interactive=$1
    shift
    local exe
    exe=$(printf "%q" "${1/doas/$2}")
    local -a candidates
    candidates=($(@nix_index@/bin/nix-locate --minimal --no-group --type x --type s --top-level --whole-name --at-root "/bin/$exe"))
    candidates=("${candidates[@]%.out}")

    if [[ ${#candidates[@]} -eq 0 ]]; then
        printf "%s: command not found.\n" "$exe"
        return 127
    fi

    printf "The program '%s' is currently not installed.\n" "$exe"

    local choice

    if [[ ${#candidates[@]} -eq 1 ]]; then
        choice=${candidates[1]}
    fi

    for c in "${candidates[@]}"; do
        if [[ "$c" == "${exe}" ]]; then
            choice="$c"
        fi
    done

    if [[ -z $choice && $interactive != interactive ]]; then
        printf "Multiple packages provide the command '%s'\n" "$exe"
        for p in "${candidates[@]}"; do
            printf "  %s\n" "$p"
        done
        printf "Run the folllowing command to select from them:\n  try %s\n" "$*"
        return 127
    fi

    if [[ -z $choice ]]; then
        printf "These packages provide the command '%s'\n" "$exe"
        printf "Which package do you want to try?\n"
        for p in "${candidates[@]}"; do
            printf "  %s\n" "$p"
        done
        local -a compcontext
        compcontext=(${candidates[@]})
        nocorrect vared -c -p "Enter choice: " choice
    fi
    printf "Starting '%s' from package '%s' via nix shell...\n" "$exe" "$choice"
    nix shell "nixpkgs#${choice}" -c "$@"
}

command_not_found_handler() {
    __try noninteractive "$@"
}

try() {
    __try interactive "$@"
}
