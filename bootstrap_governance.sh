#!/usr/bin/env bash
set -euo pipefail

mkdir -p GOVERNANCE PRODUCT DESIGN ARCH TASKS QA RELEASES templates scripts

# Write a file only if it does not already exist.
write_if_absent() {
    local path="$1"
    if [ -f "$path" ]; then
        echo "  [skip] $path already exists"
    else
        cat > "$path"
        echo "  [create] $path"
    fi
}

write_if_absent README.md <<'EOF'
# Universal AI Project Governance

Project-agnostic governance pack for AI-assisted software delivery.

## Purpose
This repository provides reusable standards for:
- product definition
- design standards
- architecture boundaries
- execution constraints
- testing and release gates
- anti-escape controls for AI agents

## Core principle
No AI agent may claim completion, testing, or release readiness without evidence.

## Suggested repo structure
- GOVERNANCE/
- PRODUCT/
- DESIGN/
- ARCH/
- TASKS/
- QA/
- RELEASES/
- templates/
- scripts/

## Usage
1. Copy this pack into a new repository.
2. Fill in PRODUCT, DESIGN, ARCH documents before implementation.
3. Require all builder agents to follow GOVERNANCE rules.
4. Require QA/release gates before packaging or shipping.
EOF

write_if_absent GOVERNANCE/ENGINEERING_CONSTITUTION.md <<'EOF'
# Engineering Constitution

## Non-negotiable rules
1. Do not start implementation before scope is defined.
2. Do not start UI before information architecture is defined.
3. Do not change schema without an explicit migration plan.
4. Do not use polling as the primary path for realtime systems.
5. Do not present fake data as healthy data.
6. Do not claim testing without executable evidence.
7. Do not claim release readiness without release-gate evidence.
8. Do not expand scope mid-iteration.

## Priority order
1. product clarity
2. architecture and boundaries
3. minimum viable core loop
4. tests
5. observability
6. UI polish
7. advanced features
EOF

write_if_absent GOVERNANCE/RELEASE_GATES.md <<'EOF'
# Release Gates

A release is blocked unless all required gates pass.

## Required gates
- Scope gate
- Baseline/provenance gate
- Test gate
- Regression gate
- Data integrity gate
- Observability gate
- Documentation gate

## Minimum evidence
- exact baseline version/commit
- test commands run
- test results
- known limitations
- rollback note

## Forbidden release statements
Do not say:
- "done"
- "tested"
- "ready"
- "released"

unless evidence is attached.
EOF

write_if_absent GOVERNANCE/AGENT_EXECUTION_RULES.md <<'EOF'
# Agent Execution Rules

## Universal rules
- Read governance files before working.
- Work on exactly one iteration goal.
- Do not modify architecture unless the task explicitly allows it.
- Do not widen scope.
- Do not change unrelated files "while here".
- Do not mark tasks complete without evidence.

## Role separation
- Product agent defines goals, flows, acceptance.
- Design agent defines IA, states, visual system.
- Architect agent defines models, modules, contracts.
- Builder agent implements only scoped work.
- QA agent verifies and can reject release.

## Evidence requirements
Every completion claim must include:
- changed files
- commands run
- outputs/results
- known limitations
EOF

write_if_absent GOVERNANCE/ESCAPE_PREVENTION_POLICY.md <<'EOF'
# Escape Prevention Policy

## Typical escape patterns
- claiming work completed without evidence
- claiming tests ran without outputs
- shipping from the wrong baseline
- fixing one thing while regressing another
- using fallback defaults to hide missing data
- using polling to imitate realtime
- releasing artifacts that do not actually exist

## Controls
1. Mandatory baseline declaration
2. Mandatory release gate checklist
3. Mandatory regression checks
4. Mandatory evidence for tests
5. Mandatory known limitations section
6. Mandatory artifact existence check before release note
EOF

write_if_absent GOVERNANCE/TESTING_POLICY.md <<'EOF'
# Testing Policy

## Required test layers
- unit tests
- integration tests
- regression tests
- migration tests when schema changes
- e2e tests for the minimum core loop

## Realtime systems require
- websocket handshake test
- reconnect behavior test
- stale/degraded state test
- no-fake-realtime check

## Test evidence format
- command
- result
- failures
- coverage notes
EOF

write_if_absent GOVERNANCE/BASELINE_AND_PROVENANCE_POLICY.md <<'EOF'
# Baseline and Provenance Policy

Every iteration and every release must declare:
- baseline branch/tag/commit
- scope of change
- files/modules touched
- release artifact name

No release is valid if provenance is unclear.
EOF

write_if_absent GOVERNANCE/UI_AND_DATA_INTEGRITY_POLICY.md <<'EOF'
# UI and Data Integrity Policy

## Required UI states
- loading
- empty
- healthy
- degraded
- failed
- stale
- blocked

## Rules
- Empty is acceptable.
- Fake healthy is unacceptable.
- Missing data must be visible.
- Realtime status must be explicit.
- Critical actions must be disabled when prerequisites fail.
EOF

write_if_absent GOVERNANCE/DEFINITION_OF_DONE.md <<'EOF'
# Definition of Done

A task is done only if:
- implementation is complete for scoped requirements
- tests were executed and results recorded
- docs/specs were updated if needed
- regressions were checked
- known limitations are listed
- QA/release criteria for that scope are satisfied
EOF

write_if_absent GOVERNANCE/REALTIME_SYSTEM_STANDARD.md <<'EOF'
# Realtime System Standard

## Principles
- event-driven first
- polling only for bootstrap, reconcile, or recovery
- explicit connection state machine
- degraded mode is part of normal product behavior

## Minimum required connection states
- connecting
- connected
- subscribing
- subscribed
- degraded
- reconnecting
- failed
EOF

write_if_absent GOVERNANCE/CORE_LOOP_STANDARD.md <<'EOF'
# Core Loop Standard

A project must define and validate its minimum core loop before advanced features.

Template:
1. input arrives
2. input is normalized
3. domain state updates
4. core action occurs
5. persistence happens
6. UI/consumer sees truthful state
EOF

write_if_absent PRODUCT/README.md <<'EOF'
# PRODUCT

Place product artifacts here:
- PRD.md
- USER_FLOWS.md
- FEATURE_BREAKDOWN.md
- NON_GOALS.md
- ACCEPTANCE_CRITERIA.md
EOF

write_if_absent DESIGN/README.md <<'EOF'
# DESIGN

Place design artifacts here:
- DESIGN_PRINCIPLES.md
- VISUAL_SYSTEM.md
- INFORMATION_ARCHITECTURE.md
- PAGE_SPECS.md
- COMPONENT_RULES.md
- EMPTY_LOADING_ERROR_STATES.md
EOF

write_if_absent ARCH/README.md <<'EOF'
# ARCH

Place architecture artifacts here:
- SYSTEM_CONTEXT.md
- DOMAIN_MODEL.md
- MODULE_BOUNDARIES.md
- API_CONTRACTS.md
- CLASS_AND_METHOD_CONVENTIONS.md
- VERSIONING_POLICY.md
- TASK_DECOMPOSITION.md
- BUG_MANAGEMENT_PROCESS.md
- TEST_STRATEGY.md
EOF

write_if_absent TASKS/README.md <<'EOF'
# TASKS

Place execution-scoped documents here:
- ROADMAP.md
- CURRENT_ITERATION.md  ← must be filled before any agent begins work
- BLOCKERS.md
EOF

write_if_absent QA/README.md <<'EOF'
# QA

Place verification documents here:
- TEST_REPORT.md
- REGRESSION_REPORT.md
- RELEASE_DECISION.md
EOF

write_if_absent RELEASES/README.md <<'EOF'
# RELEASES

Place release notes here.
Every release note must include:
- baseline
- scope
- passed tests
- known limitations
- rollback note
EOF

write_if_absent templates/CURRENT_ITERATION_TEMPLATE.md <<'EOF'
# Current Iteration

## Baseline
- branch:
- commit:

## Goal
<single goal>

## Scope
- ...

## Out of scope
- ...

## Inputs
- ...

## Outputs
- ...

## Acceptance criteria
- ...

## Blocked by
- (none)
EOF

write_if_absent templates/RELEASE_NOTE_TEMPLATE.md <<'EOF'
# Release Note

## Baseline
<baseline>

## Scope
- ...

## Passed tests
- command:
- result:

## Known limitations
- ...

## Rollback note
- ...
EOF

write_if_absent templates/AGENT_SYSTEM_PROMPT_TEMPLATE.md <<'EOF'
You are a role-constrained agent operating under repository governance.

## Your role
<ROLE: Product | Design | Architect | Builder | QA>

Role responsibilities:
- Product: define goals, user flows, acceptance criteria only
- Design: define IA, states, visual system only
- Architect: define models, module boundaries, contracts only
- Builder: implement scoped work only — no architecture changes, no scope expansion
- QA: verify against acceptance criteria, run release gates, can reject release

## Before you start
Read these governance files in order:
1. GOVERNANCE/ENGINEERING_CONSTITUTION.md
2. GOVERNANCE/AGENT_EXECUTION_RULES.md
3. GOVERNANCE/ESCAPE_PREVENTION_POLICY.md
4. TASKS/CURRENT_ITERATION.md  ← must exist and be filled before any work begins

## Rules
1. Read GOVERNANCE before making changes.
2. Work only on the single goal in TASKS/CURRENT_ITERATION.md.
3. Do not widen scope.
4. Do not modify architecture unless your role is Architect and the task explicitly allows it.
5. Do not change unrelated files "while here".
6. Do not claim completion without evidence.
7. Do not claim testing without command outputs/results.
8. Do not ship if release gates are not satisfied.

## Every completion claim must include
- changed files (exact paths)
- commands run (exact commands)
- outputs/results (exact output or link)
- known limitations

## Forbidden statements without evidence
Do not say "done", "tested", "ready", or "released" without attached evidence.
EOF

write_if_absent templates/ADR_TEMPLATE.md <<'EOF'
# ADR <number>: <title>

## Status
Proposed / Accepted / Superseded

## Context
...

## Decision
...

## Consequences
...
EOF

write_if_absent templates/BLOCKERS_TEMPLATE.md <<'EOF'
# Blockers

## Active blockers

| ID | Description | Blocked task | Blocking since | Owner | Resolution |
|----|-------------|--------------|----------------|-------|------------|
| B-001 | ... | TASK-XXX | YYYY-MM-DD | ... | ... |

## Resolved blockers

| ID | Description | Resolved on | Resolution |
|----|-------------|-------------|------------|
| ... | ... | ... | ... |

## Rules
- A task must not start if it has an unresolved blocker listed here.
- Blockers must be declared before the iteration begins.
- Resolving a blocker requires updating this file with the resolution.
EOF

write_if_absent scripts/README.md <<'EOF'
# scripts

Place governance audit and release gate scripts here.
Suggested scripts:
- governance_audit.py  — checks governance file structure and required phrases
- release_gate_audit.py  — audits each release note in RELEASES/ for required evidence
EOF

write_if_absent scripts/governance_audit.py <<'PYEOF'
#!/usr/bin/env python3
from __future__ import annotations

import argparse
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent

REQUIRED_FILES = [
    "README.md",
    "GOVERNANCE/ENGINEERING_CONSTITUTION.md",
    "GOVERNANCE/RELEASE_GATES.md",
    "GOVERNANCE/AGENT_EXECUTION_RULES.md",
    "GOVERNANCE/ESCAPE_PREVENTION_POLICY.md",
    "GOVERNANCE/TESTING_POLICY.md",
    "GOVERNANCE/BASELINE_AND_PROVENANCE_POLICY.md",
    "GOVERNANCE/UI_AND_DATA_INTEGRITY_POLICY.md",
    "GOVERNANCE/DEFINITION_OF_DONE.md",
    "GOVERNANCE/REALTIME_SYSTEM_STANDARD.md",
    "GOVERNANCE/CORE_LOOP_STANDARD.md",
    "PRODUCT/README.md",
    "DESIGN/README.md",
    "ARCH/README.md",
    "TASKS/README.md",
    "QA/README.md",
    "QA/RELEASE_DECISION_TEMPLATE.md",
    "RELEASES/README.md",
    "templates/CURRENT_ITERATION_TEMPLATE.md",
    "templates/RELEASE_NOTE_TEMPLATE.md",
    "templates/AGENT_SYSTEM_PROMPT_TEMPLATE.md",
    "templates/ADR_TEMPLATE.md",
    "templates/BLOCKERS_TEMPLATE.md",
    "scripts/governance_audit.py",
    "scripts/release_gate_audit.py",
]

REQUIRED_PHRASES = {
    "GOVERNANCE/ENGINEERING_CONSTITUTION.md": [
        "Do not claim testing without executable evidence",
        "Do not claim release readiness without release-gate evidence",
    ],
    "GOVERNANCE/RELEASE_GATES.md": [
        "Test gate",
        "Regression gate",
        "Documentation gate",
    ],
    "GOVERNANCE/AGENT_EXECUTION_RULES.md": [
        "Work on exactly one iteration goal",
        "Do not mark tasks complete without evidence",
    ],
    "GOVERNANCE/ESCAPE_PREVENTION_POLICY.md": [
        "claiming work completed without evidence",
        "Mandatory artifact existence check before release note",
    ],
    "GOVERNANCE/TESTING_POLICY.md": [
        "unit tests",
        "integration tests",
        "regression tests",
    ],
    "GOVERNANCE/UI_AND_DATA_INTEGRITY_POLICY.md": [
        "Fake healthy is unacceptable",
        "Missing data must be visible",
    ],
    "templates/RELEASE_NOTE_TEMPLATE.md": [
        "Passed tests",
        "Known limitations",
        "Rollback note",
    ],
    "templates/CURRENT_ITERATION_TEMPLATE.md": [
        "## Baseline",
        "## Blocked by",
    ],
    "templates/AGENT_SYSTEM_PROMPT_TEMPLATE.md": [
        "TASKS/CURRENT_ITERATION.md",
        "Do not claim completion without evidence",
    ],
}


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description="Audit governance repository structure.")
    parser.add_argument("--strict", action="store_true", help="Exit non-zero on failures.")
    args = parser.parse_args()

    missing_files: list[str] = []
    missing_phrases: dict[str, list[str]] = {}

    for rel in REQUIRED_FILES:
        path = ROOT / rel
        if not path.exists():
            missing_files.append(rel)

    for rel, phrases in REQUIRED_PHRASES.items():
        path = ROOT / rel
        if not path.exists():
            continue
        text = read_text(path)
        missing = [p for p in phrases if p not in text]
        if missing:
            missing_phrases[rel] = missing

    print("Governance audit")
    print("================")
    print(f"Repository root: {ROOT}")
    print()

    if missing_files:
        print("Missing files:")
        for item in missing_files:
            print(f"  - {item}")
    else:
        print("Missing files: none")

    print()

    if missing_phrases:
        print("Missing required phrases:")
        for rel, phrases in missing_phrases.items():
            print(f"  - {rel}")
            for phrase in phrases:
                print(f"      * {phrase}")
    else:
        print("Missing required phrases: none")

    failed = bool(missing_files or missing_phrases)
    print()
    print(f"passed: {not failed}")

    if args.strict and failed:
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
PYEOF

write_if_absent scripts/release_gate_audit.py <<'PYEOF'
#!/usr/bin/env python3
from __future__ import annotations

import argparse
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
RELEASES_DIR = ROOT / "RELEASES"

REQUIRED_RELEASE_HEADINGS = [
    "## Baseline",
    "## Scope",
    "## Passed tests",
    "## Known limitations",
    "## Rollback note",
]


def list_release_notes() -> list[Path]:
    if not RELEASES_DIR.exists():
        return []
    return sorted(
        [
            p for p in RELEASES_DIR.iterdir()
            if p.is_file() and p.suffix.lower() == ".md" and p.name != "README.md"
        ]
    )


def audit_release(path: Path) -> list[str]:
    text = path.read_text(encoding="utf-8")
    errors: list[str] = []

    for heading in REQUIRED_RELEASE_HEADINGS:
        if heading not in text:
            errors.append(f"Missing heading: {heading}")

    # Require at least one concrete test command line (e.g. "command: pytest ...")
    if not re.search(r"command\s*:\s*\S+", text, flags=re.IGNORECASE):
        errors.append("Missing concrete test command (expected 'command: <cmd>')")

    # Require a non-empty baseline value (not just the placeholder)
    baseline_match = re.search(r"##\s*Baseline\s*\n+(.+)", text)
    if not baseline_match or baseline_match.group(1).strip() in ("", "<baseline>"):
        errors.append("Missing or placeholder baseline declaration")

    return errors


def main() -> int:
    parser = argparse.ArgumentParser(description="Audit release note quality.")
    parser.add_argument("--strict", action="store_true", help="Exit non-zero on failures.")
    args = parser.parse_args()

    releases = list_release_notes()
    failed = False

    print("Release gate audit")
    print("==================")
    print(f"Repository root: {ROOT}")
    print()

    if not releases:
        print("No release notes found in RELEASES/")
        failed = True
    else:
        print(f"Found {len(releases)} release note(s)")
        print()
        for path in releases:
            print(f"- {path.relative_to(ROOT)}")
            errors = audit_release(path)
            if errors:
                failed = True
                for err in errors:
                    print(f"    ERROR: {err}")
            else:
                print("    OK")

    print()
    print(f"passed: {not failed}")

    if args.strict and failed:
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
PYEOF

write_if_absent QA/RELEASE_DECISION_TEMPLATE.md <<'EOF'
# Release Decision

## Release identifier
<release name / tag / version>

## Decision
Choose exactly one:

- APPROVED
- APPROVED_WITH_LIMITATIONS
- REJECTED

## Baseline
- branch:
- commit:
- artifact:

## Scope reviewed
- ...

## Evidence reviewed
- governance audit:
- release gate audit:
- test commands:
- test results:
- regression evidence:
- artifact existence verified:

## Findings
### Passed
- ...

### Failed
- ...

### Risks
- ...

## Known limitations
- ...

## Decision rationale
Explain why this release is approved, conditionally approved, or rejected.

## Required follow-ups
- ...

## Sign-off
- QA agent:
- Date:
EOF

mkdir -p .github/workflows

write_if_absent GOVERNANCE/MODULE_STRUCTURE_POLICY.md <<'EOF'
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
EOF

write_if_absent .github/workflows/governance-ci.yml <<'EOF'
name: Governance CI

on:
  push:
    branches: ["**"]
  pull_request:
    branches: ["**"]

jobs:

  governance-audit:
    name: Governance structure
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.11"
      - name: Check governance file structure and required phrases
        run: python3 scripts/governance_audit.py --strict

  module-audit:
    name: Module structure
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.11"
      - name: Check file sizes and module naming
        run: python3 scripts/module_structure_audit.py --strict

  release-gate-audit:
    name: Release gate
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.11"
      - name: Audit release notes for required evidence
        run: python3 scripts/release_gate_audit.py --strict
EOF

echo "Governance pack generated successfully."
