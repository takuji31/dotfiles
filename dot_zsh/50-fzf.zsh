if (( $+commands[fzf] )); then
    source <(fzf --zsh)
    export FZF_DEFAULT_OPTS="--height=40% --layout=reverse --info=inline --border"
    if (( $+commands[fd] )); then
        export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
    fi
fi
