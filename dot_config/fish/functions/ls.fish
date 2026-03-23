function ls -d "ls using eza"
  if command -q eza
    command eza --icons --git $argv
  else
    command ls --color=auto $argv
  end
end
