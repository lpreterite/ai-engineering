#!/bin/bash
# deploy-all.sh — 全量部署 AI 研发工程体系到下游项目
# 用法: ./deploy-all.sh <目标项目路径> [--tool opencode|claude-code] [--update]
#
# 部署内容:
#   1. guide/*.md          → docs/ai-engineering/
#   2. skills/*             → .opencode/skills/ 或 .claude/skills/
#   3. agents/*.md          → 生成 Agent 角色配置（带 YAML frontmatter）
#   4. .github/ISSUE_TEMPLATE/*.yml → .github/ISSUE_TEMPLATE/

set -euo pipefail

SRC_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TARGET="${1:?用法: $0 <目标项目路径> [--tool opencode|claude-code] [--update]}"
TOOL="opencode"
UPDATE=false

shift
while [[ $# -gt 0 ]]; do
  case "$1" in
    --tool) TOOL="$2"; shift 2 ;;
    --update) UPDATE=true; shift ;;
    *) echo "未知参数: $1"; exit 1 ;;
  esac
done

if [ "$TOOL" != "opencode" ] && [ "$TOOL" != "claude-code" ]; then
  echo "❌ 不支持的 tool: $TOOL（仅支持 opencode / claude-code）"
  exit 1
fi

echo "🚀 部署 AI 研发工程体系到: $TARGET (tool: $TOOL)"
echo ""

# ─── 步骤 1: 规范文件 ─────────────────────────────────────────
echo "📄 [1/4] 部署规范文件 → docs/ai-engineering/"
mkdir -p "$TARGET/docs/ai-engineering"
for f in "$SRC_DIR/guide/"*.md; do
  name=$(basename "$f")
  dst="$TARGET/docs/ai-engineering/$name"
  if [ "$UPDATE" = true ] && [ -f "$dst" ]; then
    echo "   ⏭️  已存在: docs/ai-engineering/$name"
  else
    cp "$f" "$dst"
    echo "   ✅ docs/ai-engineering/$name"
  fi
done

# ─── 步骤 2: 技能文件 ─────────────────────────────────────────
SKILL_DST="$TARGET/.opencode/skills"
SKILL_SRC="$SRC_DIR/skills"
if [ "$TOOL" = "claude-code" ]; then
  SKILL_DST="$TARGET/.claude/skills"
fi

echo ""
echo "🧠 [2/4] 部署技能文件 → $SKILL_DST"
mkdir -p "$SKILL_DST"
for skill_dir in "$SKILL_SRC"/*/; do
  skill_name=$(basename "$skill_dir")
  dst_dir="$SKILL_DST/$skill_name"
  if [ "$UPDATE" = true ] && [ -d "$dst_dir" ]; then
    echo "   ⏭️  已存在: $SKILL_DST/$skill_name"
  else
    cp -r "$skill_dir" "$dst_dir"
    echo "   ✅ $SKILL_DST/$skill_name"
  fi
done

# ─── 步骤 3: Agent 角色配置 ──────────────────────────────────
echo ""
echo "🤖 [3/4] 生成 Agent 角色配置"

AGENTS_SRC="$SRC_DIR/agents"
AGENTS_DST="$TARGET/.opencode/agents"
if [ "$TOOL" = "claude-code" ]; then
  AGENTS_DST="$TARGET/.claude/agents"
fi

# macOS bash 不支持关联数组，使用约定顺序文件列表
AGENT_KEYS="orchestrator po uiux developer tester"
agent_data() {
  case "$1" in
    orchestrator) echo "Orchestrator 编排|Orchestrator 编排 — 多智能体编排中枢，驱动编排流程、路由任务、门控质量、引导用户|0.3|ask|deny|20|#4A90D9" ;;
    po)           echo "PO 产品经理|PO 产品经理 — 需求分析、PRD 起草，从模糊诉求中提炼清晰可交付的需求|0.4|ask|allow|15|#7B68EE" ;;
    uiux)         echo "UI/UX 设计师|UI/UX 设计师 — 用户方案设计，设计规范制定、设计稿和交互说明|0.5|ask|allow|15|#E67E22" ;;
    developer)    echo "Full-stack Developer Agent|Full-stack Developer Agent — 全栈技术实施，覆盖前端、后端、数据库与 DevOps|0.2|allow|allow|30|#2ECC71" ;;
    tester)       echo "Tester 测试工程师|Tester 测试工程师 — 测试执行，功能测试、回归测试和验收测试，证据驱动的质量验证|0.1|ask|deny|20|#E74C3C" ;;
  esac
}

deploy_agent() {
  local key="$1"
  local src="$AGENTS_SRC/${key}-agent.md"
  if [ "$key" = "developer" ]; then
    src="$AGENTS_SRC/fullstack-developer.md"
  fi
  local dst="$AGENTS_DST/${key}.md"

  IFS='|' read -r agent_name desc temp perm_edit perm_webfetch steps color <<< "$(agent_data "$key")"

  if [ ! -f "$src" ]; then
    echo "   ⚠️  跳过: $src (文件不存在)"
    return
  fi

  if [ "$UPDATE" = true ] && [ -f "$dst" ]; then
    local tmpfile=$(mktemp)
    awk '/^---$/ { if (seen) exit; seen=1; next } seen && /^---$/ { exit } seen' "$dst" > "$tmpfile"
    if [ -s "$tmpfile" ]; then
      { cat "$tmpfile"; echo "---"; echo ""; cat "$src"; } > "${dst}.new"
    else
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
    if diff -q "$dst" "${dst}.new" > /dev/null 2>&1; then
      rm -f "${dst}.new"
      echo "   ⏭️  无变化: $key"
    else
      mv "${dst}.new" "$dst"
      echo "   🔄 已更新: $key"
    fi
  else
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
    echo "   ✅ $key"
  fi
}

for key in $AGENT_KEYS; do
  deploy_agent "$key"
done

# ─── 步骤 4: Issue 模板 ──────────────────────────────────────
echo ""
echo "📋 [4/4] 部署 Issue 模板 → .github/ISSUE_TEMPLATE/"
mkdir -p "$TARGET/.github/ISSUE_TEMPLATE"
for f in "$SRC_DIR/.github/ISSUE_TEMPLATE/"*.yml; do
  name=$(basename "$f")
  dst="$TARGET/.github/ISSUE_TEMPLATE/$name"
  if [ "$UPDATE" = true ] && [ -f "$dst" ]; then
    echo "   ⏭️  已存在: .github/ISSUE_TEMPLATE/$name"
  else
    cp "$f" "$dst"
    echo "   ✅ .github/ISSUE_TEMPLATE/$name"
  fi
done

echo ""
echo "🎉 部署完成！目标项目: $TARGET"
echo "   规范文件 → docs/ai-engineering/"
echo "   技能文件 → $SKILL_DST"
echo "   Agent 角色 → $AGENTS_DST"
echo "   Issue 模板 → .github/ISSUE_TEMPLATE/"
echo ""
echo "   退出当前 Agent 会话后重新进入以加载新配置。"
