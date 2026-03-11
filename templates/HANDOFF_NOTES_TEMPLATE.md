# Handoff Notes

> 由 builder agent 在每次迭代**结束时**写入，下一次迭代**开始时**必读。
> 这是 agent 之间的接力棒，不是给人看的报告。
>
> 写作原则：
> - 只写"下一个 agent 需要知道的事"，不写"我做了什么"
> - 一条信息对应一个行动建议，不写背景故事
> - 如果没有遗留问题，明确写 "No blockers. Ready for next iteration."
> - 每次迭代开始前，agent 读完后应能在 30 秒内理解当前状态

---

## Current state
<!-- 用一句话描述项目/模块现在处于什么状态 -->
<!-- 例："auth 模块注册功能已完成并通过测试，登录功能尚未开始" -->

## What was attempted but not finished
<!-- 本次迭代中尝试了但没完成的事项，包括失败原因 -->
<!-- 如果没有，写 "None" -->
- ...

## Known issues to watch for
<!-- 下一个 agent 工作时需要特别留意的陷阱或已知问题 -->
<!-- 例："validators.py 里 email_regex 有个边界问题，包含 + 号的邮箱会被错误拒绝，暂未修复" -->
- ...

## Suggested next step
<!-- 下一次迭代最优先应该做的一件事，尽量具体到文件/函数级别 -->
<!-- 例："实现 src/auth/login.py 的 login() 函数，接口见 ARCH/API_CONTRACTS.md#auth" -->

## Blockers requiring human input
<!-- 如果有需要人工决策才能继续的问题，在这里列出 -->
<!-- 如果没有，写 "None" -->
- ...
