function peco_history -d "select history usign peco"
  commandline | read -l query
  history search | sort -k1,1nr | perl -ne 'BEGIN { my @lines = (); } s/^\s*\d+\*?\s*//; $in=$_; if (!(grep {$in eq $_} @lines)) { push(@lines, $in); print $in; }' | peco --query "$query" | read -l cmd
  commandline $cmd
  commandline -f repaint
end
