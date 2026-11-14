$ProfileDir = Join-Path $PSScriptRoot 'profile.d'
if (Test-Path $ProfileDir) {
    Get-ChildItem -Path $ProfileDir -Filter '*.ps1' |
        Sort-Object Name |
        ForEach-Object { . $_.FullName }
}

# XDG_DATA_HOME must be a persistent user env var: otherwise mise resolves its data dir to
# %LOCALAPPDATA%\mise outside these profiles (GUI apps, agents) and the shims break.
$setupIssue = if (-not (Get-Command mise -ErrorAction SilentlyContinue)) {
    'mise not found'
} elseif (-not [Environment]::GetEnvironmentVariable('XDG_DATA_HOME', 'User')) {
    'XDG_DATA_HOME is not set as a user environment variable'
}
if ($setupIssue) {
    Write-Host ''
    Write-Host "Windows setup is incomplete ($setupIssue)." -ForegroundColor Yellow
    Write-Host 'Run the setup script:' -ForegroundColor Yellow
    Write-Host '  irm https://gist.githubusercontent.com/takuji31/2316b55050f0f0d72313b8e2d7af873d/raw/setup-windows.ps1 | iex' -ForegroundColor Cyan
    Write-Host ''
}

if (Get-Command git-wt -ErrorAction SilentlyContinue) { Invoke-Expression (& git-wt config shell init powershell | Out-String) }
