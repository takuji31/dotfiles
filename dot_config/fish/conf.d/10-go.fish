if command -q go
    set -gx GOPATH $HOME/.go
    fish_add_path $GOPATH/bin
end
