function cleanup-branches
    if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
        echo "cleanup-branches: not inside a git repository" >&2
        return 1
    end
    if not command -q gh
        echo "cleanup-branches: 'gh' not found. Install GitHub CLI: https://cli.github.com/" >&2
        return 1
    end
    if not gh extension list 2>/dev/null | grep -q '\bgh poi\b'
        echo "cleanup-branches: 'gh poi' extension not installed." >&2
        echo "  Install: gh extension install seachicken/gh-poi" >&2
        return 1
    end
    set -l has_state 0
    for arg in $argv
        if test "$arg" = "--state"; or string match -q "--state=*" -- $arg
            set has_state 1
            break
        end
    end
    set -l poi_args
    if test $has_state -eq 0
        set poi_args --state closed
    end
    set -a poi_args $argv
    git fetch --prune --prune-tags
    gh poi $poi_args
end
