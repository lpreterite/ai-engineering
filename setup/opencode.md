# OpenCode 安装指南

> Setup Guide for OpenCode

**所属目录**：`ai-engineering/setup/`
**文档状态**：草稿
**当前版本**：v0.3
**发布日期**：2026-04-05

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
| 多 Agent | 原生支持（primary / subagent） |

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

## 4. Agent 文件生成指南

OpenCode 原生支持多 Agent。Agent 角色定义保留在 `ai-engineering/agents/` 目录中，不复制到目标项目，通过路径引用直接读取。

### 4.1 官方规范字段

基于 [OpenCode Agents 官方文档](https://opencode.ai/docs/agents/)，Agent 配置支持以下字段：

| 字段 | 必填 | 说明 |
|------|------|------|
| `description` | **是** | Agent 功能描述，决定何时调用此 Agent |
| `mode` | 否 | `primary`（Tab 切换）、`subagent`（@ 提及 / 自动委派）、`all`（默认） |
| `prompt` | 否 | 系统提示词，支持 `{file:路径}` 引用外部文件 |
| `model` | 否 | 覆盖模型，格式为 `provider/model-id` |
| `permission` | 否 | 工具权限，替代已废弃的 `tools` 字段 |
| `temperature` | 否 | 0.0-1.0，控制随机性 |
| `steps` | 否 | 最大 agentic 迭代次数 |
| `top_p` | 否 | 0.0-1.0，控制多样性 |
| `hidden` | 否 | 隐藏 subagent（仅 Task 工具可调用） |
| `color` | 否 | UI 显示颜色 |
| `disable` | 否 | 禁用 Agent |

**权限配置**（`permission` 字段）：

| 工具 | 可选值 | 说明 |
|------|--------|------|
| `edit` | `ask` / `allow` / `deny` | 文件编辑权限 |
| `bash` | 字符串值或 glob 规则映射 | Bash 命令权限，支持通配符 |
| `webfetch` | `ask` / `allow` / `deny` | 网页抓取权限 |
| `task` | glob 规则映射 | 控制 subagent 可调用哪些其他 subagent |

> **重要**：`tools` 字段已废弃，请使用 `permission` 字段。

### 4.2 配置方式一：Markdown Agent 文件（推荐）

在项目的 `.opencode/agents/` 目录创建角色文件：

```bash
mkdir -p .opencode/agents
```

每个文件使用 YAML frontmatter + 正文格式。Agent 名称取自文件名（如 `pm.md` → `pm`）。

以 PM Agent 为例（`.opencode/agents/pm.md`）：

```markdown
---
description: PM Agent — 项目协调中枢，统筹进度、风险和团队协作，驱动质量循环和交付
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.3
permission:
  edit: ask
  bash:
    "git status *": allow
    "git log*": allow
    "*": ask
  webfetch: deny
  task:
    "*": allow
steps: 20
color: "#4A90D9"
---

{file:vendor/ai-engineering/agents/pm-agent.md}

## 补充规范

遵循以下研发规范（按需引用）：
- docs/ai-engineering/principles.md
- docs/ai-engineering/process.md
- docs/ai-engineering/collaboration.md
```

> `{file:...}` 路径相对于配置文件所在位置。如用 Git Submodule 引入到 `vendor/ai-engineering/`，则写 `{file:vendor/ai-engineering/agents/pm-agent.md}`。

#### 五个角色的完整配置

**`.opencode/agents/pm.md`** — PM Agent

```markdown
---
description: PM Agent — 项目协调中枢，统筹进度、风险和团队协作，驱动质量循环和交付
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.3
permission:
  edit: ask
  bash:
    "git status *": allow
    "git log*": allow
    "git diff*": allow
    "*": ask
  webfetch: deny
steps: 20
color: "#4A90D9"
---

{file:vendor/ai-engineering/agents/pm-agent.md}
```

**`.opencode/agents/po.md`** — PO Agent

```markdown
---
description: PO Agent — 需求分析、PRD 起草，从模糊诉求中提炼清晰可交付的需求
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.4
permission:
  edit: ask
  bash:
    "git diff*": allow
    "*": ask
  webfetch: allow
steps: 15
color: "#7B68EE"
---

{file:vendor/ai-engineering/agents/po-agent.md}
```

**`.opencode/agents/uiux.md`** — UI/UX Agent

```markdown
---
description: UI/UX Agent — 用户方案设计，设计规范制定、设计稿和交互说明
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.5
permission:
  edit: ask
  bash:
    "*": ask
  webfetch: allow
steps: 15
color: "#E67E22"
---

{file:vendor/ai-engineering/agents/uiux-agent.md}
```

**`.opencode/agents/developer.md`** — Developer Agent

```markdown
---
description: Developer Agent — 技术实施，将设计稿和需求转化为高质量代码
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.2
permission:
  edit: allow
  bash:
    "npm test*": allow
    "npm run lint*": allow
    "npm run build*": allow
    "npm run typecheck*": allow
    "git status *": allow
    "git diff*": allow
    "*": ask
  webfetch: allow
steps: 30
color: "#2ECC71"
---

{file:vendor/ai-engineering/agents/developer-agent.md}
```

**`.opencode/agents/tester.md`** — Tester Agent

```markdown
---
description: Tester Agent — 测试执行，功能测试、回归测试和验收测试，证据驱动的质量验证
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.1
permission:
  edit: ask
  bash:
    "npm test*": allow
    "npm run test*": allow
    "npm run lint*": allow
    "git diff*": allow
    "*": ask
  webfetch: deny
steps: 20
color: "#E74C3C"
---

{file:vendor/ai-engineering/agents/tester-agent.md}
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

### 4.3 配置方式二：opencode.json

在项目根目录创建 `opencode.json`：

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
      "description": "PM Agent — 项目协调中枢，统筹进度、风险和团队协作，驱动质量循环和交付",
      "mode": "subagent",
      "model": "anthropic/claude-sonnet-4-20250514",
      "temperature": 0.3,
      "prompt": "{file:vendor/ai-engineering/agents/pm-agent.md}",
      "permission": {
        "edit": "ask",
        "bash": {
          "git status *": "allow",
          "git log*": "allow",
          "*": "ask"
        }
      },
      "steps": 20,
      "color": "#4A90D9"
    },
    "po": {
      "description": "PO Agent — 需求分析、PRD 起草，从模糊诉求中提炼清晰可交付的需求",
      "mode": "subagent",
      "model": "anthropic/claude-sonnet-4-20250514",
      "temperature": 0.4,
      "prompt": "{file:vendor/ai-engineering/agents/po-agent.md}",
      "permission": {
        "edit": "ask",
        "webfetch": "allow"
      },
      "steps": 15,
      "color": "#7B68EE"
    },
    "uiux": {
      "description": "UI/UX Agent — 用户方案设计，设计规范制定、设计稿和交互说明",
      "mode": "subagent",
      "model": "anthropic/claude-sonnet-4-20250514",
      "temperature": 0.5,
      "prompt": "{file:vendor/ai-engineering/agents/uiux-agent.md}",
      "permission": {
        "edit": "ask",
        "webfetch": "allow"
      },
      "steps": 15,
      "color": "#E67E22"
    },
    "developer": {
      "description": "Developer Agent — 技术实施，将设计稿和需求转化为高质量代码",
      "mode": "subagent",
      "model": "anthropic/claude-sonnet-4-20250514",
      "temperature": 0.2,
      "prompt": "{file:vendor/ai-engineering/agents/developer-agent.md}",
      "permission": {
        "edit": "allow",
        "bash": {
          "npm test*": "allow",
          "npm run lint*": "allow",
          "npm run build*": "allow",
          "*": "ask"
        },
        "webfetch": "allow"
      },
      "steps": 30,
      "color": "#2ECC71"
    },
    "tester": {
      "description": "Tester Agent — 测试执行，功能测试、回归测试和验收测试，证据驱动的质量验证",
      "mode": "subagent",
      "model": "anthropic/claude-sonnet-4-20250514",
      "temperature": 0.1,
      "prompt": "{file:vendor/ai-engineering/agents/tester-agent.md}",
      "permission": {
        "edit": "ask",
        "bash": {
          "npm test*": "allow",
          "npm run test*": "allow",
          "*": "ask"
        }
      },
      "steps": 20,
      "color": "#E74C3C"
    }
  }
}
```

> `{file:...}` 路径相对于 `opencode.json` 所在位置。示例中为 Git Submodule 方式。

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
| v0.3 | 2026-04-05 | 新增 Agent 文件生成指南，基于官方规范补充完整字段说明、权限配置和五个角色完整示例 |
| v0.2 | 2026-04-04 | 修正 AGENTS.md 规范文件路径为 docs/ai-engineering/，修正交叉引用路径 |
| v0.1 | 2026-04-04 | 从 08 工具集成指南拆分，独立成文 |
