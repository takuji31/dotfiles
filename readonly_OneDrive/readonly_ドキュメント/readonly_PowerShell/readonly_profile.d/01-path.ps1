function Add-ToPathHead {
    param([string]$Dir)
    if (-not (Test-Path $Dir)) { return }
    $sep = [IO.Path]::PathSeparator
    $paths = $env:PATH -split $sep
    if ($paths -notcontains $Dir) {
        $env:PATH = $Dir + $sep + $env:PATH
    }
}

Add-ToPathHead (Join-Path $HOME '.local\bin')
Add-ToPathHead (Join-Path $HOME 'bin')
