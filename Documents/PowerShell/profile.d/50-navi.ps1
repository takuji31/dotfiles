if (Get-Command navi -ErrorAction SilentlyContinue) {
    navi widget powershell | Out-String | Invoke-Expression
}
