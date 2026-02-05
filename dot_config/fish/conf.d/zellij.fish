# Zellij aliases
if command -q zellij
    alias zj="zellij"
    alias za="zellij attach"
    alias zl="zellij list-sessions"
    alias zk="zellij kill-session"

    # Zellij project layout (.zellij.kdl) manager
    function zp
        set -l layout_dir ~/.config/zellij/layouts

        switch $argv[1]
            case edit
                set -l editor $EDITOR
                test -z "$editor"; and set editor vim
                $editor .zellij.kdl
            case new
                if test -f .zellij.kdl
                    echo "Error: .zellij.kdl already exists" >&2
                    return 1
                end
                set -l templates (find $layout_dir -name '*.kdl' -type f 2>/dev/null | sort)
                if test -z "$templates"
                    echo "Error: No templates found in $layout_dir" >&2
                    return 1
                end
                set -l selected (printf '%s\n' $templates | fzf --prompt="Select template: ")
                if test -n "$selected"
                    cp "$selected" .zellij.kdl
                    echo "Created .zellij.kdl from "(basename $selected)
                else
                    echo "Cancelled" >&2
                    return 1
                end
            case ''
                if test -f .zellij.kdl
                    zellij --layout ./.zellij.kdl
                else
                    echo "Error: .zellij.kdl not found in current directory" >&2
                    return 1
                end
            case '*'
                echo "Usage: zp [new|edit]" >&2
                return 1
        end
    end
end
