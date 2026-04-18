if (( $+commands[git-spice] )); then
    alias gs=git-spice
    eval "$(git-spice shell completion zsh)"
fi
