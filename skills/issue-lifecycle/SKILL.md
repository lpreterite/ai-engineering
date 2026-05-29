---
name: issue-lifecycle
description: "Issue 全生命周期管理——创建、状态转换、依赖管理、关闭归档。触发：创建 Issue、变更 Issue 状态、处理 Bug/Feature/Task/Decision、验收后发现缺陷、打磨阶段决策记录、Commit 提交时。"
---

# issue-lifecycle — Issue 全生命周期管理

Type: 3 (Automation & Orchestration) + 2 (Data & Information Management)

## 工作流

### 步骤 0：前置确认 [自由度：低]
- 确认当前阶段：打磨（Gate 1-2）或执行（Gate 3-4）
- 确认 Issue Type 归属：打磨族（Decision/Question/Risk/Review）或执行族（Bug/Feature/Task/Epic）
- → 此时加载 [references/polishing-phase.md](references/polishing-phase.md)
- → 此时加载 [references/execution-phase.md](references/execution-phase.md)

### 步骤 1：创建 Issue [自由度：低]
- 读取 `.github/ISSUE_TEMPLATE/{type}.yml` 解析字段定义
- 按 label/description/validations 构造 Markdown body
- 执行 `gh issue create --body-file` 或 `gh issue create --body`
- → 打磨阶段额外加载 [references/decision-protocol.md](references/decision-protocol.md)

### 步骤 2：推进生命周期 [自由度：低]
- 严格遵循各类型的状态转换规则（标签 `status/*` 驱动）
- 状态变更后看板自动同步
- → 此时加载 [references/project-board.md](references/project-board.md)

### 步骤 3：依赖与 Sub-issues [自由度：中]
- 复杂 Issue（>2天/3+子任务/跨角色）拆 Sub-issues
- 标记依赖关系（blocked by / blocks）
- P0 必须无阻塞依赖才能 in_progress
- 每日检查，超 24h 升级

### 步骤 4：打磨→执行转换 [自由度：低]
- Gate 2 后拆解依据是关键文档，非打磨工单
- 执行工单可引用 `Refs: #N` 作为背景
- → 此时加载 [references/groom-to-execute.md](references/groom-to-execute.md)

### 步骤 5：关闭归档 [自由度：低]
- 提交前核验验收标准：读取→核验→勾选→闭环
- Commit message 引用 Issue 编号，含关闭关键词
- → 此时加载 [references/commit-spec.md](references/commit-spec.md)

## 前置条件
- gh CLI 已安装并认证
- `.github/ISSUE_TEMPLATE/` 存在对应 YAML 模板
- 项目有 GitHub Projects 看板

## 完成标准
- Issue 在正确状态列，相关文档已更新
- Sub-issues 进度聚合正确（`3/5 completed`）
- STATUS.md 与 Issue 状态一致

## 回退路径
- 创建失败 → 检查模板格式/gh 认证 → 重试（最多 2 次）
- 标签变更失败 → `gh issue edit` 手动设置 → 重试
- 依赖循环 → 上报 Orchestrator 仲裁，不自行解决
