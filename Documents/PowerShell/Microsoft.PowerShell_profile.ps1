# Managed by chezmoi - do not edit directly
$ProfileDir = Join-Path (Split-Path -Parent $PROFILE) 'profile.d'
if (Test-Path $ProfileDir) {
    Get-ChildItem -Path $ProfileDir -Filter '*.ps1' |
        Sort-Object Name |
        ForEach-Object { . $_.FullName }
}
