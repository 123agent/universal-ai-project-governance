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

## Read-only analysis mode

Certain roles MUST operate in read-only mode during their analysis phase.
In read-only mode, the agent **may not write, edit, or delete any file**.

| Role | Read-only phase | Write-permitted phase |
|------|-----------------|-----------------------|
| Product agent | Reviewing existing ARCH/, DESIGN/ | Writing PRODUCT/ only |
| Design agent | Reviewing PRODUCT/, ARCH/ | Writing DESIGN/ only |
| Architect agent | Reviewing PRODUCT/, DESIGN/, src/ | Writing ARCH/ only |
| Builder agent | Reading GOVERNANCE/, ARCH/, TASKS/ | Writing src/ (scoped files only) |
| QA agent | Reviewing all of the above | Writing QA/, RELEASES/ only |

**If a read-only agent writes a file outside its permitted zone, that action is a governance violation
and must be reverted before work continues.**

Entry signal for read-only mode: agent is asked to "review", "analyze", "understand", or "assess".
Exit signal: agent explicitly receives permission to begin implementation.

## Handoff notes

When an iteration ends — whether completed or blocked — the agent MUST update `TASKS/HANDOFF_NOTES.md`
before stopping. At the start of each iteration, the agent MUST read this file first.

**What to write:**
- Current state in one sentence
- Anything attempted but not finished (with failure reason)
- Known issues the next agent should watch for
- The single most important next step
- Any blockers requiring human input

**What NOT to write:**
- A list of what was completed (that belongs in the completion claim)
- Background explanations the next agent doesn't need
- More than one "suggested next step"

This file is a relay baton, not a diary. It must be kept short enough to read in 30 seconds.

Use `templates/HANDOFF_NOTES_TEMPLATE.md` as the starting point.

## Completion signal

When a builder agent genuinely believes the entire project goal (not just the current iteration) is
finished, it must include the following exact phrase in its final completion claim:

> `WORK COMPLETE: no further iterations needed`

This phrase is case-sensitive and must appear verbatim.

**Rules:**
- Do not use this phrase unless you are certain there is nothing left to do
- Do not use it at the end of a single iteration if more iterations are planned
- If running in an automated loop, three consecutive `WORK COMPLETE` signals without any new
  commits constitutes a stuck loop — stop and report to the human

If the agent is uncertain whether the goal is fully met, it must NOT emit this signal.
Uncertainty should be expressed in `Known limitations` and `HANDOFF_NOTES.md` instead.

## CI failure retry limit

When CI fails after a commit:
- The agent may attempt to diagnose and fix CI failures, up to **3 attempts** per iteration
- Each attempt must include: what the failure was, what was changed, and the new CI result
- If CI has not passed after 3 attempts, the agent must STOP, revert to the last passing commit,
  and report the failure in `HANDOFF_NOTES.md` under "Blockers requiring human input"
- The agent must NOT keep retrying indefinitely or silently discard test failures

## Stagnation detection (circuit breaker)

A stagnation state is triggered when an agent keeps running but makes no real progress.

**Condition A — No file changes:**
If 3 consecutive iterations produce zero new commits and no blocker is declared in
`HANDOFF_NOTES.md`, the loop is considered stuck. The agent must STOP and report to the human.

**Condition B — Same error repeating:**
If the identical error message appears in 5 consecutive iterations without any change to the
affected file, the agent must STOP. Do not attempt fix #6 — escalate instead.

**What counts as progress:**
- At least one file was committed to git, OR
- A blocker was explicitly declared in `HANDOFF_NOTES.md` (blocked ≠ stuck)

**What does NOT count as progress:**
- Writing notes or comments without changing implementation files
- Refactoring files that are not in the current Scope
- Repeatedly running the same failing command hoping for a different result

When a stagnation state is triggered, the agent must:
1. Write the stagnation reason into `HANDOFF_NOTES.md` under "Blockers requiring human input"
2. Stop all execution
3. NOT attempt to self-recover by switching strategy without human approval

## Proactive investigation standard

Completing a fix does not mean stopping at the surface symptom. The agent must:
- Read 50 lines of context around the error, not just the error line itself
- After fixing, check the same file for similar bugs and other files for the same pattern
- Verify the result end-to-end — do not declare "fixed" without running it
- Report any related issues found in `Known limitations` or `HANDOFF_NOTES.md`

**Passive vs Active behavior:**

| Situation | Passive (not acceptable) | Active (required) |
|-----------|--------------------------|-------------------|
| Encounter error | Read error message only | Read error + context + search similar issues + check related modules |
| Fix a bug | Stop after the fix | Fix + verify + check same file + check other files for same pattern |
| Insufficient info | Ask user "Please tell me X" | Self-investigate with available tools first; only ask when genuinely blocked |
| Task complete | Say "Done" | Verify result + check edge cases + report potential risks |
| Debug fails | "I tried A and B, didn't work" | "I tried A/B/C/D/E, ruled out X/Y/Z, narrowed to W" |

**A new attempt that is not fundamentally different from all prior attempts is spin-loop behavior, not progress.**

## Systematic debugging methodology

When a fix attempt fails, complete these 5 steps before trying again:

1. **Map all attempts** — list every approach tried and identify the shared failure pattern
2. **Read precisely** — re-read the error word-by-word → WebSearch → read source → verify environment → challenge every assumption
3. **Self-check** — Am I repeating myself? Did I search? Did I read the relevant file? Did I check the simplest explanation?
4. **New approach** — the next attempt must be fundamentally different; define a concrete verification criterion before executing
5. **Post-fix review** — what solved it, and why wasn't it found earlier? Then proactively check related areas

## Evidence requirements
Every completion claim must include:
- changed files (with line count delta)
- commands run (exact, copy-pasteable)
- outputs/results (verbatim)
- known limitations
- confidence assessment (see below)

## Confidence assessment

Every completion claim must end with a `### Confidence` section using this format:

```
### Confidence

| Dimension | Level | Reason |
|-----------|-------|--------|
| Implementation correctness | HIGH / MEDIUM / LOW | <one sentence> |
| Test coverage | HIGH / MEDIUM / LOW | <one sentence> |
| Regression risk | LOW / MEDIUM / HIGH | <one sentence> |
```

**Level definitions:**

Implementation correctness
- HIGH: all acceptance criteria covered, logic is straightforward
- MEDIUM: some criteria covered, or logic has non-obvious parts
- LOW: partial implementation, spec was ambiguous, or significant assumptions made

Test coverage
- HIGH: all acceptance criteria have direct test cases, including edge cases
- MEDIUM: happy path tested, some edge cases missing
- LOW: minimal tests, or tests are not directly tied to acceptance criteria

Regression risk
- LOW: changes are isolated to scoped files, no shared utilities touched
- MEDIUM: scoped files interact with other modules
- HIGH: touched shared utilities, global config, or foundational layers

**A completion claim with all three dimensions at LOW or with HIGH regression risk requires
explicit human review before QA agent proceeds.**
