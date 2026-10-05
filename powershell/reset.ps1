# Rebuild the throwaway hosts file to a known pre-demo state.
# NOTHING IN THIS DIRECTORY EVER TOUCHES THE REAL hosts FILE.
$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot
if (Test-Path .\hosts) { Set-ItemProperty .\hosts -Name IsReadOnly -Value $false }
Copy-Item .\hosts.seed .\hosts -Force
if (-not (Compare-Object (Get-Content .\hosts.seed) (Get-Content .\hosts))) {
    Write-Host "reset -> $(Join-Path $PSScriptRoot 'hosts')"
} else { [Console]::Error.WriteLine("RESET FAILED: hosts does not match the seed"); exit 1 }
exit 0
