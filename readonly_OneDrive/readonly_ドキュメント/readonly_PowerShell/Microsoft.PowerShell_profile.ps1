$ProfileDir = Join-Path (Split-Path -Parent $PROFILE) 'profile.d'
if (Test-Path $ProfileDir) {
    Get-ChildItem -Path $ProfileDir -Filter '*.ps1' |
        Sort-Object Name |
        ForEach-Object { . $_.FullName }
}

if (-not (Get-Command mise -ErrorAction SilentlyContinue)) {
    Write-Host ''
    Write-Host 'Windows setup is incomplete (mise not found).' -ForegroundColor Yellow
    Write-Host 'Run the setup script:' -ForegroundColor Yellow
    Write-Host '  irm https://gist.githubusercontent.com/takuji31/2316b55050f0f0d72313b8e2d7af873d/raw/setup-windows.ps1 | iex' -ForegroundColor Cyan
    Write-Host ''
}

if (Get-Command git-wt -ErrorAction SilentlyContinue) { Invoke-Expression (& git-wt config shell init powershell | Out-String) }
