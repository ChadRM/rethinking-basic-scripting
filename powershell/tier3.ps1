# TIER 3 -- a state machine, not a check. PowerShell mirror of tier3.sh.
# Same six states, same answers, same refusals.
$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot

$HostsFile = '.\hosts'
$IP        = '10.0.0.9'
$Name      = 'backup-server'

# --- refuse before you act ---------------------------------------------------
$item = Get-Item $HostsFile -ErrorAction SilentlyContinue
if (-not $item) {
    Set-Content -Path $HostsFile -Value "$IP`t$Name"
    Write-Host "CREATED  $HostsFile with $Name -> $IP"; exit 0
}
if ($item.LinkType) { [Console]::Error.WriteLine("REFUSE: $HostsFile is a $($item.LinkType)"); exit 3 }
if ($item.IsReadOnly) { [Console]::Error.WriteLine("REFUSE: $HostsFile is not writable"); exit 3 }

$pattern = "^\s*[^#]\S*\s+$([regex]::Escape($Name))(\s|$)"
$lines   = Get-Content $HostsFile
$matches = @($lines | Where-Object { $_ -match $pattern })

switch ($matches.Count) {
    0 {
        Add-Content -Path $HostsFile -Value "$IP`t$Name"
        Write-Host "ADDED    $Name -> $IP"
    }
    1 {
        $current = ($matches[0] -split '\s+')[0]
        if ($current -eq $IP) {
            Write-Host "OK       $Name already $IP - no change"
        } else {
            Copy-Item $HostsFile "$HostsFile.bak.$(Get-Date -Format 'yyyy-MM-dd')" -Force
            # rewrite the file in place: keep every other line untouched
            $out = $lines | ForEach-Object {
                if ($_ -match $pattern) { "$IP`t$Name" } else { $_ }
            }
            Set-Content -Path $HostsFile -Value $out
            Write-Host "REPLACED $Name $current -> $IP"
        }
    }
    default {
        [Console]::Error.WriteLine("REFUSE: $($matches.Count) entries for $Name - ambiguous, needs a human")
        exit 3
    }
}
exit 0
