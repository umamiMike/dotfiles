---
description: Update CHANGELOG.md and README.md for the work done on the current branch
argument-hint: "[base branch, defaults to main]"
---

Diff the current branch against the base branch ($ARGUMENTS, or `main` if not given) using
`git log <base>..HEAD` and `git diff <base>...HEAD`. Summarize the actual functional changes,
not just the file list.

Update `CHANGELOG.md`: add or extend an entry for this branch's work. Each entry must have a
`### UI Changes` heading followed by a `### Technical Changes` heading, in that order. If a
section has nothing to report, keep the heading with a brief "None" line rather than omitting it.

Update `README.md` only if this branch changes documented behavior or usage — don't touch it
otherwise.

Edit the files directly but don't stage or commit anything. Report which sections you added or
changed so the user can review the diff.
