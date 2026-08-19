# 草稿隔离规则（含人类批准制定稿）

> 引用：`skills/goal-issue-lifecycle/SKILL.md` 步骤 1 / 步骤 3

## 隔离区路径

```
.ai-engineering/drafts/<goal-issue-number>/
```

> **目录名语义**：`.ai-engineering/` 是**固定名称**，标识「ai-engineering 这套研发工程体系」在工作区的落地痕迹，**不跟随宿主项目名**（类比 `.git/` 固定名），也与工具无关。

## 写入规则

| 阶段 | 隔离区状态 | 正式目录状态 | 触发者 |
|------|-----------|-------------|--------|
| 草稿期（draft） | `.ai-engineering/drafts/<N>/` 存在，产出物写入此处 | 未受影响 | Agent 自动 |
| 定稿（reviewing） | 内容从隔离区复制到正式目录 | 正式文档写入 | **人类批准后** Agent 执行 |
| 审核通过（approved） | 删除 `.ai-engineering/drafts/<N>/` | 保持不变 | Agent 自动 |
| 打回/废弃（rejected） | 删除 `.ai-engineering/drafts/<N>/` | 未受影响 | Agent 自动 |

## 定稿流程（人类批准制）

```
Agent 检查定稿前置条件：
  - Goal Issue 所有阻塞项已清零（checklist 无未勾选项）
  - 已完成审核（reviewing 已通过，audit 结论 approved）
Agent 询问人类："产出物已满足定稿条件，是否批准正式化？"
人类批准 → Agent 执行：
  1. 将 .ai-engineering/drafts/<N>/ 内容复制到正式项目文档目录
  2. 移除 draft 标签，状态 → approved
人类未批准 → 保持草稿期，继续讨论
```

## 不隔离的内容

以下内容不受草稿隔离影响，直接写入 Issue：

- 决策评论（始终是过程记录）
- 阻塞项 checklist（始终在 Issue 正文）
- 验收标准（始终在 Issue 正文）

## 文件类型

隔离区**允许任意文件类型**存放（决议 8）：Markdown 文档、原型图、数据模型、配置样例等均可。