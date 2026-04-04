# OpenCode 安装指南

> Setup Guide for OpenCode

**所属目录**：`ai-engineering/setup/`
**文档状态**：草稿
**当前版本**：v0.2
**发布日期**：2026-04-04

---

## 1. 概述

本指南说明如何将 AI 软件研发工程体系的规范和 Agent 角色集成到 [OpenCode](https://opencode.ai) 中。

---

## 2. OpenCode 指令机制

| 特性 | 说明 |
|------|------|
| 指令文件 | `AGENTS.md` |
| 项目级位置 | `./AGENTS.md` |
| 全局级位置 | `~/.config/opencode/AGENTS.md` |
| 子目录指令 | 不支持自动发现 |
| 外部文件引用 | `opencode.json` instructions 字段 |
| Agent 定义（Markdown） | `.opencode/agents/*.md` |
| Agent 定义（JSON） | `opencode.json` agent 字段 |
| 多 Agent | 原生支持 |

---

## 3. 项目指令文件

在目标项目根目录创建 `AGENTS.md`：

```markdown
# 项目：{项目名称}

## AI 研发规范

遵循 AI 软件研发工程体系。

当需要时，读取以下规范文件作为强制指令：
- docs/ai-engineering/principles.md — 核心原则
- docs/ai-engineering/process.md — 研发流程
- docs/ai-engineering/collaboration.md — 协作协议
- docs/ai-engineering/checklists.md — 检查清单
- docs/ai-engineering/deliverables.md — 产出物要求
- docs/ai-engineering/document-management.md — 文档管理
```

---

## 4. 配置多 Agent（推荐）

OpenCode 原生支持多 Agent 配置。Agent 角色定义保留在 `ai-engineering/agents/` 目录中，不复制到目标项目，通过路径引用直接读取。

### 方式一：Markdown Agent 文件

在项目的 `.opencode/agents/` 目录创建角色文件，通过 `{file:...}` 引用 `agents/` 中的角色定义：

```bash
mkdir -p .opencode/agents
```

每个文件内容（以 PM Agent 为例）：

```markdown
---
description: PM Agent — 项目协调中枢，统筹进度、风险和团队协作
mode: subagent
model: anthropic/claude-sonnet-4-20250514
permission:
  edit: ask
  bash:
    "git status": allow
    "git log*": allow
    "*": ask
---

{file:../vendor/ai-engineering/agents/pm-agent.md}

## 补充规范

遵循以下研发规范：
- docs/ai-engineering/principles.md
- docs/ai-engineering/process.md
```

> `{file:...}` 路径取决于 ai-engineering 的部署位置。如用 Git Submodule 引入到 `vendor/ai-engineering/`，则写 `{file:../vendor/ai-engineering/agents/pm-agent.md}`。

目录结构：

```
.opencode/
└── agents/
    ├── pm.md              # PM Agent
    ├── po.md              # PO Agent
    ├── uiux.md            # UI/UX Agent
    ├── developer.md       # Developer Agent
    └── tester.md          # Tester Agent
```

### 方式二：opencode.json 配置

在项目根目录创建 `opencode.json`，直接引用 `agents/` 目录：

```json
{
  "$schema": "https://opencode.ai/config.json",
  "instructions": [
    "AGENTS.md",
    "docs/ai-engineering/principles.md",
    "docs/ai-engineering/process.md",
    "docs/ai-engineering/collaboration.md"
  ],
  "agent": {
    "pm": {
      "description": "PM Agent — 项目协调中枢",
      "mode": "subagent",
      "prompt": "{file:vendor/ai-engineering/agents/pm-agent.md}"
    },
    "po": {
      "description": "PO Agent — 需求分析与 PRD 起草",
      "mode": "subagent",
      "prompt": "{file:vendor/ai-engineering/agents/po-agent.md}"
    },
    "uiux": {
      "description": "UI/UX Agent — 用户方案设计",
      "mode": "subagent",
      "prompt": "{file:vendor/ai-engineering/agents/uiux-agent.md}"
    },
    "developer": {
      "description": "Developer Agent — 技术实施",
      "mode": "subagent",
      "prompt": "{file:vendor/ai-engineering/agents/developer-agent.md}"
    },
    "tester": {
      "description": "Tester Agent — 测试执行",
      "mode": "subagent",
      "prompt": "{file:vendor/ai-engineering/agents/tester-agent.md}"
    }
  }
}
```

> `{file:...}` 路径取决于 ai-engineering 的部署位置。示例中为 Git Submodule 方式。

---

## 5. 使用方式

```bash
# 通过 Tab 键切换到指定 Agent
# 或通过 @ 提及调用 subagent
@developer 实现用户登录功能
@po 起草 PRD 文档
@pm 检查项目状态
```

---

## 6. 完整部署流程

```
步骤 1：复制 guide/ 规则文件到 docs/ai-engineering/
步骤 2：将 ai-engineering 引入项目（Git Submodule / 本地路径）
步骤 3：创建 AGENTS.md 主指令文件
步骤 4：创建 opencode.json 或 .opencode/agents/ 配置文件，引用 agents/ 角色
步骤 5：验证 Agent 加载
```

---

## 7. 验证

安装完成后，在 OpenCode 中执行以下检查：

```
□ 确认 AGENTS.md 被正确加载
□ 提问 "当前项目的研发规范是什么？" 验证规范已生效
□ 通过 Tab 键确认 Agent 列表显示 5 个角色
□ 调用 @pm 检查项目状态，验证角色功能正常
```

---

## 附录：相关文档

| 文档 | 路径 |
|------|------|
| Agent 使用指南 | [../guide/08-tool-integration-guide.md](../guide/08-tool-integration-guide.md) |
| Agent 角色总览 | [../agents/README.md](../agents/README.md) |

---

## 修订记录

| 版本 | 日期 | 修订内容 |
|------|------|----------|
| v0.2 | 2026-04-04 | 修正 AGENTS.md 规范文件路径为 docs/ai-engineering/，修正交叉引用路径 |
| v0.1 | 2026-04-04 | 从 08 工具集成指南拆分，独立成文 |
