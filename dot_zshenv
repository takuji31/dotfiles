export LC_ALL="en_US.UTF-8"

typeset -U path
path=(
"/Applications/Sublime Text.app/Contents/SharedSupport/bin"(N-/)
/Applications/MacVim.app/Contents/MacOS(N-/)
$HOME/.composer/vendor/bin/(N-/)
$HOME/.anyenv/bin(N-/)
$HOME/local/bin(N-/)
$HOME/bin(N-/)
/usr/local/go/bin(N-/)
/usr/local/bin(N-/)
/usr/sbin(N-/)
/usr/bin(N-/)
/sbin(N-/)
/bin(N-/)
$path
)

export EDITOR=vim

#Pager
if type lv > /dev/null 2>&1; then
    export PAGER="lv"
    export LV="-c -l"
else
    export PAGER="less"
fi

#mysql prompt
export MYSQL_PS1='\U DB:\d DATE: \D MySQL: \v  \n>\_'

export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

#anyenv
if [[ -d $HOME/.anyenv ]] ; then
    eval "$(anyenv init -)"
fi

if [ -x "`which go`" ]; then
    export GOROOT=`go env GOROOT`
    export GOPATH=$HOME/.go
    path=(
    $GOPATH/bin(N-/)
    $GOROOT/bin(N-/)
    $path
    )
fi

#source local env
[[ -e $HOME/.zshenv_local ]] && source $HOME/.zshenv_local

#eval homebrew
[[ -e /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"