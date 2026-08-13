function chezmoi-update-all --wraps chezmoi
    chezmoi update $argv; and chezmoi-agents update $argv
end
