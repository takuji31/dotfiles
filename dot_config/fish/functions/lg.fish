function lg -d "lazygit"
  if command -q lazygit
    command lazygit $argv
  else
    echo "lazygit is not installed. Run: install-modern-tools" >&2
  end
end
