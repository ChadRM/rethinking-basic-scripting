WHAT IS IN HERE
===============

The actual code five different models produced from one sentence. See
../PROMPT.txt for the prompt and the clean-room conditions.

These are teaching artifacts. Several of them are WRONG, on purpose --
that is the entire point of the session. Do not run them against anything
you care about.


RUNNABLE (adapted with the two changes described in PROMPT.txt)
---------------------------------------------------------------
llama_v2.sh    llama3.2, 3.2B parameters.
               Appends first, then greps for the line it just wrote, so it
               reports "already exists" on a run that worked -- and
               "added successfully" on a run that failed. Messages backwards.

opus5.sh       Claude Opus 5, clean room, 2026-09-16.
               Genuinely good: idempotent, replaces rather than appends,
               timestamped backup, preserves inode/ownership with the
               reasoning in a comment. Still never refuses anything.

opus55.sh      Claude Opus 5.5, clean room, 2026-09-23 -- one week later.
               Fixed the stale-entry bug. Broke two things that worked:
               it deletes whole multi-hostname lines, and it replaces a
               symlink with a regular file. On a read-only file it deletes
               the old entry, fails to append, and leaves you with nothing.


VERBATIM CAPTURES (unmodified -- diff these against the above)
--------------------------------------------------------------
opus5_cleanroom_2026-09-16.sh    Opus 5's raw output.
opus55_cleanroom_2026-09-23.txt  Opus 5.5's raw output AND its own summary,
                                 including the two disclosures it volunteered:
                                 that it deletes the whole line, and that it
                                 had not run or tested the script.


NOT INCLUDED
------------
Qwen2.5-Instruct and gemma3 appear on the slides but are not shipped here as
runnable files -- their failures are visible in the code on the slides and did
not need a demo harness.
