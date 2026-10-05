#!/usr/bin/env bash
# Put the sandbox hosts file into the "somebody forgot sudo" state -- read-only.
# ./reset.sh clears this again on its own. Demo helper.
# NOTHING IN THIS DIRECTORY EVER TOUCHES THE REAL /etc/hosts.
set -euo pipefail
cd "$(dirname "$0")"
chmod 444 hosts
echo "state -> hosts is now read-only ($(stat -c %a hosts))"
