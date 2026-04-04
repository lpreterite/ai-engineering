# Agent 使用指南

> Agent Usage Guide for Target Projects

**所属目录**：`ai-engineering/guide/`
**文档状态**：草稿
**当前版本**：v0.2
**发布日期**：2026-04-04

---

## 1. 概述

本指南面向目标项目的 Agent，说明如何在项目中接入 AI 软件研发工程体系。

接入分两步：

```
步骤 1：部署研发规范 → 将 reference/ 规则文件复制到目标项目 docs/ 目录
步骤 2：安装 Agent 角色 → 将 agents/ 角色文件配置到 AI 编程工具
```

---

## 2. 步骤 1：部署研发规范

将 `reference/` 目录中的 6 个规则文件复制到目标项目的 `docs/` 根目录：

```bash
# 从本规范库复制到目标项目
cp reference/principles.md          {target-project}/docs/principles.md
cp reference/process.md             {target-project}/docs/process.md
cp reference/collaboration.md       {target-project}/docs/collaboration.md
cp reference/checklists.md          {target-project}/docs/checklists.md
cp reference/deliverables.md        {target-project}/docs/deliverables.md
cp reference/document-management.md {target-project}/docs/document-management.md
```

部署后的目标项目结构：

```
target-project/
└── docs/
    ├── principles.md          # 核心原则（必选）
    ├── process.md             # 研发流程（必选）
    ├── collaboration.md       # 协作协议（必选）
    ├── checklists.md          # 检查清单（可选）
    ├── deliverables.md        # 产出物要求（可选）
    ├── document-management.md # 文档管理（可选）
    └── ...
```

> **最小部署**：至少复制前 3 个文件（principles、process、collaboration）即可启用基本协作规范。

同时按照 `guide/07-repo-directory-guide.md` 初始化其他 `docs/` 子目录。

---

## 3. 步骤 2：安装 Agent 角色

将 5 个 Agent 角色定义安装到目标项目使用的 AI 编程工具中。

### 角色清单

| 角色 | 文件 | 说明 |
|------|------|------|
| PM Agent | `agents/pm-agent.md` | 项目协调中枢 |
| PO Agent | `agents/po-agent.md` | 需求分析、PRD 起草 |
| UI/UX Agent | `agents/uiux-agent.md` | 用户方案设计 |
| Developer Agent | `agents/developer-agent.md` | 技术实施 |
| Tester Agent | `agents/tester-agent.md` | 测试执行 |

### 安装方式（按工具选择）

根据目标项目使用的 AI 编程工具，参照对应的安装指南：

| 工具 | 安装指南 |
|------|----------|
| Claude Code | [setup/claude-code.md](../setup/claude-code.md) |
| OpenCode | [setup/opencode.md](../setup/opencode.md) |
| Codex CLI | [setup/codex.md](../setup/codex.md) |

---

## 4. 集成检查清单

完成部署后，确认以下事项：

```
□ docs/ 目录已创建并包含规则文件（至少 principles、process、collaboration）
□ docs/STATUS.md 已写入初始内容
□ docs/README.md 已写入文档索引
□ 已按 07-repo-directory-guide.md 初始化 docs/ 子目录
□ 已选择目标 AI 编程工具并按对应 setup/ 指南完成配置
□ 已配置至少 1 个 Agent 角色
□ 已验证指令文件被正确加载
```

---

## 5. 常见问题

### Q：三种工具能否同时使用？

可以。`AGENTS.md` 和 `CLAUDE.md` 可以共存于同一项目。OpenCode 和 Codex 读取 `AGENTS.md`；Claude Code 读取 `CLAUDE.md`。

### Q：规范库更新后如何同步？

- **手动复制**：重新从 `reference/` 复制更新后的文件到 `docs/`
- **Git Submodule**：`git submodule update --remote` 同步后重新复制
- **脚本自动化**：可编写部署脚本自动同步

### Q：如何为不同项目定制？

在指令文件（`CLAUDE.md` / `AGENTS.md`）中添加项目特定规则，这些规则优先于通用规范。例如：

```markdown
## 项目特定规则

- Developer Agent 在本项目额外负责 DevOps
- 跳过 Gate 2（本项目无设计阶段）
- 测试框架：Vitest（非默认 Jest）
```

---

## 附录：相关文档

| 文档 | 路径 |
|------|------|
| Repo 目录初始化指南 | [./07-repo-directory-guide.md](./07-repo-directory-guide.md) |
| Agent 角色总览 | [../agents/README.md](../agents/README.md) |
| Claude Code 安装指南 | [../setup/claude-code.md](../setup/claude-code.md) |
| OpenCode 安装指南 | [../setup/opencode.md](../setup/opencode.md) |
| Codex CLI 安装指南 | [../setup/codex.md](../setup/codex.md) |

---

## 修订记录

| 版本 | 日期 | 修订内容 |
|------|------|----------|
| v0.2 | 2026-04-04 | 重写：定位为目标项目 Agent 使用指南，工具配置拆分到 setup/ |
| v0.1 | 2026-04-04 | 初始版本 |
