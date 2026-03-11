# Escape Prevention Policy

## Typical escape patterns
- claiming work completed without evidence
- claiming tests ran without outputs
- shipping from the wrong baseline
- fixing one thing while regressing another
- using fallback defaults to hide missing data
- using polling to imitate realtime
- releasing artifacts that do not actually exist
- retrying CI failures indefinitely without escalating to human
- emitting completion signal when work is not actually done
- skipping HANDOFF_NOTES update on early exit or partial completion
- failing to read HANDOFF_NOTES at iteration start, causing repeated mistakes
- running 3+ iterations with zero commits and no blocker declared (stagnation)
- repeating the same failing command 5+ times without changing approach (spin loop)

## Controls
1. Mandatory baseline declaration
2. Mandatory release gate checklist
3. Mandatory regression checks
4. Mandatory evidence for tests
5. Mandatory known limitations section
6. Mandatory artifact existence check before release note
7. CI retry hard limit: 3 attempts per iteration, then stop and escalate
8. Completion signal (`WORK COMPLETE: no further iterations needed`) is reserved for
   genuine project-level completion only; misuse is a governance violation
9. HANDOFF_NOTES.md must be updated at the end of every iteration, including failures
10. Stuck-loop detection: 3 consecutive completion signals with no new commits = human alert required
11. Stagnation circuit breaker: 3 iterations with no commits and no declared blocker = stop and escalate
12. Spin-loop circuit breaker: same error repeated 5 times in succession = stop and escalate
