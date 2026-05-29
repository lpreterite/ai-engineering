---
name: developer-tester-loop
version: v1.0
description: "Developer→Tester 移交循环——代码完成后移交测试、隔离测试执行、Bug 报告与回归验证。触发：Developer 任务完成设 resolved、Tester 接收 testing、测试发现 Bug、修复后回归验证、代码审查通过需移交测试时。"
---

# developer-tester-loop — Developer→Tester 移交循环

Type: 3 (Automation & Orchestration)

## 工作流

### 步骤 0：前置确认 [自由度：低]
- Developer 自测通过后，Issue 状态为 `status/resolved`
- 确认验收标准完整、自测证据就绪
- Tester 未查看 Developer 代码/测试（隔离上下文）

### 步骤 1：移交 [自由度：低]
- Orchestrator 将 Issue 从 `resolved` 设为 `ready-for-test`
- 标记后 Developer **不可再修改**相关代码
- 移交包含：Issue 编号 + 验收标准 + 自测结果摘要
- → 此时加载 [references/handoff-flow.md](references/handoff-flow.md)

### 步骤 2：测试执行 [自由度：中]
- Tester 在隔离上下文中独立设计测试用例
- 不依赖 Developer 的测试代码
- 对照验收标准逐项验证
- 执行集成测试/E2E 测试/回归测试
- → 此时加载 [references/isolation-rules.md](references/isolation-rules.md)

### 步骤 3：结果判定 [自由度：低]
- **通过**：Issue 状态设为 `verified`，通知 Orchestrator 关闭
- **不通过**：创建 Bug Issue（BUG-NNN），Issue 回到 `in_progress`
- 每个独立问题创建一个 Bug，不可合并

### 步骤 4：回归验证 [自由度：低]
- Developer 修复后，重复步骤 1-3
- 回归测试需覆盖原 Bug 场景 + 关联功能
- 最多 3 次迭代，超过后升级人类

## 前置条件
- Developer 已自测通过
- Tester 拥有独立测试环境
- .github/ISSUE_TEMPLATE/1-bug.yml 存在

## 完成标准
- Issue 标记为 `verified` 或创建了对应 Bug Issue
- 验收报告记录测试结果和证据
- 回归测试无新问题

## 回退路径
- Tester 环境不可用 → 通知 Orchestrator 协调 → 降级人工验证
- 分歧（Developer vs Tester 对 Bug 判定不一致）→ Orchestrator 仲裁
- 3 次迭代未通过 → 升级人类决策
