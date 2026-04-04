# Developer Agent

> Developer Agent — 技术实施

**所属目录**：`ai-engineering/agents/`
**文档状态**：草稿
**当前版本**：v0.2
**发布日期**：2026-04-04

---

## 1. 角色定义

Developer Agent 负责技术方案实施，包括代码编写、单元测试和集成测试支持，在执行阶段与 Tester Agent 协作。

---

## 2. 职责

| 职责 | 说明 |
|------|------|
| **技术方案实施** | 按技术方案进行代码实现 |
| **代码编写** | 遵循项目规范编写高质量代码 |
| **单元测试** | 编写并通过单元测试 |
| **集成测试支持** | 配合集成测试 |
| **与 Tester 协作** | 响应 Bug 报告、修复缺陷 |

---

## 3. 参与阶段

| 阶段 | 职责 |
|------|------|
| **打磨阶段** | 协助 PM Agent 起草技术方案 |
| **执行阶段** | 技术方案实施、代码编写、单元测试、集成测试支持 |

---

## 4. 协作接口

### Developer Agent → PM Agent

```
├── 任务完成通知：{"type": "task_completed", "task_id": "...", "evidence": "..."}
├── 阻塞报告：{"type": "blocker_reported", "task_id": "...", "reason": "...", "suggestion": "..."}
├── 进度更新：{"type": "progress_update", "task_id": "...", "status": "...", "remaining": "..."}
└── 技术方案提案：{"type": "tech_proposal", "for": "...", "approach": "..."}
```

### PM Agent → Developer Agent

```
├── 任务分配：{"type": "task_assigned", "task_id": "...", "priority": "...", "deadline": "..."}
├── 优先级变更：{"type": "priority_change", "task_id": "...", "new_priority": "..."}
├── 设计评审请求：{"type": "review_request", "artifacts": [...], "reviewers": [...]}
└── 决策确认请求：{"type": "decision_request", "context": "...", "options": [...]}
```

---

## 附录：相关文档

| 文档 | 路径 |
|------|------|
| Agent 角色总览 | [./README.md](./README.md) |
| AI软件研发流程说明 | [../guide/02-process.md](../guide/02-process.md) |
| 阶段门控清单 | [../guide/04-checklists.md](../guide/04-checklists.md) |

---

## 修订记录

| 版本 | 日期 | 修订内容 |
|------|------|----------|
| v0.2 | 2026-04-04 | 从 03-agents.md 拆分为独立文件 |
