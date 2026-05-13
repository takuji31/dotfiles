# Zellij abbreviations
if command -q zellij
    abbr -a zj zellij
    abbr -a za 'zellij attach'
    abbr -a zl 'zellij list-sessions'
    abbr -a zk 'zellij kill-session'
    abbr -a zp 'zellij --layout .zellij.kdl'
end
