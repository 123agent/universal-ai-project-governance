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
