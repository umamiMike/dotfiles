# Review output format

Applies to any review-style output: code review, /python-review, /code-review, bugs/improvements
docs, ad-hoc "review this" requests — anything that produces a list of findings.

- Keep each top-level bullet as short as possible — a one-line claim, not a paragraph.
- Push supporting detail (file:line, rationale, failure scenario, fix) down into nested
  sub-bullets instead of folding it all into one long sentence.
- Prefer nesting over prose even when a finding has a lot to say — the top-level bullet should
  be scannable on its own.

Example shape:

- Short one-line claim (the issue)
  - `file:line`
  - why it matters / failure scenario
  - fix
