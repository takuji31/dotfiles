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

    set -l packages_to_install

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
        if test (count $parts) -ne 2
            continue
        end

        set -l package $parts[1]
        set -l command $parts[2]

        if not type -q $command
            echo "  Missing: $package"
            set -a packages_to_install $package
        end
    end

    # Install or show missing packages
    if test (count $packages_to_install) -gt 0
        echo ""
        if test $dry_run -eq 1
            echo "[DRY RUN] Would install the following packages:"
            for pkg in $packages_to_install
                echo "  - $pkg"
            end
            echo ""
            echo "[DRY RUN] Would run:"
            echo "  sudo apt-get update"
            echo "  sudo apt-get install -y $packages_to_install"
        else
            echo "Installing missing packages: $packages_to_install"
            sudo apt-get update
            sudo apt-get install -y $packages_to_install
            echo ""
            echo "Installation complete!"
        end
    else
        echo "All packages are already installed!"
    end
end
