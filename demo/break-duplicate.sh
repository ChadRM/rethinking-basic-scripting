#!/usr/bin/env bash
# Put the sandbox hosts file into the "two conflicting entries" state -- what a naive
# append-only script leaves behind after it runs twice.  Demo helper.
# NOTHING IN THIS DIRECTORY EVER TOUCHES THE REAL /etc/hosts.
set -euo pipefail
cd "$(dirname "$0")"
printf '%s\t%s\n' "10.0.0.9" "backup-server" >> hosts
echo "state -> second conflicting backup-server entry appended"
