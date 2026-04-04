# AI 软件研发工程体系

> AI-Native Software Engineering Methodology

**所属目录**：`ai-engineering/`
**文档状态**：设计中
**当前版本**：v0.6
**最后更新**：2026-04-04

---

## 概述

本目录收录 AI 软件研发工程体系的设计文档，定义在 AI 原生开发模式下：
- 人与 Agent 如何分工协作
- 阶段门控如何起到质量控制作用
- 各 Agent 角色的职责与协作接口
- 关键文档的产出标准和存放规范

---

## 目录结构

```
ai-engineering/
├── README.md
├── STATUS.md
│
├── guide/                        # 研发规范（面向所有 AI，理解整体流程）
│   ├── 01-principles.md          # 核心原则、人机分工、能力边界
│   ├── 02-process.md             # 研发流程、阶段门控、阈值
│   ├── 03-collaboration.md       # 人机协作协议、逐步审查核对、升级机制
│   ├── 04-checklists.md          # 各 Gate 检查清单、周检查清单
│   ├── 05-deliverables.md        # 关键文档/产出物要求、模板、验收标准
│   ├── 06-document-management.md # 文档生命周期、命名规范、同步规则
│   ├── 07-repo-directory-guide.md # Repo 目录初始化指南（Agent 执行用）
│   ├── 08-tool-integration-guide.md # Agent 使用指南（部署规范+安装角色）
│   └── setup/                    # 工具安装指南
│       ├── claude-code.md        # Claude Code 安装配置
│       ├── opencode.md           # OpenCode 安装配置
│       └── codex.md              # Codex CLI 安装配置
│
├── agents/                       # Agent 角色定义（每个角色独立文件）
│   ├── README.md                 # 角色总览、协作矩阵、协作协议
│   ├── pm-agent.md               # PM Agent — 协调中枢
│   ├── po-agent.md               # PO Agent — 需求分析、PRD 起草
│   ├── uiux-agent.md             # UI/UX Agent — 用户方案设计
│   ├── developer-agent.md        # Developer Agent — 技术实施
│   └── tester-agent.md           # Tester Agent — 测试执行
│
└── reference/                    # 可部署的规则文件（完整内容，直接复制到目标项目 docs/）
    ├── setup.md                  # ★ Agent 执行入口（部署规范+安装角色+工具配置）
    ├── directory.md              # 项目文档目录结构规范
    ├── principles.md             # AI 研发核心原则
    ├── process.md                # AI 研发流程规范
    ├── collaboration.md          # 人机协作协议
    ├── checklists.md             # 阶段门控检查清单
    ├── deliverables.md           # 关键文档/产出物要求
    └── document-management.md    # 文档管理规范
```

---

## 文档索引

### 研发规范（guide/）

| 文档 | 说明 | 状态 |
|------|------|------|
| [01-principles.md](./guide/01-principles.md) | AI软件研发原理：人机分工原则、门控质量控制机制、能力边界 | ✅ 完成 |
| [02-process.md](./guide/02-process.md) | AI软件研发流程：阶段、门控、人类介入点、Agent 验收机制 | ✅ 完成 |
| [03-collaboration.md](./guide/03-collaboration.md) | 人机协作协议：逐步审查核对细则、升级机制 | ✅ 完成 |
| [04-checklists.md](./guide/04-checklists.md) | 阶段门控清单：每个 Gate 的检查清单、验收要点 | ✅ 完成 |
| [05-deliverables.md](./guide/05-deliverables.md) | 关键文档说明：产出物清单、模板、验收标准 | ✅ 完成 |
| [06-document-management.md](./guide/06-document-management.md) | 文档管理规范：更新时机、频率、负责人 | ✅ 完成 |
| [07-repo-directory-guide.md](./guide/07-repo-directory-guide.md) | Repo 目录初始化指南：Agent 执行用的目录结构规范 | ✅ 完成 |
| [08-tool-integration-guide.md](./guide/08-tool-integration-guide.md) | Agent 使用指南：部署规范、安装角色、工具配置 | ✅ 完成 |

### 工具安装指南（guide/setup/）

| 文档 | 说明 | 状态 |
|------|------|------|
| [claude-code.md](./guide/setup/claude-code.md) | Claude Code 安装配置指南 | ✅ 完成 |
| [opencode.md](./guide/setup/opencode.md) | OpenCode 安装配置指南 | ✅ 完成 |
| [codex.md](./guide/setup/codex.md) | Codex CLI 安装配置指南 | ✅ 完成 |

### Agent 角色定义（agents/）

| 文档 | 说明 | 状态 |
|------|------|------|
| [README.md](./agents/README.md) | 角色总览、协作矩阵、协作协议 | ✅ 完成 |
| [pm-agent.md](./agents/pm-agent.md) | PM Agent — 协调中枢 | ✅ 完成 |
| [po-agent.md](./agents/po-agent.md) | PO Agent — 需求分析、PRD 起草 | ✅ 完成 |
| [uiux-agent.md](./agents/uiux-agent.md) | UI/UX Agent — 用户方案设计 | ✅ 完成 |
| [developer-agent.md](./agents/developer-agent.md) | Developer Agent — 技术实施 | ✅ 完成 |
| [tester-agent.md](./agents/tester-agent.md) | Tester Agent — 测试执行 | ✅ 完成 |

### 参考资料（reference/）

| 文档 | 说明 | 状态 |
|------|------|------|
| [setup.md](./reference/setup.md) | **Agent 执行入口** — 部署规范、安装角色、工具配置 | ✅ 完成 |
| [directory.md](./reference/directory.md) | 项目文档目录结构规范 | ✅ 完成 |
| [principles.md](./reference/principles.md) | AI 研发核心原则（可部署） | ✅ 完成 |
| [process.md](./reference/process.md) | AI 研发流程规范（可部署） | ✅ 完成 |
| [collaboration.md](./reference/collaboration.md) | 人机协作协议（可部署） | ✅ 完成 |
| [checklists.md](./reference/checklists.md) | 阶段门控检查清单（可部署） | ✅ 完成 |
| [deliverables.md](./reference/deliverables.md) | 产出物要求（可部署） | ✅ 完成 |
| [document-management.md](./reference/document-management.md) | 文档管理规范（可部署） | ✅ 完成 |

---

## 快速索引

### 核心概念

| 概念 | 说明 |
|------|------|
| **阶段门控** | Stage Gate，里程碑转换点的验收检查 |
| **打磨阶段** | 需求打磨，定义"做正确的事" |
| **执行阶段** | 需求实施，Agent 自主协作执行 |
| **逐步审查核对** | Agent 提取关键信息，人类多轮沟通验收 |

### 角色映射

| 角色 | 说明 | 详细文档 |
|------|------|----------|
| Product Owner (PO) | 人类，需求负责、验收把关 | - |
| Product Manager (PM) | 人类，流程协调、进度管控 | - |
| PM Agent | 协调中枢 | [pm-agent.md](./agents/pm-agent.md) |
| PO Agent | 需求分析、PRD 起草 | [po-agent.md](./agents/po-agent.md) |
| UI/UX Agent | 用户方案设计 | [uiux-agent.md](./agents/uiux-agent.md) |
| Developer Agent | 技术实施 | [developer-agent.md](./agents/developer-agent.md) |
| Tester Agent | 测试执行 | [tester-agent.md](./agents/tester-agent.md) |

---

## 修订记录

| 版本 | 日期 | 修订内容 |
|------|------|----------|
| v0.3 | 2026-04-04 | 目录结构重构：拆分为 guide/agents/reference 三级目录，Agent 拆分为独立文件 |
| v0.6 | 2026-04-04 | 新增 reference/setup.md 作为 Agent 执行入口 |
| v0.5 | 2026-04-04 | 新增 reference/ 可部署规则文件（6篇）、setup/ 工具安装指南（3篇），重写 08 为 Agent 使用指南 |
| v0.4 | 2026-04-04 | 新增 07 Repo 目录初始化指南、08 Agent 工具集成指南 |
| v0.2 | 2026-04-04 | 统一 Gate 编号为 1→2→3→4 |
| v0.1 | 2026-04-04 | 初始版本，规划文档结构 |
