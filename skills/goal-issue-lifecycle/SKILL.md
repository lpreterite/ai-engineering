---
name: goal-issue-lifecycle
version: v1.1
description: "打磨与执行双阶段 Issue 生命周期管理——Goal Issue 创建、决策/审计/改进评论、草稿隔离、门禁验收（PO 驱动）、Task 拆分与阻塞项回勾。触发：创建 Goal Issue、打磨阶段讨论出现决策点、人类说'看看进度'、提交门禁、进入执行、拆分任务、阻塞项勾选时。"
---

# goal-issue-lifecycle — 打磨与执行双阶段 Issue 管理

Type: 3 (Automation & Orchestration) + 2 (Data & Information Management)

## 核心原则：人类主导对话模式

> 人类是流程掌控者，Agent 遵循「识别→询问→确认→执行→汇报」循环，**绝不主动推进或替人类决定**。
> → **此时加载** [references/dialogue-pattern.md](references/dialogue-pattern.md)（标准循环图 + 四条硬约束 + 审查-汇报-询问模式 + 常见违规纠正）

## 前置确认 [自由度：低]

- 执行 `gh auth status` 确认认证可用；不可用则请人类先认证
- 确认当前处于打磨阶段（draft/reviewing/rejected）还是执行阶段（approved 及之后），无 Goal Issue 则从步骤 1
- **人类主导原则**：全程遵循「识别 → 询问 → 确认 → 执行 → 汇报」循环

## 工作流

### 步骤 1：创建 Goal Issue（打磨 — 草稿期） [自由度：低]
- 识别新目标 → **询问**："这是一个新目标，需要我创建 Goal Issue 吗？"
- 人类确认后 → 继续**询问**目标背景与验收标准（不臆造）
- 人类回答后 → → **此时加载** [references/goal-issue-template.md](references/goal-issue-template.md) 构造正文
- 正文必须包含：目标 / 验收标准（业务时序+技术方案两大项）/ 阻塞项 checklist
- 产出物草稿 → **此时加载** [references/draft-isolation.md](references/draft-isolation.md)（写入 `.ai-engineering/drafts/<N>/`）
- `gh issue create --label goal --label polishing --label status:draft`
- 生成评论 1：目标定义审计
- **汇报**："已创建 #N"，给出下一步选项

### 步骤 2：决策记录与进度审查 [自由度：中→低]
- 讨论中识别决策点 → **询问**："这是一个关键决策，要记录到 Issue 吗？"
- 人类确认后 → **此时加载** [references/comment-protocol.md](references/comment-protocol.md)，追加决策评论；同步更新正文「依赖/开放问题」或阻塞项
- 人类说"看看进度"时：审查 Issue 状态/评论/复选框/草稿 → **汇报**当前状态 + 未决项 → **询问**："下一步：① 继续讨论 ② 记录决策 ③ 提交门禁 ... 你定。"

### 步骤 3：提交门禁 [自由度：低]
- 人类发起（"提交门禁吧"）→ Agent 先检查定稿条件：
  无未决事项（打磨期阻塞项 = 未决问题）；产出物已定稿（`draft-isolation.md`：草稿区 → 正式目录，需人类批准）
- 人类批准定稿 → 状态 draft → reviewing → **此时加载** [references/state-machine.md](references/state-machine.md) 确认标签
- 按工具方式发起隔离审核（DSH 另建会话 / OpenCode 开子会话）

### 步骤 4：门禁结论 [自由度：低]
- 隔离审核对照验收标准核对产出物，产出审核结论
- 人类（PO）终审：
  通过 → 追加审计评论，标签 → approved
  不通过 → 追加审计评论（含改进项），标签 → rejected，阻塞项更新
- **汇报**审核结论与下一步选项，等人类决定

### 步骤 5-6：计划登记与任务拆分 [自由度：低→中]
- 人类发起（"开始执行吧"）→ 标签 → planned → Agent **询问**拆分粒度
- 人类确认后 → **此时加载** [references/task-expansion.md](references/task-expansion.md)，将阻塞项展开为独立 Task Issue
- Task Issue 独立流转（in-progress / blocked / done），每个 done 后回 Goal 正文勾选对应阻塞项

### 步骤 7：阻塞管理 [自由度：低]
- Task 遇阻塞 → 打 blocked 标签，阻塞原因记录在 Task 评论
- **汇报**阻塞原因 + 询问处理方式，人类决定后处理
- 解除后 → in-progress
- Goal Issue 正文阻塞项是唯一进度权威源

### 步骤 8：完成闭环 [自由度：低]
- 所有 Task done → Agent **汇报**：全部阻塞项已勾选，询问是否关闭交付
- 人类确认后 → Goal Issue 标签 → done，关闭 Issue
- 生成总结评论：交付摘要 + 关联 Task Issue 列表

## 完成标准
- Goal Issue 完整走完 draft→...→done，打磨阶段无独立打磨族 Issue（决策/审计/改进全在评论），正文阻塞项清零即 done
- 交付物：Goal Issue（含完整评论链）+ 已勾选的阻塞项

## 回退路径
- 评论格式不满意 → 按 protocol 重写（最多 1 次）
- 门禁不通过 → rejected，改进项评论 + 阻塞项更新后重审（最多 3 轮）
- Task 拆分过度 → 合并回正文阻塞项；标签混乱 → `gh issue edit` 重置
- gh 操作失败（create/edit/comment）→ 查 `gh auth status` → 重试（最多 2 次）→ 上报人类