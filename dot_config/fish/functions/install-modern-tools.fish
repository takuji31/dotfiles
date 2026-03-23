function install-modern-tools -d "Install modern CLI tools (cross-platform)"
    set -l dry_run 0
    for arg in $argv
        switch $arg
            case -n --dry-run
                set dry_run 1
        end
    end

    set -l tools \
        eza:eza:brew \
        bat:bat:brew \
        fd:fd:brew \
        ripgrep:rg:brew \
        fzf:fzf:brew \
        jq:jq:brew \
        zoxide:zoxide:brew \
        sd:sd:brew \
        jnv:jnv:brew \
        btop:btop:brew \
        dust:dust:brew \
        duf:duf:brew \
        procs:procs:brew \
        git-delta:delta:brew \
        xh:xh:brew \
        doggo:doggo:brew \
        trippy:trip:brew \
        tealdeer:tldr:brew \
        hyperfine:hyperfine:brew \
        navi:navi:brew \
        atuin:atuin:brew \
        lazygit:lazygit:brew \
        gh:gh:brew \
        starship:starship:brew \
        yazi:yazi:brew

    set -l missing_packages

    echo "Checking for missing modern CLI tools..."

    for entry in $tools
        set -l parts (string split ":" $entry)
        set -l package $parts[1]
        set -l check_cmd $parts[2]

        if not command -q $check_cmd
            echo "  Missing: $check_cmd ($package)"
            set -a missing_packages $package
        end
    end

    if test (count $missing_packages) -eq 0
        echo "All modern CLI tools are already installed!"
        return 0
    end

    echo ""
    echo "Missing tools: "(count $missing_packages)" packages"

    if test $dry_run -eq 1
        echo "[DRY RUN] Would install via brew:"
        for pkg in $missing_packages
            echo "  - $pkg"
        end
        echo "  Command: brew install $missing_packages"
        return 0
    end

    if not command -q brew
        echo "Error: Homebrew is not installed."
        echo 'Install: /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
        return 1
    end

    echo "Installing via brew: $missing_packages"
    brew install $missing_packages

    echo ""
    echo "Installation complete! Restart your shell or run: exec fish"
end
