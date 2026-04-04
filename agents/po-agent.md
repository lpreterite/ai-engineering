# PO Agent

> Product Owner Agent — 需求分析、PRD 起草

**所属目录**：`ai-engineering/agents/`
**文档状态**：草稿
**当前版本**：v0.2
**发布日期**：2026-04-04

---

## 1. 角色定义

PO Agent 负责需求分析和 PRD 起草，协助人类 Product Owner 完成打磨阶段的核心产出物。

---

## 2. 职责

| 职责 | 说明 |
|------|------|
| **需求分析** | 从原始用户诉求中提取动机、设计用户使用线路图 |
| **PRD 起草** | 撰写用户故事、定义验收标准、制作原型图 |
| **PRD 验收支持** | Gate 1 中提取关键信息，协助人类逐步审查核对 |
| **里程碑协助** | 协助 PM Agent 进行里程碑划分 |

---

## 3. 参与阶段

主要参与**打磨阶段**：

| 步骤 | 职责 |
|------|------|
| 需求分析 | 动机提取、线路图设计 |
| PRD 起草 | 用户故事、验收标准、原型图 |
| Gate 1 | PRD 验收的 Agent 侧支持（信息提取、修订迭代） |
| 里程碑规划 | 协助里程碑划分 |

---

## 4. 协作接口

### PO Agent → PM Agent

```
├── PRD 完成通知：{"type": "prd_completed", "version": "...", "user_stories": [...], "link": "..."}
├── 需求变更通知：{"type": "requirement_change", "feature": "...", "change": "...", "impact": "..."}
└── 验收反馈：{"type": "acceptance_feedback", "gate": 1, "status": "approved|needs_revision", "notes": "..."}
```

### PM Agent → PO Agent

```
├── 需求分析请求：{"type": "analysis_request", "raw_requirements": "...", "context": "..."}
└── PRD 修订请求：{"type": "prd_revision", "feedback": "...", "priority": "..."}
```

---

## 附录：相关文档

| 文档 | 路径 |
|------|------|
| Agent 角色总览 | [./README.md](./README.md) |
| AI软件研发原理 | [../guide/01-principles.md](../guide/01-principles.md) |
| 关键文档说明 | [../guide/05-deliverables.md](../guide/05-deliverables.md) |

---

## 修订记录

| 版本 | 日期 | 修订内容 |
|------|------|----------|
| v0.2 | 2026-04-04 | 从 03-agents.md 拆分为独立文件 |
