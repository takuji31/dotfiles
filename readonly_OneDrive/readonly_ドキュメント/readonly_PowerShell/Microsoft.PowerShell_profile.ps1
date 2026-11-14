# Entry point only: the real profile lives in ~/.config/powershell (managed by chezmoi) to keep OneDrive sync conflicts away.
$init = Join-Path $HOME '.config\powershell\init.ps1'
if (Test-Path $init) { . $init }
