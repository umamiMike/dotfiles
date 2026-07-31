Convert the following PR description into a concise, actionable format for a reviewer with no prior context. 

Strip out implementation explanation unless it's necessary to make a review decision. The goal is a reviewer can read this in 60 seconds and know exactly what to do.

Structure it as:

## What changed

- one or two sentences, plain language, no implementation detail.

## Files / areas to review

 — bullet list of what to actually look at.

## How to test

— concrete steps to verify the fix works and hasn't broken anything.

## Caveats
 — anything the reviewer needs to know before signing off (untested paths, known limitations, scope boundaries).

## technical details

---
PR description:
$ARGUMENTS
