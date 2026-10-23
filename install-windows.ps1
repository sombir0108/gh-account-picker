# Windows-native entry point for gh-account-picker. Run this directly from
# PowerShell (right-click -> "Run with PowerShell", or `.\install-windows.ps1`)
# — no need to open Git Bash manually first.
#
# The actual install logic lives in install.sh (bash), since it's shared
# with macOS/Linux. This script just locates the bash.exe that ships with
# Git for Windows and runs install.sh through it — deliberately NOT the
# `bash` found via PATH, since Windows also exposes a WSL bash.exe (at
# System32\bash.exe / WindowsApps\bash.exe) that would silently resolve
# first and can't see Git for Windows' installed tools.
param(
  [string]$InstallDir
)

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

$gitCmd = Get-Command git -ErrorAction SilentlyContinue
if (-not $gitCmd) {
  Write-Error "Git not found. Install Git for Windows first: https://git-scm.com/download/win"
  exit 1
}

# git.exe can be found at <GitRoot>\cmd\git.exe, <GitRoot>\bin\git.exe, or
# <GitRoot>\mingw64\bin\git.exe depending on how PATH resolved it — walk up
# from wherever it actually is and check each ancestor for bash.exe rather
# than assuming a fixed depth.
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
  Write-Error "Could not find the bash.exe bundled with Git for Windows near '$($gitCmd.Source)'. Run install.sh manually from Git Bash instead."
  exit 1
}

$installScript = Join-Path $scriptDir "install.sh"
$bashArgs = @($installScript)
if ($InstallDir) { $bashArgs += $InstallDir }

& $bash @bashArgs
exit $LASTEXITCODE
