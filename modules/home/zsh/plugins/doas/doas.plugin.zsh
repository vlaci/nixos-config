# run command line as user root via doas:
function doas-command-line () {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER != doas\ * ]]; then
        BUFFER="doas $BUFFER"
        CURSOR=$(( CURSOR+5 ))
    fi
}
zle -N doas-command-line
bindkey "^od" doas-command-line
