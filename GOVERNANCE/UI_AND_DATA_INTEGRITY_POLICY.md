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
