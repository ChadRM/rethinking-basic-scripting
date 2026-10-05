POWERSHELL MIRROR
=================

The same demo, on Windows. Same file semantics, same bug, same fix.

  reset.ps1     put hosts back to a known state (run this between demos)
  resolve.ps1   what the resolver does -- FIRST MATCH WINS
  tier1.ps1     the two-line fix.   Add-Content = the append  ( >>  in bash)
  tier2.ps1     the one-character "fix". Set-Content = overwrite  ( >  in bash)
                *** it replaces the whole file. That is the point. ***
  tier3.ps1     the state machine: six states, six answers, two refusals

These run against .\hosts in this folder -- a throwaway copy. They never touch
C:\Windows\System32\drivers\etc\hosts, and you should not point them at it.

    powershell -ExecutionPolicy Bypass -File .\reset.ps1
    powershell -ExecutionPolicy Bypass -File .\tier1.ps1

One Windows-specific note worth saying out loud: Resolve-DnsName will happily
hand you the stale entry, exactly like the resolver does on Linux. The platform
changes. The failure does not.
