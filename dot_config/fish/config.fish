set -x LC_ALL en_US.UTF-8
set -x LANG en_US.UTF-8
add_path /usr/local/go/bin
add_path /usr/local/bin
add_path $HOME/.composer/vendor/bin/
add_path $HOME/.anyenv/bin
add_path $HOME/.plenv/bin
add_path $HOME/local/bin
add_path $HOME/.local/bin
add_path $HOME/bin
add_path /Applications/MacVim.app/Contents/MacOS
add_path /usr/local/share/android-sdk/bin
add_path /usr/local/share/android-sdk/tools
add_path /usr/local/share/android-sdk/tools/bin
add_path /usr/local/share/android-sdk/build-tools
add_path /usr/local/share/android-sdk/platform-tools/
add_path /usr/local/opt/ruby/bin
add_path /usr/local/opt/ruby@2.7/bin
add_path $HOME/flutter/bin

if test -x /usr/local/opt/ruby/bin/gem
  for p in (string split ":" (/usr/local/opt/ruby/bin/gem environment gempath))
    add_path $p/bin
  end
end

if test -x /usr/local/opt/ruby@2.7/bin/gem
  for p in (string split ":" (/usr/local/opt/ruby@2.7/bin/gem environment gempath))
    add_path $p/bin
  end
end

if test -d /usr/local/share/android-sdk
  set -x ANDROID_SDK_ROOT /usr/local/share/android-sdk
end
set -x EDITOR 'vim'
set -x PAGER less
set -x MYSQL_PS1 '\U DB:\d DATE: \D MySQL: \v  \n>\_'

# plenv
if test -d $HOME/.plenv
  source (plenv init -|psub)
end

# ndenv
if test (which nodenv)
  source (nodenv init -|psub)
end

if test (which go)
  set -x GOROOT (go env GOROOT)
  set -x GOPATH $HOME/.go
  add_path $GOPATH/bin
  add_path $GOROOT/bin
end

if test (which code)
  set -x EDITOR code -w
end

if test -f /opt/homebrew/bin/brew
  eval (/opt/homebrew/bin/brew shellenv)
end

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/takuji31/google-cloud-sdk/path.fish.inc' ]; . '/Users/takuji31/google-cloud-sdk/path.fish.inc'; end

add_path /opt/homebrew/opt/ruby/bin
add_path /opt/homebrew/lib/ruby/gems/3.3.0/bin
add_path /usr/local/opt/node@16/bin

if test -d "$HOME/.volta"
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH
end

if test -f $HOME/.fishconfig_local.fish
  source $HOME/.fishconfig_local.fish
end

if test -d /home/linuxbrew/.linuxbrew/bin/
  eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
end
if test (which starship)
  starship init fish | source
end
