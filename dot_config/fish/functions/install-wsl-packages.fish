function install-wsl-packages -d "Install missing packages for WSL Ubuntu (idempotent)"
    # Parse arguments
    set -l dry_run 0
    for arg in $argv
        switch $arg
            case -n --dry-run
                set dry_run 1
        end
    end

    # Check if running on WSL
    set -l is_wsl 0
    if test -f /proc/version
        if string match -qi "*microsoft*" (cat /proc/version); or string match -qi "*WSL*" (cat /proc/version)
            set is_wsl 1
        end
    end

    if test $is_wsl -eq 0
        echo "This function is only for WSL environments"
        return 1
    end

    # Check if running on Ubuntu
    if not test -f /etc/lsb-release
        echo "This function is designed for Ubuntu"
        return 1
    end

    # Load package list from config file
    set -l config_file ~/.config/fish/wsl-packages.txt
    if not test -f $config_file
        echo "Error: Package list file not found: $config_file"
        return 1
    end

    set -l apt_packages
    set -l brew_packages
    set -l snap_packages

    if test $dry_run -eq 1
        echo "[DRY RUN MODE] No packages will be installed"
        echo ""
    end

    echo "Checking for missing packages..."

    # Read and process package list
    for line in (cat $config_file)
        # Skip comments and empty lines
        if string match -qr '^\s*#' -- $line; or test -z "$line"
            continue
        end

        set -l parts (string split ":" $line)
        set -l part_count (count $parts)

        if test $part_count -lt 2
            continue
        end

        set -l package $parts[1]
        set -l command $parts[2]
        set -l method "apt"

        if test $part_count -ge 3
            set method $parts[3]
        end

        if not type -q $command
            echo "  Missing: $package ($method)"
            switch $method
                case apt
                    set -a apt_packages $package
                case brew
                    set -a brew_packages $package
                case snap
                    set -a snap_packages $package
            end
        end
    end

    # Install or show missing packages
    set -l total_missing (math (count $apt_packages) + (count $brew_packages) + (count $snap_packages))

    if test $total_missing -gt 0
        echo ""

        if test $dry_run -eq 1
            # Dry run mode
            if test (count $apt_packages) -gt 0
                echo "[DRY RUN] Would install via apt:"
                for pkg in $apt_packages
                    echo "  - $pkg"
                end
                echo "  Command: sudo apt-get update && sudo apt-get install -y $apt_packages"
                echo ""
            end

            if test (count $brew_packages) -gt 0
                echo "[DRY RUN] Would install via brew:"
                for pkg in $brew_packages
                    echo "  - $pkg"
                end
                echo "  Command: brew install $brew_packages"
                echo ""
            end

            if test (count $snap_packages) -gt 0
                echo "[DRY RUN] Would install via snap:"
                for pkg in $snap_packages
                    echo "  - $pkg"
                end
                echo "  Command: sudo snap install $snap_packages"
                echo ""
            end
        else
            # Actual installation
            if test (count $apt_packages) -gt 0
                echo "Installing via apt: $apt_packages"
                sudo apt-get update
                sudo apt-get install -y $apt_packages
                echo ""
            end

            if test (count $brew_packages) -gt 0
                echo "Installing via brew: $brew_packages"
                if not type -q brew
                    echo "Error: Homebrew is not installed. Install it first:"
                    echo '  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
                    return 1
                end
                brew install $brew_packages
                echo ""
            end

            if test (count $snap_packages) -gt 0
                echo "Installing via snap: $snap_packages"
                if not type -q snap
                    echo "Error: snap is not installed"
                    return 1
                end
                sudo snap install $snap_packages
                echo ""
            end

            echo "Installation complete!"
        end
    else
        echo "All packages are already installed!"
    end
end
