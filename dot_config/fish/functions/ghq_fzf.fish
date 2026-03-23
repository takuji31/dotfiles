function ghq_fzf -d "select ghq dir using fzf"
  ghq list --full-path | fzf --query (commandline) | read -l dir
  if test -n "$dir"
    cd $dir
  end
  commandline -f repaint
end
