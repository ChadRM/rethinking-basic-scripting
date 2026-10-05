# Basic Scripting — demo kit
**Tested end to end on Linux (bash) and under WSL.** Run `./selftest.sh` to verify the kit.

🔴 **NOTHING HERE TOUCHES A REAL `/etc/hosts`.** Every script defaults to `./hosts`, a throwaway copy of
`hosts.seed`. Say that out loud on stage — pointing a demo at a copy IS the lesson.

| File | What it is |
|---|---|
| `hosts.seed` | Realistic starting file: comments, a multi-hostname line, someone's outage override, and a **stale `10.0.0.5 backup-server`** |
| `reset.sh` | Rebuild `hosts` from the seed. **Run between every block.** |
| `resolve.sh` | What the resolver does, in three lines — makes **first-match-wins** visible instead of magic |
| `tier1.sh` | The naive append. Two lines. Reports success, changes nothing that matters. |
| `tier2.sh` | The "obvious fix." `>` instead of `>>`. Destroys the file. |
| `tier3.sh` | The state machine. ADDED / OK / REPLACED / **REFUSE** |
| `llama_v2.sh` | **Verbatim from llama3.2:3b**, its own "more concise version." Appends, *then* checks. **No `set -e`: on a read-only file it prints Permission denied, then "added successfully", exit 0.** Only change: `/etc/hosts` → `$HOSTS`. |
| `opus5.sh` | **Verbatim from Claude Opus 5** (clean room). Only changes: `/etc/hosts` → `$HOSTS`, must-be-root check removed. Original in `../captures/`. On the post-Tier-1 file it says **"already maps"** and exits 0 while `.5` still wins; on three conflicting entries it **silently keeps one**. |

## Run the show
```bash
./reset.sh && cat hosts && ./resolve.sh   # 10.0.0.5
./tier1.sh && ./resolve.sh                # "success" ... still 10.0.0.5
```
