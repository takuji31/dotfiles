function ll -d "long listing with eza"
  if command -q eza
    command eza -l --header --icons --git $argv
  else
    command ls -l $argv
  end
end
