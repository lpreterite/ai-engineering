# OpenCode 安装指南

> Setup Guide for OpenCode

**所属目录**：`ai-engineering/setup/`
**文档状态**：草稿
**当前版本**：v0.4
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

每个文件使用 YAML frontmatter + 正文格式。通过 `name` 字段定义 Agent 显示名称，通过 `@名称` 调用。

以 PM 为例（`.opencode/agents/pm.md`）：

```markdown
---
name: PM 项目管理
description: PM 项目管理 — 项目协调中枢，统筹进度、风险和团队协作，驱动质量循环和交付
mode: subagent
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

**`.opencode/agents/pm.md`** — PM 项目管理

```markdown
---
name: PM 项目管理
description: PM 项目管理 — 项目协调中枢，统筹进度、风险和团队协作，驱动质量循环和交付
mode: subagent
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

**`.opencode/agents/po.md`** — PO 产品负责人

```markdown
---
name: PO 产品负责人
description: PO 产品负责人 — 需求分析、PRD 起草，从模糊诉求中提炼清晰可交付的需求
mode: subagent
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

**`.opencode/agents/uiux.md`** — UI/UX 用户体验设计

```markdown
---
name: UI/UX 用户体验设计
description: UI/UX 用户体验设计 — 用户方案设计，设计规范制定、设计稿和交互说明
mode: subagent
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

**`.opencode/agents/developer.md`** — Developer 开发工程师

```markdown
---
name: Developer 开发工程师
description: Developer 开发工程师 — 技术实施，将设计稿和需求转化为高质量代码
mode: subagent
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

**`.opencode/agents/tester.md`** — Tester 测试工程师

```markdown
---
name: Tester 测试工程师
description: Tester 测试工程师 — 测试执行，功能测试、回归测试和验收测试，证据驱动的质量验证
mode: subagent
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
    ├── pm.md              # PM 项目管理
    ├── po.md              # PO 产品负责人
    ├── uiux.md            # UI/UX 用户体验设计
    ├── developer.md       # Developer 开发工程师
    └── tester.md          # Tester 测试工程师
```

### 4.3 配置方式二：直接复制嵌入（无 Git Submodule）

如果目标项目**不使用 Git Submodule** 引入 `ai-engineering`，则需要将角色定义内容直接嵌入 agent 文件中。这种方式将完整角色定义写入 Markdown 正文，不使用 `{file:...}` 引用。

#### 文件格式

```markdown
---
name: <角色名称，如 PM 项目管理>
description: <角色描述>
mode: subagent
temperature: <值>
permission:
  edit: <值>
  bash:
    "<命令通配符>": allow
    "*": ask
  webfetch: <值>
steps: <值>
color: "<#hex>"
---

<完整角色定义内容，从 agents/ 源文件复制>
```

#### 五个角色的 Frontmatter 配置摘要

| 角色 | 文件名 | temperature | edit | webfetch | steps | color |
|------|--------|-------------|------|----------|-------|-------|
| PM 项目管理 | `pm.md` | 0.3 | ask | deny | 20 | `#4A90D9` |
| PO 产品负责人 | `po.md` | 0.4 | ask | allow | 15 | `#7B68EE` |
| UI/UX 用户体验设计 | `uiux.md` | 0.5 | ask | allow | 15 | `#E67E22` |
| Developer 开发工程师 | `developer.md` | 0.2 | allow | allow | 30 | `#2ECC71` |
| Tester 测试工程师 | `tester.md` | 0.1 | ask | deny | 20 | `#E74C3C` |

#### 注意事项

- **必须包含 frontmatter**：OpenCode 通过 `---` 分隔的 YAML 块识别 agent 配置。没有 frontmatter 的 Markdown 文件不会被识别为 agent。
- **name 为必填**：通过 `name` 字段定义 Agent 显示名称（如 `PM 项目管理`），用于 `@PM 项目管理` 调用。
- **description 为必填**：这是决定 agent 何时被自动委派的关键字段。
- **不要使用 `{file:...}` 引用**：直接复制模式下，完整角色定义内容写在 frontmatter 下方的正文中。

### 4.4 配置方式三：opencode.json

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
      "name": "PM 项目管理",
      "description": "PM 项目管理 — 项目协调中枢，统筹进度、风险和团队协作，驱动质量循环和交付",
      "mode": "subagent",
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
      "name": "PO 产品负责人",
      "description": "PO 产品负责人 — 需求分析、PRD 起草，从模糊诉求中提炼清晰可交付的需求",
      "mode": "subagent",
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
      "name": "UI/UX 用户体验设计",
      "description": "UI/UX 用户体验设计 — 用户方案设计，设计规范制定、设计稿和交互说明",
      "mode": "subagent",
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
      "name": "Developer 开发工程师",
      "description": "Developer 开发工程师 — 技术实施，将设计稿和需求转化为高质量代码",
      "mode": "subagent",
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
      "name": "Tester 测试工程师",
      "description": "Tester 测试工程师 — 测试执行，功能测试、回归测试和验收测试，证据驱动的质量验证",
      "mode": "subagent",
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

### 4.5 一键搬运脚本

以下脚本将 `ai-engineering/agents/` 中的角色定义文件搬运到目标项目的 `.opencode/agents/` 目录，自动添加符合 OpenCode 官方规范的 YAML frontmatter：

```bash
#!/bin/bash
# deploy-agents.sh — 将 AI 研发体系 Agent 角色部署到目标项目
# 用法: ./deploy-agents.sh <目标项目路径> [ai-engineering路径]
#
# 示例:
#   ./deploy-agents.sh /path/to/my-project
#   ./deploy-agents.sh /path/to/my-project /path/to/ai-engineering

set -euo pipefail

TARGET="${1:?用法: $0 <目标项目路径> [ai-engineering路径]}"
AI_ENG="${2:-$(cd "$(dirname "$0")/.." && pwd)}"
AGENTS_SRC="$AI_ENG/agents"
AGENTS_DST="$TARGET/.opencode/agents"

# 检查源目录
if [ ! -d "$AGENTS_SRC" ]; then
  echo "❌ 错误: agents 目录不存在: $AGENTS_SRC"
  exit 1
fi

# 创建目标目录
mkdir -p "$AGENTS_DST"

# 角色 → (源文件, 目标文件, description, temperature, edit, webfetch, steps, color)
# bash 权限统一为: "*": ask（可按需修改）

deploy_agent() {
  local src="$1" dst="$2" agent_name="$3" desc="$4" temp="$5" perm_edit="$6" perm_webfetch="$7" steps="$8" color="$9"

  if [ ! -f "$src" ]; then
    echo "⚠️  跳过: $src (文件不存在)"
    return
  fi

  cat > "$dst" << FRONTMATTER
---
name: $agent_name
description: $desc
mode: subagent
temperature: $temp
permission:
  edit: $perm_edit
  bash:
    "*": ask
  webfetch: $perm_webfetch
steps: $steps
color: "$color"
---

FRONTMATTER

  # 追加角色定义正文
  cat "$src" >> "$dst"
  echo "✅ 已生成: $dst"
}

deploy_agent "$AGENTS_SRC/pm-agent.md"       "$AGENTS_DST/pm.md"       \
  "PM 项目管理" \
  "PM 项目管理 — 项目协调中枢，统筹进度、风险和团队协作，驱动质量循环和交付" \
  "0.3" "ask" "deny" "20" "#4A90D9"

deploy_agent "$AGENTS_SRC/po-agent.md"       "$AGENTS_DST/po.md"       \
  "PO 产品负责人" \
  "PO 产品负责人 — 需求分析、PRD 起草，从模糊诉求中提炼清晰可交付的需求" \
  "0.4" "ask" "allow" "15" "#7B68EE"

deploy_agent "$AGENTS_SRC/uiux-agent.md"     "$AGENTS_DST/uiux.md"     \
  "UI/UX 用户体验设计" \
  "UI/UX 用户体验设计 — 用户方案设计，设计规范制定、设计稿和交互说明" \
  "0.5" "ask" "allow" "15" "#E67E22"

deploy_agent "$AGENTS_SRC/developer-agent.md" "$AGENTS_DST/developer.md" \
  "Developer 开发工程师" \
  "Developer 开发工程师 — 技术实施，将设计稿和需求转化为高质量代码" \
  "0.2" "allow" "allow" "30" "#2ECC71"

deploy_agent "$AGENTS_SRC/tester-agent.md"   "$AGENTS_DST/tester.md"   \
  "Tester 测试工程师" \
  "Tester 测试工程师 — 测试执行，功能测试、回归测试和验收测试，证据驱动的质量验证" \
  "0.1" "ask" "deny" "20" "#E74C3C"

echo ""
echo "🎉 部署完成！共生成 5 个 Agent 文件到 $AGENTS_DST"
echo "   在 OpenCode 中通过 @PM\\ 项目管理 @PO\\ 产品负责人 @UI/UX\\ 用户体验设计 @Developer\\ 开发工程师 @Tester\\ 测试工程师 调用"
```

> **提示**：脚本中 `bash` 权限默认统一为 `"*": ask`。实际使用时可按角色需要修改——例如 Developer Agent 通常需要 `npm test*`、`npm run build*` 等命令的 `allow` 权限。

---

## 5. 使用方式

```bash
# 通过 Tab 键切换到指定 Agent
# 或通过 @ 提及调用 subagent
@Developer 开发工程师 实现用户登录功能
@PO 产品负责人 起草 PRD 文档
@PM 项目管理 检查项目状态
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
| v0.4 | 2026-04-05 | 新增 4.3 直接复制嵌入方式、4.5 一键搬运脚本；补充 frontmatter 注意事项和角色配置摘要表 |
| v0.3 | 2026-04-05 | 新增 Agent 文件生成指南，基于官方规范补充完整字段说明、权限配置和五个角色完整示例 |
| v0.2 | 2026-04-04 | 修正 AGENTS.md 规范文件路径为 docs/ai-engineering/，修正交叉引用路径 |
| v0.1 | 2026-04-04 | 从 08 工具集成指南拆分，独立成文 |
