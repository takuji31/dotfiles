if command -q go
    set -l go_path (go env GOPATH 2>/dev/null)
    if test -n "$go_path"
        fish_add_path "$go_path/bin"
    end
end
