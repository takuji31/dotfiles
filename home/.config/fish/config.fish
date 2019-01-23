set -x LC_ALL en_US.UTF-8
set -x LANG en_US.UTF-8
add_path /usr/local/go/bin
add_path /usr/local/bin
add_path $HOME/.composer/vendor/bin/
add_path $HOME/.anyenv/bin
add_path $HOME/.plenv/bin
add_path $HOME/local/bin
add_path $HOME/bin
add_path /Applications/MacVim.app/Contents/MacOS
add_path /usr/local/share/android-sdk/bin
add_path /usr/local/share/android-sdk/tools
add_path /usr/local/share/android-sdk/tools/bin
add_path /usr/local/share/android-sdk/build-tools
add_path /usr/local/share/android-sdk/platform-tools/
add_path /usr/local/opt/ruby/bin
if test -x /usr/local/opt/ruby/bin/gem
  for p in (string split ":" (/usr/local/opt/ruby/bin/gem environment gempath))
    add_path $p/bin
  end
end
set -x EDITOR 'vim'
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
  add_path $GOPATH/bin
  add_path $GOROOT/bin
end

if test -f $HOME/.fishconfig_local.fish
  source $HOME/.fishconfig_local.fish
end
