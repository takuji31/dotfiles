if not command -q mise
    if status is-interactive
        echo "mise not found. Installing..."
        curl https://mise.run | sh
        fish_add_path $HOME/.local/bin
    end
end

if command -q mise
    if status is-interactive
        if not mise install --dry-run-code --quiet 2>/dev/null
            echo "Installing missing tools via mise..."
            mise install --yes
        end
    end
    mise activate fish | source
end
