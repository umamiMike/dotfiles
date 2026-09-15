---
name: feature
description: End-to-end feature workflow — interview to nail down scope, write a .claude/features/ doc, open a manager-facing Gitea issue, branch + PR the planning doc, link the issue as blocked by the PR, then (once told to implement) drive TDD with a commit-and-check gate at every step. Load on /feature, or when starting a new feature from scratch.
---

# Feature workflow

Composes several of this repo's other skills rather than reimplementing
them: `submit-gitea-issue` (issue creation), `changelog` (final commit),
optionally `pr-description` (refreshing the PR description once real work
exists). Load those inline via the Skill tool at the steps below rather
than duplicating their procedures here.

This skill has two independent entry points:

- **No `.claude/features/<slug>.md` exists yet for this work** → start at
  Phase 1 (interview).
- **A feature doc + branch + PR + issue already exist and the user says
  "implement"** → skip straight to Phase 2 (TDD).

## Phase 1 — scope, plan, ticket, branch (stops before any code)

### 1. Interview

Pure requirements gathering. No code, no file edits, no implementation
planning.

- Determine feature vs. bug fix first if not obvious.
- Ask exactly ONE question at a time. Wait for the answer.
- After each answer, reflect back your understanding in one sentence
  before asking the next question.
- Never propose solutions, approaches, architectures, or code unless
  explicitly asked. Exception: if you notice a likely edge case, raise it
  as a question, not a suggested handling.
- For a **feature**, cover (skip anything already answered): problem it
  solves, who it's for, what success looks like, what's explicitly out of
  scope, constraints, edge cases.
- For a **bug fix**, cover: expected vs. actual behavior, repro steps,
  when it started, scope of impact, severity, known workarounds.
- Stop asking once you have enough for an unambiguous doc, or the user
  says so.
- Write nothing to disk during this phase. Wait for the literal word
  **"go"** before Phase 1 step 2.

### 2. Write the feature doc

On "go", write `.claude/features/<YYYY-MM-DD>-<slug>.md` (today's date,
`slug` = short kebab-case name). Follow the existing freeform convention
in `.claude/features/` (see `2026-08-27-pass-root-load-perf.md`) — a
title, prose sections covering problem/root cause/agreed scope/open
items as applicable — not a rigid fill-in-the-blank template.

Show it to the user. Revise in place until they confirm they're satisfied.
This file stays **uncommitted** on the current branch until step 4.

### 3. Manager-facing Gitea issue

Load the `submit-gitea-issue` skill and follow its procedure, with this
issue shape:

- Title: the feature doc's title.
- Body: plain language only, no technical details, no file paths, no
  code. Cover what's being built and why (2-4 sentences). Do **not**
  reference a PR number here — the dependency link added in step 5 makes
  that visible in Gitea's UI automatically.
- Confirm the exact title/body/repo with the user before submitting, per
  that skill's own rule.

Keep the returned issue number — needed in step 5.

### 4. Branch + PR

- Branch name: bare kebab-case slug matching this repo's existing
  convention (e.g. `task-nav-fix`, `window-title` — no `feature/` prefix).
  Branch from `main`.
- First (and only, at this point) commit on the branch: add the feature
  doc file from step 2. Nothing else.
- Push the branch.
- Open the PR via `.claude/skills/feature/create_pull_request.py`
  (same stdin-JSON pattern as `submit-gitea-issue`'s script — pipe
  `{"head": "<branch>", "base": "main", "title": "...", "body": "..."}`
  to avoid shell-quoting problems):
  ```bash
  python3 .claude/skills/feature/create_pull_request.py --org refuge --repo Lucifer <<'EOF'
  {"head": "<branch>", "base": "main", "title": "<title>", "body": "<body>"}
  EOF
  ```
  Draft the PR body by hand from the feature doc (there's no code diff or
  changelog fragment yet, so the `pr-description` skill doesn't apply
  here) — summarize planned scope, and link to the feature doc as a
  clickable Gitea source URL (not a bare file path) so it opens directly
  in the browser:
  `<gitea-base>/<org>/<repo>/src/commit/<commit-sha>/<path>` — use the
  SHA of the commit that added the feature doc (step 4's first commit)
  and the doc's repo-relative path. Confirm the drafted title/body with
  the user before running the script, same as any other Gitea write in
  this workflow.
  - If the PR body needs updating later (e.g. the feature doc changes,
    or this link wasn't added at creation time), edit it in place via
    `.claude/skills/feature/edit_pull_request.py`:
    ```bash
    python3 .claude/skills/feature/edit_pull_request.py --org refuge --repo Lucifer --pr <pr-number> <<'EOF'
    {"body": "<full new body>"}
    EOF
    ```
    Confirm the new body with the user first, same as any other edit to
    something already visible to others.
- This Gitea instance's PR-creation API has no `draft` flag — the PR
  opens as a regular PR whose only diff is the feature doc.

Keep the returned PR number — needed in step 5.

### 5. Link the dependency

Make the issue depend on (be blocked by) the PR:
```bash
python3 .claude/skills/feature/link_issue_dependency.py --org refuge --repo Lucifer --issue <issue-number> --depends-on <pr-number>
```
This is a real write to Gitea (not easily undone without another API
call) — confirm the two numbers with the user before running it.

Verified directly against this Gitea instance (2026-09-10): `issue-number`
is the dependent (the one that gets blocked), `pr-number` is what it
depends on — `POST /issues/<issue-number>/dependencies {"index":
<pr-number>}`. Gitea mirrors this automatically as a "blocks" entry on
the PR's own issue record (`GET /issues/<pr-number>/blocks`) — that's the
same relation viewed from the other side, not a second link to create.
If a dependency was ever set by hand in the Gitea UI instead of via this
script, `GET /issues/<issue-number>/dependencies` is how to confirm it
landed the same way before assuming this step still needs to run.

### 6. Stop

Report the feature doc path, issue URL, branch name, and PR URL. Do not
start implementation. Wait for the user to explicitly say to implement.

## Phase 2 — TDD implementation (only after being told to implement)

Work in small units. For each one:

1. **Write all expected tests as failing.** If the module/function under test doesn't
   exist yet, add a minimal stub of it (correct signature, body that
   returns an obviously-wrong sentinel or raises `NotImplementedError`)
   in the same commit — a missing module makes the whole test file
   collection-error instead of each test case failing individually,
   which hides how many cases are actually covered. Commit test + stub
   together, message noting it's expected to fail (e.g.
   `test: <behavior> (failing)`).
2. **Stop. Let the user run the full suite themselves**
   (`pytest tests/ -v` or `python start.py --run-tests`, not just the
   new test file) and confirm the new cases fail as expected — as
   distinct FAILED results, not a collection error. Do not run the test
   suite on their behalf at this gate — wait for their go-ahead.
3. **Implement** the solution for that unit.
4. **Stop. Let the user run the full suite and review the change**
   before anything is committed. Do not commit until they say so.
5. On approval, commit the solution.
6. Repeat 1-5 for the next unit. Continue until the user says the feature
   is complete.

Never skip a gate by running tests yourself and reporting the result in
place of the user doing it — the point is their own check, not just a
passing status.

## Completion

Once the user says the feature is done:

1. Update `docs/requirements.md` with the new feature's requirement entry
   (per this project's CLAUDE.md "Git commits" section) — mark it `[x]`.
2. Load the `changelog` skill to add/update this branch's changelog
   fragment. Include any edge cases or new developments discovered
   during implementation that weren't in the original feature doc or
   interview — not just the happy path.
3. Optionally, load the `pr-description` skill to refresh the PR
   description now that a real changelog fragment exists (the step 4
   description was hand-drafted from the plan, before there was any
   code).
4. Report what was committed. Do not merge the PR, close the issue, or
   push anything not already asked for.

## What this skill does not do

- Never merges a PR or closes an issue.
- Never runs the test suite on the user's behalf at a TDD gate.
- Never commits without the user's explicit go-ahead at each gate in
  Phase 2.
- Never skips the interview even when the request sounds simple — "go"
  is the only thing that ends Phase 1 step 1.
