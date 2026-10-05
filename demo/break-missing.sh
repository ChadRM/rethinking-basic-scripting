#!/usr/bin/env bash
# Put the sandbox hosts file into the "entry is gone entirely" state -- what a rebuild,
# a fresh image or a golden AMI hands you.  Demo helper, so nothing has to be typed live.
# NOTHING IN THIS DIRECTORY EVER TOUCHES THE REAL /etc/hosts.
set -euo pipefail
cd "$(dirname "$0")"
sed -i '/backup-server/d' hosts
echo "state -> backup-server entry removed"
