# Load after fzf so atuin overrides Ctrl+R (Up arrow remains zsh default)
if (( $+commands[atuin] )); then
    eval "$(atuin init zsh --disable-up-arrow)"
fi
