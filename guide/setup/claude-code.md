# Claude Code 安装指南

> Setup Guide for Claude Code

**所属目录**：`ai-engineering/guide/setup/`
**文档状态**：草稿
**当前版本**：v0.1
**发布日期**：2026-04-04

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
| 多 Agent | 不支持内建多 Agent，需通过规则文件模拟 |

---

## 3. 项目指令文件

在目标项目根目录创建 `CLAUDE.md`，导入研发规范和角色定义：

```markdown
# 项目：{项目名称}

## AI 研发规范

遵循 AI 软件研发工程体系，加载以下规范：

@docs/principles.md
@docs/process.md
@docs/collaboration.md

## 角色定义

当用户指定角色时，以此身份工作：

- "作为 PM Agent" → 加载 @docs/agents/pm-agent.md
- "作为 PO Agent" → 加载 @docs/agents/po-agent.md
- "作为 UI/UX Agent" → 加载 @docs/agents/uiux-agent.md
- "作为 Developer Agent" → 加载 @docs/agents/developer-agent.md
- "作为 Tester Agent" → 加载 @docs/agents/tester-agent.md

## 项目特定规则

- 技术栈：{填写}
- 测试命令：{填写}
- 构建命令：{填写}
```

### 3.1 引用方式

根据 `reference/` 文件的部署位置选择引用路径：

**方式 A：规则文件已复制到 `docs/`（推荐）**

```markdown
@docs/principles.md
@docs/process.md
@docs/collaboration.md
```

**方式 B：通过 Git Submodule 引用**

```bash
git submodule add https://github.com/lpreterite/ai-engineering.git docs/ai-engineering
```

```markdown
@docs/ai-engineering/reference/principles.md
@docs/ai-engineering/reference/process.md
@docs/ai-engineering/reference/collaboration.md
```

---

## 4. 按角色加载

Claude Code 不支持内建多 Agent 切换，可通过以下方式实现角色聚焦：

### 方案 A：使用 `.claude/rules/` 按文件类型触发

```
.claude/
├── CLAUDE.md              # 主指令（包含通用规范）
└── rules/
    ├── pm-rules.md        # PM Agent 相关规则
    ├── po-rules.md        # PO Agent 相关规则
    └── dev-rules.md       # Developer Agent 相关规则
```

每个规则文件内容：

```markdown
---
globs: ["docs/product/**", "docs/project-management/**"]
---

{pm-agent.md 的核心内容}
```

### 方案 B：手动切换角色提示

在 `CLAUDE.md` 中定义角色切换指令（如上文 3. 示例），用户通过自然语言指定角色。

---

## 5. 完整示例

```markdown
# 项目：MyApp

## 研发规范

遵循 AI 软件研发工程体系。

@docs/principles.md
@docs/process.md
@docs/collaboration.md
@docs/checklists.md

## 角色定义

- 作为 PM Agent 时：@docs/agents/pm-agent.md
- 作为 PO Agent 时：@docs/agents/po-agent.md
- 作为 UI/UX Agent 时：@docs/agents/uiux-agent.md
- 作为 Developer Agent 时：@docs/agents/developer-agent.md
- 作为 Tester Agent 时：@docs/agents/tester-agent.md

## 项目特定规则

- 技术栈：React + TypeScript + Node.js
- 测试命令：npm test
- 构建命令：npm run build
- 包管理器：pnpm
```

---

## 6. 验证

安装完成后，在 Claude Code 中执行以下检查：

```
□ 运行 /init 确认 CLAUDE.md 被正确加载
□ 提问 "当前项目的研发规范是什么？" 验证规范已生效
□ 指定角色 "作为 PM Agent 检查项目状态" 验证角色加载
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
