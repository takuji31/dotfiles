function fzf_kill -d "kill process using fzf"
  set -l pid (command ps ax -o pid,time,command | fzf | awk '{print $1}')
  if test -n "$pid"
    command kill $pid
  end
end
