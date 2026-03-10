# Module Structure Policy

## Purpose

Modules must be small enough that an AI agent or new engineer can understand
a single module in full isolation — the same way a human hands off a well-scoped task.
If a module cannot be understood in one pass, it is too large.

## File size limits

| Threshold | Action required |
|-----------|----------------|
| > 1000 lines | Hard violation — file must be split before any new feature is added |
| > 500 lines | Warning — plan a split in the next iteration |
| ≤ 300 lines | Target size for a single-responsibility file |

Line counts include all code, comments, and blank lines.
Generated files (migrations, lock files, build output) are exempt.

## Folder naming rules

- Use `snake_case` or `kebab-case`: `user_auth/`, `data-pipeline/`
- Name must describe a single responsibility: `payment_processor/`, `event_bus/`
- Forbidden generic names without a README justification:
  `utils/`, `helpers/`, `misc/`, `common/`, `stuff/`, `lib/`
- No spaces, no ALL_CAPS (except top-level governance dirs)

## Single-responsibility rules

- One module folder = one domain responsibility
- One file = one class, or one cohesive group of ≤ 5 related functions
- No "god files" that import from everywhere and re-export everything
- No circular dependencies between module folders

## Entry point requirement

Every module folder containing source files must declare its public interface
via an entry point file:

| Language | Entry point file |
|----------|-----------------|
| Python | `__init__.py` with explicit `__all__` |
| TypeScript / JS | `index.ts` or `index.js` with named exports |
| Go | Package declaration in a file matching the folder name |
| Other | A `README.md` listing the public interface |

Private implementation files must not be imported directly from outside the module.

## Module README requirement

Every module folder must contain a `README.md` (or equivalent docstring block)
stating exactly:

1. What this module does — one sentence
2. Public interface — function/class names and signatures
3. Dependencies — which other modules it imports from
4. What it does NOT do — explicit non-goals

This is the AI handoff contract. Without it, no agent can safely work on
the module without reading every file inside it.

## AI handoff standard

A module passes the handoff test when:

- An agent reading only the entry point and README understands the full
  module responsibility without opening any other file
- All public functions have a clear name that describes what they do
- No side effects cross module boundaries silently
- The module can be tested in isolation without standing up unrelated services

## Enforcement

`scripts/module_structure_audit.py --strict` checks:
- File line counts (hard limit: 1000, warning: 500)
- Forbidden generic folder names without README
- Missing entry point files in source module folders

This script runs in CI on every push and pull request.
