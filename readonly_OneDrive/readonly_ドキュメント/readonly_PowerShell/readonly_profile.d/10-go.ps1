if (Get-Command go -ErrorAction SilentlyContinue) {
    $env:GOPATH = Join-Path $HOME '.go'
    $goBin = Join-Path $env:GOPATH 'bin'
    $sep = [IO.Path]::PathSeparator
    if ((Test-Path $goBin) -and (($env:PATH -split $sep) -notcontains $goBin)) {
        $env:PATH = $goBin + $sep + $env:PATH
    }
}
