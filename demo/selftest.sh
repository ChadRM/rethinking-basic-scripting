#!/usr/bin/env bash
# Pre-flight. Run this on the presenting machine the morning of. Expect ALL PASS.
cd "$(dirname "$0")"
fail=0
chk(){ if [[ "$2" == *"$3"* ]]; then echo "  ok   $1"; else echo "  FAIL $1: got [$2]"; fail=1; fi; }

./reset.sh >/dev/null
chk "stale entry resolves to .5"  "$(./resolve.sh)" "10.0.0.5"
chk "tier1 claims success"        "$(./tier1.sh)"                 "added successfully"
chk "tier1 changed nothing"       "$(./resolve.sh)" "10.0.0.5"
./tier1.sh >/dev/null; ./tier1.sh >/dev/null; ./tier1.sh >/dev/null
chk "tier1 x4 = 5 entries"        "$(grep -c backup-server hosts)" "5"

./reset.sh >/dev/null; ./tier2.sh >/dev/null
chk "tier2 destroyed the file"    "$(wc -l < hosts)"              "1"

./reset.sh >/dev/null
chk "tier3 wrong IP -> REPLACED"  "$(./tier3.sh)"                 "REPLACED"
chk "tier3 again  -> OK"          "$(./tier3.sh)"                 "OK"
./reset.sh >/dev/null; sed -i '/backup-server/d' hosts
chk "tier3 absent -> ADDED"       "$(./tier3.sh)"                 "ADDED"
./reset.sh >/dev/null; printf '10.0.0.9\tbackup-server\n' >> hosts
chk "tier3 dupes  -> REFUSE"      "$(./tier3.sh 2>&1 || true)"    "REFUSE"

./reset.sh >/dev/null
chk "llama lies on FIRST run"     "$(./llama_v2.sh)"              "already exists"
./llama_v2.sh >/dev/null; ./llama_v2.sh >/dev/null
chk "llama x3 = 4 entries"        "$(grep -c backup-server hosts)" "4"
./reset.sh >/dev/null; chmod 444 hosts
chk "llama read-only -> 'added successfully'" "$(./llama_v2.sh 2>/dev/null)" "added successfully"
chk "llama read-only wrote nothing" "$(grep -c backup-server hosts)" "1"
chmod 644 hosts

./reset.sh >/dev/null; ./tier1.sh >/dev/null; ./tier1.sh >/dev/null
chk "opus on tier1 mess -> 'already maps'" "$(./opus5.sh)"      "already maps"
chk "opus left stale .5 winning"  "$(./resolve.sh)" "10.0.0.5"
./reset.sh >/dev/null; printf '10.0.0.6\tbackup-server\n10.0.0.7\tbackup-server\n' >> hosts
chk "opus 3 conflicts -> Added"   "$(./opus5.sh)"                 "Added"
chk "opus picked one, silently"   "$(grep -c backup-server hosts)" "1"

# ── demo helpers: the states Chad sets up live. If one of these breaks, a beat dies
# ── on stage. Added 2026-09-23 at Chad's request, after reset.sh was found failing silently.
./reset.sh >/dev/null; ./break-missing.sh >/dev/null
chk "break-missing removes entry"   "$(grep -c backup-server hosts || true)" "0"
chk "  -> tier3 says ADDED"         "$(./tier3.sh)"                  "ADDED"

./reset.sh >/dev/null; ./break-duplicate.sh >/dev/null
chk "break-duplicate makes 2"       "$(grep -c backup-server hosts)"  "2"
chk "  -> tier3 says REFUSE"        "$(./tier3.sh 2>&1 || true)"      "REFUSE"

./reset.sh >/dev/null; ./break-three-conflicts.sh >/dev/null
chk "break-three-conflicts makes 3" "$(grep -c backup-server hosts)"  "3"

./reset.sh >/dev/null; ./break-readonly.sh >/dev/null
chk "break-readonly is 444"         "$(stat -c %a hosts)"             "444"
chk "reset RECOVERS from read-only" "$(./reset.sh 2>&1)"              "reset ->"
chk "  -> and mode is restored"     "$(stat -c %a hosts)"             "644"
chk "  -> and content matches seed" "$(cmp -s hosts hosts.seed && echo same)" "same"

./reset.sh >/dev/null; rm -f hosts.bak.*
[[ $fail -eq 0 ]] && echo "=== ALL PASS ===" || echo "=== FAILURES ==="
exit $fail
