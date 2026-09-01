Convert the following bug report into a concise, actionable format for a teammate with no prior context.

Strip out implementation explanation unless it's necessary to understand the impact. The goal is a teammate can read this in 60 seconds and know exactly what to act on.

Output must be valid GitHub-flavoured markdown.

Structure it as:

## Summary
<!-- Brief, clear description of the bug. What is happening? -->

## Environment
- **App Version:**
- **OS:**
- **Environment:** <!-- Staging / Production / Local -->

## Triage
- **Severity:** Critical / High / Medium / Low
- **Priority:** P0 / P1 / P2 / P3

## Files / areas affected
<!-- Bullet list of what to actually look at. -->

## Steps to reproduce
<!-- Concrete numbered steps to reproduce each issue. -->

## Expected behavior
<!-- What should have happened? -->

## Actual behavior
<!-- What actually happened? Include error messages if available. -->

## Evidence
<!-- Screenshots, GIFs, or screen recordings. -->

## Logs & context
<!-- Terminal outputs, stack traces. -->

## Caveats
<!-- Anything the reader needs to know before acting: untested paths, known limitations, scope boundaries, what's pushed vs. not. -->

## Technical details

---
Report:
$ARGUMENTS
