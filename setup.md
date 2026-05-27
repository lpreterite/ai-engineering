# Agent 部署指南

> Agent Setup Guide (Executable)

**文档状态**：已发布
**当前版本**：v0.6
**发布日期**：2026-05-27

---

## 1. 概述

本文件是 AI 软件研发工程体系的 **Agent 执行入口**。目标项目的 Agent 读取本文件后，按照步骤将研发规范部署到目标项目，并配置 AI 工具引用角色定义。

---

## 2. 部署步骤

### 步骤 1：部署研发规范文件

将 `guide/` 目录中的 6 个规范文件复制到目标项目的 `docs/ai-engineering/` 目录：

| 源文件（ai-engineering/guide/） | 目标位置（target-project/docs/ai-engineering/） | 必选 |
|----------------------------------|--------------------------------------------------|------|
| `01-principles.md` | `docs/ai-engineering/principles.md` | 是 |
| `02-process.md` | `docs/ai-engineering/process.md` | 是 |
| `03-collaboration.md` | `docs/ai-engineering/collaboration.md` | 是 |
| `04-checklists.md` | `docs/ai-engineering/checklists.md` | 否 |
| `05-deliverables.md` | `docs/ai-engineering/deliverables.md` | 否 |
| `06-document-management.md` | `docs/ai-engineering/document-management.md` | 否 |
| `issue-workflow.md` | `docs/ai-engineering/issue-workflow.md` | 否 |

```bash
mkdir -p docs/ai-engineering
cp guide/01-principles.md          docs/ai-engineering/principles.md
cp guide/02-process.md             docs/ai-engineering/process.md
cp guide/03-collaboration.md       docs/ai-engineering/collaboration.md
cp guide/04-checklists.md          docs/ai-engineering/checklists.md
cp guide/05-deliverables.md        docs/ai-engineering/deliverables.md
cp guide/06-document-management.md docs/ai-engineering/document-management.md
cp guide/issue-workflow.md         docs/ai-engineering/issue-workflow.md
```

部署后初始化 MANIFEST 注册表：

```bash
cat > docs/ai-engineering/MANIFEST.json << 'MANIFEST'
{
  "manifest_version": "1.0",
  "source": {
    "repository": "lpreterite/ai-engineering",
    "deployed_at": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"
  },
  "files": {
    "principles.md": { "source": "guide/01-principles.md", "version": "v0.7", "customized": false, "previous_version": null },
    "process.md": { "source": "guide/02-process.md", "version": "v0.7", "customized": false, "previous_version": null },
    "collaboration.md": { "source": "guide/03-collaboration.md", "version": "v0.2", "customized": false, "previous_version": null },
    "checklists.md": { "source": "guide/04-checklists.md", "version": "v0.2", "customized": false, "previous_version": null },
    "deliverables.md": { "source": "guide/05-deliverables.md", "version": "v0.2", "customized": false, "previous_version": null },
    "document-management.md": { "source": "guide/06-document-management.md", "version": "v0.2", "customized": false, "previous_version": null },
    "issue-workflow.md": { "source": "guide/issue-workflow.md", "version": "v0.2", "customized": false, "previous_version": null }
  }
}
MANIFEST
```

> 最小部署：至少复制前 3 个文件即可启用基本协作规范。

> **Subagent 版本记录**：首次部署后，建议同时在 MANIFEST 中记录 `agents/` 目录角色文件的版本（参见下方"步骤 3b"），以便后续升级时 AI 能比对 agent 版本变化。

### 步骤 2：配置 AI 编程工具

根据目标项目使用的 AI 编程工具，阅读对应的安装指南完成配置：

| 工具 | 安装指南 | 说明 |
|------|----------|------|
| Claude Code | [setup/claude-code.md](./setup/claude-code.md) | `CLAUDE.md` + `@path` 引用角色 |
| OpenCode | [setup/opencode.md](./setup/opencode.md) | `opencode.json` 或 `.opencode/agents/` |
| Codex CLI | [setup/codex.md](./setup/codex.md) | `.codex/config.toml` subagent 配置 |

> Agent 角色文件 **不需要复制到目标项目**。AI 工具通过路径引用直接读取本规范库 `agents/` 目录中的角色定义。详见各工具的安装指南。

### 步骤 3：初始化 docs/ 目录结构

按照 `guide/07-repo-directory-guide.md` 创建完整的项目文档目录：

```
docs/
├── README.md                      # 项目文档索引
├── STATUS.md                      # 项目状态卡
│
├── ai-engineering/                # ← 已部署（AI 研发规范）
│   ├── MANIFEST.json              # 版本注册表（必选）
│   ├── principles.md
│   ├── process.md
│   ├── collaboration.md
│   ├── checklists.md
│   ├── deliverables.md
│   ├── document-management.md
│   └── issue-workflow.md
│
├── product/                       # 需求文档（按需创建）
├── engineering/                   # 工程文档（按需创建）
├── design/                        # 设计文档（按需创建）
├── project-management/            # 项目管理（按需创建）
└── project-tasks/                 # 任务跟踪（按需创建）
```

### 步骤 3b：初始化 Subagent 版本跟踪

在 `MANIFEST.json` 中同时记录 `agents/` 目录的角色文件版本，以便后续升级时 AI 能比对版本变化：

```bash
# 在现有的 MANIFEST.json 中追加 agent 文件版本记录
python3 -c "
import json
with open('docs/ai-engineering/MANIFEST.json') as f:
    m = json.load(f)
agents = {
    'orchestrator-agent.md': { 'source': 'agents/orchestrator-agent.md', 'version': 'v0.5', 'customized': false, 'previous_version': null, 'category': 'agent' },
    'po-agent.md':           { 'source': 'agents/po-agent.md',           'version': 'v0.3', 'customized': false, 'previous_version': null, 'category': 'agent' },
    'uiux-agent.md':         { 'source': 'agents/uiux-agent.md',         'version': 'v0.3', 'customized': false, 'previous_version': null, 'category': 'agent' },
    'fullstack-developer.md':{ 'source': 'agents/fullstack-developer.md','version': 'v0.4', 'customized': false, 'previous_version': null, 'category': 'agent' },
    'tester-agent.md':       { 'source': 'agents/tester-agent.md',       'version': 'v0.3', 'customized': false, 'previous_version': null, 'category': 'agent' }
}
m['files'].update(agents)
with open('docs/ai-engineering/MANIFEST.json', 'w') as f:
    json.dump(m, f, indent=2)
    f.write('\n')
"
```

> agent 文件不物理复制到目标项目，AI 工具通过 `{file:...}` 或 `@path` 路径引用源文件。MANIFEST 仅用于版本跟踪。

### 步骤 4：验证部署

**必选检查**（全部通过才算部署完成）：

```
□ docs/ai-engineering/MANIFEST.json 已初始化并记录所有文件
□ docs/ai-engineering/ 目录包含至少 3 个规则文件（principles、process、collaboration）
□ ★ docs/STATUS.md 已写入初始内容（含项目名称、当前阶段、里程碑列表）
□ docs/README.md 已写入文档索引
□ AI 工具的指令文件（CLAUDE.md / AGENTS.md / config.toml）已创建
□ AI 工具能正确引用 agents/ 目录中的角色文件
```

---

## 3. 规范库引用方式

将本规范库引入目标项目有多种方式：

| 方式 | 操作 | 适用场景 |
|------|------|----------|
| **手动复制** | 从 guide/ 复制到 docs/ai-engineering/ | 简单项目、一次性部署 |
| **Git Submodule** | `git submodule add https://github.com/lpreterite/ai-engineering.git vendor/ai-engineering` | 团队协作、版本锁定 |
| **本地路径** | 使用相对路径指向本规范库目录 | 个人开发、快速集成 |

---

## 4. 更新 Subagent

当源仓库 `agents/` 目录的角色文件有更新时，需要同步更新目标项目的 agent 配置。

### 版本比对

AI 通过以下方式检测 agent 是否需要更新：

1. 读取源仓库 `RELEASE.json` 中 `agents/*.md` 的版本号
2. 与下游 `MANIFEST.json` 中 `category: "agent"` 的条目逐文件比对
3. 标记过期 agent 清单

### 更新方式（分工具）

| 配置方式 | 更新操作 | 说明 |
|----------|----------|------|
| `{file:...}` 引用 | 无需复制文件，但需**重新初始化 Agent** 才能加载新内容 | 退出当前会话重新调用 agent |
| `.opencode/agents/*.md` 直接嵌入 | 重新运行 `deploy-agents.sh --update`（参见 [setup/opencode.md](./setup/opencode.md)） | 保留自定义 frontmatter |
| `.claude/agents/*.md` 直接嵌入 | 手动复制新角色定义到对应 `.claude/agents/*.md`，或重新运行安装脚本 | 旧内容被覆盖 |
| `.codex/config.toml` | 无需更新配置文件，但需检查语义版本变化 | 重启 codex 会话 |

### 更新后验证

```
□ MANIFEST.json 中 agent 版本已更新
□ AI 工具能正确引用新版角色文件
□ 通过 @agent 名称 能正常调用每个 subagent
□ （直接嵌入模式）角色定义正文已替换为最新版本
```

---

## 修订记录

| 版本 | 日期 | 修订内容 |
|------|------|----------|
| v0.6 | 2026-05-27 | 新增步骤 3b「初始化 Subagent 版本跟踪」和第 4 章「更新 Subagent」，MANIFEST 扩展支持 agent 文件 |
| v0.5 | 2026-05-24 | 验证清单中将 STATUS.md 标记为必选，增加初始内容要求 |
| v0.3 | 2026-04-04 | Agent 角色不再复制到目标项目，改为通过 setup/ 指南由 AI 工具按需引用 |
| v0.2 | 2026-04-04 | 部署目标改为 docs/ai-engineering/ 子目录 |
| v0.1 | 2026-04-04 | 初始版本，Agent 可执行入口文件 |
