#!/usr/bin/env bash
# VERBATIM from llama3.2:3b, 2026-09-16 -- its own "more concise version".
# Only change: /etc/hosts -> $HOSTS so it is safe to run on stage.
HOSTS="${HOSTS:-$(dirname "$0")/hosts}"
echo "10.0.0.9 backup-server" >> "$HOSTS"
if grep -q "10.0.0.9" "$HOSTS"; then
  echo "The IP address 10.0.0.9 already exists in the hosts file."
else
  echo "Backup server added successfully"
fi
