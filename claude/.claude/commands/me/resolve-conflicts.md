---
description: Resolve git merge/rebase/cherry-pick conflicts using the merge-conflicts skill
argument-hint: "[file, or nothing for all conflicted files]"
---

Load the `merge-conflicts` skill, then resolve $ARGUMENTS. If no argument was given, run
`git status` to find every conflicted file and resolve each one.

After resolving, run the project's build/typecheck/test suite and report the result.
Stage resolved files individually with `git add <file>` — don't stage anything else, and
don't run `git commit` / `git rebase --continue` / `git merge --continue` without the
user's go-ahead.
