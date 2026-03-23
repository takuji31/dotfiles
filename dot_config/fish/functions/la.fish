function la -d "list all with eza"
  if command -q eza
    command eza -la --header --icons $argv
  else
    command ls -la $argv
  end
end
