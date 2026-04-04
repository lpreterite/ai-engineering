# 文档目录结构

> Document Directory Structure

**所属目录**：`ai-engineering/reference/`
**文档状态**：草稿
**当前版本**：v0.1
**发布日期**：2026-04-04

---

## 1. 概述

本文档定义 AI 软件研发流程中产生的所有文档在代码仓库中的存放位置和目录结构。

---

## 2. 顶层目录结构

```
docs/
├── STATUS.md                      # 项目状态卡（PM Agent 核心输入/输出）
├── README.md                      # 项目文档索引
├── conventions.md                 # 项目管理规范
│
├── ai-engineering/                # AI 软件研发工程体系
│   ├── README.md                  # 工程体系文档索引
│   ├── STATUS.md                  # 工程体系状态卡
│   ├── 01-principles.md           # AI软件研发原理
│   ├── 02-process.md             # AI软件研发流程说明
│   ├── 03-agents.md              # Agent角色说明
│   ├── 04-documents.md            # 关键文档说明
│   ├── 05-directory.md           # 文档目录结构
│   ├── 06-protocols.md            # 文档管理规范
│   ├── 07-collaboration.md        # 人机协作协议
│   └── 08-checklists.md          # 阶段门控清单
│
├── product/                       # 产品相关文档
│   ├── PRD.md                     # 产品需求文档
│   └── user-stories.md           # 用户故事
│
├── engineering/                   # 工程实现文档
│   ├── technical-spec.md          # 技术规格
│   └── architecture.md            # 架构设计
│
├── design/                        # 设计文档
│   ├── design-system.md           # 设计系统
│   ├── page-design.md            # 页面设计
│   └── files/                    # 设计资源文件
│
├── project-management/            # 项目管理文档
│   ├── project-plan.md           # 项目计划
│   ├── milestones.md             # 里程碑规划
│   └── risk-management.md        # 风险管理
│
└── project-tasks/                 # 任务跟踪（按周组织）
    ├── README.md                  # 任务目录索引
    ├── W06-W07/                  # 第6-7周（合并周）
    │   ├── STATUS.md             # 周状态
    │   ├── tasklist.md           # 任务清单
    │   ├── review.md             # 验收报告
    │   └── problems/             # 问题记录
    └── W10/                      # 第10周
        ├── STATUS.md
        ├── tasklist.md
        ├── review.md
        └── problems/
```

---

## 3. 文档分类

### 3.1 工程体系文档（ai-engineering/）

定义 AI 软件研发的人机协作规范，包括流程、角色、协议等。

### 3.2 产品文档（product/）

定义产品需求，包括 PRD、用户故事等。

### 3.3 工程文档（engineering/）

定义技术实现，包括技术规格、架构设计等。

### 3.4 设计文档（design/）

定义设计规范和设计稿，包括设计系统、页面设计等。

### 3.5 项目管理文档（project-management/）

定义项目管理相关，包括项目计划、里程碑、风险管理等。

### 3.6 任务跟踪文档（project-tasks/）

按周组织，记录任务执行和问题跟踪。

---

## 4. AI Agent 与文档的关系

### 4.1 PM Agent

PM Agent 基于现有文档体系运作，无需创建新的存储结构。

```
PM Agent 通过读写这些文档与其他 Agent 和人工团队协作：
├── STATUS.md                    ← PM Agent 核心输入/输出
├── milestones.md               ← 阶段目标与验收标准
├── project-management/
│   ├── project-plan.md         ← 项目元数据
│   ├── risk-management.md      ← 风险登记
│   └── milestones.md           ← 阶段详细规划
└── project-tasks/
    └── W{nn}/                   ← 任务与问题跟踪
        ├── STATUS.md           ← 周状态
        ├── tasklist.md         ← 任务清单
        └── problems/           ← 问题记录
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
[项目状态卡](../STATUS.md)
[PRD文档](../product/PRD.md)
```

### 5.2 绝对路径引用

在代码中引用文档时使用绝对路径：

```typescript
const DOCS_PATH = 'docs';
const PRD_PATH = `${DOCS_PATH}/product/PRD.md`;
```

---

## 附录：相关文档

| 文档 | 路径 |
|------|------|
| 关键文档说明 | [../guide/05-deliverables.md](../guide/05-deliverables.md) |
| 项目状态卡 | [../STATUS.md](../STATUS.md) |

---

## 修订记录

| 版本 | 日期 | 修订内容 |
|------|------|----------|
| v0.1 | 2026-04-04 | 初始版本 |