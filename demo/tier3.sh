#!/usr/bin/env bash
# TIER 3 -- a state machine, not a check.
set -euo pipefail

HOSTS="${HOSTS:-$(dirname "$0")/hosts}"
NAME="backup-server"
IP="10.0.0.9"

# --- refuse before you act -------------------------------------------------
[[ -L "$HOSTS" ]] && { echo "REFUSE: $HOSTS is a symlink"    >&2; exit 3; }
[[ -w "$HOSTS" ]] || { echo "REFUSE: $HOSTS is not writable" >&2; exit 3; }

pattern="^[[:space:]]*[^#][^[:space:]]*[[:space:]]+${NAME}([[:space:]]|$)"
count=$(grep -Ec "$pattern" "$HOSTS" || true)

case "$count" in
  0)  printf '%s\t%s\n' "$IP" "$NAME" >> "$HOSTS"
      echo "ADDED    ${NAME} -> ${IP}" ;;
  1)  current=$(grep -E "$pattern" "$HOSTS" | awk '{print $1}')
      if [[ "$current" == "$IP" ]]; then
        echo "OK       ${NAME} already ${IP} - no change"
      else
        cp -p "$HOSTS" "${HOSTS}.bak.$(date +%Y-%m-%d)"
        tmp=$(mktemp)
        awk -v ip="$IP" -v n="$NAME" \
          '$2==n && $0!~/^[[:space:]]*#/ {print ip"\t"n; next} {print}' \
          "$HOSTS" > "$tmp"
        cat "$tmp" > "$HOSTS"; rm -f "$tmp"     # preserve inode/perms
        echo "REPLACED ${NAME} ${current} -> ${IP}"
      fi ;;
  *)  echo "REFUSE: ${count} entries for ${NAME} - ambiguous, needs a human" >&2
      exit 3 ;;
esac
