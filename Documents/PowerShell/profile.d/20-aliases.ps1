Set-Alias -Name cat -Value bat     -Force
Set-Alias -Name du  -Value dust    -Force
Set-Alias -Name df  -Value duf     -Force
Set-Alias -Name ps  -Value procs   -Force
Set-Alias -Name top -Value btop    -Force
Set-Alias -Name lg  -Value lazygit -Force

function ls { eza --icons --git @args }
function ll { eza -l --header --icons --git @args }
function la { eza -la --header --icons @args }
function lt { eza --tree --level=2 @args }
