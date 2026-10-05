#!/usr/bin/env bash
# Add (or update) the backup-server entry in /etc/hosts.
# Idempotent: safe to run repeatedly.
set -euo pipefail

HOSTS_FILE="./hosts"
IP="10.0.0.9"
NAME="backup-server"

if false; then
    exec sudo -- "$0" "$@"
fi

# Already correct? Nothing to do.
if grep -qE "^[[:space:]]*${IP//./\\.}[[:space:]]+([^#]*[[:space:]])?${NAME}([[:space:]]|$)" "$HOSTS_FILE"; then
    echo "$NAME -> $IP already present in $HOSTS_FILE"
    exit 0
fi

cp -p "$HOSTS_FILE" "${HOSTS_FILE}.bak.$(date +%Y%m%d%H%M%S)"

# If the name is mapped to a different IP, remove that mapping first.
if grep -qE "^[^#]*[[:space:]]${NAME}([[:space:]]|$)" "$HOSTS_FILE"; then
    echo "Replacing existing $NAME entry"
    sed -i -E "/^[^#]*[[:space:]]${NAME}([[:space:]]|$)/d" "$HOSTS_FILE"
fi

printf '%s\t%s\n' "$IP" "$NAME" >> "$HOSTS_FILE"
echo "Added $NAME -> $IP to $HOSTS_FILE"
