# Zellij aliases
if command -q zellij
    alias zj="zellij"
    alias za="zellij attach"
    alias zl="zellij list-sessions"
    alias zk="zellij kill-session"

    # Zellij project layout (.zellij.kdl) manager
    function zp
        set -l layout_dir ~/.config/zellij/layouts
        set -l template_file $layout_dir/_template.kdl

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
                # Exclude _template.kdl and default.kdl from selection
                set -l templates (find $layout_dir -name '*.kdl' -type f ! -name '_*' ! -name 'default.kdl' 2>/dev/null | sort)
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
                if not test -f .zellij.kdl
                    echo "Error: .zellij.kdl not found in current directory" >&2
                    return 1
                end
                if not test -f $template_file
                    echo "Error: Template not found: $template_file" >&2
                    return 1
                end
                # Combine template and project layout
                set -l tmp_layout
                if test (uname) = Darwin
                    set tmp_layout (mktemp /tmp/zellij-XXXXXXXX)
                else
                    set tmp_layout (mktemp --suffix=.kdl)
                end
                echo "layout {" > $tmp_layout
                cat $template_file >> $tmp_layout
                cat .zellij.kdl >> $tmp_layout
                echo "}" >> $tmp_layout
                zellij --layout $tmp_layout
                rm -f $tmp_layout
            case '*'
                echo "Usage: zp [new|edit]" >&2
                return 1
        end
    end
end
