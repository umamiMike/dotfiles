---
description: Draft a PR description for the current branch's changes, in reviewer format
argument-hint: "[base branch, defaults to main]"
---

Draft a PR description for the current branch's changes, for a reviewer with no prior context.
Determine the base branch from $ARGUMENTS (default `main`), then read `git log <base>..HEAD` and
`git diff <base>...HEAD` to understand what actually changed.

Strip out implementation explanation unless it's necessary to make a review decision. The goal is
a reviewer can read this in 60 seconds and know exactly what to do.

Structure it as:

## What changed

- one or two sentences, plain language, no implementation detail.

## Files / areas to review

— bullet list of what to actually look at.

## How to test

— concrete steps to verify the change works and hasn't broken anything.

## Caveats
— anything the reviewer needs to know before signing off (untested paths, known limitations, scope boundaries).

## technical details
