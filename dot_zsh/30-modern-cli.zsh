# Modern CLI replacements. Each wrapper falls back to the original tool
# when the modern alternative is not installed.

case "${OSTYPE}" in
freebsd*|darwin*)
    _zsh_ls_fallback() { command ls -G -w "$@" }
    ;;
linux*)
    _zsh_ls_fallback() { command ls --color "$@" }
    ;;
*)
    _zsh_ls_fallback() { command ls "$@" }
    ;;
esac

ls() {
    if (( $+commands[eza] )); then
        command eza --icons --git "$@"
    else
        _zsh_ls_fallback "$@"
    fi
}

la() {
    if (( $+commands[eza] )); then
        command eza -la --header --icons "$@"
    else
        _zsh_ls_fallback -la "$@"
    fi
}

ll() {
    if (( $+commands[eza] )); then
        command eza -l --header --icons --git "$@"
    else
        _zsh_ls_fallback -l "$@"
    fi
}

lt() {
    if (( $+commands[eza] )); then
        command eza --tree --level=2 "$@"
    elif (( $+commands[tree] )); then
        command tree -L 2 "$@"
    else
        _zsh_ls_fallback -R "$@"
    fi
}

cat() {
    if (( $+commands[bat] )); then
        command bat "$@"
    else
        command cat "$@"
    fi
}

df() {
    if (( $+commands[duf] )); then
        command duf "$@"
    else
        command df -h "$@"
    fi
}

du() {
    if (( $+commands[dust] )); then
        command dust "$@"
    else
        command du -h "$@"
    fi
}

ps() {
    if (( $+commands[procs] )); then
        command procs "$@"
    else
        command ps "$@"
    fi
}

top() {
    if (( $+commands[btop] )); then
        command btop "$@"
    else
        command top "$@"
    fi
}

lg() {
    if (( $+commands[lazygit] )); then
        command lazygit "$@"
    else
        echo "lazygit is not installed. Run: mise install lazygit" >&2
        return 1
    fi
}
