# claude

Stow package for `~/.claude/`. Mirrors the parts of Claude Code's config worth
version-controlling — global instructions, skills, commands, and reference docs.
The rest of `~/.claude/` (history, credentials, caches) stays untracked.

```
claude/.claude/
├── CLAUDE.md          # lean index — links out to docs/*.md, applies to every conversation
├── docs/              # one topic per file, linked from CLAUDE.md or a skill
├── skills/            # auto-loaded when a task matches the skill's description
└── commands/          # slash commands you invoke explicitly, e.g. /python-review
```

## Skills vs. commands

- **Skill** — knowledge Claude should pull in automatically when the task shape matches
  (e.g. writing Python → `python-standards`). The `description` in its frontmatter is the
  trigger — write it as concrete keywords ("PEP 8", "type hints", "pytest"), not an
  abstract summary. That field is the entire auto-discovery mechanism.
- **Command** — an action you invoke explicitly (`/python-review`). Use commands for
  things you kick off on your own schedule, not knowledge you want silently applied.
  Rule of thumb: if you'd type `/foo`, it's a command; if you want Claude to just know it
  without asking, it's a skill.
- Keep commands as thin wrappers over skills, not their own logic — `/python-review`
  loads `python-standards` and applies it to a target; the command supplies "when" and
  "what target", the skill supplies "how". Keeps the standard in one place instead of
  duplicated between the two.

## Keeping things lean

- `CLAUDE.md` loads on *every* conversation regardless of relevance — the test for any
  addition there is "does this apply to literally every conversation?" If not, it belongs
  in a skill (loads on trigger) or a command (loads on invoke), not `CLAUDE.md`.
- Push detail out of `SKILL.md`/`CLAUDE.md` into linked `docs/*.md` once a section grows
  past roughly one screen. `CLAUDE.md` already does this for every section; apply the
  same split inside a skill once it outgrows a single file.
- Prefer one command per verb with the target as an argument (`/review <target>`) over
  one command per noun (`/python-review`, `/elixir-review`, ...) once more than one shows
  up — dispatch to the right skill by file type instead of adding a new command each time.

## Gotchas

- Duplicate skill names get directory-scoped (e.g. `claude:python-standards` when a
  top-level `python-standards` also exists) — name scoped skills so they still read
  sensibly standalone.
- New skills/commands go live everywhere the moment they're stowed into `~/.claude/` —
  smoke-test a new one against one real task before trusting it broadly.
