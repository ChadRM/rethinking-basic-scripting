# What the RESOLVER does -- first match wins, so it is visible rather than magic.
# (Windows reads C:\Windows\System32\drivers\etc\hosts the same way.)
$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot
$name = 'backup-server'
$hit = Get-Content .\hosts |
       Where-Object { $_ -notmatch '^\s*#' -and $_ -match "\s$([regex]::Escape($name))(\s|$)" } |
       Select-Object -First 1
if ($hit) { ($hit -split '\s+')[0] } else { Write-Host "no entry for $name" }
exit 0
