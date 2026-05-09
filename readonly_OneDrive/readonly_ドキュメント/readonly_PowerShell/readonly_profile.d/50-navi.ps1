if (Get-Module -ListAvailable -Name navi.plugin) {
    Import-Module navi.plugin
    Set-PSReadlineKeyHandler -Chord 'Ctrl+g' -ScriptBlock { Invoke-NaviWidget }
}
