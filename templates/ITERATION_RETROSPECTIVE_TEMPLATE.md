# Iteration Retrospective

> 每次迭代结束后由人工或 QA agent 填写，存入 TASKS/RETROSPECTIVES/。
> 目的：跨迭代积累经验，让下一次迭代的 scope 划定和 agent 指令更精准。

---

## Iteration ref
- CURRENT_ITERATION: <!-- 对应的迭代文件名，如 ITERATION_005 -->
- Date completed:
- Builder agent:

## Goal (one line)
<!-- 复制 CURRENT_ITERATION.md 的 Goal 字段 -->

## Outcome
<!-- COMPLETED / COMPLETED_WITH_DEVIATIONS / REJECTED -->

---

## Scope quality

Did the scope turn out to be correctly sized?
<!-- TOO_LARGE / CORRECT / TOO_SMALL -->

If not, what happened?
<!-- 例：agent 需要修改 scope 外文件才能完成目标；或目标太小、agent 一个小时内就做完了 -->

---

## Scope drift incidents

List any files touched outside the declared Scope (should be zero):

| File | Reason agent touched it | Action taken |
|------|------------------------|--------------|
| | | |

---

## Agent behavior observations

| Signal | Observed? | Notes |
|--------|-----------|-------|
| Agent tried to widen scope | YES / NO | |
| Agent claimed done without evidence | YES / NO | |
| Agent modified GOVERNANCE/ or ARCH/ without permission | YES / NO | |
| Agent operated correctly in read-only phase | YES / NO | |
| Agent provided confidence assessment | YES / NO | |

---

## Confidence assessment accuracy

After seeing the actual outcome, how accurate was the agent's self-assessment?

| Dimension | Agent claimed | Actual outcome | Accurate? |
|-----------|--------------|----------------|-----------|
| Implementation correctness | | | YES / NO |
| Test coverage | | | YES / NO |
| Regression risk | | | YES / NO |

If inaccurate, what caused the mismatch?

---

## Patterns to carry forward

What worked well and should be repeated in future iterations?

- ...

## Patterns to avoid

What caused friction, scope drift, or rework?

- ...

## Recommendations for next iteration

- Scope guidance: <!-- e.g., "break auth into two iterations: register and login separately" -->
- Agent instruction improvements: <!-- e.g., "explicitly state that validators.py is read-only" -->
- Acceptance criteria improvements: <!-- e.g., "include error code in criterion, not just HTTP status" -->
