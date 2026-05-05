function ghq_fzf -d "select ghq dir using fzf"
  if not command -q ghq
    echo "ghq_fzf: 'ghq' not found" >&2
    return 1
  end
  if not command -q fzf
    echo "ghq_fzf: 'fzf' not found" >&2
    return 1
  end

  ghq list --full-path | fzf --query (commandline) | read -l dir
  if test -n "$dir"
    cd $dir
  end
  commandline -f repaint
end
