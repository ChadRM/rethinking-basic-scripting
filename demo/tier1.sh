#!/usr/bin/env bash
# TIER 1 -- what everybody writes. Ships. Runs clean. Reports success.
HOSTS="${HOSTS:-$(dirname "$0")/hosts}"
echo "10.0.0.9	backup-server" >> "$HOSTS"
echo "Backup server added successfully."
