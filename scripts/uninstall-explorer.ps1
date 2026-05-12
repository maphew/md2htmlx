<#
.SYNOPSIS
    Remove the md2htmlx Explorer integration created by install-explorer.ps1.

.DESCRIPTION
    Deletes every HKCU registry key the install script creates:
      - HKCU\Software\Classes\Applications\md2htmlx.exe
      - HKCU\Software\Classes\md2htmlx.md
      - HKCU\Software\Classes\.md\OpenWithProgids\md2htmlx.md value
      - HKCU\Software\Classes\SystemFileAssociations\.md\shell\Render with md2htmlx

    Leaves the .md OpenWithProgids key itself in place (other apps may
    have entries there).

    Does not touch HKLM and does not require admin.

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File .\scripts\uninstall-explorer.ps1
#>
[CmdletBinding()]
param()

$ErrorActionPreference = 'Continue'

function Remove-KeyIfPresent {
    param([string]$Path)
    if (Test-Path -LiteralPath $Path) {
        Remove-Item -LiteralPath $Path -Recurse -Force
        Write-Host "Removed: $Path"
    }
    else {
        Write-Host "Skip   : $Path (not present)"
    }
}

Remove-KeyIfPresent 'HKCU:\Software\Classes\Applications\md2htmlx.exe'
Remove-KeyIfPresent 'HKCU:\Software\Classes\md2htmlx.md'
Remove-KeyIfPresent 'HKCU:\Software\Classes\SystemFileAssociations\.md\shell\Render with md2htmlx'

# Remove the generated .ico (and its folder, if it ends up empty).
$iconDir = Join-Path $env:LOCALAPPDATA 'md2htmlx'
$iconPath = Join-Path $iconDir 'md.ico'
if (Test-Path -LiteralPath $iconPath) {
    Remove-Item -LiteralPath $iconPath -Force
    Write-Host "Removed: $iconPath"
}
if ((Test-Path -LiteralPath $iconDir) -and -not (Get-ChildItem -LiteralPath $iconDir -Force)) {
    Remove-Item -LiteralPath $iconDir -Force
    Write-Host "Removed: $iconDir (empty)"
}

# Just remove the single value we added under OpenWithProgids; leave the key.
$openWith = 'HKCU:\Software\Classes\.md\OpenWithProgids'
if (Test-Path -LiteralPath $openWith) {
    $prop = Get-ItemProperty -LiteralPath $openWith -Name 'md2htmlx.md' -ErrorAction SilentlyContinue
    if ($prop) {
        Remove-ItemProperty -LiteralPath $openWith -Name 'md2htmlx.md' -Force
        Write-Host "Removed value: $openWith\md2htmlx.md"
    }
    else {
        Write-Host "Skip   : $openWith\md2htmlx.md (not present)"
    }
}

Write-Host ""
Write-Host "Done." -ForegroundColor Green
Write-Host "If md2htmlx was set as the default handler for .md, Windows will"
Write-Host "prompt you to pick a new default the next time you open a .md file."
