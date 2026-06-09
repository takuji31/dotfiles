# EDITOR / VISUAL: CUI editors only. Prefer the edit-in-pane wrapper, which
# splits the pane inside zellij / tmux / cmux and falls back to direct exec
# outside any multiplexer. MY_CUI_EDITOR overrides the wrapper's editor choice.
if (( $+commands[edit-in-pane] )); then
    export EDITOR=edit-in-pane
elif (( $+commands[nvim] )); then
    export EDITOR=nvim
elif (( $+commands[hx] )); then
    export EDITOR=hx
elif (( $+commands[vim] )); then
    export EDITOR=vim
fi

if [[ -n "$EDITOR" ]]; then
    export VISUAL="$EDITOR"
fi

# PAGER: prefer moor, fall back to less
if (( $+commands[moor] )); then
    export PAGER=moor
elif (( $+commands[less] )); then
    export PAGER=less
fi
