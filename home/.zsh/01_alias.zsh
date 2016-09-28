case "${OSTYPE}" in
freebsd*|darwin*)
    alias ls="ls -G -w"
    ;;
linux*)
    alias ls="ls --color"
    ;;
esac

alias la="ls -la"

alias du="du -h"
alias df="df -h"

alias su="su -l"

alias q="exit"
alias zmv='noglob zmv -W'

function gcm() {
    git commit -m $*
}
