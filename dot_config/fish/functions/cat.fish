function cat -d "cat using bat"
  if command -q bat
    command bat $argv
  else
    command cat $argv
  end
end
