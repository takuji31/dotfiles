if (( $+commands[go] )); then
    local go_path
    go_path=$(go env GOPATH 2>/dev/null)
    if [[ -n "$go_path" ]]; then
        typeset -U path
        path=("$go_path/bin"(N-/) $path)
    fi
fi
