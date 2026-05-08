function theme-toggle --description 'Toggle Zellij theme between theme_dark and theme_light'
    set -q ZELLIJ_SESSION_NAME; or return 0
    zellij action toggle-theme
end
