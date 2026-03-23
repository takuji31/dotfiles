if command -q fzf
    fzf --fish | source
    set -gx FZF_DEFAULT_OPTS "--height=40% --layout=reverse --info=inline --border"
    if command -q fd
        set -gx FZF_DEFAULT_COMMAND "fd --type f --hidden --follow --exclude .git"
    end
end
