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
