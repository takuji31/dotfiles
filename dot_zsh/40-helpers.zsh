claude-work() {
    CLAUDE_CONFIG_DIR=~/.claude-work command claude "$@"
}
(( $+commands[claude] )) && compdef claude-work=claude 2>/dev/null

cleanup-branches() {
    if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        echo "cleanup-branches: not inside a git repository" >&2
        return 1
    fi
    if ! (( $+commands[gh] )); then
        echo "cleanup-branches: 'gh' not found. Install GitHub CLI: https://cli.github.com/" >&2
        return 1
    fi
    if ! gh extension list 2>/dev/null | grep -q '\bgh poi\b'; then
        echo "cleanup-branches: 'gh poi' extension not installed." >&2
        echo "  Install: gh extension install seachicken/gh-poi" >&2
        return 1
    fi
    local has_state=0
    local arg
    for arg in "$@"; do
        if [[ "$arg" == "--state" || "$arg" == --state=* ]]; then
            has_state=1
            break
        fi
    done
    local -a poi_args
    if (( has_state == 0 )); then
        poi_args=(--state closed)
    fi
    poi_args+=("$@")
    git fetch --prune --prune-tags
    gh poi "${poi_args[@]}"
}

fzf_kill() {
    if ! (( $+commands[fzf] )); then
        echo "fzf_kill: 'fzf' not found" >&2
        return 1
    fi
    local pid
    pid=$(command ps ax -o pid,time,command | fzf | awk '{print $1}')
    if [[ -n "$pid" ]]; then
        command kill "$pid"
    fi
}

theme-toggle() {
    [[ -n "$ZELLIJ_SESSION_NAME" ]] || return 0
    zellij action toggle-theme
}

# ZLE widget: ghq dir selector via fzf
ghq-fzf() {
    if ! (( $+commands[ghq] )); then
        zle -M "ghq-fzf: 'ghq' not found"
        return 1
    fi
    if ! (( $+commands[fzf] )); then
        zle -M "ghq-fzf: 'fzf' not found"
        return 1
    fi
    local selected_dir
    selected_dir=$(ghq list --full-path | fzf --query "$LBUFFER")
    if [[ -n "$selected_dir" ]]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N ghq-fzf
bindkey '^S' ghq-fzf

# ZLE widget: Alt+T toggles Zellij theme
theme-toggle-widget() {
    theme-toggle
    zle reset-prompt
}
zle -N theme-toggle-widget
bindkey '^[t' theme-toggle-widget
