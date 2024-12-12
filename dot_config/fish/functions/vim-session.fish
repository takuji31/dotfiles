function vim-session -d "open vim with session"
  if test (count $argv) -eq 0
    echo 'needs session_name'
    return 1
  end

  set -l session_name $argv[1]
  set -l session_dir "$HOME/.vim-session/$session_name"
  mkdir -pv $session_dir

  set -l session_file "$session_dir/Session.vim"
  if test -f $session_file
    vim -S $session_file
  else
    vim -c ":Obsession $session_file"
  end
end
