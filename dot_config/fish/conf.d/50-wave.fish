function __wave_restore_cwd --on-event fish_prompt
    if set -q WAVETERM_BLOCKID
        set -l saved_cwd (wsh getvar -b block CWD 2>&1)
        if test $status -eq 0 -a -d "$saved_cwd"
            cd $saved_cwd
        end
    end
    functions -e __wave_restore_cwd
end

function __wave_save_cwd --on-variable PWD
    if set -q WAVETERM_BLOCKID
        wsh setvar -b block CWD="$PWD" 2>/dev/null
    end
end
