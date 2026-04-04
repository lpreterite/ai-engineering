# Claude Code 安装指南

> Setup Guide for Claude Code

**所属目录**：`ai-engineering/setup/`
**文档状态**：草稿
**当前版本**：v0.2
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

## 4. 按角色加载

Claude Code 不支持内建多 Agent 切换，Agent 角色定义保留在 `ai-engineering/agents/` 目录中，不复制到目标项目。

当用户指定角色时，Claude Code 通过 `@path` 引用直接读取角色文件：

```markdown
## 角色定义

当用户指定角色时，以此身份工作：

- "作为 PM Agent" → 加载 @{ai-engineering 路径}/agents/pm-agent.md
- "作为 PO Agent" → 加载 @{ai-engineering 路径}/agents/po-agent.md
- "作为 UI/UX Agent" → 加载 @{ai-engineering 路径}/agents/uiux-agent.md
- "作为 Developer Agent" → 加载 @{ai-engineering 路径}/agents/developer-agent.md
- "作为 Tester Agent" → 加载 @{ai-engineering 路径}/agents/tester-agent.md
```

> `{ai-engineering 路径}` 取决于部署方式。如用 Git Submodule 引入到 `vendor/ai-engineering/`，则写 `@vendor/ai-engineering/agents/pm-agent.md`。

### 方案 A：使用 `.claude/rules/` 按文件类型触发

```
.claude/
├── CLAUDE.md              # 主指令（包含通用规范）
└── rules/
    ├── pm-rules.md        # PM Agent 相关规则
    ├── po-rules.md        # PO Agent 相关规则
    └── dev-rules.md       # Developer Agent 相关规则
```

每个规则文件引用角色定义：

```markdown
---
paths: ["docs/product/**", "docs/project-management/**"]
---

@{ai-engineering 路径}/agents/pm-agent.md
```

### 方案 B：手动切换角色提示

在 `CLAUDE.md` 中定义角色切换指令（如上文示例），用户通过自然语言指定角色。

---

## 5. 完整示例

以下示例采用 **方式 A（规范文件已复制到 `docs/ai-engineering/`）+ Git Submodule 引入 ai-engineering 仓库**的混合部署方式：研发规范从本地 `docs/` 读取，Agent 角色从 submodule 路径加载。

```markdown
# 项目：MyApp

## 研发规范

遵循 AI 软件研发工程体系。

@docs/ai-engineering/principles.md
@docs/ai-engineering/process.md
@docs/ai-engineering/collaboration.md
@docs/ai-engineering/checklists.md

## 角色定义

当用户指定角色时，以此身份工作：

- "作为 PM Agent" → 加载 @vendor/ai-engineering/agents/pm-agent.md
- "作为 PO Agent" → 加载 @vendor/ai-engineering/agents/po-agent.md
- "作为 UI/UX Agent" → 加载 @vendor/ai-engineering/agents/uiux-agent.md
- "作为 Developer Agent" → 加载 @vendor/ai-engineering/agents/developer-agent.md
- "作为 Tester Agent" → 加载 @vendor/ai-engineering/agents/tester-agent.md

## 项目特定规则

- 技术栈：React + TypeScript + Node.js
- 测试命令：npm test
- 构建命令：npm run build
- 包管理器：pnpm
```

> 如果未使用 Git Submodule，将角色路径替换为实际的 ai-engineering 目录相对路径。

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
| Agent 使用指南 | [../guide/08-tool-integration-guide.md](../guide/08-tool-integration-guide.md) |
| Agent 角色总览 | [../agents/README.md](../agents/README.md) |

---

## 修订记录

| 版本 | 日期 | 修订内容 |
|------|------|----------|
| v0.2 | 2026-04-04 | 修正规则 frontmatter 字段名，补充完整示例部署方式说明，修正交叉引用路径 |
| v0.1 | 2026-04-04 | 从 08 工具集成指南拆分，独立成文 |
