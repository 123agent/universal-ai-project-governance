# Definition of Done

A task is not done until every item in this checklist is satisfied.
"I think it works" is not evidence. Each item requires a verifiable artifact.

---

## 1. Implementation

- [ ] All acceptance criteria in `TASKS/CURRENT_ITERATION.md` are addressed
- [ ] Only files listed in the Scope section were modified
- [ ] No files outside Scope were touched (verify with `git diff --name-only`)
- [ ] No architecture changes were made without an Architect-role iteration

## 2. Tests

- [ ] Tests were actually executed — not just written
- [ ] Exact test command is recorded (copy-pasteable)
- [ ] Verbatim test output is attached to the completion claim
- [ ] All tests pass; any pre-existing failures are explicitly noted as pre-existing
- [ ] Regression check: no previously passing test now fails

## 3. Confidence assessment

- [ ] Implementation correctness level declared (HIGH / MEDIUM / LOW) with reason
- [ ] Test coverage level declared (HIGH / MEDIUM / LOW) with reason
- [ ] Regression risk level declared (LOW / MEDIUM / HIGH) with reason
- [ ] If all three are LOW or regression risk is HIGH: human review explicitly requested

## 4. Documentation

- [ ] Any module README affected by the change is updated
- [ ] Any public interface change is reflected in `ARCH/API_CONTRACTS.md` (if applicable)
- [ ] Known limitations are listed (write "None" if genuinely none)

## 5. Handoff

- [ ] `TASKS/HANDOFF_NOTES.md` is updated with current state, unfinished items,
      known issues, suggested next step, and any blockers
- [ ] If the entire project goal is complete: `WORK COMPLETE: no further iterations needed`
      is included in the final message

## 6. Release readiness (QA agent only)

- [ ] All Release Gates in `GOVERNANCE/RELEASE_GATES.md` are verified
- [ ] Release note in `RELEASES/` is complete and passes `release_gate_audit.py --strict`
- [ ] `QA/RELEASE_DECISION.md` is filled with APPROVED / APPROVED_WITH_LIMITATIONS / REJECTED
- [ ] Rollback procedure is documented and executable

---

## Failure modes that are NOT "done"

| What the agent says | Why it is not done |
|---------------------|--------------------|
| "All tests pass" — no output shown | No evidence. Run the command and paste the output. |
| "I checked and it looks good" | Not a test. Not evidence. |
| "Minor changes outside scope were needed" | Scope violation. Revert first, then evaluate. |
| "Known limitation: tests not written yet" | Tests are required, not optional. |
| Confidence all LOW, no human review requested | Governance violation. Request review before proceeding. |
| HANDOFF_NOTES not updated | Iteration is not closed. |
