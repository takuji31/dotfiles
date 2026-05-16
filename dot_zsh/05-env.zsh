# EDITOR: terminal-first (used by sudoedit / crontab / headless tools)
if (( $+commands[nvim] )); then
    export EDITOR=nvim
elif (( $+commands[zed] )); then
    export EDITOR="zed -w"
elif (( $+commands[code] )); then
    export EDITOR="code -w"
fi

# VISUAL: GUI-first (used by git etc. — prefer zed over code)
if (( $+commands[zed] )); then
    export VISUAL="zed -w"
elif (( $+commands[code] )); then
    export VISUAL="code -w"
elif [[ -n "$EDITOR" ]]; then
    export VISUAL="$EDITOR"
fi

# PAGER: prefer moor, fall back to less
if (( $+commands[moor] )); then
    export PAGER=moor
elif (( $+commands[less] )); then
    export PAGER=less
fi

if (( $+commands[gh] )); then
    _github_token="$(gh auth token </dev/null 2>/dev/null)"
    if [[ -n "$_github_token" ]]; then
        export GITHUB_TOKEN="$_github_token"
    fi
    unset _github_token
fi
