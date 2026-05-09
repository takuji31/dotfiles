if (Get-Module -ListAvailable -Name PSReadLine) {
    Set-PSReadLineKeyHandler -Chord 'Ctrl+s' -ScriptBlock {
        [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
        ghq_fzf
        [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
    }
}
