#!/usr/bin/env bash
# VERBATIM from Claude Opus 5, clean room, 2026-09-16. Original: ../captures/opus5_cleanroom_2026-09-16.sh
# Only changes: /etc/hosts -> $HOSTS, and the must-be-root check removed, so it is safe to run on stage.
# Add (or update) the backup-server entry in /etc/hosts.
# You can run it more than once: it does nothing if the entry is already correct.
set -euo pipefail

IP="10.0.0.9"
NAME="backup-server"
HOSTS="${HOSTS:-$(dirname "$0")/hosts}"


# Already mapped correctly? Nothing to do.
if grep -qE "^[[:space:]]*${IP//./\\.}[[:space:]]+([^#]*[[:space:]])?${NAME}([[:space:]]|\$|#)" "$HOSTS"; then
    echo "$HOSTS already maps $NAME to $IP"
    exit 0
fi

cp -p "$HOSTS" "${HOSTS}.bak.$(date +%Y%m%d%H%M%S)"

# If the name is mapped to a different IP, remove the name from that line
# (and drop the line if it had no other hostnames). Other lines are untouched.
tmp=$(mktemp)
awk -v name="$NAME" '
    /^[[:space:]]*#/ || NF < 2 { print; next }
    {
        found = 0
        for (i = 2; i <= NF && $i !~ /^#/; i++) if ($i == name) found = 1
        if (!found) { print; next }
        out = $1; kept = 0
        for (i = 2; i <= NF; i++) {
            if ($i ~ /^#/) { for (j = i; j <= NF; j++) out = out " " $j; break }
            if ($i != name) { out = out " " $i; kept++ }
        }
        if (kept > 0) print out
    }
' "$HOSTS" > "$tmp"
cat "$tmp" > "$HOSTS"   # write in place to keep ownership and permissions
rm -f "$tmp"

printf '%s\t%s\n' "$IP" "$NAME" >> "$HOSTS"
echo "Added: $IP $NAME"
