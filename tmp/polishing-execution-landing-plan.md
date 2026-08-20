# 打磨与执行双阶段 Issue 设计 — 落地改造方案（定稿待审）

> 日期：2026-08-16
> 前置文档：[tmp/polishing-execution-two-phase-design.md](polishing-execution-two-phase-design.md)（目标设计）
> 状态：**草案待审**，审核确认后进入执行
> 审核依据：本仓库规矩——业务时序流程中角色与行为、程序的改造方案，经审核确认后才能进入执行

---

## 1. 落地决策摘要

| 决策点 | 结论 |
|--------|------|
| 落地载体 | **专属 Skill 封装全流程**（新建一个 skill，Agent 加载后按流程执行） |
| 打磨族模板 | **四模板（Decision/Question/Risk/Review）废弃**，决策/审计/改进变为 Goal Issue 评论 |
| 门禁方案 | **PO（人类角色）驱动的产出物验收**，**里程碑包含一个或多个 Gate**，每个 Gate 一个 Gate Issue 跟进；里程碑计划确认后通过询问逐步完善各 Gate 细化确认；隔离审核（DSH 另建会话 / OpenCode 开子会话）给出审核结论，PO 终审放行/打回；同一 Gate Issue 承载重审 |
| 过程审计 | **独立于门禁**：监督过程、产出优化建议（见 `tmp/process-audit-design.md` + `tmp/process-audit-dual-session.md`） |
| 产出物草稿隔离 | **`.ai-engineering/drafts/` 隔离区 + draft 标签**，产出物未定稿前不写入正式项目文档目录，定稿后复制 |
| 本轮范围 | **方案定稿与拆解**——仅产出本方案文档，实际改造留到执行步骤（Step 1-7） |

---

## 2. 落地范围全景

本改造涉及仓库四类文件：

| 层 | 现状 | 改造动作 |
|----|------|---------|
| `.github/ISSUE_TEMPLATE/` | 7 个模板（含 4 个打磨族） | 废弃 4 个打磨族模板；新增 `0-goal.yml`；`config.yml` 调整入口 |
| `skills/` | 10 个 skill，`issue-lifecycle`/`stage-gate`/`decision-record` 与打磨族绑定 | 新建 `goal-issue-lifecycle` skill；**删除** 3 个既有打磨族相关 skill（issue-lifecycle / stage-gate / decision-record），废弃说明写入升级文档 |
| `AGENTS.md` | 含「打磨阶段 Issue 创建指令」（决策 → 独立 Decision Issue） | 指令重写：决策/审计/改进 → Goal Issue 评论 |
| `agents/` | 5 个 agent 定义 | `po-agent` 等角色定义中 Issue 相关职责同步更新 |

---

## 3. 专属 Skill 设计

### 3.1 定位

**唯一入口 skill，管理从需求提出到交付完成的完整双阶段 Issue 流程。**

- **名称**：`goal-issue-lifecycle`（打磨-执行双阶段 Issue 管理）
- **类型**：Type 2 (Data & Information Management) + Type 3 (Automation & Orchestration)
- **触发场景**：创建 Goal Issue、打磨讨论出现决策/审计/改进、提交阶段审核、进入执行、拆分任务、阻塞管理、完成勾选

### 3.2 核心原则：人类主导对话模式

> **人类是流程节奏的掌控者，Agent 是响应者。** skill 必须遵循此对话模式，否则评审会变成 Agent 自我推进的自说自话。

**Agent 的标准响应循环（强制）：**

```
人类 ──► 发起（提需求 / 想推进 / 要求记录 / 确认决策）
                │
                ▼
Agent ──► 识别（判断是否达到创建 Issue / 记录 / 门禁节点）
                │
                ▼
Agent ──► 询问（"是否需要创建 Goal Issue？" / "请确认..."）
                │
                ▼
人类 ──► 确认 / 回答（决定下一步）
                │
                ▼
Agent ──► 执行（按确认执行 gh 操作 / 写评论 / 更新状态）
                │
                ▼
Agent ──► 汇报（"已创建 #N" / 进度审查结果 + 询问下一步）
```

**四条硬约束：**

| # | 约束 | 说明 |
|---|------|------|
| 1 | **不主动创建** | 创建 Issue 前必须先询问人类，人类确认后才执行 |
| 2 | **不臆造内容** | 目标、验收标准、决策内容必须来自人类回答，Agent 只做记录与结构化 |
| 3 | **不自动推进** | 状态流转由人类发起（"提交门禁"/"开始执行"/"关闭"），Agent 审查汇报后等人类决定 |
| 4 | **步步汇报** | 每个执行动作完成后汇报结果，并给出下一步选项让人类选择 |

**审查-汇报-询问模式（人类说"看看进度"时的标准响应）：**

```
Agent 审查 → 汇报（当前状态 / 已确认事项 / 阻塞项勾选情况）
          → 给出下一步选项（① 继续讨论 ② 记录决策 ③ 提交门禁 ...）
          → 询问："你定。"
```

### 3.3 Skill 文件结构

```
skills/goal-issue-lifecycle/
├── SKILL.md                    # 主流程指令（含对话模式约束）
└── references/
    ├── goal-issue-template.md  # Goal Issue 正文标准结构
    ├── gate-issue-template.md  # Gate Issue 模板（一个里程碑一个，见 6.5）
    ├── comment-protocol.md     # 评论协议（决策/审计/改进三类评论格式）
    ├── state-machine.md        # 单一状态机 + 标签映射
    ├── task-expansion.md       # 阻塞项 → Task Issue 拆分规则（含自包含规范）
    └── draft-isolation.md      # 草稿隔离规则（含人类批准制定稿）
```

### 3.3.1 Task Issue 自包含规范（task-expansion.md 核心，2026-08-19 定稿）

**问题**：Task Issue 的创建上下文（会话讨论）会随会话消失。人类或其他 AI 脱离原上下文重拾 Task Issue 时，必须仅凭 Issue 内容即可独立理解并执行，无需回溯聊天记录或重建对话上下文。

**原则**：Task Issue 是「自包含可执行指令包」，不是指向 Goal Issue 的指针。所有执行所需上下文内联进 Issue 本体。

**Task Issue 标准字段（六段式）**：

```
## 背景与动机（为什么有这个任务）
- 来源：Goal Issue 阻塞项 N
- 触发决策/评论：<引用及摘要>
- 前置依赖：<已完成的先决条件>

## 目标（一句话说明完成什么）
<完成这个任务要达到的状态>

## 任务（执行指令——具体动作）
- [ ] 动作 1
- [ ] 动作 2

## 验收标准（可验证）
- [ ] 条件 1
- [ ] 条件 2

## 关联（尽力内联，不只放链接）
- 目标: <Goal Issue 编号>（含验收标准要点摘要）
- 参考产出物: <文件路径>
- 关键决策: <评论引用 + 结论摘要>

## 完成定义（明确不做 / 边界）
- 不做: <明确排除的范围>
- 边界: <与其他任务的职责划分>
```

### 3.4 SKILL.md 工作流（草案）

```
### 步骤 0：阶段判定 [自由度：低]
- 确认当前处于打磨阶段（draft/reviewing/rejected）还是执行阶段（approved 及之后）
- 打磨阶段 → 后续步骤 1-4；执行阶段 → 步骤 5-8
- 若会话中无 Goal Issue → 从步骤 1 开始

### 步骤 1：创建 Goal Issue（打磨） [自由度：低]
- 识别新目标 → **询问**："这是一个新目标，需要我创建 Goal Issue 吗？"
- 人类确认后 → 继续**询问**目标背景与验收标准（不臆造）
- 人类回答后 → 读取 references/goal-issue-template.md 构造正文
- 正文必须包含：目标 / 验收标准（业务时序+技术方案两大项）/ 阻塞项 checklist
- gh issue create --label polishing --label goal，创建即打 draft 标签
- 生成评论 1：目标定义审计（状态卡格式）
- **汇报**："已创建 #N"，给出下一步选项

### 步骤 2：决策记录 [自由度：中]
- 讨论中识别决策点（方案比较、技术选型、排除替代方案）
- **询问**："这是一个关键决策，要记录到 Issue 吗？"
- 人类确认后 → 按 references/comment-protocol.md 的决策评论格式追加评论
- 决策结论同步更新正文「依赖/开放问题」或阻塞项

### 步骤 2.5：进度审查（人类发起时） [自由度：低]
- 人类说"看看进度" / "现在什么情况" 时触发
- Agent 审查：读 Issue 状态 / 评论 / 复选框 / .ai-engineering/drafts 产出物
- **汇报**：当前状态（draft/reviewing/...）、已确认事项、未决项、阻塞项勾选情况
- **询问**："下一步：① 继续讨论 ② 记录决策 ③ 提交门禁 ... 你定。"

### 步骤 3：提交门禁 [自由度：低]
- 人类发起（"提交门禁吧"）→ Agent 先检查定稿条件：
  - 无未决事项（打磨期阻塞项语义 = 未决问题）
  - 产出物已定稿（草稿隔离区 → 正式目录，需人类批准）
- 人类批准定稿后 → 状态标签 draft → reviewing
- 按工具方式发起隔离审核（DSH 另建会话 / OpenCode 开子会话）

### 步骤 4：门禁结论 [自由度：低]
- 隔离审核对照正文验收标准核对产出物，产出审核结论
- 人类（PO）终审：
  - 通过 → 追加审计评论，标签 → approved
  - 不通过 → 追加审计评论（含改进项），标签 → rejected，阻塞项更新
- **汇报**审核结论与下一步选项，等人类决定

### 步骤 5：计划登记 [自由度：低]
- 人类发起（"开始执行吧"）→ 标签 → planned
- Agent **询问**任务拆分粒度，人类确认后执行

### 步骤 6：任务拆分执行 [自由度：中]
- 按 references/task-expansion.md 将阻塞项展开为独立 Task Issue（人类确认拆分方案后）
- Task Issue 独立流转状态（in-progress / blocked / done）
- 每个 Task done 后 → 回 Goal Issue 正文勾选对应阻塞项

### 步骤 7：阻塞管理 [自由度：低]
- Task 遇阻塞 → 打 blocked 标签，阻塞原因记录在 Task 评论
- **汇报**阻塞原因 + 询问处理方式，人类决定后处理
- 解除后 → in-progress
- Goal Issue 正文阻塞项是唯一进度权威源

### 步骤 8：完成闭环 [自由度：低]
- 所有 Task done → Agent **汇报**：全部阻塞项已勾选，询问是否关闭交付
- 人类确认后 → Goal Issue 标签 → done，关闭 Issue
- 生成总结评论：交付摘要 + 关联 Task Issue 列表

## 前置条件
- gh CLI 已安装并认证
- 目标仓库已部署 .github/ISSUE_TEMPLATE/0-goal.yml
- 仓库已配置状态标签集（见 references/state-machine.md）
- **人类主导原则**：Agent 全程遵循「识别 → 询问 → 确认 → 执行 → 汇报」循环（见 3.2）

## 完成标准
- Goal Issue 完整走完 draft → ... → done
- 打磨阶段无独立打磨族 Issue 产生（决策/审计/改进全在评论）
- 正文阻塞项清零时刻即 Goal Issue done 时刻

## 回退路径
- 人类对评论格式不满意 → 按 comment-protocol 重写该条评论
- 审核不通过 → 走 rejected 分支，改进项评论 + 阻塞项更新后重新审核
- Task 拆分过度 → 合并回正文阻塞项，仅保留必要粒度
- 状态标签混乱 → gh issue edit 重置为当前真实状态
```

### 3.4 评论协议（references/comment-protocol.md 核心）

三类评论统一前缀标识，便于检索与回溯：

| 类型 | 评论标题前缀 | 必填字段 |
|------|-------------|---------|
| 决策 | `[决策] <主题>` | 背景 / 可选方案 / 结论 / 依据 / 影响 |
| 审计 | `[审计] <审核点>` | 审核项 / 结果（通过/不通过） / 依据 / 打回原因（若否） |
| 改进 | `[改进] <主题>` | 触发来源（决策或审计） / 动作 / 目标阻塞项 |

### 3.5 状态标签映射（references/state-machine.md 核心）

| 状态 | 标签 | 阶段 | 说明 |
|------|------|------|------|
| draft | `polishing, status:draft` | 打磨 | 初始态 |
| reviewing | `polishing, status:reviewing` | 打磨 | 已提交审核 |
| approved | `polishing, status:approved` | 打磨→执行 | 门禁通过 |
| rejected | `polishing, status:rejected` | 打磨 | 打回，回到 draft 前序 |
| planned | `execution, status:planned` | 执行 | 已登记计划 |
| in-progress | `execution, status:in-progress` | 执行 | 执行中 |
| blocked | `execution, status:blocked` | 执行 | 被阻塞 |
| done | `execution, status:done` | 完成 | 正文阻塞项清零后 |

---

## 4. 模板改造清单

### 4.1 废弃（4 个打磨族模板）

| 文件 | 废弃理由 | 去向 |
|------|---------|------|
| `4-decision.yml` | 决策改入 Goal Issue 评论 | 删除文件 |
| `5-question.yml` | 待确认项改入正文「依赖/开放问题」字段 | 删除文件 |
| `6-risk.yml` | 风险作为依赖/范围处理，不设独立类型 | 删除文件 |
| `7-review.yml` | 审核结果改入 Goal Issue 审计评论 | 删除文件 |

### 4.2 新增 `0-goal.yml`（Goal Issue 入口）

```
# 编号 0 体现「根容器」地位，排在模板列表首位
name: Goal
description: 打磨与执行双阶段的根容器，承载目标、验收标准、阻塞项与全部过程评论
title: "[Goal]: "
labels: ["polishing", "goal"]
body:
  - markdown: 说明本 Issue 是双阶段流程的根，决策/审计/改进记录在评论中
  - textarea: 目标描述（为什么做这个）
  - textarea: 验收标准（两大项：业务时序角色与行为 / 程序改造方案）
  - markdown: 阻塞项 checklist（占位，正文由 Agent 按 skill 维护）
  - input: 关联项目文档（业务流程文档 / 技术方案文档）
```

### 4.3 `config.yml` 调整

- 空白 Issue 禁用逻辑保持
- 模板列表顺序：`0-goal` 置顶，执行族（bug/feature/task）随后

---

## 5. AGENTS.md 指令重写提案

现 AGENTS.md「打磨阶段 Issue 创建指令」与新设计冲突，重写要点：

| 现指令 | 重写为 |
|--------|--------|
| 决策识别（方案比较、选型倾向、排除方案） | 保持——识别信号不变 |
| 触发门槛：>3 轮有效讨论后询问建 Decision Issue | 改为：>3 轮有效讨论后询问「需要把该决策记录到 Goal Issue 评论吗？」 |
| 读取 4-decision.yml → gh issue create | 改为：加载 goal-issue-lifecycle skill → 按 comment-protocol 追加决策评论 |
| Issue 保持 open | 决策评论不产生新 Issue，仅评论 |
| 决策结论记入关键文档 | 保持，不变 |

---

## 6. 门禁方案：PO 驱动的产出物质量验收

> 2026-08-19 更新：门禁与过程审计拆分。本节为**门禁**方案；过程审计（含双会话设计）见 `tmp/process-audit-design.md` 与 `tmp/process-audit-dual-session.md`。

### 6.1 设计约束

- **门禁由 PO（人类角色）发起和跟进**：PO 定义验收标准、掌握研发流程、验收每个环节产出物质量
- **验收依据**：Goal Issue 正文中的验收标准 + 产出物（文档、方案、代码、测试结果）
- **隔离审核（防自产自检）**：审核执行需独立上下文，避免被制作过程污染
- **终审权归 PO**：隔离审核给出审核结论（通过/不通过），PO 终审放行或打回

### 6.2 门禁验收机制

```
流程环节 ──► 产出物 ──► PO 对照验收标准（Goal Issue 正文）──► 放行 ──► 下一环节
                               │
                               └── 打回 ──► 返工（状态 → rejected）
```

门禁由 PO 发起，审核结论来自隔离审核（见 6.3），PO 决策放行/打回。

### 6.3 隔离审核的执行方式（跨工具）

审核执行**依赖工具能力**，不同工具实现方式不同：

| 工具 | 隔离审核方式 | 说明 |
|------|-------------|------|
| **DSH** | **另建会话审核** | 双会话文件桥接：副手会话写 `checkpoint.json`，审核会话读状态 + 拉取会话日志（session-query），写回 `audit.json` |
| **OpenCode** | **开子会话审核** | 子代理独立上下文执行审核，审核结论反馈给主会话 |
| Codex / Claude Code | 各自原生隔离机制 | 待通用层落盘后再讨论 |

> 说明：DSH 的「另建会话」与 OpenCode 的「开子会话」均是**会话隔离**的不同实现——DSH 是跨会话文件桥接，OpenCode 是子代理隔离。两者都满足「独立模型判断」的核心约束。

### 6.4 门禁状态流转

```
副手会话（制作）                       审核会话（隔离审核）              Goal Issue 状态
  │                                          │                            │
  ├─ 环节完成（产出物 ready）                 │                            │
  ├─ 写 checkpoint.json                     │                            │
  │  (step: ready-for-review)               │                            │
  │                                          │                            │
  │                        [PO 发起门禁]      │                            │
  │                                          │                            │
  │                          ① 读 checkpoint                            │
  │                          ② 读产出物 + 会话日志（证据链）              │
  │                          ③ 写 audit.json（审核结论）                 │
  │                                          │                            │
  │                        [PO 终审]         │                            │
  │  PO 决策：                                │                            │
  │  通过 → status: approved                 │                            │
  │  打回 → status: rejected → 返工          │                            │
```

### 6.5 门禁与状态机的衔接（skill 步骤 3/4）

> 2026-08-19 增补：门禁验收以**独立 Gate Issue** 跟进；**里程碑包含一个或多个 Gate**，里程碑计划确认后通过询问方式逐步完善每个 Gate 的细化确认。

`goal-issue-lifecycle` skill 的门禁流程：

```
### 步骤 0.5：里程碑 Gate 规划（人类主导） [自由度：低]
- 里程碑计划确认后，Agent **询问**人类：
  "阶段 A 需要拆分为哪些验收门禁（Gate）?"
- 人类回答（可能多个 Gate），Agent 逐一**询问确认**每个 Gate 的验收项清单
- 每个 Gate 创建独立 Gate Issue（gh issue create --label gate --label status:open）

### 步骤 3：提交门禁（PO 发起） [自由度：低]
- 环节产出物完成，PO 确认提交门禁
- 打开对应的 Gate Issue（一个 Gate 一个，同一 Issue 承载重审）：
  - 首次：gh issue create --label gate --label polishing --label status:open
  - 重审：同一 Issue 追加评论（承载多轮）
  - 正文：Gate 名称 + 验收项清单 + 关联 Goal Issue + 里程碑
- 状态同步 → reviewed（Goal Issue 状态 → reviewing）
- 按工具方式发起隔离审核（DSH 另建会话 / OpenCode 开子会话）
- 写入 checkpoint 文件（如适用）

### 步骤 4：门禁结论 [自由度：低]
- 隔离审核对照 Gate Issue 验收项清单核对产出物
- 产出审核结论（通过/不通过）
- PO 终审：
  通过 ──► Gate Issue 追加审计评论 + 状态 → approved，Goal 状态 → approved（该 Gate 通过）
  打回 ──► Gate Issue 追加审计评论（含改进项）+ 状态 → rejected，Goal 状态 → rejected，返工
- 里程碑下所有 Gate 通过 → 里程碑完成
```

**Gate Issue 模板（`references/gate-issue-template.md`）**：

```
## Gate 名称
<里程碑名称> - <Gate 名称>

## 验收项清单
- [ ] ① <验收项 1>
- [ ] ② <验收项 2>

## 本轮审核结论
- 结果：待审核 / 通过 / 打回
- 证据：<隔离审核结论、验收标准核对、会话日志摘录>
- 打回原因（若否）：<具体原因>

## 重审记录（同一 Issue 承载）
- 轮 1（日期）：rejected，原因...
- 轮 2（日期）：approved，结论...

## 关联
- 目标: #N
- 里程碑: <里程碑名称>
```

**标签**：`gate` + `polishing`/`execution` + `status:open`/`status:reviewing`/`status:approved`/`status:rejected`

**状态同步规则**：

| Gate Issue 状态 | Goal Issue 状态 |
|----------------|----------------|
| open（PO 发起） | reviewing |
| approved（PO 终审） | approved |
| rejected（PO 打回） | rejected（返工后重审） |

> 里程碑下所有 Gate Issue approved → 里程碑完成，进入下一里程碑。

### 6.6 与过程审计的分工

| | 门禁（本节） | 过程审计（另文档） |
|--|-------------|-------------------|
| 目的 | 验收产出物质量 | 监督过程、发现可优化环节 |
| 产出 | 放行/打回（驱动状态流转） | 过程优化建议（不驱动状态流转） |
| 发起 | PO（人类角色） | 独立监督角色 |
| 隔离 | ✅ DSH 另建会话 / OpenCode 开子会话 | ✅ 双会话设计 |

> 两者共享「会话隔离」原则，但产出与职责不同。过程审计的双会话设计细节见 `tmp/process-audit-dual-session.md`。

---

## 7. 产出物草稿隔离方案

### 7.1 设计约束

- **问题**：打磨阶段目标讨论中，产出物文档（业务时序、技术方案）内容不成熟，直接写入正式目录会污染已有项目上下文
- **解法**：隔离区存放（`.ai-engineering/drafts/`）+ 草稿标记（`draft` 标签）
- **定稿才正式化**：方案明确后，从隔离区复制到正式目录

> **目录名语义（重要）**：`.ai-engineering/` 是**固定名称**，标识「ai-engineering 这套研发工程体系」在工作区中的落地痕迹，**不跟随宿主项目名**。无论该方案部署到哪个下游项目，工作区目录统一为 `.ai-engineering/`（类比 `.git/` 固定名）。它与 DSH 工具无关，也不随项目重命名。

### 7.2 隔离区目录结构

```
.ai-engineering/drafts/                          # 草稿隔离区（加入 .gitignore，不提交版本库）
└── <goal-issue-number>/
    ├── index.md                      # 目标摘要（自动生成）
    ├── business-flow.md              # 业务时序草稿（可选）
    ├── tech-spec.md                  # 技术方案草稿（可选）
    └── ...                           # 支持任意其他文件类型（原型图、数据模型等）
```

> 决议 8：隔离区**允许任意文件类型**存放，不限于 Markdown（原型图、数据模型、配置样例等均可）。

**生命周期**：

| 阶段 | 隔离区状态 | 正式目录状态 | 触发者 |
|------|-----------|-------------|--------|
| 草稿期（draft） | `.ai-engineering/drafts/<N>/` 存在，产出物写入此处 | 未受影响 | Agent 自动 |
| 定稿（reviewing） | 内容从 `.ai-engineering/drafts/` 复制到正式目录 | 正式文档写入 | **人类批准后** Agent 执行 |
| 审核通过（approved） | 删除 `.ai-engineering/drafts/<N>/` | 保持不变 | Agent 自动 |
| 打回/废弃（rejected） | 删除 `.ai-engineering/drafts/<N>/` | 未受影响 | Agent 自动 |

### 7.3 与 skill 的衔接

在 `goal-issue-lifecycle` skill 的流程中嵌入草稿隔离指引。**定稿采用「人类批准制」**（决议 7）：

```
### 步骤 1：创建 Goal Issue（打磨 — 草稿期） [自由度：低]
- 读取 references/goal-issue-template.md 构造正文
- 正文必须包含：目标 / 验收标准（业务时序+技术方案两大项）/ 阻塞项 checklist
- gh issue create --label polishing --label goal --label draft
- 如需产出物文档，写入 .ai-engineering/drafts/<issue-number>/
- 产出物未定稿前，不写入正式项目文档目录

### 步骤 1.5：定稿（草稿 → 正式化，人类批准制） [自由度：中]
- 定稿动作由人类在 harness 中发起，Agent 不自触发
- 定稿前置条件（Agent 检查后向人类汇报）：
  - Goal Issue 所有阻塞项已清零（checklist 无未勾选项）
  - 已完成审核（reviewing 已通过，audit.json 存在且 approved）
- Agent 询问人类确认："产出物已满足定稿条件，是否批准正式化？"
- 人类批准后，Agent 执行：
  - 将 .ai-engineering/drafts/<issue-number>/ 内容复制到正式项目文档目录
  - 移除 draft 标签，状态 → approved
- 人类未批准 → 保持草稿期，继续讨论或调整
```

### 7.4 与 references 的衔接

新增 references 文件 `references/draft-isolation.md`，记录：

```
# 草稿隔离规则

## 隔离区路径
.ai-engineering/drafts/<issue-number>/

## 写入规则
- 草稿期：产出物只写入隔离区，不碰正式目录
- 定稿：从隔离区复制到正式目录
- 废弃/打回：删除隔离区目录

## 不隔离的内容
以下内容不受草稿隔离影响，直接写入 Issue：
- 决策评论（始终是过程记录）
- 阻塞项 checklist（始终在 Issue 正文）
- 验收标准（始终在 Issue 正文）
```

### 7.5 对门禁与过程审计的影响

- 隔离审核（门禁审核 / 过程审计）除读 Issue 和会话日志外，还需读 `.ai-engineering/drafts/` 中的草稿内容作为判断依据
- 隔离审核只读隔离区，不写（产出物正式化由定稿动作负责，见 7.3）

---

## 8. 通用层与工具适配层

### 8.1 分层动机

设计方案希望能跨工具使用（DSH 为主，OpenCode 为辅，Codex / Claude Code 为备），不绑定单一工具。但各工具的自动化增强能力（多 Agent 角色、会话隔离、日志审计等）各有不同，不能强求一致。

因此将方案分为两层：

- **通用层**：不依赖任何工具，所有 AI 编程工具都能遵循
- **工具适配层**：依赖特定工具特性，为每个工具提供适配指引

### 8.2 通用层（所有工具通用）

| 要素 | 载体 | 实现方式 | 关系 |
|------|------|---------|------|
| 双阶段流程 | AGENTS.md + skill | 工作区指令定义流程，GH Issue 承载记录 | 核心骨架 |
| Goal Issue 根容器 | GitHub Issues | `gh issue create` / 母版 | 所有工具共用 |
| 决策/审计/改进评论 | GitHub Issues 评论 | `gh issue comment`，结构前缀 | 所有工具共用 |
| 阻塞项 checklist | GitHub Issues 正文 | `gh issue edit` 维护 checklist | 所有工具共用 |
| 单一状态机 | GitHub Issue 标签 | `gh issue edit --add-label` | 所有工具共用 |
| 门禁验收 | GitHub Issue 标签 + 产出物 | PO 发起，隔离审核给出结论，PO 终审 | 通用层核心 |
| 产出物草稿隔离 | `.ai-engineering/drafts/`（文件系统） | 定稿前写入隔离区 | 通用层核心 |
| 隔离审核（门禁/过程审计） | 按工具方式 | DSH 另建会话 / OpenCode 开子会话 | 通用层核心 |

**通用层以 AGENTS.md + skill 为入口，不依赖任何工具的用户界面和自动化特性。**

### 8.3 工具适配层（按工具特性增强）

| 能力 | DSH 适配 | OpenCode 适配 | Codex / Claude Code 适配 |
|------|---------|-------------|-------------------------|
| 多 Agent 角色 | agent-preset 配置多个 tool-subagent 实例（`subagent_po` 等），带 persona + toolFilter | `.opencode/agents/*.md` 自动发现角色定义 | 各自原生 Agent 机制，在 AGENTS.md 中引用角色定义文件 |
| 门禁隔离审核 | **另建会话**：文件桥接 + `session-query` 拉取会话日志作审核证据 | **开子会话**：子代理独立上下文执行审核 | 各自原生隔离机制 |
| 过程审计 | `session-query` 拉副手日志 + 独立监督会话 | 依赖 GitHub Issue 记录 + 手工子会话 | Codex 原生跨会话沟通能力 |
| 实时审查 | `dsh-advisor` 插件（副模型每轮审查） | 无原生 | 无原生 |
| 项目级自动发现 | `dsh-agent-instructions` 加载 AGENTS.md | 自动发现 `.opencode/` 目录 | 自动发现 `.claude/` 目录 |

### 8.4 落地建议

**通用层优先，工具适配层按需迭代：**

1. **先落地通用层**：AGENTS.md + skill + Issue 模板 + 文件桥接协议，确保所有工具都能用
2. **DSH 适配第一批**：preset 配置 + session-query 审计 + dsh-advisor 实时审查，作为主力工具的增强
3. **OpenCode 适配第二批**：`.opencode/agents/*.md` 角色定义 + 流程编排，作为辅助工具的增强
4. **Codex / Claude Code 适配保留**：仅 AGENTS.md 通用层 + 手工监督，不做自动化适配，除非社区出相关插件

### 8.5 维护策略

- 通用层（AGENTS.md + skill）在本仓库维护，全量部署到下游
- 工具适配层分别放在 `setup/` 目录下（`setup/dsh.md`、`setup/opencode.md` 等），按需引用
- 适配层不互相依赖，可独立升级

---

## 9. 执行步骤拆解（审核通过后执行）

| Step | 动作 | 产出物 | 验证方式 |
|------|------|--------|---------|
| 1 | 新建 `skills/goal-issue-lifecycle/`（SKILL.md + 5 个 references，含 draft-isolation.md）——**通用层** | skill 文件 | 结构符合仓库 skill 约定；加载后指令完整 |
| 2 | 新增 `.github/ISSUE_TEMPLATE/0-goal.yml`，删除 4 个打磨族模板，改 config.yml——**通用层** | 模板文件 | gh 模板列表仅剩 goal/bug/feature/task |
| 3 | 重写 `AGENTS.md` 打磨指令（含草稿隔离 + 跨工具通用流程）——**通用层** | AGENTS.md | 指令与新设计一致，无 Decision Issue 残留 |
| 4 | 更新 `agents/po-agent.md` 等角色定义中的 Issue 职责——**通用层** | agents 文件 | 职责表与 skill 流程对应 |
| 5 | **删除** 3 个既有 skill（issue-lifecycle / stage-gate / decision-record），废弃说明写入升级文档——**通用层** | 删除文件 + 升级文档 | 升级文档中标注废弃与迁移路径 |
| 6 | 配置 `.gitignore` 忽略 `.ai-engineering/drafts/` 与 `.ai-engineering/gate/`——**通用层** | .gitignore | git status 无草稿目录残留 |
| 7 | **DSH 适配**：agent-preset 配置角色化 subagent + supervisor 会话预设，session-query 审计、dsh-advisor 实时审查启用 | setup/dsh.md + preset | DSH 会话中角色工具可见，监督审计可跑通 |
| 8 | **OpenCode 适配**：`.opencode/agents/*.md` 角色定义生成，流程编排接入 | setup/opencode.md + agents 部署 | OpenCode 会话中 `@agent-name` 可用 |
| 9 | 试点验证：本仓库创建第一个 Goal Issue 走通全流程（含草稿→定稿→审核） | 试点 Goal Issue | 双阶段状态机完整流转一次 |

> 依赖关系：1-6（通用层）→ 7,8（工具适配层）→ 9（试点）；适配层互相独立

---

## 10. 待确认项（已决议）

> 2026-08-16 人类确认决议如下：

| # | 决策点 | 决议 |
|---|--------|------|
| 1 | **Skill 名称** | `goal-issue-lifecycle`（已全文替换） |
| 2 | **旧模板删除** | 直接删除文件 |
| 3 | **既有 skill 的打磨族引用** | 删除既有 skill，并在升级文档中明确说明废弃与升级 |
| 4 | **试点仓库** | 略过（暂不决策） |
| 5 | **隔离审核（门禁）的 preset 配置** | 工具层细节待通用层落盘后再讨论 |
| 6 | **`.ai-engineering/gate/` 目录的 gitignore 策略** | 同上（待通用层落盘后讨论） |
| 7 | **草稿定稿动作的触发** | 定稿动作由**人类在 harness 中发起**；定稿条件：Goal Issue 无阻塞项且完成审核后，询问人类确认，**人类批准后**才定稿 |
| 8 | **草稿隔离区的文件类型** | 允许其他文件类型存放（如原型图、数据模型等） |
| 9 | **Codex / Claude Code 适配深度** | 工具层细节待通用层落盘后再讨论 |

**决议影响**：

- 决议 1：全文 skill 名称已更新为 `goal-issue-lifecycle`
- 决议 3：既有 skill（issue-lifecycle / stage-gate / decision-record）**删除**而非改写，废弃说明写入升级文档
- 决议 7：定稿动作的触发链路调整为「人类批准制」，见第 7.3 节更新
- 决议 8：草稿隔离区支持任意文件类型，见第 7.2 节更新
- 决议 5/6/9：工具层与 gitignore 策略推迟到通用层落盘后讨论

---

## 11. 风险与对策

| 风险 | 对策 |
|------|------|
| 打磨阶段所有记录堆在一个 Issue 评论流里，变得冗长 | 评论强制结构化前缀 + 定期将决策结论同步到正文/项目文档 |
| 阻塞项 checklist 与 Task Issue 状态不同步 | skill 步骤 6 强制「Task done 立即回勾正文」，以正文为权威源 |
| 既有团队已习惯独立 Decision Issue | 迁移期在 AGENTS.md 指令中明确新规，废弃模板从入口阻断 |
| **自产自检：Agent 审核自己的产出** | 审核执行采用隔离上下文（DSH 另建会话 / OpenCode 开子会话），审核结论由 PO 终审；过程审计另走双会话设计（见 process-audit 文档） |
| **隔离审核的切换摩擦** | 人类在会话间切换的认知成本，通过 checkpoint/audit 文件的结构化摘要降低（关键信息聚合在 JSON 中，不需通读全文） |
| **隔离审核的执行环境不足** | 审核执行需要 gh + session-query 等工具，工具层按 DSH/OpenCode 分别配置，并在 skill 中明确审核执行的 toolFilter 策略 |
| **草稿内容被误当正式文档引用** | `.ai-engineering/drafts/` 加入 `.gitignore` 不提交版本库 + Goal Issue 的 draft 标签明示状态；定稿复制到正式目录时在文档头部标注版本与状态 |
| **草稿隔离区与正式目录内容重复造成漂移** | 定稿动作采用「复制」而非「移动」的阶段性策略，定稿后隔离区标注 `finalized` 待清理，避免半途失效 |
| **Agent 忘记执行定稿动作** | skill 步骤 1.5 强制化：提交审核（reviewing）前必须完成隔离区 → 正式目录复制，作为步骤 3 的前置校验 |