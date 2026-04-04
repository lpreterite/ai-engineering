# Agent 工具集成指南

> Agent Tool Integration Guide

**所属目录**：`ai-engineering/guide/`
**文档状态**：草稿
**当前版本**：v0.1
**发布日期**：2026-04-04

---

## 1. 概述

本文档说明如何将 AI 软件研发工程体系中的 Agent 角色定义和研发规范导入主流 AI 编程工具，使 Agent 在实际项目中遵循统一的协作规范。

### 1.1 适用工具

| 工具 | 说明 |
|------|------|
| Claude Code | Anthropic 的终端 AI 编程助手 |
| OpenCode | 开源终端 AI 编程助手 |
| Codex CLI | OpenAI 的终端 AI 编程助手 |

### 1.2 集成目标

```
ai-engineering/              ← 本规范库（共享）
│
└── target-project/          ← 目标项目
    ├── AGENTS.md / CLAUDE.md  ← 加载角色和规范指令
    └── docs/                  ← 项目文档（按 07 规范初始化）
```

---

## 2. 集成方式总览

三种工具的指令加载机制对比：

| 特性 | Claude Code | OpenCode | Codex CLI |
|------|-------------|----------|-----------|
| 指令文件 | `CLAUDE.md` | `AGENTS.md` | `AGENTS.md` |
| 项目级位置 | `./CLAUDE.md` 或 `.claude/CLAUDE.md` | `./AGENTS.md` | `./AGENTS.md` |
| 全局级位置 | `~/.claude/CLAUDE.md` | `~/.config/opencode/AGENTS.md` | `~/.codex/AGENTS.md` |
| 子目录指令 | 支持（子目录 `CLAUDE.md`） | 不支持自动发现 | 支持（嵌套 `AGENTS.md`） |
| 外部文件引用 | `@path/to/file` 语法 | `opencode.json` instructions 字段 | 自动发现子目录 |
| 规则目录 | `.claude/rules/*.md` | `.opencode/agents/*.md` | `.codex/` 目录 |
| Agent 定义 | 无内建多 Agent | `.opencode/agents/*.md` | `.codex/config.toml` |

---

## 3. Claude Code 集成

### 3.1 项目指令文件

在目标项目根目录创建 `CLAUDE.md`，导入本规范库内容：

```markdown
# 项目：{项目名称}

## AI 研发规范

遵循 AI 软件研发工程体系，加载以下规范：

@{ai-engineering-path}/guide/01-principles.md
@{ai-engineering-path}/guide/02-process.md
@{ai-engineering-path}/guide/03-collaboration.md
@{ai-engineering-path}/guide/04-checklists.md
@{ai-engineering-path}/guide/05-deliverables.md
@{ai-engineering-path}/guide/06-document-management.md
```

将 `{ai-engineering-path}` 替换为规范库的实际路径（相对或绝对路径均可）。

### 3.2 按角色加载

Claude Code 不支持内建多 Agent 切换，但可通过子目录指令或 `.claude/rules/` 实现角色聚焦：

**方案 A：使用 `.claude/rules/` 按文件类型触发**

```
.claude/
├── CLAUDE.md              # 主指令（包含通用规范）
└── rules/
    ├── pm-rules.md        # PM Agent 相关规则
    ├── po-rules.md        # PO Agent 相关规则
    └── dev-rules.md       # Developer Agent 相关规则
```

**方案 B：手动切换角色提示**

在 `CLAUDE.md` 中定义角色切换指令：

```markdown
## 角色切换

当用户指定角色时，加载对应的角色定义文件并以此身份工作：

- "作为 PM Agent" → 加载 @{ai-engineering-path}/agents/pm-agent.md
- "作为 PO Agent" → 加载 @{ai-engineering-path}/agents/po-agent.md
- "作为 UI/UX Agent" → 加载 @{ai-engineering-path}/agents/uiux-agent.md
- "作为 Developer Agent" → 加载 @{ai-engineering-path}/agents/developer-agent.md
- "作为 Tester Agent" → 加载 @{ai-engineering-path}/agents/tester-agent.md
```

### 3.3 示例：完整 CLAUDE.md

```markdown
# 项目：MyApp

## 研发规范

本遵循 AI 软件研发工程体系。

@../ai-engineering/guide/01-principles.md
@../ai-engineering/guide/02-process.md
@../ai-engineering/guide/03-collaboration.md

## 角色定义

- 作为 PM Agent 时：@../ai-engineering/agents/pm-agent.md
- 作为 Developer Agent 时：@../ai-engineering/agents/developer-agent.md

## 项目特定规则

- 技术栈：React + TypeScript + Node.js
- 测试命令：npm test
- 构建命令：npm run build
```

---

## 4. OpenCode 集成

### 4.1 项目指令文件

在目标项目根目录创建 `AGENTS.md`：

```markdown
# 项目：{项目名称}

## AI 研发规范

本遵循 AI 软件研发工程体系。

当需要时，读取以下规范文件作为强制指令：
- {ai-engineering-path}/guide/01-principles.md — 核心原则
- {ai-engineering-path}/guide/02-process.md — 研发流程
- {ai-engineering-path}/guide/03-collaboration.md — 协作协议
- {ai-engineering-path}/guide/04-checklists.md — 检查清单
- {ai-engineering-path}/guide/05-deliverables.md — 产出物要求
- {ai-engineering-path}/guide/06-document-management.md — 文档管理
```

### 4.2 配置多 Agent（推荐）

OpenCode 原生支持多 Agent 配置。将本体系的 5 个角色定义为独立 Agent：

**方式一：Markdown Agent 文件**

在项目 `.opencode/agents/` 目录创建各角色文件：

```
.opencode/
└── agents/
    ├── pm.md              # PM Agent
    ├── po.md              # PO Agent
    ├── uiux.md            # UI/UX Agent
    ├── developer.md       # Developer Agent
    └── tester.md          # Tester Agent
```

每个文件内容格式：

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

{将 agents/pm-agent.md 的完整内容粘贴于此}

## 补充规范

遵循以下研发规范：
- {ai-engineering-path}/guide/01-principles.md
- {ai-engineering-path}/guide/02-process.md
```

**方式二：opencode.json 配置**

```json
{
  "$schema": "https://opencode.ai/config.json",
  "instructions": [
    "AGENTS.md",
    "../ai-engineering/guide/01-principles.md",
    "../ai-engineering/guide/02-process.md",
    "../ai-engineering/guide/03-collaboration.md"
  ],
  "agent": {
    "pm": {
      "description": "PM Agent — 项目协调中枢",
      "mode": "subagent",
      "prompt": "{file:../ai-engineering/agents/pm-agent.md}"
    },
    "po": {
      "description": "PO Agent — 需求分析与 PRD 起草",
      "mode": "subagent",
      "prompt": "{file:../ai-engineering/agents/po-agent.md}"
    },
    "uiux": {
      "description": "UI/UX Agent — 用户方案设计",
      "mode": "subagent",
      "prompt": "{file:../ai-engineering/agents/uiux-agent.md}"
    },
    "developer": {
      "description": "Developer Agent — 技术实施",
      "mode": "subagent",
      "prompt": "{file:../ai-engineering/agents/developer-agent.md}"
    },
    "tester": {
      "description": "Tester Agent — 测试执行",
      "mode": "subagent",
      "prompt": "{file:../ai-engineering/agents/tester-agent.md}"
    }
  }
}
```

### 4.3 使用方式

```bash
# 通过 Tab 键切换到指定 Agent
# 或通过 @ 提及调用 subagent
@developer 实现用户登录功能
@po 起草 PRD 文档
@pm 检查项目状态
```

---

## 5. Codex CLI 集成

### 5.1 项目指令文件

在目标项目根目录创建 `AGENTS.md`：

```markdown
# 项目：{项目名称}

## AI 研发规范

本遵循 AI 软件研发工程体系。

核心规范位于：
- {ai-engineering-path}/guide/ — 研发流程规范（01-06）
- {ai-engineering-path}/agents/ — Agent 角色定义

## 角色定义

当需要特定角色能力时，参照以下文件：
- PM Agent：{ai-engineering-path}/agents/pm-agent.md
- PO Agent：{ai-engineering-path}/agents/po-agent.md
- UI/UX Agent：{ai-engineering-path}/agents/uiux-agent.md
- Developer Agent：{ai-engineering-path}/agents/developer-agent.md
- Tester Agent：{ai-engineering-path}/agents/tester-agent.md
```

### 5.2 Subagent 配置

Codex CLI 支持在 `.codex/config.toml` 中配置 subagent：

```toml
[agents.pm]
name = "pm"
description = "PM Agent — 项目协调中枢，统筹进度与协作"
developer_instructions = """
{pm-agent.md 的核心内容}

遵循研发规范，参照 guide/01-principles.md 和 guide/02-process.md。
"""

[agents.po]
name = "po"
description = "PO Agent — 需求分析与 PRD 起草"
developer_instructions = """
{po-agent.md 的核心内容}
"""

[agents.developer]
name = "developer"
description = "Developer Agent — 技术实施"
developer_instructions = """
{developer-agent.md 的核心内容}
"""

[agents.tester]
name = "tester"
description = "Tester Agent — 测试执行"
developer_instructions = """
{tester-agent.md 的核心内容}
"""
```

### 5.3 全局配置

将通用工作协议写入 `~/.codex/AGENTS.md`，所有项目自动继承：

```markdown
# 工作协议

- 提交前运行测试
- 遵循项目的 AGENTS.md 指令
- 使用约定式提交信息
```

---

## 6. 通用集成策略

### 6.1 规范库引用方式

无论使用哪种工具，推荐以下策略来引用 `ai-engineering` 规范库：

| 策略 | 方式 | 适用场景 |
|------|------|----------|
| **Git Submodule** | `git submodule add` 引入规范库 | 团队协作、版本锁定 |
| **相对路径引用** | 使用相对路径指向本地规范库目录 | 个人开发、快速集成 |
| **内联复制** | 将规范内容直接写入目标项目 | 简单项目、定制需求 |
| **远程 URL** | 通过 URL 加载原始文件 | OpenCode instructions |

**Git Submodule 示例：**

```bash
# 在目标项目中添加规范库为 submodule
git submodule add https://github.com/lpreterite/ai-engineering.git docs/ai-engineering

# CLAUDE.md 或 AGENTS.md 中引用
# @docs/ai-engineering/guide/01-principles.md
```

### 6.2 最小集成方案

如果只需快速启用基本协作规范，最小配置只需在项目根目录创建指令文件并引入 3 个核心规范：

```
必选：
├── 01-principles.md       # 核心原则（人机分工）
├── 02-process.md          # 研发流程（阶段门控）
└── 03-collaboration.md    # 协作协议（沟通规则）

可选：
├── 04-checklists.md       # 检查清单
├── 05-deliverables.md     # 产出物要求
└── 06-document-management.md  # 文档管理
```

### 6.3 集成检查清单

```
□ 已选择目标 AI 编程工具
□ 已在项目根目录创建指令文件（CLAUDE.md / AGENTS.md）
□ 已引入核心规范（至少 01-03）
□ 已按需配置 Agent 角色定义
□ 已验证指令文件被正确加载（/init 或 /memory 确认）
□ 已按照 07-repo-directory-guide.md 初始化 docs/ 目录
```

---

## 7. 常见问题

### Q：三种工具能否同时使用？

可以。`AGENTS.md` 和 `CLAUDE.md` 可以共存于同一项目。OpenCode 会优先读取 `AGENTS.md`；Claude Code 只读取 `CLAUDE.md`（但可 `@AGENTS.md` 导入）。Codex CLI 只读取 `AGENTS.md`。

### Q：规范库更新后如何同步？

- **Git Submodule**：`git submodule update --remote`
- **相对路径引用**：自动同步（共享同一文件系统）
- **内联复制**：需手动重新复制

### Q：如何为不同项目定制角色？

在 `AGENTS.md` / `CLAUDE.md` 中添加项目特定规则，这些规则优先于通用角色定义。例如：

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
| AI 软件研发原理 | [./01-principles.md](./01-principles.md) |
| AI 软件研发流程 | [./02-process.md](./02-process.md) |
| 人机协作协议 | [./03-collaboration.md](./03-collaboration.md) |
| Repo 目录初始化指南 | [./07-repo-directory-guide.md](./07-repo-directory-guide.md) |
| Agent 角色总览 | [../agents/README.md](../agents/README.md) |

---

## 修订记录

| 版本 | 日期 | 修订内容 |
|------|------|----------|
| v0.1 | 2026-04-04 | 初始版本 |
