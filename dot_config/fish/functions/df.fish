function df -d "df using duf"
  if command -q duf
    command duf $argv
  else
    command df -h $argv
  end
end
