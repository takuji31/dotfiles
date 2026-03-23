function ps -d "ps using procs"
  if command -q procs
    command procs $argv
  else
    command ps $argv
  end
end
