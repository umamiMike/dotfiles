---
name: session-summary
description: Write a brief bulleted outline of what was done in the current Claude Code session to a dated file in $CLAUDE_SESSION_SUMMARIES_DIR, for quick later scanning. Works in any project. Load when asked to summarize, log, or record this session.
---

# Session summary

Summarize the current conversation as a short, scannable bulleted outline — not prose, not a
transcript. Each bullet is one line: what changed or was decided, not how.

- Output directory is `$CLAUDE_SESSION_SUMMARIES_DIR` (set in `zsh/.zshrc`, points at the
  personal journal's `claude-sessions/` folder regardless of which project this session is
  in). If that env var isn't set, tell the user to check `zsh/.zshrc` / re-source their shell
  rather than guessing a fallback location.
- Determine the project name: if the cwd is inside a git repo, use the basename of `git
  rev-parse --show-toplevel`; otherwise use the basename of the cwd.
- Write to `$CLAUDE_SESSION_SUMMARIES_DIR/<project-name>-<YYYY-MM-DD>-<HH-MM-SS>.md` (project
  name first so files sort/group by project; timestamp of when the summary is written, so
  multiple sessions - in this or other projects - don't collide).
- File contents:
  ```
  # Session: <project-name> — <YYYY-MM-DD HH:MM>

  ## <Component/area 1>
  - <bullet>
  - <bullet>

  ## <Component/area 2>
  - <bullet>

  ## Open questions / follow-up
  - <bullet>
  ```
- Group bullets under `##` headers named for the file, tool, script, or feature area they
  affect (e.g. `rcreview`, `gdrive-media-links.sh`, `zsh config`) - not fixed categories like
  "Features"/"Fixes". Decide the headers fresh each session based on what was actually
  touched; order them however reads best (chronological or by weight, whichever is clearer).
  A session with one clear focus still gets one header, not a headerless list.
- Keep bullets to outcomes, not the back-and-forth — one bullet per distinct piece of work
  completed, decision made, or bug fixed. Skip exploratory dead ends and clarifying questions
  unless they changed the outcome.
- Aim for under 10 bullets total for a normal session; use nested sub-bullets only if a single
  item genuinely needs it.
- `## Open questions / follow-up` always appears, even when empty — write a single `- None.`
  rather than omitting the section, so scanning later doesn't require guessing whether it was
  skipped. Include unresolved questions the user hasn't answered yet, decisions explicitly
  deferred, and anything flagged as "later"/"backlog"/"next time" during the session.
- After writing, report the file path back to the user — don't also print the full summary in
  chat, the file is the record.
