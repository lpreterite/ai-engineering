# Agent 部署指南

> Agent Setup Guide (Executable)

**文档状态**：已发布
**当前版本**：v0.2
**发布日期**：2026-04-04

---

## 1. 概述

本文件是 AI 软件研发工程体系的 **Agent 执行入口**。目标项目的 Agent 读取本文件后，按照步骤将研发规范部署到目标项目，并配置 AI 工具引用角色定义。

---

## 2. 部署步骤

### 步骤 1：部署研发规范文件

将 `guide/` 目录中的 6 个规范文件复制到目标项目的 `docs/ai-engineering/` 目录：

| 源文件（ai-engineering/guide/） | 目标位置（target-project/docs/ai-engineering/） | 必选 |
|----------------------------------|--------------------------------------------------|------|
| `01-principles.md` | `docs/ai-engineering/principles.md` | 是 |
| `02-process.md` | `docs/ai-engineering/process.md` | 是 |
| `03-collaboration.md` | `docs/ai-engineering/collaboration.md` | 是 |
| `04-checklists.md` | `docs/ai-engineering/checklists.md` | 否 |
| `05-deliverables.md` | `docs/ai-engineering/deliverables.md` | 否 |
| `06-document-management.md` | `docs/ai-engineering/document-management.md` | 否 |

```bash
mkdir -p docs/ai-engineering
cp guide/01-principles.md          docs/ai-engineering/principles.md
cp guide/02-process.md             docs/ai-engineering/process.md
cp guide/03-collaboration.md       docs/ai-engineering/collaboration.md
cp guide/04-checklists.md          docs/ai-engineering/checklists.md
cp guide/05-deliverables.md        docs/ai-engineering/deliverables.md
cp guide/06-document-management.md docs/ai-engineering/document-management.md
```

> 最小部署：至少复制前 3 个文件即可启用基本协作规范。

### 步骤 2：配置 AI 编程工具

根据目标项目使用的 AI 编程工具，阅读对应的安装指南完成配置：

| 工具 | 安装指南 | 说明 |
|------|----------|------|
| Claude Code | [setup/claude-code.md](./setup/claude-code.md) | `CLAUDE.md` + `@path` 引用角色 |
| OpenCode | [setup/opencode.md](./setup/opencode.md) | `opencode.json` 或 `.opencode/agents/` |
| Codex CLI | [setup/codex.md](./setup/codex.md) | `.codex/config.toml` subagent 配置 |

> Agent 角色文件 **不需要复制到目标项目**。AI 工具通过路径引用直接读取本规范库 `agents/` 目录中的角色定义。详见各工具的安装指南。

### 步骤 3：初始化 docs/ 目录结构

按照 `guide/07-repo-directory-guide.md` 创建完整的项目文档目录：

```
docs/
├── README.md                      # 项目文档索引
├── STATUS.md                      # 项目状态卡
│
├── ai-engineering/                # ← 已部署（AI 研发规范）
│   ├── principles.md
│   ├── process.md
│   ├── collaboration.md
│   ├── checklists.md
│   ├── deliverables.md
│   └── document-management.md
│
├── product/                       # 需求文档（按需创建）
├── engineering/                   # 工程文档（按需创建）
├── design/                        # 设计文档（按需创建）
├── project-management/            # 项目管理（按需创建）
└── project-tasks/                 # 任务跟踪（按需创建）
```

### 步骤 4：验证部署

```
□ docs/ai-engineering/ 目录包含至少 3 个规则文件（principles、process、collaboration）
□ docs/STATUS.md 已写入初始内容
□ docs/README.md 已写入文档索引
□ AI 工具的指令文件（CLAUDE.md / AGENTS.md / config.toml）已创建
□ AI 工具能正确引用 agents/ 目录中的角色文件
```

---

## 3. 规范库引用方式

将本规范库引入目标项目有多种方式：

| 方式 | 操作 | 适用场景 |
|------|------|----------|
| **手动复制** | 从 guide/ 复制到 docs/ai-engineering/ | 简单项目、一次性部署 |
| **Git Submodule** | `git submodule add https://github.com/lpreterite/ai-engineering.git vendor/ai-engineering` | 团队协作、版本锁定 |
| **本地路径** | 使用相对路径指向本规范库目录 | 个人开发、快速集成 |

---

## 修订记录

| 版本 | 日期 | 修订内容 |
|------|------|----------|
| v0.3 | 2026-04-04 | Agent 角色不再复制到目标项目，改为通过 setup/ 指南由 AI 工具按需引用 |
| v0.2 | 2026-04-04 | 部署目标改为 docs/ai-engineering/ 子目录 |
| v0.1 | 2026-04-04 | 初始版本，Agent 可执行入口文件 |
