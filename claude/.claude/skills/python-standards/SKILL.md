---
name: python-standards
description: Python code style, structure, and best-practices checklist covering formatting, type hints, docstrings, naming, error handling, project layout, and testing conventions. Load before writing, reviewing, or refactoring Python code so it follows consistent, modern standards.
---

# Python standards

Reference checklist for writing and reviewing Python (3.10+). Apply these when generating new code, refactoring, or reviewing a diff. Flag violations with file:line references; don't silently "fix" unrelated style elsewhere in the file.

## Formatting & linting

- Format with `ruff format` (or `black` if that's what the project already uses) — don't hand-format.
- Lint with `ruff check`. Fix or justify every warning; don't suppress with a bare `# noqa`.
- Line length 88-100 depending on project config — match whatever `pyproject.toml`/`ruff.toml` already declares, don't impose a new one.
- Imports: standard library, then third-party, then local — each group alphabetized, no wildcard imports (`from x import *`).

## Typing

- Type-hint all public function/method signatures (params + return). Skip hints only on trivial private helpers where the type is obvious from context.
- Prefer built-in generics (`list[str]`, `dict[str, int]`) over `typing.List`/`typing.Dict` (3.9+ style).
- Avoid `Any` unless the type genuinely is dynamic — it's an escape hatch, not a default.
- Use `X | None` instead of `Optional[X]`.
- If the project runs `mypy`/`pyright` in CI, code must pass it — check for a config file before assuming strictness level.

## Naming

- `snake_case` for functions, variables, modules; `PascalCase` for classes; `UPPER_SNAKE_CASE` for module-level constants.
- No single-letter names outside short comprehensions/lambdas or well-known conventions (`i`, `j` in loops, `_` for unused).
- Boolean-returning functions/variables read as a predicate: `is_valid`, `has_permission`, not `valid_check`.

## Docstrings & comments

- Docstring every public module, class, and function whose behavior isn't obvious from its signature — skip them on trivial one-liners.
- Pick one docstring style per project (Google or NumPy) and match what's already there; don't mix.
- Comments explain *why*, not *what* — same rule as general code style. Don't restate what the code already says.

## Error handling

- Catch specific exceptions, never bare `except:` or `except Exception:` unless re-raising or logging at a boundary.
- Use context managers (`with`) for anything with teardown (files, locks, connections) instead of manual try/finally.
- Raise with an informative message; don't swallow exceptions silently.
- Custom exceptions subclass a project-specific base, not bare `Exception`, when a project already has one.

## Structure & dependencies

- `src/<package>/` layout with a `pyproject.toml` for anything beyond a single script — check for an existing layout before restructuring.
- Dependency management follows whatever the project already uses (`uv`, `poetry`, `pip-tools`, plain `requirements.txt`) — don't introduce a second tool.
- No circular imports; if two modules need each other, extract the shared piece.
- Keep `__init__.py` files minimal — re-export the public API, don't hide logic there.

## Testing

- `pytest`, not `unittest`, unless the project already standardized on `unittest`.
- One assertion concept per test; use `pytest.mark.parametrize` instead of hand-rolled loops over cases.
- Name tests for the behavior under test (`test_raises_on_empty_input`), not the implementation detail.
- Fixtures for shared setup, not copy-pasted arrange blocks.

## Common violations to flag in review

- Mutable default arguments (`def f(x=[])`).
- Comparing to `None`/booleans with `==` instead of `is`.
- Manual string formatting instead of f-strings.
- Bare `except`, silently swallowed errors, or broad `Exception` catches.
- Missing type hints on new public functions.
- Print statements left in library code where logging should be used.
