go-up () {
    cd ..
    if typeset -f _p9k_on_widget_send-break > /dev/null; then
        _p9k_on_widget_send-break
    else
        zle reset-prompt
    fi
}; zle -N go-up

bindkey '^[u' go-up
