#!/bin/bash
input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
model=$(echo "$input" | jq -r '.model.display_name')
pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
dir=$(echo "$cwd" | sed "s|$HOME|~|")
short=$(echo "$dir" | awk -F/ '{for(i=1;i<NF;i++) printf "%s/", substr($i,1,1); print $NF}')
branch=$(git -C "$cwd" branch --show-current 2>/dev/null)
if [ -n "$branch" ]; then
  printf '\033[36m%s\033[0m \033[35;1m%s\033[0m \033[33m%s\033[0m \033[32m%s%%\033[0m' "$short" "$branch" "$model" "$pct"
else
  printf '\033[36m%s\033[0m \033[33m%s\033[0m \033[32m%s%%\033[0m' "$short" "$model" "$pct"
fi
