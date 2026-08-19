# Issue 工作流

> Issue Workflow

**所属目录**：`ai-engineering/guide/`
**文档状态**：正式
**当前版本**：v2.0
**发布日期**：2026-08-19
**来源仓库**：`lpreterite/ai-engineering`
**源文件路径**：`guide/issue-workflow.md`
> **Skill 引用**：Issue 生命周期 → `skills/goal-issue-lifecycle`

---

## 1. 概述

本文档定义项目中 **Issue 的完整生命周期管理规范**。体系基于「打磨 vs 执行」双阶段，使用 **GitHub Issues** 作为持久化载体，遵守「**打磨阶段零独立打磨族 Issue**」原则。

**核心设计原则**：

| 原则 | 说明 |
|------|------|
| **人类主导节奏** | 人类发起流程，Agent 遵循「识别→询问→确认→执行→汇报」循环 |
| **Goal Issue 根容器** | 打磨阶段的决策/审计/改进以**评论**附着于 Goal Issue，不产生独立打磨族 Issue |
| **阻塞项 = 子任务** | Goal 正文的阻塞项 checklist 同时是子任务清单，全部清零才 done |
| **产出物草稿隔离** | 产出物未定稿前写入 `.ai-engineering/drafts/`，人类批准后才正式化 |
| **门禁 PO 驱动** | 门禁由 PO（人类角色）发起，隔离审核给出结论，PO 终审放行/打回 |
| **任务自包含** | Task Issue 是自包含可执行指令包，脱离创建上下文后仍可独立执行 |

### 全过程 Issue 流转总图

```
打磨阶段                                 执行阶段
──────────────────────────────────     ────────────────────────────
Goal Issue (根容器)                       Task Issue (从阻塞项展开)
  draft ──► reviewing ──► approved        in-progress ⇄ blocked → done
              │  ▲                            │
              │  └── rejected (打回)           ▼
              ▼                          回到 Goal 勾选阻塞项
         [隔离审核 + PO 终审]           所有阻塞项清零 → Goal done
  ┌───────────────────────┐
  │ Goal 评论:            │
  │  [决策] 方案选择      │
  │  [审计] 门禁结论       │
  │  [改进] 返工动作      │
  └───────────────────────┘
```

---

## 2. Issue 类型与标签

### 2.1 Issue 类型

新体系只有两类 Issue：

| 类型 | 说明 | 使用场景 | 标签 |
|------|------|----------|------|
| **Goal Issue** | 双阶段根容器：目标 + 验收标准 + 阻塞项 + 过程评论 | 每个需求一个 | `goal, polishing` |
| **Task Issue** | 执行阶段任务：从 Goal 阻塞项展开 | 执行拆分的子任务 | `task, execution` |

> 旧打磨族类型（Decision / Question / Risk / Review）已废弃——决策/审计/改进均记录为 **Goal Issue 评论**。

### 2.2 状态标签

**Goal Issue 状态**（单一状态机跨两阶段）：

| 标签 | 阶段 | 说明 |
|------|------|------|
| `status:draft` | 打磨 | 已创建，产出物未定稿（写入草稿区） |
| `status:reviewing` | 打磨 | 已提交门禁，隔离审核中 |
| `status:approved` | 打磨→执行 | 门禁通过，可进入执行 |
| `status:rejected` | 打磨 | 门禁打回，返工后重审 |
| `status:planned` | 执行 | 已登记计划，待拆分任务 |
| `status:in-progress` | 执行 | 执行中 |
| `status:blocked` | 执行 | 被阻塞（解除后回 in-progress） |
| `status:done` | 完成 | 所有阻塞项清零 |

**Task Issue 状态**：

| 标签 | 说明 |
|------|------|
| `status:in-progress` | 正在处理 |
| `status:blocked` | 被阻塞（记录原因到 Task 评论） |
| `status:done` | 已完成，QA 验证通过 |

### 2.3 阶段标签

| 标签 | 说明 |
|------|------|
| `polishing` | 打磨阶段（Goal Issue） |
| `execution` | 执行阶段（Task Issue） |

---

## 3. Goal Issue 生命周期

### 3.1 创建（人类主导）

```
[人类] 提出需求
[Agent] 识别 → 询问："需要创建 Goal Issue 吗？"
[人类] 确认
[Agent] 询问目标背景与验收标准（不臆造）
[人类] 回答
[Agent] gh issue create --label goal,polishing --label status:draft
```

**正文结构**（见 `skills/goal-issue-lifecycle/references/goal-issue-template.md`）：

```
## 目标
## 验收标准
## 阻塞项（= 子任务清单）
## 关联
```

**产出物草稿**：写入 `.ai-engineering/drafts/<issue-number>/`，不污染正式目录。

### 3.2 决策/审计/改进评论

打磨过程的讨论记录**全部作为 Goal Issue 评论**，用前缀区分类型（见 `references/comment-protocol.md`）：

| 评论类型 | 前缀 | 必填字段 |
|---------|------|---------|
| 决策 | `[决策] <主题>` | 背景 / 可选方案 / 结论 / 依据 / 影响 |
| 审计 | `[审计] <审核点>` | 审核项 / 结果 / 依据 |
| 改进 | `[改进] <主题>` | 来源 / 动作 / 目标阻塞项 |

**触发方式**：Agent 识别决策点 → **询问人类**是否记录 → 确认后写入评论。

### 3.3 进度审查

人类发起（"看看进度"）时，Agent 执行：

```
Agent 审查：读 Issue 状态 / 评论 / 阻塞项勾选 / 草稿区产出物
Agent 汇报：当前状态 + 已确认事项 + 未决项 + 下一步选项
Agent 询问："下一步：① 继续讨论 ② 记录决策 ③ 提交门禁 ... 你定。"
```

### 3.4 定稿（人类批准制）

**定稿前置条件**：
- 无未决事项（打磨期阻塞项 = 未决问题）
- 已完成审核

**流程**：

```
Agent 检查条件 → 询问人类："产出物已满足定稿条件，是否批准正式化？"
人类批准 → Agent 将 .ai-engineering/drafts/<N>/ 复制到正式目录
人类未批准 → 保持草稿期，继续讨论
```

### 3.5 门禁

门禁由 **PO（人类角色）发起和跟进**：

```
PO 发起门禁 → 状态 reviewing
    │
    ├─ 隔离审核（独立上下文）：
    │    DSH：另建会话（文件桥接 + session-query 拉日志）
    │    OpenCode：开子会话（子代理隔离）
    │    对照验收标准逐项核对产出物 → 审核结论
    │
    ├─ PO 终审：
    │    通过 ──► 审计评论 + status:approved
    │    打回 ──► 审计评论（含改进项）+ status:rejected → 返工
```

### 3.6 生命周期状态机

```
draft ──提交门禁──► reviewing ──通过──► approved ──登记计划──► planned
  ▲                   │                                               │
  │                   │ 不通过（打回）                       开始执行  ▼
  │◄── rejected ◄─────┘                                        in-progress
                                                                     │
                                                                     ▼
                                                            所有阻塞项清零 ──► done
```

---

## 4. Task Issue 生命周期

### 4.1 展开（人类确认拆分方案后）

Goal `approved` 后，人类确认进入执行（planned），Agent 询问拆分粒度，确认后从阻塞项展开：

```
Agent 询问："正文 3 个阻塞项，是否一个阻塞项一个 Task Issue？"
人类确认 → Agent 创建 Task Issue
```

### 4.2 Task Issue 自包含规范（六段式）

脱离创建上下文后，读者（人类或新 AI）仅凭 Issue 内容即可独立理解并执行：

```
## 背景与动机
- 来源：Goal Issue 阻塞项 N
- 触发决策/评论：<引用 + 摘要>
- 前置依赖：<先决条件>

## 目标
<一句话完成状态>

## 任务
- [ ] 动作 1

## 验收标准
- [ ] 条件 1

## 关联
- 目标: <Goal 编号>（验收标准要点摘要）
- 关键决策: <评论引用 + 结论>

## 完成定义
- 不做: <排除范围>
- 边界: <职责划分>
```

### 4.3 任务流转

```
in-progress ⇄ blocked → done
```

| 状态 | 操作 | 说明 |
|------|------|------|
| **in-progress** | Dev 开始 | 认领任务 |
| **blocked** | Dev 汇报 | 遇阻塞，阻塞原因写 Task 评论，询问人类处理方式 |
| **done** | QA 验证通过 | 测试结果写 Task 评论；回到 Goal 勾选对应阻塞项 |

---

## 5. 阻塞项与进度管理

### 5.1 阻塞项 = 子任务

- Goal Issue 正文的阻塞项 checklist 每一行就是**一个子任务**
- **完成判定**：Goal **只有在其所有阻塞项都勾选完成后才算 done**
- 进度计量始终回到正文 checklist：Task done → 勾选阻塞项 → 全部清零 → Goal done

### 5.2 回勾强制规则

每个 Task Issue 完成后，Agent **立即**回到 Goal Issue 正文，将对应阻塞项 `- [ ]` 改为 `- [x]`。Goal 正文阻塞项是唯一进度权威源。

---

## 6. 谁在什么时机创建 Issue

| 角色 | 时机 | 创建类型 |
|------|------|----------|
| **人类** | 提出需求、确认创建 | Goal Issue（Agent 辅助创建） |
| **PO（人类）** | 发起门禁、终审 | 状态流转（reviewing/approved/rejected） |
| **Dev Agent** | 人类确认拆分方案后 | Task Issue |
| **QA Agent** | 测试验证后 | 在 Task Issue 评论记录结果 |

---

## 7. Issue Forms 规范

### 7.1 模板清单

新体系只保留 YAML Forms 模板：

| 文件 | 类型 | 说明 |
|------|------|------|
| `0-goal.yml` | Goal | 双阶段根容器入口 |
| `1-bug.yml` | Bug | 缺陷报告（执行期发现的问题） |
| `2-feature.yml` | Feature | 功能请求 |
| `3-task.yml` | Task | 工程任务 |

> 旧模板 `4-decision.yml`、`5-question.yml`、`6-risk.yml`、`7-review.yml` 已删除。
> 决策/审计/改进通过 `gh issue comment` 记录为 Goal Issue 评论，不创建独立 Issue。

### 7.2 AI 创建 Issue 流程

```
1. 读取 .github/ISSUE_TEMPLATE/{type}.yml
2. 解析 body 字段定义（label / description / validations）
3. 按字段结构构造 Issue body（Markdown）
4. 执行 gh issue create --body-file 或 API 创建
5. 汇报："已创建 #N" + 下一步选项
```

---

## 8. 打磨→执行转换规则

### 8.1 转换条件

Goal Issue 状态为 `approved` 后，人类确认进入执行：

```
approved ──人类确认进入执行──► planned ──确认拆分方案──► Task Issue 展开
```

### 8.2 拆解依据

- 执行任务从 **Goal Issue 正文阻塞项** 展开
- Task Issue 通过「关联」字段引用 Goal Issue（内联验收标准摘要）
- 决策记录通过 Goall Issue 评论回溯（`[决策]` 前缀）

### 8.3 完整迭代流程

```
v1.0 打磨 → Goal Issue（draft→reviewing→approved）
→ 门禁通过（PO 终审）
→ 执行 → Task Issue 展开 → 阻塞项回勾 → 全部清零 → done

v1.1 新需求 → 新 Goal Issue → 新讨论 → 新门禁 → 新执行 → done
```

---

## 9. Commit 规范

### 9.1 提交前验收核验

1. **读取验收标准**：`gh issue view <N> --json body` 获取验收标准
2. **逐一核验**：对照每一项确认改动已覆盖
3. **勾选验收标准**：`gh issue edit <N> --body-file` 将 `- [ ]` 更新为 `- [x]`
4. **确认闭环**：全部勾选后提交推送

### 9.2 引用格式

| 变更类型 | Commit 格式 | 示例 |
|----------|------------|------|
| 修复 Bug | `fix: 描述 (#N)` | `fix: 统一 .env 键名 (#1)` |
| 新功能 | `feat: 描述 (#N)` | `feat: 添加批量发布功能 (#5)` |
| 文档 | `docs: 描述 (#N)` | `docs: 更新安装说明 (#3)` |

### 9.3 关闭关键词

| 关键词 | 使用场景 |
|--------|----------|
| `Close #N` | 通用关闭 |
| `Fixes #N` | Bug 修复 |
| `Resolves #N` | 功能/任务完成 |

> 注意：Goal Issue 的 done 由**阻塞项清零**驱动（`status:done` 标签 + close），不是 commit 自动关闭。

---

## 10. 与 STATUS.md 的关系

| 维度 | GitHub Issues | STATUS.md |
|------|---------------|-----------|
| **定位** | 外部问题跟踪 | 内部项目总览 |
| **粒度** | 单个 Goal/Task | 里程碑/任务级别 |
| **生命周期** | draft → done | 更新最新快照 |

---

## 附录：相关文档

| 文档 | 路径 |
|------|------|
| 项目状态卡 | [../STATUS.md](../STATUS.md) |
| 关键文档说明 | [./05-deliverables.md](./05-deliverables.md) |
| AI 软件研发流程 | [./02-process.md](./02-process.md) |
| 下游同步指南 | [./09-downstream-sync-guide.md](./09-downstream-sync-guide.md) |

---

## 修订记录

| 版本 | 日期 | 修订内容 |
|------|------|----------|
| **v2.0** | 2026-08-19 | **重构为新体系**：废弃打磨族 4 类型（Decision/Question/Risk/Review），决策/审计/改进改为 Goal Issue 评论；新增 Goal Issue 生命周期（draft→reviewing→approved/rejected→planned→in-progress→done）；阻塞项=子任务；门禁 PO 驱动 + 隔离审核；Task Issue 自包含规范（六段式）；模板清单更新（删除 4 个打磨族模板） |
| v1.0 | 2026-05-28 | 重构为双阶段 Issue 体系：新增打磨族类型和执行族类型；双生命周期模型；双看板设计；4 个 YAML Forms 模板；AI 决策记录协议（3 轮门槛）；打磨→执行转换规则；增量文档版本管理规范；补充 AGENTS.md 指令 |