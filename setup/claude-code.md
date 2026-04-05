# Claude Code 安装指南

> Setup Guide for Claude Code

**所属目录**：`ai-engineering/setup/`
**文档状态**：草稿
**当前版本**：v0.3
**发布日期**：2026-04-05

---

## 1. 概述

本指南说明如何将 AI 软件研发工程体系的规范和 Agent 角色集成到 [Claude Code](https://docs.anthropic.com/en/docs/claude-code) 中。

---

## 2. Claude Code 指令机制

| 特性 | 说明 |
|------|------|
| 指令文件 | `CLAUDE.md` |
| 项目级位置 | `./CLAUDE.md` 或 `.claude/CLAUDE.md` |
| 全局级位置 | `~/.claude/CLAUDE.md` |
| 子目录指令 | 支持（子目录 `CLAUDE.md`） |
| 外部文件引用 | `@path/to/file` 语法 |
| 规则目录 | `.claude/rules/*.md` |
| Subagent 文件 | `.claude/agents/*.md` |

---

## 3. 项目指令文件

在目标项目根目录创建 `CLAUDE.md`，导入研发规范：

```markdown
# 项目：{项目名称}

## AI 研发规范

遵循 AI 软件研发工程体系，加载以下规范：

@docs/ai-engineering/principles.md
@docs/ai-engineering/process.md
@docs/ai-engineering/collaboration.md

## 项目特定规则

- 技术栈：{填写}
- 测试命令：{填写}
- 构建命令：{填写}
```

### 3.1 规范文件引用路径

根据部署方式选择引用路径：

**方式 A：规范文件已复制到 `docs/ai-engineering/`（推荐）**

```markdown
@docs/ai-engineering/principles.md
@docs/ai-engineering/process.md
@docs/ai-engineering/collaboration.md
```

**方式 B：通过 Git Submodule 引用**

```bash
git submodule add https://github.com/lpreterite/ai-engineering.git vendor/ai-engineering
```

```markdown
@vendor/ai-engineering/guide/01-principles.md
@vendor/ai-engineering/guide/02-process.md
@vendor/ai-engineering/guide/03-collaboration.md
```

---

## 4. Subagent 文件生成指南

Claude Code 原生支持自定义 subagent。Agent 角色定义保留在 `ai-engineering/agents/` 目录中，不复制到目标项目。

### 4.1 官方规范字段

基于 [Claude Code Subagents 官方文档](https://docs.anthropic.com/en/docs/claude-code/sub-agents)，subagent 文件使用 YAML frontmatter + Markdown 正文格式。

**文件存放位置（优先级从高到低）**：

| 位置 | 范围 | 优先级 |
|------|------|--------|
| Managed settings | 组织级 | 1（最高） |
| `--agents` CLI 参数 | 当前会话 | 2 |
| `.claude/agents/*.md` | 当前项目 | 3 |
| `~/.claude/agents/*.md` | 所有项目 | 4 |
| 插件 `agents/` | 插件启用时 | 5（最低） |

**Frontmatter 字段**：

| 字段 | 必填 | 说明 |
|------|------|------|
| `name` | **是** | 唯一标识符，小写字母 + 连字符 |
| `description` | **是** | 描述何时应委派给此 subagent |
| `tools` | 否 | 工具白名单：Read, Write, Edit, Bash, Grep, Glob, Agent(类型) |
| `disallowedTools` | 否 | 工具黑名单 |
| `model` | 否 | `sonnet`, `opus`, `haiku`, 完整模型 ID, 或 `inherit` |
| `permissionMode` | 否 | `default`, `acceptEdits`, `auto`, `dontAsk`, `bypassPermissions`, `plan` |
| `maxTurns` | 否 | 最大 agentic 轮次 |
| `skills` | 否 | 预加载到上下文的 skills |
| `mcpServers` | 否 | 作用于此 subagent 的 MCP 服务器 |
| `hooks` | 否 | 生命周期钩子（PreToolUse, PostToolUse, Stop） |
| `memory` | 否 | 持久化记忆：`user`, `project`, `local` |
| `background` | 否 | 后台运行 |
| `effort` | 否 | `low`, `medium`, `high`, `max` |
| `isolation` | 否 | `worktree` 独立仓库副本 |
| `color` | 否 | 显示颜色 |
| `initialPrompt` | 否 | 自动提交的首条 prompt |

> **重要限制**：subagent 不能嵌套调用其他 subagent。

### 4.2 创建 Subagent 文件

在项目的 `.claude/agents/` 目录创建角色文件：

```bash
mkdir -p .claude/agents
```

文件名即 agent 名称（如 `pm.md` → `pm`）。frontmatter 定义配置，正文为系统提示词。

#### 五个角色的完整配置

**`.claude/agents/pm.md`** — PM Agent

```markdown
---
name: pm
description: PM Agent — 项目协调中枢，统筹进度、风险和团队协作，驱动质量循环和交付。当需要项目协调、进度跟踪、风险管控或流程引导时使用
tools: Read, Write, Edit, Bash, Grep, Glob
model: inherit
maxTurns: 30
color: blue
permissionMode: default
---

@vendor/ai-engineering/agents/pm-agent.md

## 补充规范

遵循以下研发规范（按需引用）：
- @docs/ai-engineering/principles.md
- @docs/ai-engineering/process.md
- @docs/ai-engineering/collaboration.md
```

**`.claude/agents/po.md`** — PO Agent

```markdown
---
name: po
description: PO Agent — 需求分析、PRD 起草，从模糊诉求中提炼清晰可交付的需求。当需要分析需求、起草 PRD、用户调研时使用
tools: Read, Write, Edit, Bash, Grep, Glob
model: inherit
maxTurns: 25
color: purple
---

@vendor/ai-engineering/agents/po-agent.md
```

**`.claude/agents/uiux.md`** — UI/UX Agent

```markdown
---
name: uiux
description: UI/UX Agent — 用户方案设计，设计规范制定、设计稿和交互说明。当需要设计界面、制定设计规范或交互说明时使用
tools: Read, Write, Edit, Bash, Grep, Glob
model: inherit
maxTurns: 25
color: orange
---

@vendor/ai-engineering/agents/uiux-agent.md
```

**`.claude/agents/developer.md`** — Developer Agent

```markdown
---
name: developer
description: Developer Agent — 技术实施，将设计稿和需求转化为高质量代码。当需要编写代码、修复 Bug、技术重构时使用
tools: Read, Write, Edit, Bash, Grep, Glob
model: inherit
maxTurns: 40
color: green
permissionMode: acceptEdits
---

@vendor/ai-engineering/agents/developer-agent.md
```

**`.claude/agents/tester.md`** — Tester Agent

```markdown
---
name: tester
description: Tester Agent — 测试执行，功能测试、回归测试和验收测试，证据驱动的质量验证。当需要编写测试、执行测试、验证质量时使用
tools: Read, Write, Edit, Bash, Grep, Glob
model: inherit
maxTurns: 30
color: red
---

@vendor/ai-engineering/agents/tester-agent.md
```

> `@path` 引用路径取决于 ai-engineering 的部署位置。示例中为 Git Submodule 方式。

目录结构：

```
.claude/
├── CLAUDE.md              # 主指令
├── agents/
│   ├── pm.md              # PM Agent
│   ├── po.md              # PO Agent
│   ├── uiux.md            # UI/UX Agent
│   ├── developer.md       # Developer Agent
│   └── tester.md          # Tester Agent
└── rules/                 # 规则文件（可选）
```

### 4.3 使用方式

```bash
# @ 提及调用 subagent
@"pm (agent)" 检查项目状态
@"developer (agent)" 实现用户登录功能
@"po (agent)" 起草 PRD 文档

# 或用自然语言
Use the developer agent to implement user login
Have the tester agent run the test suite
```

也可以通过 CLI 启动指定 agent 作为主会话：

```bash
claude --agent developer
```

---

## 5. 完整部署流程

```
步骤 1：复制 guide/ 规则文件到 docs/ai-engineering/
步骤 2：将 ai-engineering 引入项目（Git Submodule / 本地路径）
步骤 3：创建 CLAUDE.md 主指令文件
步骤 4：创建 .claude/agents/ subagent 文件，通过 @path 引用 agents/ 角色
步骤 5：验证 Agent 加载
```

---

## 6. 验证

安装完成后，在 Claude Code 中执行以下检查：

```
□ 运行 /agents 确认 subagent 列表显示 5 个角色
□ 运行 /init 确认 CLAUDE.md 被正确加载
□ 提问 "当前项目的研发规范是什么？" 验证规范已生效
□ @提及 @"pm (agent)" 检查项目状态，验证角色加载
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
| v0.3 | 2026-04-05 | 新增 Subagent 文件生成指南，基于官方规范补充完整字段说明和五个角色配置示例；更新为原生 subagent 支持 |
| v0.2 | 2026-04-04 | 修正规则 frontmatter 字段名，补充完整示例部署方式说明，修正交叉引用路径 |
| v0.1 | 2026-04-04 | 从 08 工具集成指南拆分，独立成文 |
