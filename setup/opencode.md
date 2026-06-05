# OpenCode 安装指南

> Setup Guide for OpenCode

**所属目录**：`ai-engineering/setup/`
**文档状态**：草稿
**当前版本**：v0.6
**发布日期**：2026-05-27

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

在目标项目根目录创建 `AGENTS.md`，可直接使用模板文件：

```bash
cp vendor/ai-engineering/reference/templates/AGENTS.md.example ./AGENTS.md
```

AGENTS.md 定义编排中枢的身份、Gate 流程框架、核心规则、Sub-agent 调度表和规范文档索引。详见 `reference/templates/AGENTS.md.example`。

如需定制，修改 `{项目名称}` 占位符即可。

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

以 Orchestrator 为例（`.opencode/agents/orchestrator.md`）：

```markdown
---
name: Orchestrator 编排
description: Orchestrator 编排 — 多智能体编排中枢，驱动编排流程、路由任务、门控质量、引导用户
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

{file:vendor/ai-engineering/agents/orchestrator-agent.md}

## 补充规范

遵循以下研发规范（按需引用）：
- docs/ai-engineering/principles.md
- docs/ai-engineering/process.md
- docs/ai-engineering/collaboration.md
```

> `{file:...}` 路径相对于配置文件所在位置。如用 Git Submodule 引入到 `vendor/ai-engineering/`，则写 `{file:vendor/ai-engineering/agents/orchestrator-agent.md}`。

#### 五个角色的完整配置

**`.opencode/agents/orchestrator.md`** — 编排

```markdown
---
name: Orchestrator 编排
description: Orchestrator 编排 — 多智能体编排中枢，驱动编排流程、路由任务、门控质量、引导用户
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

{file:vendor/ai-engineering/agents/orchestrator-agent.md}
```

**`.opencode/agents/po.md`** — 产品经理

```markdown
---
name: PO 产品经理
description: PO 产品经理 — 需求分析、PRD 起草，从模糊诉求中提炼清晰可交付的需求
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

**`.opencode/agents/uiux.md`** — UI/UX 设计师

```markdown
---
name: UI/UX 设计师
description: UI/UX 设计师 — 用户方案设计，设计规范制定、设计稿和交互说明
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

**`.opencode/agents/developer.md`** — 开发工程师

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

{file:vendor/ai-engineering/agents/fullstack-developer.md}
```

**`.opencode/agents/tester.md`** — 测试工程师

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
    ├── orchestrator.md    # 编排
    ├── po.md              # 产品经理
    ├── uiux.md            # UI/UX 设计师
    ├── developer.md       # 开发工程师
    └── tester.md          # 测试工程师
```

### 4.3 配置方式二：直接复制嵌入（无 Git Submodule）

如果目标项目**不使用 Git Submodule** 引入 `ai-engineering`，则需要将角色定义内容直接嵌入 agent 文件中。这种方式将完整角色定义写入 Markdown 正文，不使用 `{file:...}` 引用。

#### 文件格式

```markdown
---
name: <角色名称，如 项目经理>
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
| 编排 | `orchestrator.md` | 0.3 | ask | deny | 20 | `#4A90D9` |
| 产品经理 | `po.md` | 0.4 | ask | allow | 15 | `#7B68EE` |
| UI/UX 设计师 | `uiux.md` | 0.5 | ask | allow | 15 | `#E67E22` |
| 开发工程师 | `developer.md` | 0.2 | allow | allow | 30 | `#2ECC71` |
| 测试工程师 | `tester.md` | 0.1 | ask | deny | 20 | `#E74C3C` |

#### 注意事项

- **必须包含 frontmatter**：OpenCode 通过 `---` 分隔的 YAML 块识别 agent 配置。没有 frontmatter 的 Markdown 文件不会被识别为 agent。
- **name 为必填**：通过 `name` 字段定义 Agent 显示名称（如 `项目经理`），用于 `@项目经理` 调用。
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
    "orchestrator": {
      "name": "Orchestrator 编排",
      "description": "Orchestrator 编排 — 多智能体编排中枢，驱动编排流程、路由任务、门控质量、引导用户",
      "mode": "subagent",
      "temperature": 0.3,
      "prompt": "{file:vendor/ai-engineering/agents/orchestrator-agent.md}",
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
      "name": "PO 产品经理",
      "description": "PO 产品经理 — 需求分析、PRD 起草，从模糊诉求中提炼清晰可交付的需求",
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
      "name": "UI/UX 设计师",
      "description": "UI/UX 设计师 — 用户方案设计，设计规范制定、设计稿和交互说明",
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
      "name": "Full-stack Developer Agent",
      "description": "Full-stack Developer Agent — 全栈技术实施，覆盖前端、后端、数据库与 DevOps",
      "mode": "subagent",
      "temperature": 0.2,
      "prompt": "{file:vendor/ai-engineering/agents/fullstack-developer.md}",
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

以下脚本提供两种模式：

- **首次部署**：将 `agents/` 角色定义搬运到 `.opencode/agents/`，生成 YAML frontmatter
- **增量更新**（`--update`）：保留自定义 frontmatter，仅替换角色定义正文

```bash
#!/bin/bash
# deploy-agents.sh — 部署/更新 AI 研发体系 Agent 角色到目标项目
# 用法:
#   首次部署: ./deploy-agents.sh <目标项目路径> [ai-engineering路径]
#   增量更新: ./deploy-agents.sh --update <目标项目路径> [ai-engineering路径]
#
# 示例:
#   ./deploy-agents.sh /path/to/my-project
#   ./deploy-agents.sh --update /path/to/my-project /path/to/ai-engineering

set -euo pipefail

MODE="${1:-}"
if [ "$MODE" = "--update" ]; then
  UPDATE=true
  TARGET="${2:?用法: $0 --update <目标项目路径> [ai-engineering路径]}"
  AI_ENG="${3:-$(cd "$(dirname "$0")/.." && pwd)}"
else
  UPDATE=false
  TARGET="${1:?用法: $0 <目标项目路径> [ai-engineering路径]}"
  AI_ENG="${2:-$(cd "$(dirname "$0")/.." && pwd)}"
fi

AGENTS_SRC="$AI_ENG/agents"
AGENTS_DST="$TARGET/.opencode/agents"
CHANGED=0

# 检查源目录
if [ ! -d "$AGENTS_SRC" ]; then
  echo "❌ 错误: agents 目录不存在: $AGENTS_SRC"
  exit 1
fi

# 角色 → (源文件, 目标文件, description, temperature, edit, webfetch, steps, color)
# bash 权限统一为: "*": ask（可按需修改）

deploy_agent() {
  local src="$1" dst="$2" agent_name="$3" desc="$4" temp="$5" perm_edit="$6" perm_webfetch="$7" steps="$8" color="$9"

  if [ ! -f "$src" ]; then
    echo "⚠️  跳过: $src (文件不存在)"
    return
  fi

  if [ "$UPDATE" = true ] && [ -f "$dst" ]; then
    # 更新模式：保留现有 frontmatter，仅替换正文
    local tmpfile=$(mktemp)
    # 提取现有 frontmatter（--- ... ---）
    awk '/^---$/ { if (seen) exit; seen=1; next } seen && /^---$/ { exit } seen' "$dst" > "$tmpfile"
    if [ -s "$tmpfile" ]; then
      # 有现有 frontmatter，保留它
      { cat "$tmpfile"; echo "---"; echo ""; cat "$src"; } > "${dst}.new"
    else
      # 无 frontmatter 或格式异常，回退到默认
      cat > "${dst}.new" << FRONTMATTER
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
      cat "$src" >> "${dst}.new"
    fi
    rm -f "$tmpfile"

    # 检查是否有实际变化
    if diff -q "$dst" "${dst}.new" > /dev/null 2>&1; then
      rm -f "${dst}.new"
      echo "⏭️  无变化: $dst"
    else
      mv "${dst}.new" "$dst"
      CHANGED=$((CHANGED + 1))
      echo "🔄 已更新: $dst"
    fi
  else
    # 首次部署
    mkdir -p "$(dirname "$dst")"
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
    cat "$src" >> "$dst"
    CHANGED=$((CHANGED + 1))
    echo "✅ 已生成: $dst"
  fi
}

deploy_agent "$AGENTS_SRC/orchestrator-agent.md" "$AGENTS_DST/orchestrator.md" \
  "Orchestrator 编排" \
  "Orchestrator 编排 — 多智能体编排中枢，驱动编排流程、路由任务、门控质量、引导用户" \
  "0.3" "ask" "deny" "20" "#4A90D9"

deploy_agent "$AGENTS_SRC/po-agent.md"       "$AGENTS_DST/po.md"       \
  "PO 产品经理" \
  "PO 产品经理 — 需求分析、PRD 起草，从模糊诉求中提炼清晰可交付的需求" \
  "0.4" "ask" "allow" "15" "#7B68EE"

deploy_agent "$AGENTS_SRC/uiux-agent.md"     "$AGENTS_DST/uiux.md"     \
  "UI/UX 设计师" \
  "UI/UX 设计师 — 用户方案设计，设计规范制定、设计稿和交互说明" \
  "0.5" "ask" "allow" "15" "#E67E22"

deploy_agent "$AGENTS_SRC/fullstack-developer.md" "$AGENTS_DST/developer.md" \
  "Full-stack Developer Agent" \
  "Full-stack Developer Agent — 全栈技术实施，覆盖前端、后端、数据库与 DevOps" \
  "0.2" "allow" "allow" "30" "#2ECC71"

deploy_agent "$AGENTS_SRC/tester-agent.md"   "$AGENTS_DST/tester.md"   \
  "Tester 测试工程师" \
  "Tester 测试工程师 — 测试执行，功能测试、回归测试和验收测试，证据驱动的质量验证" \
  "0.1" "ask" "deny" "20" "#E74C3C"

echo ""
if [ "$UPDATE" = true ]; then
  echo "🎉 更新完成！$CHANGED 个 Agent 文件已更新到 $AGENTS_DST"
  if [ "$CHANGED" -gt 0 ]; then
    echo "⚠️  请退出当前 OpenCode 会话后重新调用 @agent 名称 以加载新定义"
  fi
else
  echo "🎉 部署完成！共生成 5 个 Agent 文件到 $AGENTS_DST"
  echo "   在 OpenCode 中通过 @Orchestrator\\ 编排 @PO\\ 产品经理 @UI/UX\\ 设计师 @Full-stack Developer Agent @Tester\\ 测试工程师 调用"
fi
```

> **提示**：脚本中 `bash` 权限默认统一为 `"*": ask`。实际使用时可按角色需要修改——例如 Full-stack Developer Agent 通常需要 `npm test*`、`npm run build*` 等命令的 `allow` 权限。`--update` 模式会保留你对 frontmatter 的自定义修改，仅替换 `---` 下方的角色定义正文。

---

### 4.6 更新 Subagent

当源仓库 `agents/` 目录的角色文件发布新版本时，按以下步骤更新：

#### 方式一：直接嵌入（使用 deploy-agents.sh）

```bash
# 更新所有 agent 文件（保留自定义 frontmatter）
./deploy-agents.sh --update /path/to/my-project /path/to/ai-engineering
```

脚本会：
1. 读取现有的 `.opencode/agents/*.md` frontmatter（保留你的权限、温度等自定义配置）
2. 对比源文件判断是否有变化
3. 仅替换角色定义正文（`---` 下方内容）
4. 提示退出会话重新加载

#### 方式二：{file:...} 引用（推荐）

如果使用 Git Submodule 且 agent 配置为 `{file:vendor/ai-engineering/agents/xxx-agent.md}`：

```bash
# 更新子模块
git submodule update --remote vendor/ai-engineering
# 重新初始化 Agent：退出当前会话后重新调用 @agent 名称
```

agent 文件不复制到目标项目，更新子模块后**无需文件操作**。但 `{file:...}` 引用是懒加载的，需要**退出当前 OpenCode 会话**后重新进入才能看到新内容。

#### 版本跟踪

建议同时在 `MANIFEST.json` 中记录 agent 版本（参见 [setup.md](../setup.md) 的「步骤 3b」），以便未来版本比对。

> **注意**：无论是哪种配置方式，更新 agent 角色定义后都需要重新初始化 Agent 会话才能生效。OpenCode 不支持热加载 subagent 定义。

---

## 5. Skill 部署与集成

### 5.1 技能来源

`skills/` 目录包含 10 个独立 Skill，每个 Skill 封装了一个领域工具或流程运作。Skill 被角色路由表引用，按场景自动加载。

### 5.2 部署命令

```bash
# 复制所有 Skill 到下游项目
cp -r vendor/ai-engineering/skills/* .opencode/skills/
```

### 5.3 自动发现机制

OpenCode 在项目启动时自动扫描 `.opencode/skills/` 目录，无需在配置中显式注册。每个 Skill 的 `SKILL.md` 中的 `name` 和 `description` 字段决定了 Skill 的身份和被加载的场景。

Agent 角色定义中的 **§工具箱（Skills）** 章节作为路由表，告知 AI 在哪些场景下调用哪些 Skill。部署时随 Agent 正文一同下发。

### 5.4 一键全量部署

使用 `scripts/deploy-all.sh` 可一次性完成规范、技能、Agent 角色和 Issue 模板的部署：

```bash
# 部署到下游项目
./scripts/deploy-all.sh /path/to/my-project

# 更新模式（保留定制）
./scripts/deploy-all.sh /path/to/my-project --update
```

### 5.5 Agent 角色中的 Skill 路由

每个 Agent 角色文件（`agents/*.md`）的 **§工具箱（Skills）** 章节定义了该角色可调用的 Skill 路由表。部署时随 Agent 正文一同下发，Agent 在对应场景下自动加载相关 Skill。

---

## 6. 使用方式

```bash
# 通过 Tab 键切换到指定 Agent
# 或通过 @ 提及调用 subagent
@Developer 开发工程师 实现用户登录功能
@PO 产品经理 起草 PRD 文档
@Orchestrator 编排 检查项目状态
```

### 6.1 更新 Agent 后重新加载

| 配置方式 | 更新后操作 |
|----------|-----------|
| `.opencode/agents/*.md` 直接嵌入 | 退出当前会话，重新 @ 调用即可 |
| `opencode.json` 中 `{file:...}` 引用 | 退出当前会话，重新 @ 调用即可 |
| 两种方式通用 | 运行 `scripts/deploy-all.sh --update` 后需退出会话重入 |

---

## 7. GitHub Actions 集成

将 OpenCode 接入 GitHub Actions 工作流，实现在 Issue/PR 中通过 `/oc` 或 `/opencode` 自动触发 AI 处理。

### 7.1 安装方式

**方式一：复制模板（推荐）**

从 `reference/templates/opencode-workflow.yml` 复制到目标项目的 `.github/workflows/opencode.yml`：

```bash
cp vendor/ai-engineering/reference/templates/opencode-workflow.yml .github/workflows/opencode.yml
```

**方式二：手动创建**

```bash
mkdir -p .github/workflows
```

将 [模板内容](file:../reference/templates/opencode-workflow.yml) 粘贴到 `.github/workflows/opencode.yml`。

### 7.2 配置 Secrets

在 GitHub 仓库 **Settings → Secrets and variables → Actions** 中添加：

| Secret 名 | 说明 | 示例值 |
|-----------|------|--------|
| `LLM_API_KEY` | AI 模型的 API Key | `sk-ant-xxxxxxxx` |

### 7.3 自定义模型

模板默认使用 `deepseek/deepseek-v4-flash`。修改 workflow 中 `model` 字段：

```yaml
with:
  model: anthropic/claude-sonnet-4-20250514  # 替换为你使用的模型
```

支持的模型格式：`provider/model`（如 `openai/gpt-4o`、`deepseek/deepseek-v4-flash`）。

### 7.4 使用方式

| 场景 | 操作 |
|------|------|
| 分析 Issue | 在 Issue 中评论 `/oc 帮我分析这个 Issue` |
| 修复 Bug | 在 Issue 中评论 `/oc 修复这个 Bug` |
| 审查 PR | 在 PR 评论中提及 `/oc` 或自动触发 |
| 自动 Triage | 新 Issue 创建后自动分析并添加标签 |

> 评论触发的操作仅仓库 OWNER 和 COLLABORATOR 可执行。

---

## 8. 完整部署流程

```
步骤 1：复制 guide/ 规则文件到 docs/ai-engineering/
步骤 2：复制 skills/ 技能文件到 .opencode/skills/
步骤 3：将 ai-engineering 引入项目（Git Submodule / 本地路径）
步骤 4：创建 AGENTS.md 主指令文件
步骤 5：创建 opencode.json 或 .opencode/agents/ 配置文件，引用 agents/ 角色
步骤 6：[可选] 部署 GitHub Actions 工作流（参考 §7）
步骤 7：验证 Agent 加载
```

---

## 9. 验证

安装完成后，在 OpenCode 中执行以下检查：

```
□ 确认 AGENTS.md 被正确加载
□ 提问 "当前项目的研发规范是什么？" 验证规范已生效
□ 通过 Tab 键确认 Agent 列表显示 5 个角色
□ 调用 @orchestrator 检查项目状态，验证角色功能正常
```

---

## 10. 同步更新

### 10.1 同步范围一览

| # | 组件 | 源路径 | 目标路径 | 更新方式 |
|---|------|--------|---------|---------|
| 1 | 规范文件 | `guide/*.md` | `docs/ai-engineering/` | `deploy-all.sh` / 手动复制 |
| 2 | 技能文件 | `skills/*/` | `.opencode/skills/` | `deploy-all.sh` / 手动复制 |
| 3 | Agent 角色 | `agents/*.md` | `.opencode/agents/*.md` | `deploy-all.sh` / §4.5 内联脚本 |
| 4 | 主指令文件 | `reference/templates/AGENTS.md.example` | `AGENTS.md` | 手动更新占位符 |
| 5 | Issue 模板 | `.github/ISSUE_TEMPLATE/*.yml` | `.github/ISSUE_TEMPLATE/` | `deploy-all.sh` / 手动复制 |
| 6 | GitHub Actions | `reference/templates/opencode-workflow.yml` | `.github/workflows/opencode.yml` | 手动复制 |

### 10.2 全量同步（推荐）

```bash
# 一次性同步组件 1-5（保留定制内容）
./scripts/deploy-all.sh /path/to/project --update
```

组件 6（GitHub Actions）需要手动复制，`deploy-all.sh` 不覆盖已有 workflow 文件。

### 10.3 版本比对同步

```bash
# 仅同步规范文件（组件 1）+ 记录 Agent 版本（组件 3 仅版本号）
./scripts/downstream-sync.sh \
  --source vendor/ai-engineering \
  --manifest docs/ai-engineering/MANIFEST.json \
  --target docs/ai-engineering/
```

适用场景：只想更新规范内容，不刷新技能/模板。

### 10.4 组件级同步

| 组件 | 命令 |
|------|------|
| 规范文件 | `cp vendor/ai-engineering/guide/*.md docs/ai-engineering/` |
| 技能文件 | `cp -r vendor/ai-engineering/skills/* .opencode/skills/` |
| Agent 角色 | 首次：`deploy-all.sh` / 更新：复制 §4.5 内联脚本到 `scripts/deploy-agents.sh` 后执行 `--update` |
| Issue 模板 | `cp vendor/ai-engineering/.github/ISSUE_TEMPLATE/*.yml .github/ISSUE_TEMPLATE/` |

### 10.5 更新后验证

```
□ 所有组件版本已更新（MANIFEST.json 比对）
□ Agent 会话已重新初始化（退出后重新 @ 调用）
□ 新技能可正常加载
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
| v0.8 | 2026-05-30 | 新增 §10「同步更新」章节；新增 §5.3「自动发现机制」；§5.3→§5.4、§5.4→§5.5 重编号 |
| v0.7 | 2026-05-29 | 新增 §5「Skill 部署与集成」章节；新增 `scripts/deploy-all.sh` 全量部署脚本；部署流程加入 skill 复制步骤；§5→§6→§7→§8→§9 重编号 |
| v0.4 | 2026-04-05 | 新增 4.3 直接复制嵌入方式、4.5 一键搬运脚本；补充 frontmatter 注意事项和角色配置摘要表 |
| v0.3 | 2026-04-05 | 新增 Agent 文件生成指南，基于官方规范补充完整字段说明、权限配置和五个角色完整示例 |
| v0.2 | 2026-04-04 | 修正 AGENTS.md 规范文件路径为 docs/ai-engineering/，修正交叉引用路径 |
| v0.1 | 2026-04-04 | 从 08 工具集成指南拆分，独立成文 |
