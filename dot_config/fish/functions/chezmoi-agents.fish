function chezmoi-agents --wraps chezmoi
    chezmoi --source $HOME/.local/share/agents-config $argv
end
