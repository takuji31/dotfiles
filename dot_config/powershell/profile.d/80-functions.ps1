function ghq_fzf {
    if (-not (Get-Command ghq -ErrorAction SilentlyContinue)) { return }
    if (-not (Get-Command fzf -ErrorAction SilentlyContinue)) { return }
    $dir = ghq list --full-path | fzf
    if ($dir) { Set-Location $dir }
}

function cleanup-branches {
    git delete-merged-branches
    git fetch --prune --prune-tags
}
