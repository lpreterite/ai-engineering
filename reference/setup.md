# Agent 部署指南

> Agent Setup Guide (Executable)

**文档状态**：已发布
**当前版本**：v0.1
**发布日期**：2026-04-04

---

## 1. 概述

本文件是 AI 软件研发工程体系的 **Agent 执行入口**。目标项目的 Agent 读取本文件后，按照步骤将研发规范和角色定义部署到目标项目中。

---

## 2. 部署步骤

### 步骤 1：部署研发规范文件

将以下 6 个规则文件从 `reference/` 复制到目标项目的 `docs/` 根目录：

| 源文件（ai-engineering/reference/） | 目标位置（target-project/docs/） | 必选 |
|--------------------------------------|-----------------------------------|------|
| `principles.md` | `docs/principles.md` | 是 |
| `process.md` | `docs/process.md` | 是 |
| `collaboration.md` | `docs/collaboration.md` | 是 |
| `checklists.md` | `docs/checklists.md` | 否 |
| `deliverables.md` | `docs/deliverables.md` | 否 |
| `document-management.md` | `docs/document-management.md` | 否 |

```bash
cp reference/principles.md          {target}/docs/principles.md
cp reference/process.md             {target}/docs/process.md
cp reference/collaboration.md       {target}/docs/collaboration.md
cp reference/checklists.md          {target}/docs/checklists.md
cp reference/deliverables.md        {target}/docs/deliverables.md
cp reference/document-management.md {target}/docs/document-management.md
```

> 最小部署：至少复制前 3 个文件即可启用基本协作规范。

### 步骤 2：部署 Agent 角色文件

将 5 个角色定义文件复制到目标项目的 `docs/agents/` 目录：

| 源文件（ai-engineering/agents/） | 目标位置（target-project/docs/agents/） |
|----------------------------------|------------------------------------------|
| `pm-agent.md` | `docs/agents/pm-agent.md` |
| `po-agent.md` | `docs/agents/po-agent.md` |
| `uiux-agent.md` | `docs/agents/uiux-agent.md` |
| `developer-agent.md` | `docs/agents/developer-agent.md` |
| `tester-agent.md` | `docs/agents/tester-agent.md` |

```bash
mkdir -p {target}/docs/agents
cp agents/pm-agent.md       {target}/docs/agents/pm-agent.md
cp agents/po-agent.md       {target}/docs/agents/po-agent.md
cp agents/uiux-agent.md     {target}/docs/agents/uiux-agent.md
cp agents/developer-agent.md {target}/docs/agents/developer-agent.md
cp agents/tester-agent.md   {target}/docs/agents/tester-agent.md
```

### 步骤 3：初始化 docs/ 目录结构

按照 `guide/07-repo-directory-guide.md` 创建完整的项目文档目录：

```
docs/
├── README.md                      # 项目文档索引
├── STATUS.md                      # 项目状态卡
├── principles.md                  # ← 已部署
├── process.md                     # ← 已部署
├── collaboration.md               # ← 已部署
├── checklists.md                  # ← 已部署
├── deliverables.md                # ← 已部署
├── document-management.md         # ← 已部署
├── agents/                        # ← 已部署
│   ├── pm-agent.md
│   ├── po-agent.md
│   ├── uiux-agent.md
│   ├── developer-agent.md
│   └── tester-agent.md
├── product/                       # 需求文档（按需创建）
├── engineering/                   # 工程文档（按需创建）
├── design/                        # 设计文档（按需创建）
├── project-management/            # 项目管理（按需创建）
└── project-tasks/                 # 任务跟踪（按需创建）
```

### 步骤 4：配置 AI 编程工具

根据目标项目使用的工具，选择对应的配置方式：

#### Claude Code

在项目根目录创建 `CLAUDE.md`：

```markdown
# 项目：{项目名称}

## AI 研发规范

遵循 AI 软件研发工程体系，加载以下规范：

@docs/principles.md
@docs/process.md
@docs/collaboration.md

## 角色定义

当用户指定角色时，以此身份工作：

- "作为 PM Agent" → 加载 @docs/agents/pm-agent.md
- "作为 PO Agent" → 加载 @docs/agents/po-agent.md
- "作为 UI/UX Agent" → 加载 @docs/agents/uiux-agent.md
- "作为 Developer Agent" → 加载 @docs/agents/developer-agent.md
- "作为 Tester Agent" → 加载 @docs/agents/tester-agent.md

## 项目特定规则

- 技术栈：{填写}
- 测试命令：{填写}
- 构建命令：{填写}
```

#### OpenCode

**方式一：Markdown Agent 文件**

将 `docs/agents/` 中的角色文件复制到 `.opencode/agents/`，每个文件顶部添加 YAML frontmatter：

```markdown
---
description: PM Agent — 项目协调中枢
mode: subagent
---

{角色文件内容}
```

**方式二：opencode.json**

```json
{
  "$schema": "https://opencode.ai/config.json",
  "instructions": ["AGENTS.md", "docs/principles.md", "docs/process.md", "docs/collaboration.md"],
  "agent": {
    "pm": { "description": "PM Agent", "mode": "subagent", "prompt": "{file:docs/agents/pm-agent.md}" },
    "po": { "description": "PO Agent", "mode": "subagent", "prompt": "{file:docs/agents/po-agent.md}" },
    "uiux": { "description": "UI/UX Agent", "mode": "subagent", "prompt": "{file:docs/agents/uiux-agent.md}" },
    "developer": { "description": "Developer Agent", "mode": "subagent", "prompt": "{file:docs/agents/developer-agent.md}" },
    "tester": { "description": "Tester Agent", "mode": "subagent", "prompt": "{file:docs/agents/tester-agent.md}" }
  }
}
```

#### Codex CLI

在 `.codex/config.toml` 中配置 subagent，将角色文件内容内联到 `developer_instructions` 字段：

```toml
[agents.pm]
name = "pm"
description = "PM Agent — 项目协调中枢"
developer_instructions = """
{pm-agent.md 的内容}
"""
```

> Codex CLI 不支持文件引用，需要将角色定义内容直接粘贴到配置文件中。

### 步骤 5：验证部署

```
□ docs/ 目录包含至少 3 个规则文件（principles、process、collaboration）
□ docs/agents/ 目录包含 5 个角色文件
□ docs/STATUS.md 已写入初始内容
□ docs/README.md 已写入文档索引
□ AI 工具的指令文件（CLAUDE.md / AGENTS.md）已创建
□ 指令文件正确引用了 docs/ 下的规范文件
□ 指令文件正确引用了 docs/agents/ 下的角色文件
```

---

## 3. 规范库引用方式

将本规范库引入目标项目有多种方式：

| 方式 | 操作 | 适用场景 |
|------|------|----------|
| **手动复制** | 从 reference/ 和 agents/ 复制文件 | 简单项目、一次性部署 |
| **Git Submodule** | `git submodule add https://github.com/lpreterite/ai-engineering.git` | 团队协作、版本锁定 |
| **本地路径** | 使用相对路径指向本规范库目录 | 个人开发、快速集成 |

---

## 修订记录

| 版本 | 日期 | 修订内容 |
|------|------|----------|
| v0.1 | 2026-04-04 | 初始版本，Agent 可执行入口文件 |
