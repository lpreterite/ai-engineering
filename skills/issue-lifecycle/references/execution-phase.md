# 执行族生命周期

> SKILL.md 步骤 0 时加载。用于确认执行阶段 Issue 的创建和生命周期管理。

## Issue 类型

| 类型 | 说明 | 使用场景 |
|------|------|----------|
| **Bug** | 功能缺陷 | 现有功能不符合预期 |
| **Feature** | 新功能或改进 | 新增能力或优化已有功能 |
| **Task** | 工程任务 | 重构、文档、配置变更等非功能工作 |
| **Epic** | 大型工作分组 | 包含多个 Sub-issue 的复杂工作 |

## 生命周期

```
open → triaged → in_progress → resolved → ready-for-test → testing → verified → closed
```

| 阶段 | 操作者 | 说明 |
|------|--------|------|
| **open** | 创建者 | 提交 Issue，自动设置 Issue Type |
| **triaged** | Orchestrator | 确认有效，设置优先级和负责人。复杂 Issue 拆 Sub-issues |
| **in_progress** | Developer | 开始处理，关联分支或 commit |
| **resolved** | Developer | 提交修复，PR 关联 Issue，自测通过 |
| **ready-for-test** | Developer 或 Orchestrator | 移交 Tester，不可再修改代码 |
| **testing** | Tester | 在隔离上下文中独立执行测试 |
| **verified** | Tester | 测试通过，回归无新问题 |
| **closed** | Orchestrator | 验证通过后关闭，在 STATUS.md 中同步 |

## 状态标签

| 标签 | 说明 |
|------|------|
| `status/open` | 已创建，待 triage |
| `status/triaged` | 已确认，待分配 |
| `status/in-progress` | 正在处理 |
| `status/resolved` | 已修复，开发者自测通过 |
| `status/ready-for-test` | 已移交待测试，开发者不可再修改 |
| `status/testing` | Tester 正在执行测试 |
| `status/verified` | 已验证通过 |
| `status/closed` | 已关闭 |

## 优先级标签

| 标签 | 定义 | 响应要求 |
|------|------|----------|
| P0 | 阻塞级：核心功能不可用或数据错误 | 立即修复，阻塞所有工作 |
| P1 | 严重级：功能异常但有临时绕过方案 | 当前迭代内修复 |
| P2 | 一般级：非核心功能异常或体验问题 | 排入后续迭代 |

## 创建时机

| 角色 | 时机 | 创建类型 |
|------|------|----------|
| Orchestrator | Gate 2 后，依据关键文档拆解 | Feature / Task / Epic |
| Tester | 测试发现缺陷（由 Orchestrator 代为创建） | Bug |
| 人类 | 验收发现、用户反馈 | Bug / Feature |
| Developer | 开发中发现问题 | Bug / Feature / Task |

## 验收发现→Issue 映射

Tester 完成验收后，Orchestrator 执行：
1. 每个独立问题创建一个 Bug Issue
2. 标题用 `BUG-NNN: 简短描述`（BUG-001, BUG-002...）
3. 验收报告中的 BUG-ID 在 Issue 正文引用
4. 设置 Issue Type 和优先级
5. 分配对应 Developer
