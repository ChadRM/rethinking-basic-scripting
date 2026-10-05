#!/usr/bin/env bash
# Put the sandbox hosts file into the "three conflicting entries, none correct" state.
# Demo helper, so nothing has to be typed live.
# NOTHING IN THIS DIRECTORY EVER TOUCHES THE REAL /etc/hosts.
set -euo pipefail
cd "$(dirname "$0")"
printf '%s\t%s\n' "10.0.0.6" "backup-server" >> hosts
printf '%s\t%s\n' "10.0.0.7" "backup-server" >> hosts
echo "state -> three conflicting backup-server entries ($(grep -c backup-server hosts) lines)"
