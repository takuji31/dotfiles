# EDITOR: prefer nvim, fall back to code
if (( $+commands[nvim] )); then
    export EDITOR=nvim
elif (( $+commands[code] )); then
    export EDITOR="code -w"
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
