function gcm --description "Compose conventional commit message"
    if not command -q fzf
        echo "gcm: 'fzf' not found" >&2
        return 1
    end

    set -l type (printf '%s\n' feat fix docs refactor test chore style perf | fzf --prompt='type> ' --height=40%)
    or return

    read -P 'scope (blank=none): ' -l scope

    set -l prefix
    if test -n "$scope"
        set prefix "$type($scope): "
    else
        set prefix "$type: "
    end

    set -l pre_cursor 'git commit -m "'$prefix
    set -l line $pre_cursor'"'

    commandline -r -- $line
    commandline -C (string length -- $pre_cursor)
end
