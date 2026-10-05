# Rethinking What You Already Know: Basic Scripting

**Chad Miller** · chad.r.miller@gmail.com · [linkedin.com/in/chadryanmiller](https://linkedin.com/in/chadryanmiller) · [github.com/ChadRM](https://github.com/ChadRM)

Everything from the session, so you can run it yourself.

> ⚠️ **For reference only.** See `LICENSE.txt` — this material is not licensed for reuse,
> redistribution or delivery. It is here so you can check my work, not so you can give my talk.

---

## Start here

| | |
|---|---|
| **`Basic_Scripting_Demo.html`** | The deck. Self-contained — open it in a browser, no install, no network. |
| **`Basic_Scripting_SpeakerNotes.pdf`** | The full speaker notes, every line, every beat. |
| **`PROMPT.txt`** | The one sentence every model was given, the clean-room conditions, and the only two lines I changed in their code. |

**Deck keys:** `←`/`→` navigate · `S` speaker window · `F` fullscreen · `B` black · `T` pause timer · `R` reset timer · `G` go to slide

---

## The demo

`demo/` is the Linux/macOS kit, `powershell/` is the same thing on Windows. Both operate on a
**throwaway `hosts` file in their own folder.** Neither one touches `/etc/hosts` or
`C:\Windows\System32\drivers\etc\hosts`, and you should not make them.

```bash
cd demo
./selftest.sh          # 26 checks, all should pass
./reset.sh             # start from a known file
./tier1.sh             # the two-line fix
./tier3.sh             # the state machine
```

| Script | What it is |
|---|---|
| `reset.sh` | Put the file back to a known state. Run it between everything. |
| `resolve.sh` | What the resolver does — **first match wins**, made visible. |
| `tier1.sh` | The two-line fix. Appends. Never checks. |
| `tier2.sh` | The one-character "fix". Replaces the **entire file**. Run once, in horror. |
| `tier3.sh` | Six states, six correct actions, two refusals. |
| `break-missing.sh` | Put the file in the "entry is gone" state — a rebuild or a fresh image. |
| `break-duplicate.sh` | Two conflicting entries — what an append-only script leaves behind. |
| `break-three-conflicts.sh` | Three conflicting entries, none correct. |
| `break-readonly.sh` | Read-only — somebody forgot sudo. `reset.sh` clears it again. |
| `selftest.sh` | Proves the whole kit still behaves. Run it first. |

---

## The models

`models/` has the actual code five models produced from one sentence, plus the **verbatim,
unmodified captures** so you can diff them against the runnable versions. Read
`models/README.txt` first. Several of these are wrong on purpose — that is the session.

---

## The thing worth stealing

`CLAUDE.md.example` — the rules file from the slide. Four rules, each one something that went
wrong during the session. Drop it in as `CLAUDE.md`, `AGENTS.md` or `.cursorrules`, delete half
of it, add your own. **The point is not my four rules. The point is that the file exists and the
generator reads it every time.**

---

## What the session argued

Everything that can be learned from a corpus, these models learned. *"Stop and ask a human"* is
not in the corpus. The discipline has to live somewhere, and it does not come free with the
generator.

That part is still yours.
