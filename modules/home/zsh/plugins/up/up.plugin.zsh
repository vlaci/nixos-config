function ultimate-plumb-command-line () {
    export BUFFER CURSOR
    local command output pipe

    [[ -z $BUFFER ]] && zle up-history

    pipe=${BUFFER#*|[[:space:]]#}
    if [[ $pipe  == "$BUFFER" ]]; then
        command=$BUFFER
        pipe=""
    else
        command=${BUFFER%[[:space:]]#|*}
    fi

    output=$(mktemp -t tmp.up.XXXXXXX.sh) || exit 2
    eval "$command" | @up@/bin/up -o "$output" -c "$pipe" 2> /dev/null
    if [[ -s "$output" ]]; then
        pipe=$(tail -1 "$output")
        rm -f -- "$output"
        BUFFER="$command | $pipe"
        CURSOR=${#BUFFER}
        zle reset-prompt
    fi
}
zle -N ultimate-plumb-command-line
bindkey "^op" ultimate-plumb-command-line
