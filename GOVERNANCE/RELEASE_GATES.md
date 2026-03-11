# Release Gates

A release is blocked unless **all applicable gates pass**.
Each gate has a concrete pass/fail criterion — "I believe it passes" is not a pass.

---

## Gate 1 — Scope gate

**Question:** Did the release touch only what was declared in scope?

**Pass:** `git diff --name-only <baseline>..<HEAD>` matches exactly the files listed
in the release's `## Scope` section. No extra files.

**Fail:** Any file appears in the diff that is not in the declared Scope.

**Action on fail:** Identify extra changes, revert them or open a new release for them.

---

## Gate 2 — Baseline / provenance gate

**Question:** Is the starting point of this release unambiguously known?

**Pass:** The release note contains a non-placeholder `## Baseline` with an exact
branch name and full or short commit SHA (e.g., `branch: main, commit: a3f91c2`).

**Fail:** Baseline is missing, says `<baseline>`, or is a branch name without a commit.

**Action on fail:** Run `git log --oneline -1` and fill in the real value.

---

## Gate 3 — Test gate

**Question:** Were the tests actually run and did they pass?

**Pass:** The release note `## Passed tests` section contains:
- `command:` field with an exact, copy-pasteable command
- Result showing zero failures (or explicitly lists pre-existing failures by name)

**Fail:** No `command:` field. Output is missing or summarized. Any new test failure
is present and not acknowledged.

**Automated check:** `scripts/release_gate_audit.py --strict` enforces this mechanically.

---

## Gate 4 — Regression gate

**Question:** Did this release break anything that was working before?

**Pass:** Test suite ran against the baseline and against HEAD; no test that passed
on baseline now fails on HEAD. If a test was intentionally removed or renamed,
this is documented in Known limitations.

**Fail:** Any previously passing test now fails without documented justification.

**Action on fail:** Identify the regression, fix it in the current release, or explicitly
document it as a known regression with a follow-up plan.

---

## Gate 5 — Data integrity gate

*(Skip if this release contains no schema changes, no migration, and no data writes.)*

**Question:** Is data written by this release consistent and recoverable?

**Pass:** All of the following that apply:
- Schema changes have a migration script that runs without error
- Migration is reversible (down migration exists and is tested)
- No existing data is silently dropped or coerced

**Fail:** Migration script is absent, fails, or has no rollback path.

---

## Gate 6 — Observability gate

*(Skip if this release adds no new user-facing behavior.)*

**Question:** Can operators tell if the new behavior is working or broken in production?

**Pass:** At least one of the following is true:
- New behavior emits a log line at INFO level on the happy path
- New behavior has a health/status indicator visible in existing monitoring
- New behavior is covered by an existing alert or metric that would fire on failure

**Fail:** New behavior is completely silent — no logs, no metrics, no alerting path.
If the feature breaks silently, no one will know.

---

## Gate 7 — Documentation gate

*(Skip if this release changes no public interfaces and no user-visible behavior.)*

**Question:** Is the change discoverable by the next person who touches this code?

**Pass:** All of the following that apply:
- Any changed module's `README.md` reflects the new behavior
- Any changed public interface is updated in `ARCH/API_CONTRACTS.md`
- Any user-facing change is noted in the release note's `## Scope` section

**Fail:** A public function signature changed but the contract doc was not updated.
A new module was added but has no README.

---

## Minimum evidence in every release note

Regardless of which gates are skipped, the release note must always contain:

| Field | Requirement |
|-------|-------------|
| `## Baseline` | Non-placeholder branch + commit |
| `## Scope` | File list matching git diff |
| `## Passed tests` | `command:` + verbatim result |
| `## Known limitations` | Explicit list, or "None" |
| `## Rollback note` | Step-by-step instructions to undo this release |
| `## Confidence` | Three-dimension table (Implementation / Test coverage / Regression risk) |

---

## Forbidden release statements

Do not write or say:
- "done"
- "tested"
- "ready"
- "released"

unless the full evidence is attached and all applicable gates pass.
