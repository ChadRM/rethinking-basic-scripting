# TIER 1 -- the two-line fix. Add-Content is the append (>> in bash).
# It never checks. Run it twice and you have two entries.
$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot
Add-Content -Path .\hosts -Value "10.0.0.9`tbackup-server"
Write-Host "Backup server added successfully."
exit 0
