function peco_ghq -d "select ghq dirs usign peco"
  if test -z (which peco)
    echo 'peco does not exists'
  else
    commandline | read -l query
    ghq list --full-path | peco --query "$query" | read -l selected_dir
    if test -n "$selected_dir"
        commandline "cd $selected_dir"
        commandline -f execute
    end
  end
  commandline -f repaint
end
