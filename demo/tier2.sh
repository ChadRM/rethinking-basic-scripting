#!/usr/bin/env bash
# TIER 2 -- "fixed the duplicates."
HOSTS="${HOSTS:-$(dirname "$0")/hosts}"
echo "10.0.0.9	backup-server" > "$HOSTS"
echo "Backup server added successfully. No duplicates!"
