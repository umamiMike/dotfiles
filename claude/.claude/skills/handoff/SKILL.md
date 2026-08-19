---
name: handoff
description: Procedure for writing a session handoff doc that distills accumulated session progress, decisions, and open threads into one actionable markdown file for another developer (or another repo/session) to pick up from — since Claude Code's own state in ~/.claude (memory, plans, transcripts) is machine-local and doesn't travel with the repo. Load on /handoff, or a request to write a handoff, hand off to another developer, or summarize progress before switching repos or machines.
---

# Writing a handoff doc

## Where it goes

`.claude/handoffs/<YYYY-MM-DD>.md` in the current repo (create the directory
if it doesn't exist). One file per day — but see "Same-day updates" below
before writing; don't blindly overwrite an existing today-file.

After writing, run `git check-ignore .claude/handoffs` (or check `.claude`
itself). If it's ignored, tell the user explicitly: this file won't reach
another developer through git, so they'll need to share it another way
(paste, Slack, `git add -f`, or adjusting `.gitignore`).

## Same-day updates (don't overwrite blindly)

If today's file already exists, read it before writing anything. Treat it
as the base and update it, not a fresh draft:

- Move any "In progress" item that's now finished into "Done this session".
- Add newly-completed work and newly-made decisions.
- Refresh "Open questions / risks" — drop ones that got answered, keep or
  add the ones that are still live.
- Don't duplicate a bullet that's already accurate as written.

This same behavior is what makes the doc resilient if this session's own
context gets auto-compacted partway through (see "Don't trust memory
alone" below) — the file on disk, once it exists, is the durable record,
not the live conversation.

## Archiving old dated files

Before writing today's file, list `.claude/handoffs/*.md` (filenames sort
chronologically). Keep the 5 most recent as-is. For any older ones not yet
rolled up:

1. Read each one and compress it to a single line:
   `- <date> — <one-sentence summary of what that day accomplished>`
2. Prepend that line to `.claude/handoffs/ARCHIVE.md` (create it with a
   one-line header — `# Handoff archive` — if it doesn't exist; newest
   entries at the top).
3. Delete the now-archived dated file.

This keeps the directory shallow — today plus a handful of recent days
plus one terse, ever-growing index — instead of accumulating full daily
files forever. Five is a reasonable default, not a hard rule; use judgment
if the user asks for a different depth.

## What to gather

Draw primarily from the current conversation — you already know what was
done, decided, and left unfinished. Don't go fishing through unrelated
`~/.claude` history for its own sake.

1. **Git state** — current branch, `git status --short`, and
   `git log <base>..HEAD --oneline` if this branch has diverged from its
   base, so the reader knows what's committed vs. still dirty.
2. **Done this session** — a short, plain-language bullet list of
   completed work. Not a truncated diff.
3. **In progress / not done** — anything started but incomplete, with why
   if that's known (blocked on X, needs a decision, etc).
4. **Decisions and conventions established** — anything agreed this
   session that isn't yet reflected in the relevant `CLAUDE.md` file(s).
   Cross-check those files first; only list genuine gaps (same spirit as
   the `pivot` command's step 1 — don't invent items).
5. **Open questions / risks** — anything a fresh reader would need to
   decide or watch out for.
6. **Files touched** — one line each on why, not just a file list.
7. **Further context** — name a specific `~/.claude/plans/*.md` path or
   this project's `memory/MEMORY.md` path only if one exists and is
   genuinely relevant. These are the current machine's own working notes —
   cite them as such, not as something a different recipient can
   necessarily open themselves.

### Don't trust memory alone

Conversation memory may be incomplete — either because this session has
already run long enough to have been auto-compacted by the harness, or
because you're updating a file from an earlier run. Cross-check what you
recall against `git log`/`git status` (ground truth) and against the
existing handoff file if one exists (durable checkpoint) rather than
assuming the visible conversation is the complete history. If something
looks thin or uncertain as a result, say so in the doc instead of
guessing or silently omitting it. It's also fine to suggest the user run
`/handoff` again partway through a long session — each run checkpoints
progress before compaction has a chance to lose it.

## What to leave out

- No personal/user-preference or feedback-type memory content — that
  describes how the current user likes Claude to behave, not the project,
  and isn't useful or appropriate to hand to someone else.
- No secrets, tokens, credentials, or personal identifiers, even if they
  surfaced in the session.
- Omit a section entirely if it has nothing to report — don't pad with
  "None" or "N/A".

## Output template

```markdown
# Handoff — <repo/branch> — <date>

## Status
<branch, dirty/clean, ahead/behind base>

## Done this session
- ...

## In progress
- ...

## Decisions made
- ...

## Open questions / risks
- ...

## Files touched
- `path` — why

## Further context
- ...
```

## After writing

Report the file path and a one-line summary of what's in it. Don't stage
or commit the file — that's the user's call.
