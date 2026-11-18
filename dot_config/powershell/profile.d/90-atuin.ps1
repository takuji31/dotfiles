if (Get-Command atuin -ErrorAction SilentlyContinue) {
    # Pre-set the session so the init script skips spawning `atuin uuid` (same UUIDv7 hex format).
    if (-not $env:ATUIN_SESSION -or $env:ATUIN_PID -ne $PID) {
        $env:ATUIN_SESSION = [guid]::CreateVersion7().ToString('N')
        $env:ATUIN_PID = $PID
    }
    Import-CachedInit atuin @('init', 'powershell')
    Set-PSReadLineKeyHandler -Chord 'UpArrow' -Function PreviousHistory
}
