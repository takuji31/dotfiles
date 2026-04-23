function __complete_git-spice
    set -lx COMP_LINE (commandline -cp)
    test -z (commandline -ct)
    and set COMP_LINE "$COMP_LINE "
    command git-spice
end
complete -f -c git-spice -a "(__complete_git-spice)"
