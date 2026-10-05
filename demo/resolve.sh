#!/usr/bin/env bash
# resolve.sh -- a SIMULATION of what the OS resolver does, in three lines.
#
# It always looks up ONE name: backup-server. That is the only host this session cares
# about, so there is nothing to type and nothing to get wrong.
#
# It reads the sandboxed hosts file in this directory -- never the real /etc/hosts --
# applies the same rule the OS applies, and prints which entry actually wins.
#
# THE RULE: /etc/hosts is FIRST MATCH WINS. The first line that names the host is the
# answer. Everything below it is dead weight, no matter how recently it was added.

HOSTS="${HOSTS:-$(dirname "$0")/hosts}"
NAME="backup-server"

line=$(grep -nE "^[[:space:]]*[^#][^[:space:]]*[[:space:]]+${NAME}([[:space:]]|$)" "$HOSTS" | head -1)
if [[ -z "$line" ]]; then echo "${NAME}: not found"; exit 1; fi
printf '%-16s -> %s      (line %s -- FIRST match wins)\n' \
  "$NAME" "$(echo "${line#*:}" | awk '{print $1}')" "${line%%:*}"
