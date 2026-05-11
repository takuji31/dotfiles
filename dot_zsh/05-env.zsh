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
