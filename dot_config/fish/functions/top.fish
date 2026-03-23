function top -d "top using btop"
  if command -q btop
    command btop $argv
  else
    command top $argv
  end
end
