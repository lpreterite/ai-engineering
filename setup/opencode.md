# OpenCode 安装指南

> Setup Guide for OpenCode

**所属目录**：`ai-engineering/setup/`
**文档状态**：草稿
**当前版本**：v0.5
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

以下脚本将 `ai-engineering/agents/` 中的角色定义文件搬运到目标项目的 `.opencode/agents/` 目录，自动添加符合 OpenCode 官方规范的 YAML frontmatter：

```bash
#!/bin/bash
# deploy-agents.sh — 将 AI 研发体系 Agent 角色部署/更新到目标项目
# 用法:
#   首次部署: ./deploy-agents.sh <目标项目路径> [ai-engineering路径]
#   增量更新: ./deploy-agents.sh --update <目标项目路径> [ai-engineering路径] [--manifest-path <MANIFEST.json路径>]
#
# 示例:
#   ./deploy-agents.sh /path/to/my-project
#   ./deploy-agents.sh --update /path/to/my-project
#   ./deploy-agents.sh --update /path/to/my-project /path/to/ai-engineering \
#     --manifest-path /path/to/my-project/docs/ai-engineering/MANIFEST.json

set -euo pipefail

# ---- 参数解析 ----
UPDATE_MODE=false
MANIFEST_PATH=""

POSITIONAL=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --update) UPDATE_MODE=true; shift ;;
    --manifest-path) MANIFEST_PATH="$2"; shift 2 ;;
    *) POSITIONAL+=("$1"); shift ;;
  esac
done

TARGET="${POSITIONAL[0]:?用法: $0 [--update] <目标项目路径> [ai-engineering路径]}"
AI_ENG="${POSITIONAL[1]:-$(cd "$(dirname "$0")/.." && pwd)}"
AGENTS_SRC="$AI_ENG/agents"
AGENTS_DST="$TARGET/.opencode/agents"
AGENTS_MANIFEST="$AGENTS_DST/.agent-manifest.json"

# 检查源目录
if [ ! -d "$AGENTS_SRC" ]; then
  echo "❌ 错误: agents 源目录不存在: $AGENTS_SRC"
  exit 1
fi

# 创建目标目录
mkdir -p "$AGENTS_DST"

# 角色配置表： (源文件名, 目标文件名, agent_name, description, temperature, edit, webfetch, steps, color)
declare -A AGENT_CONFIG=(
  ["orchestrator-agent.md"]="orchestrator.md|Orchestrator 编排|Orchestrator 编排 — 多智能体编排中枢，驱动编排流程、路由任务、门控质量、引导用户|0.3|ask|deny|20|#4A90D9"
  ["po-agent.md"]="po.md|PO 产品经理|PO 产品经理 — 需求分析、PRD 起草，从模糊诉求中提炼清晰可交付的需求|0.4|ask|allow|15|#7B68EE"
  ["uiux-agent.md"]="uiux.md|UI/UX 设计师|UI/UX 设计师 — 用户方案设计，设计规范制定、设计稿和交互说明|0.5|ask|allow|15|#E67E22"
  ["fullstack-developer.md"]="developer.md|Full-stack Developer Agent|Full-stack Developer Agent — 全栈技术实施，覆盖前端、后端、数据库与 DevOps|0.2|allow|allow|30|#2ECC71"
  ["tester-agent.md"]="tester.md|Tester 测试工程师|Tester 测试工程师 — 测试执行，功能测试、回归测试和验收测试，证据驱动的质量验证|0.1|ask|deny|20|#E74C3C"
)

# ---- 函数定义 ----

# 计算文件 MD5
checksum() {
  md5sum "$1" 2>/dev/null | cut -d' ' -f1 || echo ""
}

# 读取已部署的 manifest
read_manifest() {
  if [ -f "$AGENTS_MANIFEST" ]; then
    cat "$AGENTS_MANIFEST"
  else
    echo "{}"
  fi
}

# 写入 manifest
write_manifest() {
  echo "$1" > "$AGENTS_MANIFEST"
}

# 记录部署状态到外部 MANIFEST.json
update_external_manifest() {
  local src_name="$1" version="$2"
  [ -z "$MANIFEST_PATH" ] && return
  [ ! -f "$MANIFEST_PATH" ] && return
  local agent_key="${src_name%.md}"
  local tmp=$(mktemp)
  python3 -c "
import json, sys
with open('$MANIFEST_PATH') as f:
    m = json.load(f)
m.setdefault('agents', {})
agent_key = '$agent_key'
if agent_key not in m['agents']:
    m['agents'][agent_key] = {
        'source': 'agents/$src_name',
        'version': '$version',
        'customized': False,
        'previous_version': None
    }
else:
    m['agents'][agent_key]['version'] = '$version'
with open('$MANIFEST_PATH', 'w') as f:
    json.dump(m, f, indent=2)
    f.write('\n')
" 2>/dev/null && rm "$tmp" || true
}

# 部署或更新单个 agent
deploy_agent() {
  local src="$1" dst="$2" agent_name="$3" desc="$4" temp="$5" perm_edit="$6" perm_webfetch="$7" steps="$8" color="$9"
  local src_name="${10}" customized="${11:-false}"

  if [ ! -f "$src" ]; then
    echo "⚠️   跳过: $src (文件不存在)"
    return 1
  fi

  # 如果是更新模式且已定制，跳过
  if [ "$UPDATE_MODE" = true ] && [ "$customized" = "true" ]; then
    echo "⏭️   跳过 $dst (已定制，请手动审查)"
    return 0
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

  cat "$src" >> "$dst"

  # 更新内部 manifest
  local src_checksum=$(checksum "$src")
  local manifest=$(read_manifest)
  local current_checksum=$(echo "$manifest" | python3 -c "
import json,sys
d=json.load(sys.stdin)
print(d.get('$src_name',{}).get('deployed_checksum',''))
" 2>/dev/null || echo "")
  # 写入更新后的 manifest
  local new_manifest=$(echo "$manifest" | python3 -c "
import json,sys
d=json.load(sys.stdin)
d.setdefault('$src_name',{})
d['$src_name']['deployed_checksum']='$src_checksum'
d['$src_name']['customized']=$customized
d['$src_name']['deployed_at']='$(date -u +%Y-%m-%dT%H:%M:%SZ)'
print(json.dumps(d,indent=2))
" 2>/dev/null || echo "{}")
  write_manifest "$new_manifest"

  if [ "$UPDATE_MODE" = true ]; then
    echo "🔄 已更新: $dst"
  else
    echo "✅ 已生成: $dst"
  fi

  # 同步版本到外部 MANIFEST.json（如有提供）
  if [ -n "$MANIFEST_PATH" ] && [ -f "$MANIFEST_PATH" ]; then
    update_external_manifest "$src_name" "$(basename "$src")"
  fi
}

# 从 version 字段提取版本号（取文件名前缀匹配 RELEASE）
infer_version() {
  local src_name="$1"
  # 从 AI_ENG/RELEASE.json 读取版本
  if [ -f "$AI_ENG/RELEASE.json" ]; then
    python3 -c "
import json
with open('$AI_ENG/RELEASE.json') as f:
    r = json.load(f)
for key, ver in r.get('files', {}).items():
    if key == 'agents/$src_name':
        print(ver)
        break
" 2>/dev/null
  fi
}

# ---- 主逻辑 ----

if [ "$UPDATE_MODE" = true ]; then
  echo "🔍 增量更新模式 — 检查是否有变更的 Agent 角色..."
  echo ""

  UPDATED_COUNT=0
  SKIPPED_COUNT=0

  # 读取内部 manifest
  local_manifest=$(read_manifest)

  for src_file in "${!AGENT_CONFIG[@]}";  do
    IFS='|' read -r dst_file agent_name desc temp perm_edit perm_webfetch steps color <<< "${AGENT_CONFIG[$src_file]}"
    src_path="$AGENTS_SRC/$src_file"
    dst_path="$AGENTS_DST/$dst_file"

    if [ ! -f "$src_path" ]; then
      echo "⚠️   跳过: $src_file (源文件不存在)"
      continue
    fi

    # 检查 manifest 中的定制状态
    customized=$(echo "$local_manifest" | python3 -c "
import json,sys
try:
    d=json.load(sys.stdin)
    print(d.get('$src_file',{}).get('customized','false'))
except:
    print('false')
" 2>/dev/null || echo "false")

    # 获取源文件最新 checksum
    src_checksum=$(checksum "$src_path")

    # 获取已部署 checksum
    deployed_checksum=$(echo "$local_manifest" | python3 -c "
import json,sys
try:
    d=json.load(sys.stdin)
    print(d.get('$src_file',{}).get('deployed_checksum',''))
except:
    print('')
" 2>/dev/null || echo "")

    if [ "$src_checksum" = "$deployed_checksum" ] && [ -f "$dst_path" ]; then
      echo "✓   无变更: $src_file"
      continue
    fi

    if [ "$customized" = "true" ]; then
      echo "⏭️   跳过 $dst_file (源文件已变更但已标记为定制，请手动审查)"
      SKIPPED_COUNT=$((SKIPPED_COUNT + 1))
      continue
    fi

    deploy_agent "$src_path" "$dst_path" "$agent_name" "$desc" "$temp" "$perm_edit" "$perm_webfetch" "$steps" "$color" "$src_file" "false"
    UPDATED_COUNT=$((UPDATED_COUNT + 1))
  done

  echo ""
  echo "🎉 增量更新完成！"
  echo "   更新: $UPDATED_COUNT | 跳过(已定制): $SKIPPED_COUNT | 总计: $((${#AGENT_CONFIG[@]}))"
  echo ""
  echo "💡 提示: 对于已定制的 Agent，请手动审查变更后运行:"
  echo "   python3 -c \"import json; m=json.load(open('$AGENTS_MANIFEST')); m['<agent_name>']['customized']=False; json.dump(m,open('$AGENTS_MANIFEST','w'),indent=2)\""
  echo "   然后重新运行 --update"
else
  echo "🚀 首次部署 — 将 AI 研发体系 Agent 角色部署到 $AGENTS_DST"
  echo ""

  for src_file in "${!AGENT_CONFIG[@]}"; do
    IFS='|' read -r dst_file agent_name desc temp perm_edit perm_webfetch steps color <<< "${AGENT_CONFIG[$src_file]}"
    src_path="$AGENTS_SRC/$src_file"
    dst_path="$AGENTS_DST/$dst_file"

    deploy_agent "$src_path" "$dst_path" "$agent_name" "$desc" "$temp" "$perm_edit" "$perm_webfetch" "$steps" "$color" "$src_file" "false"

    # 同步版本到外部 MANIFEST.json（如有提供）
    if [ -n "$MANIFEST_PATH" ] && [ -f "$MANIFEST_PATH" ]; then
      update_external_manifest "$src_file" "$(infer_version "$src_file")"
    fi
  done

  echo ""
  echo "🎉 部署完成！共生成 5 个 Agent 文件到 $AGENTS_DST"
  echo "   在 OpenCode 中通过 @Orchestrator\\ 编排 @PO\\ 产品经理 @UI/UX\\ 设计师 @Full-stack Developer Agent @Tester\\ 测试工程师 调用"
  echo ""
  echo "💡 提示: 后续源仓库 agents/*.md 更新后，运行以下命令增量更新："
  echo "   $0 --update $TARGET ${AI_ENG:+"$AI_ENG"}"
fi
```

> **提示**：脚本中 `bash` 权限默认统一为 `"*": ask`。实际使用时可按角色需要修改——例如 Full-stack Developer Agent 通常需要 `npm test*`、`npm run build*` 等命令的 `allow` 权限。

#### deploy-agents.sh --update 模式

运行 `--update` 模式时，脚本会：

1. 读取 `.opencode/agents/.agent-manifest.json`，获取已部署文件的 checksum 和定制状态
2. 逐文件比对 `agents/` 源文件的最新 checksum
3. 仅更新 **源文件有变更且未定制**（`customized: false`）的 Agent 文件
4. 跳过已标记为定制（`customized: true`）的文件，输出通知
5. 可选通过 `--manifest-path` 同步版本号到 `docs/ai-engineering/MANIFEST.json`

```bash
# 首次部署后，后续增量更新：
./deploy-agents.sh --update /path/to/my-project

# 同步更新 MANIFEST.json 版本记录：
./deploy-agents.sh --update /path/to/my-project \
  --manifest-path /path/to/my-project/docs/ai-engineering/MANIFEST.json
```

---

## 5. 使用方式

```bash
# 通过 Tab 键切换到指定 Agent
# 或通过 @ 提及调用 subagent
@Developer 开发工程师 实现用户登录功能
@PO 产品经理 起草 PRD 文档
@Orchestrator 编排 检查项目状态
```

---

## 6. GitHub Actions 集成

将 OpenCode 接入 GitHub Actions 工作流，实现在 Issue/PR 中通过 `/oc` 或 `/opencode` 自动触发 AI 处理。

### 6.1 安装方式

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

### 6.2 配置 Secrets

在 GitHub 仓库 **Settings → Secrets and variables → Actions** 中添加：

| Secret 名 | 说明 | 示例值 |
|-----------|------|--------|
| `LLM_API_KEY` | AI 模型的 API Key | `sk-ant-xxxxxxxx` |

### 6.3 自定义模型

模板默认使用 `deepseek/deepseek-v4-flash`。修改 workflow 中 `model` 字段：

```yaml
with:
  model: anthropic/claude-sonnet-4-20250514  # 替换为你使用的模型
```

支持的模型格式：`provider/model`（如 `openai/gpt-4o`、`deepseek/deepseek-v4-flash`）。

### 6.4 使用方式

| 场景 | 操作 |
|------|------|
| 分析 Issue | 在 Issue 中评论 `/oc 帮我分析这个 Issue` |
| 修复 Bug | 在 Issue 中评论 `/oc 修复这个 Bug` |
| 审查 PR | 在 PR 评论中提及 `/oc` 或自动触发 |
| 自动 Triage | 新 Issue 创建后自动分析并添加标签 |

> 评论触发的操作仅仓库 OWNER 和 COLLABORATOR 可执行。

---

## 7. 完整部署流程

```
步骤 1：复制 guide/ 规则文件到 docs/ai-engineering/
步骤 2：将 ai-engineering 引入项目（Git Submodule / 本地路径）
步骤 3：创建 AGENTS.md 主指令文件
步骤 4：创建 opencode.json 或 .opencode/agents/ 配置文件，引用 agents/ 角色
       首次部署：运行 ./deploy-agents.sh <target>
       增量更新：运行 ./deploy-agents.sh --update <target>
步骤 5：[可选] 部署 GitHub Actions 工作流（参考 §6）
步骤 6：验证 Agent 加载
```

---

## 8. 验证

安装完成后，在 OpenCode 中执行以下检查：

```
□ 确认 AGENTS.md 被正确加载
□ 提问 "当前项目的研发规范是什么？" 验证规范已生效
□ 通过 Tab 键确认 Agent 列表显示 5 个角色
□ 调用 @orchestrator 检查项目状态，验证角色功能正常
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
| v0.6 | 2026-05-27 | §4.5 deploy-agents.sh 新增 --update 增量更新模式，支持 checksum 比对和定制保护，同步 MANIFEST.json 版本；§7 更新部署流程 |
| v0.5 | 2026-05-27 | 新增 §6 GitHub Actions 集成（安装方式、Secrets 配置、模型自定义） |
| v0.4 | 2026-04-05 | 新增 4.3 直接复制嵌入方式、4.5 一键搬运脚本；补充 frontmatter 注意事项和角色配置摘要表 |
| v0.3 | 2026-04-05 | 新增 Agent 文件生成指南，基于官方规范补充完整字段说明、权限配置和五个角色完整示例 |
| v0.2 | 2026-04-04 | 修正 AGENTS.md 规范文件路径为 docs/ai-engineering/，修正交叉引用路径 |
| v0.1 | 2026-04-04 | 从 08 工具集成指南拆分，独立成文 |
