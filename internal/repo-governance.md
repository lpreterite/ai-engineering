# 仓库治理规则

> Repository Governance Rules

**所属目录**：`ai-engineering/internal/`
**文档状态**：草稿
**当前版本**：v0.1
**发布日期**：2026-05-24
**来源仓库**：`lpreterite/ai-engineering`
**源文件路径**：`internal/repo-governance.md`

---

## 1. 概述

本文档定义 **ai-engineering 主仓库**的 Issue、PR、分支、CI 管理规则。

与 `guide/issue-workflow.md` 的关系：guide 定义的是普适的 Issue 生命周期规范，本文档专注于本仓库特定的执行细则。

---

## 2. Issue 管理

### 2.1 Issue 类型

| 类型 | 标签 | 使用场景 |
|------|------|----------|
| Bug | `bug` | guide/ 或 agents/ 文档错误、引用断裂 |
| Feature | `enhancement` | 新增规范文件、升级协议 |
| Task | `task` | 重构、目录整理、版本发布 |
| Meta | `meta` | 治理规则本身、internal/ 相关 |

### 2.2 标签体系

| 类别 | 标签 | 说明 |
|------|------|------|
| 类型 | `bug` / `enhancement` / `task` / `meta` | Issue 分类 |
| 优先级 | `P0` / `P1` / `P2` | 紧急程度 |
| 状态 | `status/triaged` / `status/in-progress` / `status/resolved` / `status/verified` / `status/closed` | 生命周期阶段（与 guide/issue-workflow.md 一致） |

### 2.3 分配合规

- 默认由 Issue 创建者分配给 PM Agent
- PM Agent 在 24h 内完成 triage（确认类型、设置优先级、分配负责人）
- 复杂 Issue 拆分为 Sub-issues（条件：3+ 独立子任务或预估工时 > 2天）

---

## 3. PR 管理

### 3.1 审查 Checklist

每个 PR 必须通过以下检查才能合并：

```
□ 变更范围与 Issue 描述一致
□ guide/ 文件修改后交叉引用未断裂（grep 校验）
□ guide/ 文件 HEADER 版本号已更新
□ agents/ 修改后保持角色接口兼容
□ 新增文件已在 reference/directory.md 中注册
□ 修改 Internal 规范后已在 internal/README.md 中同步索引
```

### 3.2 合并策略

| 场景 | 策略 |
|------|------|
| feature → main | Squash merge，commit message 引用 Issue 编号 |
| fix → main | Squash merge |
| 多 commit 协作 | Rebase merge，保持线性历史 |

### 3.3 Commit 格式

与 `guide/issue-workflow.md` §9 一致：

```
<type>: <描述> (#<issue-num>)
```

---

## 4. 分支策略

```
main          ← 发布就绪，保护分支
  └─ feat/*   ← 新功能/改进
  └─ fix/*    ← Bug 修复
  └─ docs/*   ← 文档变更
```

- `main` 为保护分支，禁止直接推送
- 分支命名：`feat/release-json`、`fix/broken-link`、`docs/update-setup`

---

## 5. CI 要求

| 检查项 | 触发时机 | 要求 |
|--------|----------|------|
| 交叉引用检查 | PR 时 | 所有 guide/ 间引用路径有效 |
| HEADER 版本号格式 | PR 时 | 符合语义化版本号格式 |
| RELEASE.json 一致性 | 发版前 | 与 guide/ HEADER 版本号一致 |

---

## 6. internal/ 自举规则

修改 `internal/` 自身时：

1. 创建 Issue，类型标记为 `meta`
2. PR 需至少 1 人 Code Review
3. 修改后更新 `internal/README.md` 的索引
4. 如果影响了治理流程，同步更新相关引用

---

## 修订记录

| 版本 | 日期 | 修订内容 |
|------|------|----------|
| v0.1 | 2026-05-24 | 初始版本：Issue/PR/分支/CI/自举规则 |
