# ai-engineering

## 语言要求
- 所有 Issue/PR 评论、沟通回复必须使用**简体中文**
- commit message 使用英文（保持与 git log 一致）
- 代码注释使用英文

## 项目简介
AI 原生软件研发工程体系，定义 AI 开发模式下的人机协作规范、阶段门控、多 Agent 角色与关键文档产出标准。

## 仓库目录结构

| 目录 | 用途 | 是否部署到下游 |
|------|------|---------------|
| `guide/` | 研发规范文件（原则、流程、协作、检查清单、模板） | ✅ → `docs/ai-engineering/` |
| `skills/` | Agent 技能定义（11 个 Skill，每个封装领域工具或流程） | ✅ → `.opencode/skills/` 或 `.claude/skills/` |
| `agents/` | 子 Agent 角色定义（Orchestrator / PO / UIUX / Developer / Tester） | ✅ → 生成 `.opencode/agents/*.md` |
| `setup/` | 各 AI 编程工具（OpenCode / Claude Code / Codex）的配置指南 | ✅ → 参考 |
| `scripts/` | 自动化脚本（deploy-all / bump-version / validate-release 等） | ❌ 仅本仓库 |
| `internal/` | 本仓库自管理规范（发版流程、治理规则、开发约束） | ❌ 仅本仓库 |
| `reference/` | 模板文件和目录结构参考 | ✅ → 参考 |
| `.github/ISSUE_TEMPLATE/` | Issue 表单模板 | ✅ → `.github/ISSUE_TEMPLATE/` |

## 版本管理

版本发布与 skill 版本管理规则详见 `internal/release-workflow.md`。

## Goal Issue 生命周期指令

在双阶段研发流程（打磨 → 执行）中，Agent 遵循 `goal-issue-lifecycle` skill 管理 Issue 生命周期。核心原则：**人类是流程节奏的掌控者，Agent 是响应者**。

### 核心原则：人类主导对话模式

Agent 全程遵循「识别 → 询问 → 确认 → 执行 → 汇报」循环，**绝不主动推进流程或替人类做决定**：

| 约束 | 说明 |
|------|------|
| 不主动创建 | 创建 Issue 前必须先询问人类，人类确认后才执行 |
| 不臆造内容 | 目标、验收标准、决策内容必须来自人类回答，Agent 只做记录与结构化 |
| 不自动推进 | 状态流转由人类发起（"提交门禁"/"开始执行"/"关闭"），Agent 汇报后等人类决定 |
| 步步汇报 | 每个执行动作完成后汇报结果，并给出下一步选项 |

### 创建 Goal Issue（打磨 — 草稿期）

1. 识别新目标 → 询问："这是一个新目标，需要我创建 Goal Issue 吗？"
2. 人类确认后 → 询问目标背景与验收标准（不臆造）
3. 人类回答后 → 记录到 Goal Issue（底色 draft），产出物写入 `.ai-engineering/drafts/<N>/` 隔离区
4. 汇报："已创建 #N"，给出下一步选项

### 决策/审计/改进记录

- 讨论中识别决策点（方案比较、技术选型、排除方案）→ 询问："要记录到 Issue 吗？"
- 人类确认后 → 按 comment-protocol 追加决策评论到 Goal Issue，不创建独立 Decision Issue

### 进度审查

- 人类说"看看进度" → Agent 审查 Issue 状态/评论/阻塞项/草稿 → 汇报当前状态 + 未决项 → 询问下一步

### 定稿与门禁（PO 驱动）

- **定稿**：人类批准制——产出物未定稿前留在隔离区，人类批准后复制到正式目录
- **门禁**：PO（人类角色）发起 → 里程碑划分 Gate Issue（独立验收载体）→ 隔离审核（DSH 另建会话 / OpenCode 开子会话）→ PO 终审放行/打回

### 执行阶段

- 人类确认进入执行 → 从 Goal 阻塞项展开 Task Issue（自包含规范）
- Task 独立流转（in-progress / blocked / done），人类主导节奏
- 所有阻塞项清零 → Goal done

具体操作步骤、评论格式、状态机映射等详见 `skills/goal-issue-lifecycle/`。

## 规范来源与同步

| 项目 | 说明 |
|------|------|
| 上游仓库 | `lpreterite/ai-engineering` |
| 下游同步入口 | `guide/09-downstream-sync-guide.md` |
| 版本注册 | 下游项目通过 `MANIFEST.json` 追踪版本 |
| 全量部署参考 | `setup/<tool>.md §同步更新`（按工具选择对应文档） |
