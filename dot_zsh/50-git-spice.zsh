if (( $+commands[git-spice] )); then
    alias gs=git-spice
    # Redirect stdin from /dev/null so the completion subprocess can't
    # consume bytes preloaded into the pty (see CLAUDE.md pitfall note).
    eval "$(git-spice shell completion zsh </dev/null)"
fi
