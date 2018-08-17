set -x LC_ALL en_US.UTF-8
set -x LANG en_US.UTF-8
add_path /usr/local/go/bin /usr/local/bin
add_path $HOME/.composer/vendor/bin/ $HOME/local/bin $HOME/bin
add_path $HOME/.plenv/bin
add_path /Applications/MacVim.app/Contents/MacOS
set -x EDITOR 'atom -w'
set -x PAGER less
set -x MYSQL_PS1 '\U DB:\d DATE: \D MySQL: \v  \n>\_'

# plenv
if test -d $HOME/.plenv
  source (plenv init -|psub)
end

# ndenv
if test -x (which nodenv)
  source (nodenv init -|psub)
end

if test -x (which go)
  set -x GOROOT (go env GOROOT)
  set -x GOPATH $HOME/.go
  add_path $GOPATH/bin $GOROOT/bin
end

if test -f $HOME/.fishconfig_local.fish
  source $HOME/.fishconfig_local.fish
end
