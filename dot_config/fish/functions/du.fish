function du -d "du using dust"
  if command -q dust
    command dust $argv
  else
    command du -h $argv
  end
end
