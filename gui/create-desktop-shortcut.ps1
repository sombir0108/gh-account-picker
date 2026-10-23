param(
  [Parameter(Mandatory = $true)][string]$SwitchScriptPath
)

$desktop = [Environment]::GetFolderPath("Desktop")
$shortcutPath = Join-Path $desktop "Switch GitHub Account.lnk"

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($shortcutPath)
$Shortcut.TargetPath = "powershell.exe"
$Shortcut.Arguments = "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$SwitchScriptPath`""
$Shortcut.WorkingDirectory = Split-Path $SwitchScriptPath
$Shortcut.IconLocation = "powershell.exe,0"
$Shortcut.Description = "Switch the active GitHub CLI/git account"
$Shortcut.Save()

Write-Output $shortcutPath
