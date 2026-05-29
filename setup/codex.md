# Codex CLI 安装指南

> Setup Guide for Codex CLI

**所属目录**：`ai-engineering/setup/`
**文档状态**：草稿
**当前版本**：v0.3
**发布日期**：2026-04-05

---

## 1. 概述

本指南说明如何将 AI 软件研发工程体系的规范和 Agent 角色集成到 [Codex CLI](https://github.com/openai/codex) 中。

---

## 2. Codex CLI 指令机制

| 特性 | 说明 |
|------|------|
| 指令文件 | `AGENTS.md` |
| 项目级位置 | `./AGENTS.md` |
| 全局级位置 | `~/.codex/AGENTS.md` |
| 子目录指令 | 支持（嵌套 `AGENTS.md`） |
| 外部文件引用 | 自动发现子目录 |
| Agent 配置 | `.codex/config.toml` |
| 多 Agent | 支持 subagent 配置 |

---

## 3. 项目指令文件

在目标项目根目录创建 `AGENTS.md`，可直接使用模板文件：

```bash
cp vendor/ai-engineering/reference/templates/codex-AGENTS.md.example ./AGENTS.md
```

AGENTS.md 定义编排中枢的身份、Gate 流程框架、核心规则、Sub-agent 调度表和规范文档索引。详见 `reference/templates/codex-AGENTS.md.example`。

如需定制，修改 `{项目名称}` 占位符即可。

---

## 4. Agent 文件生成指南

Codex CLI 支持在 `.codex/` 中配置 subagent。Agent 角色定义保留在 `ai-engineering/agents/` 目录中。

> **重要**：Codex CLI **不支持文件引用**，`developer_instructions` 必须包含完整的角色提示词内容，需将 `agents/*.md` 的内容直接粘贴到配置中。

### 4.1 官方规范字段

基于 Codex CLI 官方规范，Agent 配置使用 **TOML 格式**，支持以下字段：

**Agent 文件字段**（`.codex/agents/*.toml`）：

| 字段 | 必填 | 说明 |
|------|------|------|
| `name` | **是** | Agent 唯一标识符 |
| `description` | **是** | Agent 功能描述，决定何时调用此 Agent |
| `developer_instructions` | **是** | 完整系统提示词（**不支持文件引用，必须内联**） |
| `model` | 否 | 覆盖模型，如 `o3`, `o4-mini`, `gpt-4.1` |
| `model_reasoning_effort` | 否 | 推理强度：`low`, `medium`, `high` |
| `sandbox_mode` | 否 | 沙箱模式：`read-only`, `workspace-write` |
| `nickname_candidates` | 否 | 别名列表，用于 Agent 匹配 |
| `mcp_servers` | 否 | 作用于此 Agent 的 MCP 服务器配置 |

**全局配置字段**（`.codex/config.toml` 的 `[agents]` 节）：

| 字段 | 默认值 | 说明 |
|------|--------|------|
| `max_threads` | 6 | 最大并行 Agent 线程数 |
| `max_depth` | 1 | Agent 嵌套深度（0 = 不允许调用其他 Agent） |
| `job_max_runtime_seconds` | — | 单个 Agent 任务最大运行时间 |

**沙箱模式说明**：

| 模式 | 说明 | 适用角色 |
|------|------|----------|
| `read-only` | 只读文件系统，不可写入 | PO Agent, UI/UX Agent, Tester Agent |
| `workspace-write` | 可写入工作区 | Orchestrator Agent, Full-stack Developer Agent |

> **内置 Agent**：Codex CLI 提供 `default`, `worker`, `explorer` 三个内置 Agent，自定义 Agent 与之共存。

### 4.2 配置方式一：独立 Agent 文件（推荐）

在 `.codex/agents/` 目录创建独立的 `.toml` 文件，每个角色一个文件：

```bash
mkdir -p .codex/agents
```

#### 五个角色的完整配置

**`.codex/agents/orchestrator.toml`** — Orchestrator Agent

```toml
name = "orchestrator"
description = "Orchestrator Agent — 编排中枢，驱动多智能体编排流程、路由任务、门控质量、引导用户。当需要项目编排、任务路由、进度跟踪或流程引导时使用"
model = "o4-mini"
model_reasoning_effort = "medium"
sandbox_mode = "workspace-write"
nickname_candidates = ["orchestrator", "orch", "编排"]
developer_instructions = """
{将 ai-engineering/agents/orchestrator-agent.md 的完整内容粘贴到此处}

## 补充规范

遵循以下研发规范（按需引用）：
- docs/ai-engineering/principles.md — 核心原则
- docs/ai-engineering/process.md — 研发流程
- docs/ai-engineering/collaboration.md — 协作协议
"""
```

**`.codex/agents/po.toml`** — PO Agent

```toml
name = "po"
description = "PO Agent — 需求分析、PRD 起草，从模糊诉求中提炼清晰可交付的需求。当需要分析需求、起草 PRD 或用户调研时使用"
model = "o4-mini"
model_reasoning_effort = "high"
sandbox_mode = "read-only"
nickname_candidates = ["po", "product-owner", "产品经理"]
developer_instructions = """
{将 ai-engineering/agents/po-agent.md 的完整内容粘贴到此处}

## 补充规范

遵循以下研发规范（按需引用）：
- docs/ai-engineering/principles.md — 核心原则
- docs/ai-engineering/process.md — 研发流程
- docs/ai-engineering/deliverables.md — 产出物要求
"""
```

**`.codex/agents/uiux.toml`** — UI/UX Agent

```toml
name = "uiux"
description = "UI/UX Agent — 用户方案设计，设计规范制定、设计稿和交互说明。当需要设计界面、制定设计规范或交互说明时使用"
model = "o4-mini"
model_reasoning_effort = "medium"
sandbox_mode = "read-only"
nickname_candidates = ["uiux", "designer", "设计师"]
developer_instructions = """
{将 ai-engineering/agents/uiux-agent.md 的完整内容粘贴到此处}

## 补充规范

遵循以下研发规范（按需引用）：
- docs/ai-engineering/principles.md — 核心原则
- docs/ai-engineering/deliverables.md — 产出物要求
"""
```

**`.codex/agents/developer.toml`** — Full-stack Developer Agent

```toml
name = "developer"
description = "Full-stack Developer Agent — 全栈技术实施，覆盖前端、后端、数据库与 DevOps。当需要编写代码、修复 Bug 或技术重构时使用"
model = "o3"
model_reasoning_effort = "high"
sandbox_mode = "workspace-write"
nickname_candidates = ["developer", "dev", "开发者"]
developer_instructions = """
{将 ai-engineering/agents/fullstack-developer.md 的完整内容粘贴到此处}

## 补充规范

遵循以下研发规范（按需引用）：
- docs/ai-engineering/principles.md — 核心原则
- docs/ai-engineering/process.md — 研发流程
- docs/ai-engineering/checklists.md — 检查清单
"""
```

**`.codex/agents/tester.toml`** — Tester Agent

```toml
name = "tester"
description = "Tester Agent — 测试执行，功能测试、回归测试和验收测试，证据驱动的质量验证。当需要编写测试、执行测试或验证质量时使用"
model = "o4-mini"
model_reasoning_effort = "high"
sandbox_mode = "read-only"
nickname_candidates = ["tester", "qa", "测试"]
developer_instructions = """
{将 ai-engineering/agents/tester-agent.md 的完整内容粘贴到此处}

## 补充规范

遵循以下研发规范（按需引用）：
- docs/ai-engineering/principles.md — 核心原则
- docs/ai-engineering/checklists.md — 检查清单
- docs/ai-engineering/deliverables.md — 产出物要求
"""
```

目录结构：

```
.codex/
├── config.toml              # 全局配置（可选）
└── agents/
    ├── orchestrator.toml    # Orchestrator Agent
    ├── po.toml              # PO Agent
    ├── uiux.toml            # UI/UX Agent
    ├── developer.toml       # Full-stack Developer Agent
    └── tester.toml          # Tester Agent
```

### 4.3 配置方式二：集中式 config.toml

将所有 Agent 定义集中在 `.codex/config.toml` 中，适合 Agent 较少或快速启动的项目：

```toml
[agents]
max_threads = 5
max_depth = 1

[agents.orchestrator]
name = "orchestrator"
description = "Orchestrator Agent — 编排中枢，驱动多智能体编排流程、路由任务、门控质量、引导用户"
model = "o4-mini"
model_reasoning_effort = "medium"
sandbox_mode = "workspace-write"
nickname_candidates = ["orchestrator", "orch", "编排"]
developer_instructions = """
{将 ai-engineering/agents/orchestrator-agent.md 的完整内容粘贴到此处}

## 补充规范

遵循以下研发规范（按需引用）：
- docs/ai-engineering/principles.md
- docs/ai-engineering/process.md
- docs/ai-engineering/collaboration.md
"""

[agents.po]
name = "po"
description = "PO Agent — 需求分析、PRD 起草，从模糊诉求中提炼清晰可交付的需求"
model = "o4-mini"
model_reasoning_effort = "high"
sandbox_mode = "read-only"
nickname_candidates = ["po", "product-owner", "产品经理"]
developer_instructions = """
{将 ai-engineering/agents/po-agent.md 的完整内容粘贴到此处}

## 补充规范

遵循以下研发规范（按需引用）：
- docs/ai-engineering/principles.md
- docs/ai-engineering/process.md
- docs/ai-engineering/deliverables.md
"""

[agents.uiux]
name = "uiux"
description = "UI/UX Agent — 用户方案设计，设计规范制定、设计稿和交互说明"
model = "o4-mini"
model_reasoning_effort = "medium"
sandbox_mode = "read-only"
nickname_candidates = ["uiux", "designer", "设计师"]
developer_instructions = """
{将 ai-engineering/agents/uiux-agent.md 的完整内容粘贴到此处}

## 补充规范

遵循以下研发规范（按需引用）：
- docs/ai-engineering/principles.md
- docs/ai-engineering/deliverables.md
"""

[agents.developer]
name = "developer"
description = "Full-stack Developer Agent — 全栈技术实施，覆盖前端、后端、数据库与 DevOps"
model = "o3"
model_reasoning_effort = "high"
sandbox_mode = "workspace-write"
nickname_candidates = ["developer", "dev", "开发者"]
developer_instructions = """
{将 ai-engineering/agents/fullstack-developer.md 的完整内容粘贴到此处}

## 补充规范

遵循以下研发规范（按需引用）：
- docs/ai-engineering/principles.md
- docs/ai-engineering/process.md
- docs/ai-engineering/checklists.md
- docs/ai-engineering/deliverables.md
"""
```

> 集中式配置适合快速启动。当角色定义较长时，推荐使用 4.2 独立文件方式，便于维护。

### 4.4 使用方式

```bash
# 通过自然语言委派任务给指定 Agent
# Orchestrator Agent 检查项目状态
# 让 developer 实现用户登录功能
# 让 po 起草 PRD 文档

# CSV 批量任务（Codex CLI 特有）
# 通过 spawn_agents_on_csv 并行执行多行任务
```

---

## 5. Skill 部署与集成

### 5.1 技能来源

`skills/` 目录包含 10 个独立 Skill，每个 Skill 封装了一个领域工具或流程运作。Codex CLI 不原生支持 Skill 目录，技能通过 `developer_instructions` 中注明按需调用。

### 5.2 部署说明

Codex CLI 无内建 Skill 加载机制，Skill 作为 Agent 提示词的一部分工作：

1. 每个 Agent 角色文件（`agents/*.md`）的 **§工具箱（Skills）** 章节定义了该角色的 Skill 路由表
2. 该路由表随 `developer_instructions` 完整内联到 Agent 配置中
3. Agent 在对应场景下按路由表描述自动加载 Skill

### 5.3 一键全量部署

使用 `scripts/deploy-all.sh` 完成规范、Agent 角色和 Issue 模板的部署：

```bash
# 仅 Codex 不支持技能文件复制，其余组件正常部署
./vendor/ai-engineering/scripts/deploy-all.sh . --tool opencode
```

> 注意：Codex CLI 无 `.claude/skills/` 或 `.opencode/skills/` 等效目录。如需手动查阅 Skill 内容，直接读取 `vendor/ai-engineering/skills/*/SKILL.md`。

---

## 6. 全局配置

将通用工作协议写入 `~/.codex/AGENTS.md`，所有项目自动继承：

```markdown
# 工作协议

- 提交前运行测试
- 遵循项目的 AGENTS.md 指令
- 使用约定式提交信息
```

全局 Agent 目录 `~/.codex/agents/` 可存放所有项目共享的 Agent 定义。

---

## 7. 完整部署流程

```
步骤 1：复制 guide/ 规则文件到 docs/ai-engineering/
步骤 2：将 ai-engineering 引入项目（Git Submodule / 本地路径）
步骤 3：创建 AGENTS.md 主指令文件
步骤 4：创建 .codex/agents/ 独立文件或 .codex/config.toml，将 agents/ 角色内容粘贴到 developer_instructions
步骤 5：验证 Agent 加载
```

---

## 8. 验证

安装完成后，在 Codex CLI 中执行以下检查：

```
□ 确认 AGENTS.md 被正确加载
□ 提问 "当前项目的研发规范是什么？" 验证规范已生效
□ 调用 subagent 确认角色功能正常
□ 验证 developer Agent 的 sandbox_mode 为 workspace-write
□ 验证 tester Agent 的 sandbox_mode 为 read-only
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
| v0.4 | 2026-05-29 | 新增 §5「Skill 部署与集成」章节（含 Codex 无 Skill 目录的特殊说明）；§5→§6→§7→§8 重编号 |
| v0.2 | 2026-04-04 | 重构：拆分独立 Agent 文件和集中式配置两种方式，修正交叉引用路径 |
| v0.1 | 2026-04-04 | 从 08 工具集成指南拆分，独立成文 |
