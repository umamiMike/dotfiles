---
name: merge-conflicts
description: Procedure for resolving git merge/rebase/cherry-pick conflicts safely — determining which side is "ours" vs "theirs" for the operation in progress, reconciling conflict markers by intent rather than blindly picking a side, handling rename/delete conflicts, and verifying the result before staging. Load on conflict markers (<<<<<<<, =======, >>>>>>>), a failed merge/rebase/cherry-pick, or a request to resolve conflicts.
---

# Resolving merge conflicts

## Before touching anything

- Run `git status` to see the full list of conflicted files — don't resolve them one at a
  time blind to the rest.
- Identify which operation is in progress (merge, rebase, or cherry-pick) — this flips the
  meaning of "ours" and "theirs":
  - **Merge**: ours = current branch (HEAD), theirs = the branch being merged in.
  - **Rebase**: inverted — ours = the upstream commit being rebased onto, theirs = your
    commit being replayed on top.
  - **Cherry-pick**: ours = current branch, theirs = the commit being picked.
- Read both sides' history (`git log --oneline <ref>..<other-ref>`) to understand intent,
  not just the raw diff text.

## Resolving each conflict

- Never blindly run `git checkout --ours` / `--theirs` across the board — that discards
  one side's change wholesale without understanding why it conflicted.
- Open each file, find the `<<<<<<<` / `=======` / `>>>>>>>` markers, and reconcile by
  understanding what each side was trying to accomplish. The correct resolution is often
  neither side verbatim but a merge of both intents.
- For rename/rename or delete/modify conflicts (`git status` labels these distinctly),
  decide whether the file should exist, be renamed, or be deleted based on which side's
  intent should win — don't default to keeping both just to avoid the decision.
- Remove every conflict marker before considering a file resolved — grep for `<<<<<<<`
  across the repo to confirm none remain.

## After resolving

- Run the project's build/typecheck/test suite before finalizing — a textually clean
  merge can still be semantically broken (e.g. both sides changed a function's contract
  compatibly on paper but not in practice).
- `git add` each resolved file individually — don't blanket `git add .`, in case
  conflict resolution touched files beyond what was intended.
- Do not run `git commit` / `git rebase --continue` / `git merge --continue` without the
  user's go-ahead — resolving the text and finalizing the operation are different levels
  of risk.

## Red flags — stop and ask instead of guessing

- Both sides significantly restructured the same logic (not just adjacent lines) — this
  needs the user's judgment on intent, not an inferred merge.
- A conflict in a lockfile, generated file, or migration — these usually need to be
  regenerated or reconciled via tooling, not hand-merged.
