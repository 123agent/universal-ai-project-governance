# 新项目使用说明书

> Universal AI Project Governance 框架接入指南
> 适用于：人工 + AI agent 协作交付的软件项目

---

## 目录

1. [框架是什么，解决什么问题](#1-框架是什么解决什么问题)
2. [快速接入新项目](#2-快速接入新项目)
3. [目录结构说明](#3-目录结构说明)
4. [启动一个新项目的完整流程](#4-启动一个新项目的完整流程)
5. [每次迭代的操作步骤](#5-每次迭代的操作步骤)
6. [Agent 角色分工说明](#6-agent-角色分工说明)
7. [模块结构规范](#7-模块结构规范)
8. [审计脚本使用](#8-审计脚本使用)
9. [CI 自动执行说明](#9-ci-自动执行说明)
10. [Release 发布流程](#10-release-发布流程)
11. [常见错误和应对](#11-常见错误和应对)
12. [Confidence Assessment 说明](#12-confidence-assessment-说明)
13. [跨迭代交接机制](#13-跨迭代交接机制)

---

## 1. 框架是什么，解决什么问题

### 根本问题

AI agent 的典型失控模式：

- 声称完成但没有证据
- 实际没跑测试但说"测试通过"
- 顺手改了不在 scope 内的文件
- 每次交接都要重新理解整个项目
- 代码越堆越大，没人知道哪个文件干什么

### 框架做什么

| 问题 | 框架的对策 |
|------|-----------|
| 无证据声称完成 | 强制 completion claim 必须附命令 + 输出 |
| 假测试 | CI 拦截没有 `command:` 字段的 release note |
| Scope 漂移 | CURRENT_ITERATION.md 定义边界，audit 检查 |
| 交接困难 | 每个模块必须有 README + 入口文件，agent 一次读完 |
| 文件膨胀 | 500 行警告 / 1000 行 CI 硬拦截 |

### 框架不做什么

- **不替代人的判断**：框架是结构，审查还是需要人
- **不验证代码正确性**：测试要你自己写，框架只验证证据存在
- **不自动拆分大文件**：只告诉你哪里超限，怎么拆由你决定

---

## 2. 快速接入新项目

### 方法 A：复制整个框架仓库（推荐）

```bash
# 克隆框架
git clone https://github.com/your-org/universal-ai-project-governance.git my-project
cd my-project

# 重置 git 历史，作为新项目起点
rm -rf .git
git init
git add .
git commit -m "init: bootstrap governance pack"
```

### 方法 B：在现有项目中运行 bootstrap 脚本

```bash
# 把 bootstrap_governance.sh 复制到你的项目根目录
cp /path/to/governance/bootstrap_governance.sh .

# 运行（已有文件不会被覆盖）
bash bootstrap_governance.sh
```

### 接入后立刻验证

```bash
python3 scripts/governance_audit.py --strict
# 预期输出：passed: True
```

---

## 3. 目录结构说明

```
my-project/
│
├── GOVERNANCE/               ← 治理规则，不要修改，直接用
│   ├── ENGINEERING_CONSTITUTION.md   # 8 条不可违反的规则
│   ├── AGENT_EXECUTION_RULES.md      # agent 执行约束
│   ├── ESCAPE_PREVENTION_POLICY.md   # 防逃脱控制清单
│   ├── TESTING_POLICY.md             # 测试层级要求
│   ├── RELEASE_GATES.md              # 发布门禁
│   ├── DEFINITION_OF_DONE.md         # 完成的定义
│   ├── MODULE_STRUCTURE_POLICY.md    # 模块大小和结构规范
│   ├── UI_AND_DATA_INTEGRITY_POLICY.md
│   ├── REALTIME_SYSTEM_STANDARD.md
│   ├── CORE_LOOP_STANDARD.md
│   └── BASELINE_AND_PROVENANCE_POLICY.md
│
├── PRODUCT/                  ← 产品定义（人填，agent 只读）
│   ├── PRD.md                # 产品需求文档
│   ├── USER_FLOWS.md         # 用户流程
│   └── ACCEPTANCE_CRITERIA.md
│
├── DESIGN/                   ← 设计规范（人填，agent 只读）
│   ├── INFORMATION_ARCHITECTURE.md
│   └── COMPONENT_RULES.md
│
├── ARCH/                     ← 架构定义（人填，agent 只读）
│   ├── DOMAIN_MODEL.md
│   ├── MODULE_BOUNDARIES.md  # 模块划分和依赖关系
│   └── API_CONTRACTS.md
│
├── TASKS/                    ← 迭代执行区（每次迭代更新）
│   ├── CURRENT_ITERATION.md  # 当前迭代目标 ← agent 工作前必读
│   ├── HANDOFF_NOTES.md      # agent 自维护的跨迭代交接便签 ← 每次迭代开始必读、结束必写
│   ├── ROADMAP.md
│   ├── BLOCKERS.md
│   └── RETROSPECTIVES/       # 迭代后记（人工填写，可选）
│
├── QA/                       ← 质量验证区
│   ├── RELEASE_DECISION.md   # QA agent 填写
│   └── RELEASE_DECISION_TEMPLATE.md
│
├── RELEASES/                 ← 发布记录
│   └── RELEASE_001_xxx.md    # 每次发布一个文件
│
├── templates/                ← 模板，复制使用
│   ├── CURRENT_ITERATION_TEMPLATE.md
│   ├── HANDOFF_NOTES_TEMPLATE.md
│   ├── ITERATION_RETROSPECTIVE_TEMPLATE.md
│   ├── BUILD_COMMANDS.md     # 构建/测试命令参考，agent 维护
│   ├── RELEASE_NOTE_TEMPLATE.md
│   ├── AGENT_SYSTEM_PROMPT_TEMPLATE.md
│   ├── BLOCKERS_TEMPLATE.md
│   └── ADR_TEMPLATE.md
│
├── scripts/                  ← 审计脚本，CI 调用
│   ├── governance_audit.py
│   ├── release_gate_audit.py
│   └── module_structure_audit.py
│
├── .github/workflows/
│   └── governance-ci.yml     ← CI 自动执行三个审计
│
└── src/                      ← 你的实际业务代码（框架不预设结构）
```

---

## 4. 启动一个新项目的完整流程

### 第一阶段：产品定义（人完成，不让 agent 参与）

```
PRODUCT/PRD.md             ← 写清楚：做什么、不做什么、用户是谁
PRODUCT/USER_FLOWS.md      ← 核心用户路径，文字描述即可
PRODUCT/ACCEPTANCE_CRITERIA.md  ← 什么叫"做完了"
```

**检查点**：能用一句话回答"这个产品的最小核心 loop 是什么"。
参考 `GOVERNANCE/CORE_LOOP_STANDARD.md` 的 6 步模板填写。

---

### 第二阶段：架构定义（架构师或资深工程师完成）

```
ARCH/DOMAIN_MODEL.md       ← 核心实体和关系
ARCH/MODULE_BOUNDARIES.md  ← 模块划分，每个模块一句话职责
ARCH/API_CONTRACTS.md      ← 模块间接口约定
```

**模块划分原则**（直接影响 AI agent 工作质量）：

- 每个模块文件夹 = 一个业务职责
- 模块内部文件 ≤ 300 行（目标），不超过 1000 行（硬限）
- 模块对外只暴露入口文件（`__init__.py` / `index.ts`）
- 禁止跨模块直接引用内部文件

---

### 第三阶段：写第一个 CURRENT_ITERATION.md

复制模板：

```bash
cp templates/CURRENT_ITERATION_TEMPLATE.md TASKS/CURRENT_ITERATION.md
```

填写内容：

```markdown
# Current Iteration

## Baseline
- branch: main
- commit: abc1234   ← git log --oneline -1 拿到

## Goal
实现用户注册功能（邮箱 + 密码）

## Scope
- src/auth/register.py
- src/auth/validators.py
- tests/auth/test_register.py

## Out of scope
- 登录功能
- 邮件验证
- 第三方 OAuth

## Acceptance criteria
- POST /auth/register 返回 201 和 user_id
- 重复邮箱返回 409
- 密码少于 8 位返回 400
- 单元测试覆盖以上三个路径

## Blocked by
- (none)
```

---

## 5. 每次迭代的操作步骤

### 迭代开始前（人工完成）

```
1. 更新 TASKS/CURRENT_ITERATION.md
   - 填写 baseline commit
   - 写清楚 Goal（只能有一个）
   - 明确 Scope（文件级别）
   - 明确 Out of scope
   - 明确 Acceptance criteria

2. 如有阻塞项，更新 TASKS/BLOCKERS.md

3. 确认没有上一次迭代遗留的未关闭问题
```

### 给 agent 的 System Prompt

复制 `templates/AGENT_SYSTEM_PROMPT_TEMPLATE.md`，填入角色，作为 agent 的 system prompt：

```
You are a role-constrained agent operating under repository governance.

## Your role
Builder

## Before you start
Read these governance files in order:
1. GOVERNANCE/ENGINEERING_CONSTITUTION.md
2. GOVERNANCE/AGENT_EXECUTION_RULES.md
3. GOVERNANCE/ESCAPE_PREVENTION_POLICY.md
4. TASKS/CURRENT_ITERATION.md  ← 必须存在且已填写

[... 其余规则保留 ...]
```

### Agent 工作期间（人工监控）

观察 agent 是否出现以下信号，出现立刻打断：

| 危险信号 | 说明 |
|----------|------|
| 修改了 Scope 外的文件 | Scope 漂移，要求 agent 回滚 |
| 说"done"但没有命令输出 | 要求提供实际执行证据 |
| 修改了 ARCH/ 或 GOVERNANCE/ | 超出 Builder 角色 |
| 说"我认为这里也需要改" | 要求 agent 停止，新建迭代处理 |

### 迭代结束（agent 完成后）

Agent 必须输出 completion claim，包含以下**五项**（缺任何一项不接受）：

```
## Completion claim

### Changed files
- src/auth/register.py  (新增，47 行)
- src/auth/validators.py  (新增，31 行)
- tests/auth/test_register.py  (新增，52 行)

### Commands run
$ pytest tests/auth/test_register.py -v

### Output
tests/auth/test_register.py::test_register_success PASSED
tests/auth/test_register.py::test_duplicate_email PASSED
tests/auth/test_register.py::test_short_password PASSED
3 passed in 0.43s

### Known limitations
- 未测试数据库连接超时场景
- 密码 hash 算法固定为 bcrypt，未来可能需要配置化

### Confidence
| Dimension                    | Level  | Reason                                      |
|------------------------------|--------|---------------------------------------------|
| Implementation correctness   | HIGH   | 所有验收标准均有对应实现，逻辑直接           |
| Test coverage                | MEDIUM | happy path 覆盖，超时场景未测试              |
| Regression risk              | LOW    | 改动仅限 src/auth/，未触碰共用模块           |
```

**没有以上五项，不接受 completion claim。**

> Confidence 判断标准见 `GOVERNANCE/AGENT_EXECUTION_RULES.md`。
> 若三项均为 LOW 或 Regression risk 为 HIGH，必须人工审查后 QA agent 才能继续。

### 迭代后记（可选但推荐）

每次迭代完成后，将观察到的经验记录到 `TASKS/RETROSPECTIVES/`：

```bash
cp templates/ITERATION_RETROSPECTIVE_TEMPLATE.md \
   TASKS/RETROSPECTIVES/RETRO_001_user_registration.md
```

填写内容包括：scope 是否合适、agent 是否有 scope 漂移、confidence 自评准不准。
这些记录不强制，但会随项目积累，帮助人工不断改进 scope 划定和 agent 指令质量。

---

## 6. Agent 角色分工说明

| 角色 | 职责 | 只读阶段 | 可写目录 |
|------|------|----------|---------|
| **Product agent** | 定义目标、用户流程、验收标准 | 审阅 ARCH/、DESIGN/ | `PRODUCT/` |
| **Design agent** | 定义 IA、状态、视觉系统 | 审阅 PRODUCT/、ARCH/ | `DESIGN/` |
| **Architect agent** | 定义模型、模块边界、接口契约 | 审阅 PRODUCT/、DESIGN/、src/ | `ARCH/` |
| **Builder agent** | 实现 Scope 内的代码 | 读 GOVERNANCE/、ARCH/、TASKS/ | `src/`（Scope 指定文件） |
| **QA agent** | 验证、运行 release gates、可以拒绝发布 | 审阅所有目录 | `QA/`、`RELEASES/` |

**关键规则：**

- Builder 不能修改 `ARCH/`（架构变更需要新迭代，角色切换为 Architect）
- 任何 agent 不能修改 `GOVERNANCE/`
- QA agent 可以拒绝发布，且拒绝决定不可被其他 agent 覆盖

**只读模式触发词：** 当你给 agent 的指令包含"审阅"、"分析"、"理解"、"评估"、"review"、"analyze" 时，agent 进入只读模式，**在收到明确的"开始实现"指令前，不得写入任何文件**。

违反只读模式的写操作视为治理违规，必须回滚后才能继续。

---

## 7. 模块结构规范

### 文件大小限制

| 阈值 | 要求 |
|------|------|
| ≤ 300 行 | 目标大小 |
| 301–500 行 | 可接受 |
| 501–1000 行 | 警告，计划拆分 |
| > 1000 行 | **CI 硬拦截**，必须拆分才能合并 |

### 模块文件夹结构（以 Python 为例）

```
src/
├── auth/
│   ├── README.md          ← 必须：一句话职责 + 公开接口列表
│   ├── __init__.py        ← 必须：只暴露公开函数/类
│   ├── register.py        ← 单一职责，< 300 行
│   ├── login.py
│   └── validators.py
│
├── payment/
│   ├── README.md
│   ├── __init__.py
│   ├── charge.py
│   └── refund.py
```

### 模块 README 必须包含的内容

```markdown
# auth

## 职责
处理用户认证：注册、登录、token 验证。

## 公开接口
- `register(email, password) -> User`
- `login(email, password) -> Token`
- `verify_token(token) -> UserID`

## 依赖
- `src/database` — 用户持久化
- `src/email_service` — 注册确认邮件

## 不做什么
- 不处理第三方 OAuth
- 不处理权限控制（由 src/permissions 负责）
```

### AI 接手标准

一个模块合格的判断标准：**agent 只读 `README.md` 和入口文件，不打开任何其他文件，就能完全理解这个模块的职责和边界。**

---

## 8. 审计脚本使用

### 治理结构审计

```bash
# 检查所有必要文件是否存在，必要短语是否包含
python3 scripts/governance_audit.py

# 严格模式：失败时退出码非 0（CI 使用）
python3 scripts/governance_audit.py --strict
```

### Release Note 审计

```bash
# 检查 RELEASES/ 下每个 release note 的证据完整性
python3 scripts/release_gate_audit.py

# 严格模式
python3 scripts/release_gate_audit.py --strict
```

**检查项：**
- 必须有 `## Baseline`、`## Scope`、`## Passed tests`、`## Known limitations`、`## Rollback note`
- `## Passed tests` 下必须有 `command: <实际命令>` 字段
- `## Baseline` 下的值不能是空或占位符 `<baseline>`

### 模块结构审计

```bash
# 检查文件行数、文件夹命名、入口文件
python3 scripts/module_structure_audit.py

# 严格模式
python3 scripts/module_structure_audit.py --strict

# 跳过入口文件检查（迁移老项目时使用）
python3 scripts/module_structure_audit.py --strict --no-entry-point-check
```

### 一次性全量检查

```bash
python3 scripts/governance_audit.py --strict \
  && python3 scripts/module_structure_audit.py --strict \
  && python3 scripts/release_gate_audit.py --strict \
  && echo "ALL PASSED"
```

---

## 9. CI 自动执行说明

推送到任意分支或提 PR 时，GitHub Actions 自动运行：

| Job | 触发条件 | 失败影响 |
|-----|----------|----------|
| `governance-audit` | 每次 push / PR | PR 无法合并 |
| `module-audit` | 每次 push / PR | PR 无法合并 |
| `release-gate-audit` | 仅 main 分支 push | main 构建失败 |

### 本地模拟 CI

```bash
# 在提 PR 前本地跑一遍
python3 scripts/governance_audit.py --strict
python3 scripts/module_structure_audit.py --strict
```

### 迁移老项目时的过渡策略

老项目文件普遍超过 1000 行，可先用非严格模式观察：

```bash
# 只报告，不拦截
python3 scripts/module_structure_audit.py
```

看报告，按优先级逐步拆分，再切换到 `--strict`。

---

## 10. Release 发布流程

### 第一步：Builder agent 完成迭代，提交 completion claim

见第 5 节"迭代结束"部分。

### 第二步：QA agent 运行审计

```bash
python3 scripts/governance_audit.py --strict
python3 scripts/release_gate_audit.py --strict
python3 scripts/module_structure_audit.py --strict
```

### 第三步：QA agent 填写 Release Decision

```bash
cp QA/RELEASE_DECISION_TEMPLATE.md QA/RELEASE_DECISION_RELEASE_001.md
```

填写三选一决策：`APPROVED` / `APPROVED_WITH_LIMITATIONS` / `REJECTED`

### 第四步：Builder agent 写 Release Note

```bash
cp templates/RELEASE_NOTE_TEMPLATE.md RELEASES/RELEASE_001_user_registration.md
```

必须填写：

```markdown
# Release Note

## Baseline
branch: main, commit: abc1234

## Scope
- src/auth/register.py (新增)
- src/auth/validators.py (新增)
- tests/auth/test_register.py (新增)

## Passed tests
- command: pytest tests/auth/ -v
- result: 3 passed, 0 failed, 0.43s

## Known limitations
- 未测试数据库连接超时场景

## Rollback note
- 回滚到 commit abc1233，删除 src/auth/ 下三个新增文件即可
```

### 第五步：推送，CI 自动验证

`release-gate-audit` job 会机械检查 release note 的证据格式，不通过则 main 分支构建失败。

---

## 11. 常见错误和应对

### 错误 1：agent 说"done"但没有命令输出

**处置：** 拒绝接受。要求 agent 实际运行命令并粘贴输出。
如果 agent 没有执行工具权限，给它执行权限，或者由人工运行命令后把输出喂回给 agent。

---

### 错误 2：CI `module-audit` 报文件超 1000 行

```
ERROR  src/services/order.py  (1247 lines — hard limit 1000)
```

**处置：**
1. 打开文件，识别内部独立职责（通常是 3–5 个）
2. 新建迭代，Scope 只写这一个文件的拆分
3. 拆分完成后重新提 PR

---

### 错误 3：`release-gate-audit` 报 baseline 是占位符

```
ERROR: Missing or placeholder baseline declaration
```

**处置：** 打开 release note，把 `<baseline>` 改成实际 commit：

```bash
git log --oneline -1
# 输出：abc1234 feat: add user registration
```

---

### 错误 4：agent 修改了 Scope 外的文件

**处置：**
```bash
git diff --name-only HEAD~1
```
对比 `CURRENT_ITERATION.md` 的 Scope 列表，多出来的文件 `git checkout HEAD~1 -- <file>` 还原。
如果确实需要改那个文件，新建迭代处理。

---

### 错误 5：`utils/` 文件夹被 CI 拦截

```
ERROR  src/utils/  (generic name 'utils' — add README.md to justify)
```

**处置两选一：**
- 在 `src/utils/` 下新增 `README.md`，说明为什么这些函数不属于任何模块
- 更好的做法：把里面的函数按职责分配到对应模块，删掉 `utils/`

---

### 错误 6：agent 在迭代中途要求"顺手修一下别的地方"

**处置：** 直接拒绝。告诉 agent：

> 当前迭代 Scope 不包含该文件。如果需要修改，请在当前迭代结束后新建迭代，
> 更新 TASKS/CURRENT_ITERATION.md，重新开始。

这是框架最重要的纪律之一。允许一次"顺手改"，就会有第二次、第三次。

---

## 附：给 AI Agent 的最短版规则卡

> 可以直接粘贴到任意 agent 的 context 开头

```
=== GOVERNANCE RULES (MUST READ BEFORE ANY ACTION) ===

1. Read TASKS/HANDOFF_NOTES.md (if it exists), then TASKS/CURRENT_ITERATION.md.
   If CURRENT_ITERATION.md doesn't exist or is not filled in, STOP and report.

2. Work ONLY on files listed in the Scope section.
   Do not touch any other file, even if you think it needs fixing.

3. Do not say "done", "tested", or "ready" without:
   - exact list of changed files (with line count delta)
   - exact commands you ran
   - exact output of those commands
   - known limitations
   - confidence assessment (implementation / test coverage / regression risk)

4. If you encounter something outside Scope that needs fixing,
   STOP, report it, and wait for a new iteration to be defined.

5. Do not modify GOVERNANCE/, ARCH/, or PRODUCT/ unless your role
   explicitly permits it.

6. If you are asked to "review", "analyze", or "assess" — you are in
   read-only mode. Do not write any file until you receive explicit
   instruction to begin implementation.

7. When your iteration ends (success, partial, or blocked), update
   TASKS/HANDOFF_NOTES.md. Not updating it means the iteration is
   not officially closed.

8. If CI fails, you may attempt to fix it up to 3 times. After 3
   failed attempts, revert to the last passing commit, write the
   blocker in HANDOFF_NOTES.md, and stop.

9. Only emit "WORK COMPLETE: no further iterations needed" when the
   entire project goal is finished — not at the end of a single
   iteration. Misuse is a governance violation.

10. Circuit breaker — stop immediately and report to human if:
    - 3 consecutive iterations with zero new commits and no declared blocker
    - Same error repeated 5 times without changing the affected file

=== END GOVERNANCE RULES ===
```

---

## 12. Confidence Assessment 说明

### 为什么加 Confidence

AI agent 经常过度自信（说 HIGH 其实有漏洞）或过度谦虚（说 LOW 其实没问题）。
强制填写三维置信度，并在迭代后记中对照实际结果，可以：
1. 让人工在 review 时知道把注意力放在哪里
2. 随时间积累，发现 agent 在哪类任务上系统性高估或低估

### 三个维度

**Implementation correctness** — 实现是否正确覆盖了验收标准
- HIGH：所有验收标准都有直接对应实现，逻辑清晰
- MEDIUM：部分验收标准覆盖，或实现有非显而易见的假设
- LOW：部分实现，规格模糊，或做了重大假设

**Test coverage** — 测试是否充分覆盖了验收标准
- HIGH：所有验收标准有直接测试用例，含边界情况
- MEDIUM：happy path 有测试，部分边界情况缺失
- LOW：测试极少，或测试与验收标准脱节

**Regression risk** — 改动对其他功能造成回归的风险
- LOW：改动仅限 Scope 文件，未触碰共用模块
- MEDIUM：Scope 文件与其他模块有交互
- HIGH：触碰了共用工具函数、全局配置、或基础层

### 触发人工强制审查的条件

以下任一情况出现，QA agent 在完成人工确认前不得推进发布：
- 三个维度全部为 LOW
- Regression risk = HIGH

### 迭代后记中的准确率追踪

在 `TASKS/RETROSPECTIVES/` 中，每次迭代后记录 agent 自评与实际结果的对比。
经过 5–10 次迭代后，可以发现规律性的偏差（如：agent 在涉及共用模块的任务中总是低估 regression risk）。
这个发现可以直接写入给 agent 的 system prompt，修正其判断习惯。

---

## 13. 跨迭代交接机制

### 设计背景

AI agent 的一个典型问题是**无状态**：每次启动都是全新上下文，不知道上次做到哪里、踩过哪些坑。
这导致重复的错误、重复的探索、以及"我来从头理解一遍这个项目"的时间浪费。

解法：让 agent 在每次迭代结束时用 30 秒写一张便签，下次迭代开始时用 30 秒读完，然后直接从上次停下来的地方继续。
这是接力棒，不是日志。

### HANDOFF_NOTES.md 使用规则

**位置：** `TASKS/HANDOFF_NOTES.md`（固定路径，只有一个文件，每次迭代覆写）

**何时写：** 每次迭代结束时，无论成功、部分完成，还是中途被阻塞。

**何时读：** 每次迭代开始时，在读 CURRENT_ITERATION.md 之后、开始任何工作之前。

**格式：** 复制 `templates/HANDOFF_NOTES_TEMPLATE.md`，填写五个字段。

内容原则：
- 只写下一个 agent 需要知道的事
- 不写"我完成了什么"（那在 completion claim 里）
- Suggested next step 只能有一条，最重要的那一条
- 如果没有遗留问题，明确写 `No blockers. Ready for next iteration.`

**未更新 HANDOFF_NOTES 视为迭代未正式结束。**

### Completion Signal（完成暗语）

当 agent 判断**整个项目目标**（不仅仅是当前迭代）已全部完成时，必须在 completion claim 中包含以下精确短语：

```
WORK COMPLETE: no further iterations needed
```

规则：
- 区分大小写，必须一字不差
- 只用于项目级完成，不用于单次迭代结束
- 如果还有遗留事项，必须写在 Known limitations 和 HANDOFF_NOTES 里，不能发出此信号

**卡死循环识别：** 如果自动化流程中连续 3 次出现此信号但没有新 commit，则视为循环卡死，必须停止并通知人工。

### CI 失败自动修复限额

当 CI 在 commit 后失败时：

| 阶段 | 规则 |
|------|------|
| 第 1–3 次修复尝试 | 允许。每次必须记录：失败原因 → 改动内容 → 新 CI 结果 |
| 第 3 次仍未通过 | **停止**。回退到最近通过的 commit，将失败情况写入 HANDOFF_NOTES 的"Blockers"字段 |
| 禁止行为 | 无限重试、静默忽略测试失败、带失败 CI 继续推进 |

原因：三次修复尝试不通过，通常意味着问题超出了当前迭代的 scope 或能力，需要人工介入重新定义问题。

### BUILD_COMMANDS.md（构建命令参考）

**位置：** 复制 `templates/BUILD_COMMANDS.md` 到项目根目录，改名为 `BUILD_COMMANDS.md`。

**谁来填：** builder agent 在首次接触项目时填写，之后遇到命令变化随手更新。人工可以校验，但不需要主动维护。

**作用：** 每一个接手的 agent 直接读这个文件，立刻知道"怎么跑测试、怎么构建"，不用重新探索。

包含字段：依赖安装、运行测试、单文件测试、构建、开发服务器、lint、环境配置、已知陷阱。

---

### Stagnation Circuit Breaker（熔断机制）

两种熔断条件，满足任一即触发：

**条件 A — 无进展熔断：**
连续 3 次迭代，没有任何新 commit，且 HANDOFF_NOTES 里没有声明 blocker。
→ 视为循环卡死，立即停止，通知人工。

**条件 B — 同错误自旋：**
相同的错误信息连续出现 5 次，没有对受影响文件做任何修改。
→ 视为自旋死锁，立即停止，通知人工。

**什么算"有进展"：**
- 至少一个文件被 commit 到 git，或
- HANDOFF_NOTES 的 Blockers 字段新增了声明（被阻塞 ≠ 卡死）

**什么不算"有进展"：**
- 只改了注释或文档但没 commit
- 改了 Scope 外的文件
- 重复运行同一个失败命令

---

### 机制全景图

```
项目初始化
  └─ 复制 BUILD_COMMANDS.md → 填写构建/测试命令

每次迭代开始
  └─ 读 BUILD_COMMANDS.md（知道怎么跑测试）
  └─ 读 HANDOFF_NOTES（知道上次到哪里）
  └─ 读 CURRENT_ITERATION（确认目标和 scope）

迭代执行中
  ├─ CI 失败？→ 最多修复 3 次 → 超限则停止写 Blockers
  ├─ 3 次无 commit 且无 blocker？→ 熔断，停止
  └─ 同一错误出现 5 次？→ 熔断，停止

迭代结束
  └─ 写 completion claim（含 Confidence 三维评估）
  └─ 更新 HANDOFF_NOTES（接力棒交出去）
  └─ 若项目全部完成 → 发出 WORK COMPLETE 信号
  └─ 若连续多迭代 → 人工更新 CURRENT_ITERATION → 下一棒
```
