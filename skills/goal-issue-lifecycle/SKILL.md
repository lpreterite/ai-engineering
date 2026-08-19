---
name: goal-issue-lifecycle
version: v1.0
description: "打磨与执行双阶段 Issue 生命周期管理——Goal Issue 创建、决策/审计/改进评论、草稿隔离、门禁验收（PO 驱动）、Task 拆分与阻塞项回勾。触发：创建 Goal Issue、打磨阶段讨论出现决策点、提交门禁、进入执行、拆分任务、阻塞项勾选时。"
---

# goal-issue-lifecycle — 打磨与执行双阶段 Issue 管理

Type: 2 (Data & Information Management) + 3 (Automation & Orchestration)

## 核心原则：人类主导对话模式

> **人类是流程节奏的掌控者，Agent 是响应者。** Agent 全程遵循「识别 → 询问 → 确认 → 执行 → 汇报」循环，**绝不主动推进流程或替人类做决定**。

### 标准响应循环

```
人类 ──► 发起（提需求 / 想推进 / 要求记录 / 确认决策）
                │
                ▼
Agent ──► 识别（判断是否达到创建 Issue / 记录 / 门禁的节点）
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

### 四条硬约束

| # | 约束 | 说明 |
|---|------|------|
| 1 | **不主动创建** | 创建 Issue 前必须先询问人类，人类确认后才执行 |
| 2 | **不臆造内容** | 目标、验收标准、决策内容必须来自人类回答，Agent 只做记录与结构化 |
| 3 | **不自动推进** | 状态流转由人类发起（"提交门禁"/"开始执行"/"关闭"），Agent 审查汇报后等人类决定 |
| 4 | **步步汇报** | 每个执行动作完成后汇报结果，并给出下一步选项让人类选择 |

### 审查-汇报-询问模式

人类说"看看进度"时的标准响应：

```
Agent 审查 → 汇报（当前状态 / 已确认事项 / 阻塞项勾选情况）
          → 给出下一步选项（① 继续讨论 ② 记录决策 ③ 提交门禁 ...）
          → 询问："你定。"
```

## 工作流

### 步骤 0：阶段判定 [自由度：低]
- 确认当前处于打磨阶段（draft/reviewing/rejected）还是执行阶段（approved 及之后）
- → 打磨阶段加载 [references/goal-issue-template.md](references/goal-issue-template.md)
- → 打磨阶段加载 [references/comment-protocol.md](references/comment-protocol.md)
- → 执行阶段加载 [references/task-expansion.md](references/task-expansion.md)

### 步骤 1：创建 Goal Issue（打磨 — 草稿期） [自由度：低]
- 识别新目标 → **询问**："这是一个新目标，需要我创建 Goal Issue 吗？"
- 人类确认后 → 继续**询问**目标背景与验收标准（不臆造）
- 人类回答后 → 读取 references/goal-issue-template.md 构造正文
- 正文必须包含：目标 / 验收标准（业务时序+技术方案两大项）/ 阻塞项 checklist
- gh issue create --label goal --label polishing --label status:draft
- 如需产出物文档，写入 .ai-engineering/drafts/<issue-number>/
- 产出物未定稿前，不写入正式项目文档目录
- 生成评论 1：目标定义审计
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
- **人类主导原则**：Agent 全程遵循「识别 → 询问 → 确认 → 执行 → 汇报」循环（见核心原则）

## 完成标准
- Goal Issue 完整走完 draft → ... → done
- 打磨阶段无独立打磨族 Issue 产生（决策/审计/改进全在评论）
- 正文阻塞项清零时刻即 Goal Issue done 时刻

## 回退路径
- 人类对评论格式不满意 → 按 comment-protocol 重写该条评论
- 审核不通过 → 走 rejected 分支，改进项评论 + 阻塞项更新后重新审核
- Task 拆分过度 → 合并回正文阻塞项，仅保留必要粒度
- 状态标签混乱 → gh issue edit 重置为当前真实状态