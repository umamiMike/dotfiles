---
name: pickup
description: Procedure for orienting to where a previous session left off by reading this repo's most recent handoff doc (written by /handoff or /pivot) and checking it against current git state. Load on /pickup, or a request to catch up, resume, pick up where a session left off, or orient after a break.
---

# Picking up from a handoff

## Find the right file

Look in `.claude/handoffs/` in the current repo.

- If a date was given as an argument, use `.claude/handoffs/<date>.md`. If
  it doesn't exist, say so plainly and stop — don't fall back to a
  different date silently.
- Otherwise, use today's file if it exists; if not, use the most recent
  dated file present.
- If `.claude/handoffs/` doesn't exist, or exists but is empty (and
  `ARCHIVE.md` doesn't exist either), say plainly that there's no handoff
  to pick up from — don't fabricate one or improvise a substitute summary
  from guesswork.
- If `ARCHIVE.md` has entries older than the file you're reading, mention
  it exists as a pointer for deeper history — don't read or dump it
  unless the user asks for that.

## Don't trust the file blindly either

The handoff was written to be resilient against incomplete conversation
memory (see the `handoff` skill); the flip side is that time has passed
since it was written, so it can now be stale. Before presenting it:

- Check `git log`/`git status` against what the file claims — new commits
  on the branch it describes, uncommitted changes it doesn't mention, or
  a branch that no longer exists.
- If an "Open questions / risks" or "In progress" item looks like it may
  already be resolved based on current repo state, say so as a caveat
  rather than silently dropping or silently trusting the claim — you're
  orienting the user, not deciding for them.

## Present a summary, not a reprint

Synthesize a concise orientation: where things stood, what's still open,
anything that looks like it's drifted since the file was written. Name the
file you read so the user can open it directly for full detail. Don't
paste the whole file verbatim, and don't take any action beyond reading
and reporting — no edits, no commits, no resuming "in progress" work on
your own initiative.
