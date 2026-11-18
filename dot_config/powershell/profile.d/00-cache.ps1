# Process spawns are slow in some terminals (herdr: ~1s each), so cache `<tool> init` output
# and regenerate only when the tool's executable is newer than the cache.
function Import-CachedInit {
    param([string]$Name, [string[]]$InitArgs)
    $cmd = Get-Command $Name -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $cmd) { return }
    $dir = Join-Path $env:LOCALAPPDATA 'pwsh-init-cache'
    $cache = Join-Path $dir "$Name.ps1"
    if (-not (Test-Path $cache) -or (Get-Item $cache).LastWriteTimeUtc -lt (Get-Item $cmd.Source).LastWriteTimeUtc) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        & $cmd.Source @InitArgs | Out-File -FilePath $cache -Encoding utf8
    }
    . $cache
}
