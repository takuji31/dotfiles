function fzf_kill -d "kill process using fzf"
  ps ax -o pid,time,command | fzf | awk '{print $1}' | xargs kill
end
