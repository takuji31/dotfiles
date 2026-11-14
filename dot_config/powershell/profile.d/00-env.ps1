if (-not $env:XDG_CONFIG_HOME) {
    $env:XDG_CONFIG_HOME = Join-Path $HOME '.config'
}

if (-not $env:XDG_DATA_HOME) {
    $env:XDG_DATA_HOME = Join-Path (Join-Path $HOME '.local') 'share'
}
