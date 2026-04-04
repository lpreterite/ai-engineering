# Codex CLI 安装指南

> Setup Guide for Codex CLI

**所属目录**：`ai-engineering/guide/setup/`
**文档状态**：草稿
**当前版本**：v0.1
**发布日期**：2026-04-04

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

在目标项目根目录创建 `AGENTS.md`：

```markdown
# 项目：{项目名称}

## AI 研发规范

遵循 AI 软件研发工程体系。

核心规范位于：
- docs/principles.md — 核心原则
- docs/process.md — 研发流程
- docs/collaboration.md — 协作协议
- docs/checklists.md — 检查清单
- docs/deliverables.md — 产出物要求
- docs/document-management.md — 文档管理

## 角色定义

当需要特定角色能力时，参照以下文件：
- PM Agent：docs/agents/pm-agent.md
- PO Agent：docs/agents/po-agent.md
- UI/UX Agent：docs/agents/uiux-agent.md
- Developer Agent：docs/agents/developer-agent.md
- Tester Agent：docs/agents/tester-agent.md
```

---

## 4. Subagent 配置

Codex CLI 支持在 `.codex/config.toml` 中配置 subagent：

```toml
[agents.pm]
name = "pm"
description = "PM Agent — 项目协调中枢，统筹进度与协作"
developer_instructions = """
{pm-agent.md 的核心内容}

遵循研发规范，参照 docs/principles.md 和 docs/process.md。
"""

[agents.po]
name = "po"
description = "PO Agent — 需求分析与 PRD 起草"
developer_instructions = """
{po-agent.md 的核心内容}

遵循研发规范，参照 docs/principles.md 和 docs/process.md。
"""

[agents.uiux]
name = "uiux"
description = "UI/UX Agent — 用户方案设计"
developer_instructions = """
{uiux-agent.md 的核心内容}

遵循研发规范，参照 docs/principles.md 和 docs/process.md。
"""

[agents.developer]
name = "developer"
description = "Developer Agent — 技术实施"
developer_instructions = """
{developer-agent.md 的核心内容}

遵循研发规范，参照 docs/principles.md 和 docs/process.md。
"""

[agents.tester]
name = "tester"
description = "Tester Agent — 测试执行"
developer_instructions = """
{tester-agent.md 的核心内容}

遵循研发规范，参照 docs/principles.md 和 docs/process.md。
"""
```

> 注意：`developer_instructions` 字段需要直接内联角色定义内容（不支持文件引用）。请将对应 `agents/*.md` 文件的内容复制到对应字段中。

---

## 5. 全局配置

将通用工作协议写入 `~/.codex/AGENTS.md`，所有项目自动继承：

```markdown
# 工作协议

- 提交前运行测试
- 遵循项目的 AGENTS.md 指令
- 使用约定式提交信息
```

---

## 6. 完整部署流程

```
步骤 1：复制 reference/ 规则文件到 docs/        ← 见 08 使用指南
步骤 2：复制 agents/ 角色文件到 docs/agents/
步骤 3：创建 AGENTS.md 主指令文件
步骤 4：创建 .codex/config.toml 配置 subagent
步骤 5：验证 Agent 加载
```

---

## 7. 验证

安装完成后，在 Codex CLI 中执行以下检查：

```
□ 确认 AGENTS.md 被正确加载
□ 提问 "当前项目的研发规范是什么？" 验证规范已生效
□ 调用 subagent 确认角色功能正常
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
