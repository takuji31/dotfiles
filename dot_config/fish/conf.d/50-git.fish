if command -q git
    abbr -a gst 'git status'
    abbr -a gd  'git diff'
    abbr -a gds 'git diff --staged'
    abbr -a gl  'git log --oneline -20'
    abbr -a gp  'git push'
    abbr -a gpl 'git pull'
    abbr -a gpf 'git push --force-with-lease'
    abbr -a ga  'git add'
    abbr -a gaa 'git add -A'
    abbr -a gco 'git checkout'
    abbr -a gcb 'git checkout -b'
    abbr -a gf  'git fetch'
end
