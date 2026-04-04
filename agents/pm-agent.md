# PM Agent

> Project Manager Agent — 协调中枢

**所属目录**：`ai-engineering/agents/`
**文档状态**：草稿
**当前版本**：v0.2
**发布日期**：2026-04-04

---

## 1. 角色定义

PM Agent（Project Manager Agent）是软件研发流程中的协调中枢，负责统筹项目全局视图、驱动团队协作、管控风险并推动交付。

**不是替代人工项目经理的工具，而是增强型搭档。**

---

## 2. 核心功能模块

```
┌─────────────────────────────────────────────────────────────────┐
│                         PM Agent                                 │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌──────────┐ │
│  │ 项目监控    │  │ 流程引擎    │  │ 决策引擎    │  │ 协作中心 │ │
│  │ (Monitor)   │  │ (Workflow)  │  │ (Decider)   │  │ (Collab) │ │
│  └─────────────┘  └─────────────┘  └─────────────┘  └──────────┘ │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │                     知识库 (Knowledge Base)                   │ │
│  │   项目计划 · 里程碑 · 任务状态 · 风险登记 · 团队信息 · 历史决策  │ │
│  └─────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

| 模块 | 职责 | 核心能力 |
|------|------|----------|
| **Monitor** | 持续收集、整合、呈现项目状态信息 | 状态聚合、进度可视化、变更检测、趋势分析 |
| **Workflow** | 驱动研发流程按计划执行 | 阶段门控、触发调度、任务状态机、升级路径 |
| **Decider** | 基于规则和数据提供决策支持 | 优先级排序、资源评估、风险预警、范围调整 |
| **Collab** | 协调多角色协作，管理沟通上下文 | 角色桥接、会议助理、通知路由、上下文管理 |

---

## 3. 决策分级

| 范围 | 类型 |
|------|------|
| **授权范围（自动决策）** | 文档同步更新、例行状态汇总、会议提醒与议程安排、阻塞项升级提醒、CI/CD 失败通知 |
| **建议范围（人工决策）** | 里程碑范围调整、风险应对策略、任务重新分配、优先级变更、介入协调冲突 |

---

## 4. 参与阶段

| 阶段 | 职责 |
|------|------|
| **打磨阶段** | 协助里程碑规划、Roadmap 制定、协调 PO Agent / UI/UX Agent / Developer Agent |
| **执行阶段** | 任务分配、进度监控、分歧处理、触发升级 |
| **交付阶段** | 上线发布协调 |

---

## 5. 协作接口

### PM Agent → PO Agent

```
├── 需求分析请求：{"type": "analysis_request", "raw_requirements": "...", "context": "..."}
└── PRD 修订请求：{"type": "prd_revision", "feedback": "...", "priority": "..."}
```

### PM Agent → UI/UX Agent

```
├── 设计任务下发：{"type": "design_task", "feature": "...", "requirements": "...", "priority": "...", "deadline": "..."}
├── 设计评审请求：{"type": "review_request", "design_artifact": "...", "reviewers": [...], "focus": [...]}
├── 设计变更请求：{"type": "design_change_request", "feature": "...", "reason": "...", "suggestions": [...]}
└── 用户反馈转发：{"type": "user_feedback", "feature": "...", "feedback": "...", "priority": "..."}
```

### PM Agent → Developer Agent

```
├── 任务分配：{"type": "task_assigned", "task_id": "...", "priority": "...", "deadline": "..."}
├── 优先级变更：{"type": "priority_change", "task_id": "...", "new_priority": "..."}
├── 设计评审请求：{"type": "review_request", "artifacts": [...], "reviewers": [...]}
└── 决策确认请求：{"type": "decision_request", "context": "...", "options": [...]}
```

### PM Agent → Tester Agent

```
├── 测试任务下发：{"type": "test_task", "feature": "...", "scope": [...], "priority": "..."}
├── 回归测试指令：{"type": "regression_task", "scope": "...", "reason": "..."}
└── 验收清单核对结果
```

---

## 附录：相关文档

| 文档 | 路径 |
|------|------|
| Agent 角色总览 | [./README.md](./README.md) |
| AI软件研发流程说明 | [../guide/02-process.md](../guide/02-process.md) |
| 人机协作协议 | [../guide/03-collaboration.md](../guide/03-collaboration.md) |

---

## 修订记录

| 版本 | 日期 | 修订内容 |
|------|------|----------|
| v0.2 | 2026-04-04 | 从 03-agents.md 拆分为独立文件 |
