if command -q git-spice
    abbr -a gs git-spice

    # branch 操作
    abbr -a gsbc 'git-spice branch create'
    abbr -a gsbs 'git-spice branch submit'
    abbr -a gsbk 'git-spice branch checkout'
    abbr -a gsbd 'git-spice branch delete'

    # stack 操作
    abbr -a gss  'git-spice stack submit'
    abbr -a gssr 'git-spice stack restack'

    # upstack / downstack
    abbr -a gsus 'git-spice upstack submit'
    abbr -a gsds 'git-spice downstack submit'
    abbr -a gsur 'git-spice upstack restack'

    # log 系
    abbr -a gsl  'git-spice log short'
    abbr -a gsls 'git-spice log long'
end
