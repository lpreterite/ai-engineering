# 文档目录结构

> Document Directory Structure

**文档状态**：已发布
**当前版本**：v0.3
**发布日期**：2026-04-04

---

## 1. 概述

本文档定义 AI 软件研发流程中产生的所有文档在目标项目代码仓库中的存放位置和目录结构。

Agent 应按照本规范在目标项目中创建和维护 `docs/` 目录。

---

## 2. 顶层目录结构

```
target-project/
├── docs/                              # 项目文档根目录
│   ├── README.md                      # 项目文档索引
│   ├── STATUS.md                      # 项目状态卡（PM Agent 核心输入/输出）
│   │
│   ├── ai-engineering/                # AI 研发规范
│   │   ├── principles.md              # AI 研发核心原则
│   │   ├── process.md                 # AI 研发流程规范
│   │   ├── collaboration.md           # 人机协作协议
│   │   ├── checklists.md              # 阶段门控检查清单
│   │   ├── deliverables.md            # 关键文档/产出物要求
│   │   └── document-management.md     # 文档管理规范
│   │
│   ├── product/                       # 产品相关文档
│   │   ├── PRD.md                     # 产品需求文档
│   │   └── user-stories.md            # 用户故事
│   │
│   ├── engineering/                   # 工程实现文档
│   │   ├── technical-spec.md          # 技术规格
│   │   └── architecture.md            # 架构设计
│   │
│   ├── design/                        # 设计文档
│   │   ├── design-system.md           # 设计系统
│   │   ├── page-design.md             # 页面设计
│   │   └── files/                     # 设计资源文件
│   │
│   ├── project-management/            # 项目管理文档
│   │   ├── project-plan.md            # 项目计划
│   │   ├── milestones.md              # 里程碑规划
│   │   └── risk-management.md         # 风险管理
│   │
│   └── project-tasks/                 # 任务跟踪（按周组织）
│       ├── README.md                  # 任务目录索引
│       ├── W06-W07/                   # 第6-7周（合并周）
│       │   ├── STATUS.md              # 周状态
│       │   ├── tasklist.md            # 任务清单
│       │   ├── review.md              # 验收报告
│       │   └── problems/              # 问题记录
│       └── W10/                       # 第10周
│           ├── STATUS.md
│           ├── tasklist.md
│           ├── review.md
│           └── problems/
│
├── CLAUDE.md                          # Claude Code 指令文件（如使用）
├── AGENTS.md                          # OpenCode / Codex 指令文件（如使用）
└── ...
```

---

## 3. 文档分类

### 3.1 研发规范文件（docs/ai-engineering/）

从 AI 软件研发工程体系部署到目标项目的核心规则文件：

| 文件 | 说明 | 必选 |
|------|------|------|
| `principles.md` | AI 研发核心原则、人机分工原则、能力边界 | 是 |
| `process.md` | 研发流程、阶段门控、阈值、人类介入点 | 是 |
| `collaboration.md` | 人机协作协议、逐步审查核对细则、升级机制 | 是 |
| `checklists.md` | 各 Gate 检查清单、周检查清单 | 否 |
| `deliverables.md` | 产出物清单、模板、验收标准 | 否 |
| `document-management.md` | 文档生命周期、命名规范、同步规则 | 否 |

> 部署时，将 `guide/` 目录中对应的 6 个 `.md` 文件直接复制到目标项目的 `docs/ai-engineering/` 目录。

### 3.2 产品文档（docs/product/）

定义产品需求，包括 PRD、用户故事等。

| 文件 | 维护者 | 创建时机 |
|------|--------|----------|
| `PRD.md` | PO Agent | 打磨阶段开始时 |
| `user-stories.md` | PO Agent | PRD 细化时 |

### 3.3 工程文档（docs/engineering/）

定义技术实现，包括技术规格、架构设计等。

| 文件 | 维护者 | 创建时机 |
|------|--------|----------|
| `technical-spec.md` | Developer Agent | Gate 1 通过后 |
| `architecture.md` | Developer Agent | Gate 1 通过后 |

### 3.4 设计文档（docs/design/）

定义设计规范和设计稿，包括设计系统、页面设计等。

| 文件 | 维护者 | 创建时机 |
|------|--------|----------|
| `design-system.md` | UI/UX Agent | Gate 1 通过后 |
| `page-design.md` | UI/UX Agent | Gate 1 通过后 |
| `files/` | UI/UX Agent | 需要时 |

### 3.5 项目管理文档（docs/project-management/）

定义项目管理相关，包括项目计划、里程碑、风险管理等。

| 文件 | 维护者 | 创建时机 |
|------|--------|----------|
| `project-plan.md` | PM Agent | 项目初始化时 |
| `milestones.md` | PM Agent | 项目初始化时 |
| `risk-management.md` | PM Agent | 识别到风险时 |

### 3.6 任务跟踪文档（docs/project-tasks/）

按周组织，记录任务执行和问题跟踪。

---

## 4. AI Agent 与文档的关系

### 4.1 PM Agent

PM Agent 基于现有文档体系运作，无需创建新的存储结构。

```
PM Agent 通过读写这些文档与其他 Agent 和人工团队协作：
├── docs/STATUS.md               ← PM Agent 核心输入/输出
├── docs/project-management/
│   ├── project-plan.md          ← 项目元数据
│   ├── milestones.md            ← 阶段详细规划
│   └── risk-management.md       ← 风险登记
└── docs/project-tasks/
    └── W{nn}/                   ← 任务与问题跟踪
        ├── STATUS.md            ← 周状态
        ├── tasklist.md          ← 任务清单
        └── problems/            ← 问题记录
```

### 4.2 其他 Agent

| Agent | 主要读取 | 主要写入 |
|-------|----------|----------|
| PO Agent | PRD.md, user-stories.md | PRD.md |
| UI/UX Agent | PRD.md | design-system.md, page-design.md |
| Developer Agent | technical-spec.md, architecture.md | 代码 |
| Tester Agent | technical-spec.md, PRD.md | review.md |

---

## 5. 路径规范

### 5.1 相对路径引用

文档间相互引用时使用相对路径：

```markdown
[项目状态卡](./STATUS.md)
[PRD文档](./product/PRD.md)
```

### 5.2 绝对路径引用

在代码中引用文档时使用绝对路径：

```typescript
const DOCS_PATH = 'docs';
const PRD_PATH = `${DOCS_PATH}/product/PRD.md`;
```

---

## 修订记录

| 版本 | 日期 | 修订内容 |
|------|------|----------|
| v0.3 | 2026-04-04 | 修正规范来源目录为 guide/，移除 agents/ 子目录（角色不再复制到目标项目） |
| v0.2 | 2026-04-04 | 重写：移除旧 ai-engineering/ 子目录结构，更新为直接部署模式 |
| v0.1 | 2026-04-04 | 初始版本 |
