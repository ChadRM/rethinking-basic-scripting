# TIER 2 -- the one-character "fix". Set-Content is the single arrow (>).
# It does not append. It replaces the ENTIRE FILE with one line.
# This is here to be run once, in horror, and then never again.
$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot
Set-Content -Path .\hosts -Value "10.0.0.9`tbackup-server"
Write-Host "Backup server added successfully."
exit 0
