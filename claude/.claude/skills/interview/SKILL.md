---
name: interview
description: Procedure for interviewing the user about a new feature or bug fix before any design or implementation — ask one question at a time, reflect back understanding, and never propose solutions or approaches unless explicitly asked. Ends by writing a spec doc to the current repo. Load on /interview, or before starting work on a feature or bug fix whose requirements aren't yet nailed down.
---

# Interviewing before design or implementation

Pure requirements gathering. No code, no file edits (other than the spec
doc at the end), no implementation planning. That comes later, as a
separate step the user asks for explicitly.

## Rules for the interview itself

- Ask exactly ONE question at a time. Wait for the answer before asking
  the next.
- After each answer, reflect back your understanding in one sentence
  before asking the next question (per `essential-directives.md`).
- Never propose solutions, approaches, architectures, or code. No "you
  could try X," no unprompted options — even phrased gently. If the user
  explicitly asks what you think, answer plainly; otherwise stay in
  question mode.
- Exception: if something you notice — from the conversation, or from
  reading the code — looks like a likely edge case or side effect, raise
  it. But raise it as a question ("What should happen if X occurs?"),
  never as a statement or a suggested handling ("You should do Y for
  that case"). Surfacing the case is allowed; solving it isn't.
- If the user answers multiple open topics at once (skips ahead), don't
  re-ask what's already covered — reflect it back and move to whatever
  remains open.
- No sycophancy ("Great question!"). Stay neutral.

## Determine feature vs. bug first

Ask this first if it isn't already obvious from context or $ARGUMENTS —
the checklist differs.

### For a new feature, cover (skip anything already answered):

1. What problem does this solve — what can't the user do today?
2. Who is it for (all users, a specific role, internal only)?
3. What does success look like — how will they know it works?
4. What's explicitly OUT of scope for this pass?
5. Any constraints (performance, compatibility, deadline, platform)?
6. Edge cases or failure modes that matter?

### For a bug fix, cover:

1. Expected behavior vs. actual behavior?
2. Steps to reproduce?
3. When did it start — recent change, always been broken, intermittent?
4. Scope of impact — one user, all users, one environment?
5. Severity / urgency?
6. Any known workaround?

These are a starting menu, not a script. Skip what's already answered,
add questions specific to the situation, and stop once you have enough
for a clear, unambiguous spec.

## When to stop asking

Stop when either is true:

- You have enough to write a spec with no major open unknowns, or
- The user signals they're done ("that's enough", "let's go", "write it
  up").

## Ending the interview

Write a spec doc to `.claude/specs/<slug>.md` in the **current repo**
(the one being worked in, not `~/.claude`) — create the directory if it
doesn't exist. `slug` is a short kebab-case name for the feature or bug.

Template:

```markdown
# <Title>

Type: Feature | Bug fix
Date: <date>

## Problem
...

## Requirements
- ...

## Out of scope
- ...

## Constraints
- ...

## Open questions
- ...
```

After writing, run `git check-ignore .claude/specs` (or check `.claude`
itself). If it's ignored, tell the user explicitly — the spec won't
reach anyone else through git.

## After writing

Report the file path. Do not propose an implementation plan, suggest an
approach, or start writing code — that is a separate, explicit next step
the user asks for.
