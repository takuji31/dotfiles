if (Get-Command atuin -ErrorAction SilentlyContinue) {
    atuin init powershell | Out-String | Invoke-Expression
    Set-PSReadLineKeyHandler -Chord 'UpArrow' -Function PreviousHistory
}
