# OpenCode 安装指南

> Setup Guide for OpenCode

**所属目录**：`ai-engineering/setup/`
**文档状态**：草稿
**当前版本**：v0.1
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
- docs/principles.md — 核心原则
- docs/process.md — 研发流程
- docs/collaboration.md — 协作协议
- docs/checklists.md — 检查清单
- docs/deliverables.md — 产出物要求
- docs/document-management.md — 文档管理
```

---

## 4. 配置多 Agent（推荐）

OpenCode 原生支持多 Agent 配置。将本体系的 5 个角色定义为独立 Agent。

### 方式一：Markdown Agent 文件

将 `agents/` 目录中的角色文件复制到项目的 `.opencode/agents/` 目录：

```bash
# 复制角色文件
cp agents/pm-agent.md       .opencode/agents/pm.md
cp agents/po-agent.md       .opencode/agents/po.md
cp agents/uiux-agent.md     .opencode/agents/uiux.md
cp agents/developer-agent.md .opencode/agents/developer.md
cp agents/tester-agent.md   .opencode/agents/tester.md
```

每个文件顶部添加 YAML frontmatter：

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

{pm-agent.md 的完整内容}

## 补充规范

遵循以下研发规范：
- docs/principles.md
- docs/process.md
```

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

在项目根目录创建 `opencode.json`：

```json
{
  "$schema": "https://opencode.ai/config.json",
  "instructions": [
    "AGENTS.md",
    "docs/principles.md",
    "docs/process.md",
    "docs/collaboration.md"
  ],
  "agent": {
    "pm": {
      "description": "PM Agent — 项目协调中枢",
      "mode": "subagent",
      "prompt": "{file:docs/agents/pm-agent.md}"
    },
    "po": {
      "description": "PO Agent — 需求分析与 PRD 起草",
      "mode": "subagent",
      "prompt": "{file:docs/agents/po-agent.md}"
    },
    "uiux": {
      "description": "UI/UX Agent — 用户方案设计",
      "mode": "subagent",
      "prompt": "{file:docs/agents/uiux-agent.md}"
    },
    "developer": {
      "description": "Developer Agent — 技术实施",
      "mode": "subagent",
      "prompt": "{file:docs/agents/developer-agent.md}"
    },
    "tester": {
      "description": "Tester Agent — 测试执行",
      "mode": "subagent",
      "prompt": "{file:docs/agents/tester-agent.md}"
    }
  }
}
```

> 注意：`prompt` 字段中的 `{file:...}` 路径需要指向实际部署的角色文件位置。可以将角色文件复制到 `docs/agents/` 子目录中。

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
步骤 1：复制 reference/ 规则文件到 docs/        ← 见 08 使用指南
步骤 2：复制 agents/ 角色文件到 docs/agents/ 或 .opencode/agents/
步骤 3：创建 AGENTS.md 主指令文件
步骤 4：创建 opencode.json 配置文件（如用方式二）
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
| Agent 使用指南 | [../08-tool-integration-guide.md](../08-tool-integration-guide.md) |
| Agent 角色总览 | [../../agents/README.md](../../agents/README.md) |

---

## 修订记录

| 版本 | 日期 | 修订内容 |
|------|------|----------|
| v0.1 | 2026-04-04 | 从 08 工具集成指南拆分，独立成文 |
