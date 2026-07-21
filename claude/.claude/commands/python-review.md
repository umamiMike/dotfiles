---
description: Review Python code against the python-standards skill
argument-hint: "[file, dir, or nothing for current diff]"
---

Load the `python-standards` skill, then review $ARGUMENTS for adherence to it. If no argument was given, review the current diff (`git diff`) instead of the whole codebase.

Report findings as a list of `file:line` — issue — fix, ordered most-severe first. Don't restyle or refactor anything beyond what the skill's checklist covers, and don't touch code outside the reviewed target.
