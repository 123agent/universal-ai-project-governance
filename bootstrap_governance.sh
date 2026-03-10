#!/usr/bin/env bash
set -euo pipefail

mkdir -p GOVERNANCE PRODUCT DESIGN ARCH TASKS QA RELEASES templates scripts

cat > README.md <<'EOF'
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

cat > GOVERNANCE/ENGINEERING_CONSTITUTION.md <<'EOF'
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

cat > GOVERNANCE/RELEASE_GATES.md <<'EOF'
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

cat > GOVERNANCE/AGENT_EXECUTION_RULES.md <<'EOF'
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

cat > GOVERNANCE/ESCAPE_PREVENTION_POLICY.md <<'EOF'
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

cat > GOVERNANCE/TESTING_POLICY.md <<'EOF'
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

cat > GOVERNANCE/BASELINE_AND_PROVENANCE_POLICY.md <<'EOF'
# Baseline and Provenance Policy

Every iteration and every release must declare:
- baseline branch/tag/commit
- scope of change
- files/modules touched
- release artifact name

No release is valid if provenance is unclear.
EOF

cat > GOVERNANCE/UI_AND_DATA_INTEGRITY_POLICY.md <<'EOF'
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

cat > GOVERNANCE/DEFINITION_OF_DONE.md <<'EOF'
# Definition of Done

A task is done only if:
- implementation is complete for scoped requirements
- tests were executed and results recorded
- docs/specs were updated if needed
- regressions were checked
- known limitations are listed
- QA/release criteria for that scope are satisfied
EOF

cat > GOVERNANCE/REALTIME_SYSTEM_STANDARD.md <<'EOF'
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

cat > GOVERNANCE/CORE_LOOP_STANDARD.md <<'EOF'
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

cat > PRODUCT/README.md <<'EOF'
# PRODUCT

Place product artifacts here:
- PRD.md
- USER_FLOWS.md
- FEATURE_BREAKDOWN.md
- NON_GOALS.md
- ACCEPTANCE_CRITERIA.md
EOF

cat > DESIGN/README.md <<'EOF'
# DESIGN

Place design artifacts here:
- DESIGN_PRINCIPLES.md
- VISUAL_SYSTEM.md
- INFORMATION_ARCHITECTURE.md
- PAGE_SPECS.md
- COMPONENT_RULES.md
- EMPTY_LOADING_ERROR_STATES.md
EOF

cat > ARCH/README.md <<'EOF'
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

cat > TASKS/README.md <<'EOF'
# TASKS

Place execution-scoped documents here:
- ROADMAP.md
- CURRENT_ITERATION.md
- BLOCKERS.md
EOF

cat > QA/README.md <<'EOF'
# QA

Place verification documents here:
- TEST_REPORT.md
- REGRESSION_REPORT.md
- RELEASE_DECISION.md
EOF

cat > RELEASES/README.md <<'EOF'
# RELEASES

Place release notes here.
Every release note must include:
- baseline
- scope
- passed tests
- known limitations
- rollback note
EOF

cat > templates/CURRENT_ITERATION_TEMPLATE.md <<'EOF'
# Current Iteration

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
EOF

cat > templates/RELEASE_NOTE_TEMPLATE.md <<'EOF'
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

cat > templates/AGENT_SYSTEM_PROMPT_TEMPLATE.md <<'EOF'
You are a role-constrained agent operating under repository governance.

Rules:
1. Read GOVERNANCE before making changes.
2. Work only on CURRENT_ITERATION scope.
3. Do not widen scope.
4. Do not claim completion without evidence.
5. Do not claim testing without command outputs/results.
6. Do not ship if release gates are not satisfied.
EOF

cat > templates/ADR_TEMPLATE.md <<'EOF'
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

cat > scripts/README.md <<'EOF'
# scripts

Place governance audit and release gate scripts here.
Suggested scripts:
- governance_audit.py
- release_gate_audit.py
EOF

echo "Governance pack generated successfully."
