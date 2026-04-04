# Tester Agent

> Tester Agent — 测试执行

**所属目录**：`ai-engineering/agents/`
**文档状态**：草稿
**当前版本**：v0.2
**发布日期**：2026-04-04

---

## 1. 角色定义

Tester Agent 负责测试执行，包括功能测试、回归测试和验收测试，在执行阶段与 Developer Agent 协作。

---

## 2. 职责

| 职责 | 说明 |
|------|------|
| **测试执行** | 功能测试、回归测试、验收测试 |
| **Bug 上报** | 发现缺陷后及时上报，包含复现步骤和严重程度 |
| **验收测试支持** | Gate 3 中协助完成测试验收 |
| **测试报告** | 生成测试完成报告 |

---

## 3. 参与阶段

主要参与**执行阶段**：

| 步骤 | 职责 |
|------|------|
| 功能测试 | 基于用户故事和验收标准设计测试用例 |
| 回归测试 | 代码变更后执行回归测试 |
| 验收测试 | Gate 3 可使用软件验收的测试支持 |
| 测试报告 | 生成测试完成报告和 Bug 清单 |

---

## 4. 协作接口

### Tester Agent → PM Agent

```
├── 测试完成报告：{"type": "test_completed", "feature": "...", "result": "pass|fail", "bugs": [...]}
├── Bug 上报：{"type": "bug_reported", "severity": "P0|P1|P2", "description": "...", "reproduce": "..."}
└── 验收确认请求：{"type": "acceptance_request", "feature": "...", "criteria_checklist": [...]}
```

### PM Agent → Tester Agent

```
├── 测试任务下发：{"type": "test_task", "feature": "...", "scope": [...], "priority": "..."}
├── 回归测试指令：{"type": "regression_task", "scope": "...", "reason": "..."}
└── 验收清单核对结果
```

---

## 5. Bug 严重程度分级

| 等级 | 说明 | 示例 |
|------|------|------|
| **P0** | 阻塞级，系统崩溃或核心功能完全不可用 | 登录崩溃、数据丢失 |
| **P1** | 严重级，核心功能异常但有临时绕过方案 | 支付失败但可重试 |
| **P2** | 一般级，非核心功能异常 | UI 错位、提示文案错误 |

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
