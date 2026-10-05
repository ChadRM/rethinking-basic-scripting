#!/usr/bin/env bash
# Rebuild the throwaway hosts file to a known pre-demo state.
# NOTHING IN THIS DIRECTORY EVER TOUCHES THE REAL /etc/hosts.
#
# 2026-09-23: this used to `cp` and echo success unconditionally -- so after the read-only
# beat it printed "reset ->" and exited 0 while doing nothing at all. The demo for the talk
# about silent failure was failing silently. It now clears the read-only bit first and
# verifies the result.
set -euo pipefail
cd "$(dirname "$0")"
[[ -e hosts ]] && chmod u+w hosts
cp hosts.seed hosts
chmod 644 hosts
cmp -s hosts.seed hosts || { echo "RESET FAILED: hosts does not match the seed" >&2; exit 1; }
echo "reset -> $(pwd)/hosts"
