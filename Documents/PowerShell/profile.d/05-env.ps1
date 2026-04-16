if (Get-Command nvim -ErrorAction SilentlyContinue) {
    $env:EDITOR = 'nvim'
} elseif (Get-Command code -ErrorAction SilentlyContinue) {
    $env:EDITOR = 'code -w'
}
$env:PAGER = 'less'
$env:BAT_THEME = 'Catppuccin Mocha'
$env:RIPGREP_CONFIG_PATH = Join-Path $HOME '.ripgreprc'
$env:CLAUDE_CODE_NO_FLICKER = '1'
