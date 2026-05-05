function lg -d "lazygit"
  if command -q lazygit
    command lazygit $argv
  else
    echo "lazygit is not installed. Run: mise install lazygit" >&2
  end
end
