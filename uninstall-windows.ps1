# Windows-native entry point for removing gh-account-picker. See
# install-windows.ps1 for why this bridges to uninstall.sh via Git for
# Windows' bundled bash.exe rather than a plain `bash` on PATH.
param(
  [string]$InstallDir
)

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

$gitCmd = Get-Command git -ErrorAction SilentlyContinue
if (-not $gitCmd) {
  Write-Error "Git not found."
  exit 1
}

$bash = $null
$dir = Split-Path -Parent $gitCmd.Source
for ($i = 0; $i -lt 4 -and -not $bash; $i++) {
  $dir = Split-Path -Parent $dir
  if (-not $dir) { break }
  foreach ($rel in @("bin\bash.exe", "usr\bin\bash.exe")) {
    $candidate = Join-Path $dir $rel
    if (Test-Path $candidate) { $bash = $candidate; break }
  }
}

if (-not $bash) {
  Write-Error "Could not find the bash.exe bundled with Git for Windows near '$($gitCmd.Source)'. Run uninstall.sh manually from Git Bash instead."
  exit 1
}

$uninstallScript = Join-Path $scriptDir "uninstall.sh"
$bashArgs = @($uninstallScript)
if ($InstallDir) { $bashArgs += $InstallDir }

& $bash @bashArgs
exit $LASTEXITCODE
