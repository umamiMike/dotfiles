---
description: Update CLAUDE.md and log a backlog item before pivoting to an unrelated topic, then hand off for /clear
argument-hint: "[optional description of what's being paused, otherwise inferred from the conversation]"
---

Prepare to pivot away from the current task, without actually clearing anything (you cannot invoke `/clear` yourself — it's a harness command, not something you can trigger).

1. Review this session for anything durable — a fact, decision, or convention — that was established but isn't yet reflected in the relevant `CLAUDE.md` file(s) for the current directory hierarchy. If you find something, update the file(s) directly. Don't invent items; only capture what was actually established this session.

2. Log a backlog entry for whatever is being left unfinished: $ARGUMENTS if given, otherwise infer a short, accurate description from the conversation. Use the project's existing backlog convention if one exists (e.g. `todo.md`, `TODO.md`); if none exists, ask before creating one.

3. Load the `handoff` skill and write or update this session's handoff doc, now that step 1 has already closed any CLAUDE.md gaps it would otherwise flag.

4. Report what was updated, logged, and written, then tell the user it's safe to run `/clear`.
