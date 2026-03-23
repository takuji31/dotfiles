function lt -d "tree listing with eza"
  if command -q eza
    command eza --tree --level=2 $argv
  else
    command tree -L 2 $argv
  end
end
