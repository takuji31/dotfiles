function cleanup-branches
    if not command -q gh
        echo "cleanup-branches: 'gh' not found. Install GitHub CLI: https://cli.github.com/" >&2
        return 1
    end
    if not gh extension list 2>/dev/null | grep -q '\bgh poi\b'
        echo "cleanup-branches: 'gh poi' extension not installed." >&2
        echo "  Install: gh extension install seachicken/gh-poi" >&2
        return 1
    end
    git fetch --prune --prune-tags
    gh poi $argv
end
