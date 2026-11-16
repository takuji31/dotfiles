if ($mise = Get-Command mise -ErrorAction SilentlyContinue) {
    # Elevated sessions (e.g. SSH logins as an admin) refuse user-created symlinks
    # like WinGet\Links\mise.exe (os error 448), so put the real directory first.
    $target = (Get-Item $mise.Source).Target
    if ($target) { $env:PATH = "$(Split-Path $target);$env:PATH" }
    (&mise activate pwsh --shims) | Out-String | Invoke-Expression
}
