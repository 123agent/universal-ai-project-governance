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
