# AI 软件研发工程体系

> AI-Native Software Engineering Methodology

**所属目录**：`ai-engineering/`
**文档状态**：设计中
**当前版本**：v1.1.0
**最后更新**：2026-05-30

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
├── README.md                     # 本文件
├── STATUS.md                     # 项目状态
├── RELEASE.json                  # 发布版本注册表（版本比对输入）
├── setup.md                      # ★ Agent 执行入口（部署规范+安装角色+工具配置）
│
├── guide/                        # 研发规范（面向所有 AI，理解整体流程）
│   ├── 01-principles.md          # 核心原则、人机分工、能力边界
│   ├── 02-process.md             # 研发流程、阶段门控、阈值
│   ├── 03-collaboration.md       # 人机协作协议、逐步审查核对、升级机制
│   ├── 04-checklists.md          # 各 Gate 检查清单、周检查清单
│   ├── 05-deliverables.md        # 关键文档/产出物要求、模板、验收标准
│   ├── 06-document-management.md # 文档生命周期、命名规范、同步规则
│   ├── 07-repo-directory-guide.md # Repo 目录初始化指南（Agent 执行用）
│   ├── 08-tool-integration-guide.md # Agent 使用指南（部署规范+安装角色+非破坏性更新）
│   └── 09-downstream-sync-guide.md # 下游同步指南（面向下游仓库维护者）
│
├── setup/                        # 工具安装指南
│   ├── claude-code.md            # Claude Code 安装配置
│   ├── opencode.md               # OpenCode 安装配置（含 deploy-agents.sh）
│   └── codex.md                  # Codex CLI 安装配置
│
├── agents/                       # Agent 角色定义（每个角色独立文件）
│   ├── README.md                 # 角色总览、协作矩阵、协作协议
│   ├── orchestrator-agent.md     # Orchestrator Agent — 编排中枢
│   ├── po-agent.md               # PO Agent — 需求分析、PRD 起草
│   ├── uiux-agent.md             # UI/UX Agent — 用户方案设计
│   ├── fullstack-developer.md    # Full-stack Developer Agent — 全栈技术实施
│   └── tester-agent.md           # Tester Agent — 测试执行
│
├── scripts/                      # 自动化脚本
│   ├── bump-version.sh           # 批量更新 guide/*.md 头部版本号
│   ├── validate-release.sh       # 发布前验证（版本一致性 + 来源元数据）
│   └── downstream-sync.sh       # 下游仓库规范文件自动同步脚本
│
└── reference/                    # 参考资料
    ├── directory.md              # 项目文档目录结构规范
    └── templates/                # 模板文件
        └── opencode-workflow.yml # GitHub Actions CI/CD 模板
```

---

## 文档索引

| [setup.md](./setup.md) | **Agent 执行入口** — 部署规范、安装角色、工具配置、Subagent 版本跟踪 | ✅ 完成 |
| [RELEASE.json](./RELEASE.json) | **发布版本注册表** — 所有文件版本快照，下游版本比对输入 | ✅ 完成 |

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
| [09-downstream-sync-guide.md](./guide/09-downstream-sync-guide.md) | 下游同步指南：版本比对、三路合并、冲突处理、MANIFEST 更新 | ✅ 完成 |

### 工具安装指南（setup/）

| 文档 | 说明 | 状态 |
|------|------|------|
| [claude-code.md](./setup/claude-code.md) | Claude Code 安装配置指南 | ✅ 完成 |
| [opencode.md](./setup/opencode.md) | OpenCode 安装配置指南 | ✅ 完成 |
| [codex.md](./setup/codex.md) | Codex CLI 安装配置指南 | ✅ 完成 |

### Agent 角色定义（agents/）

| 文档 | 说明 | 状态 |
|------|------|------|
| [README.md](./agents/README.md) | 角色总览、协作矩阵、协作协议 | ✅ 完成 |
| [orchestrator-agent.md](./agents/orchestrator-agent.md) | Orchestrator Agent — 编排中枢 | ✅ 完成 |
| [po-agent.md](./agents/po-agent.md) | PO Agent — 需求分析、PRD 起草 | ✅ 完成 |
| [uiux-agent.md](./agents/uiux-agent.md) | UI/UX Agent — 用户方案设计 | ✅ 完成 |
| [fullstack-developer.md](./agents/fullstack-developer.md) | Full-stack Developer Agent — 全栈技术实施（前端/后端/数据库/DevOps） | ✅ 完成 |
| [tester-agent.md](./agents/tester-agent.md) | Tester Agent — 测试执行 | ✅ 完成 |

### 参考资料（reference/）

| 文档 | 说明 | 状态 |
|------|------|------|
| [directory.md](./reference/directory.md) | 项目文档目录结构规范 | ✅ 完成 |

---

## 快速索引

### 核心概念

| 概念 | 说明 |
|------|------|
| **阶段门控** | Stage Gate，里程碑转换点的验收检查 |
| **打磨阶段** | 需求打磨，定义"做正确的事" |
| **执行阶段** | 需求实施，Agent 自主协作执行 |
| **逐步审查核对** | Agent 提取关键信息，人类多轮沟通验收 |
| **非破坏性更新** | 通过 MANIFEST 注册表和四步协议实现规范+Agent 增量升级，不覆盖定制内容 |

### 角色映射

| 角色 | 说明 | 详细文档 |
|------|------|----------|
| Product Owner (PO) | 人类，需求负责、验收把关 | - |
| Product Manager (PM) | 人类，流程协调、进度管控 | - |
| Orchestrator Agent | 编排中枢 | [orchestrator-agent.md](./agents/orchestrator-agent.md) |
| PO Agent | 需求分析、PRD 起草 | [po-agent.md](./agents/po-agent.md) |
| UI/UX Agent | 用户方案设计 | [uiux-agent.md](./agents/uiux-agent.md) |
| Full-stack Developer Agent | 全栈技术实施（前端/后端/数据库/DevOps） | [fullstack-developer.md](./agents/fullstack-developer.md) |
| Tester Agent | 测试执行 | [tester-agent.md](./agents/tester-agent.md) |

---

## 下游仓库更新指引

当用户要求 AI **更新上游规范规则**时，AI 应按以下流程操作：

1. **阅读指南** — 打开 [guide/09-downstream-sync-guide.md](./guide/09-downstream-sync-guide.md) 了解完整同步流程
2. **版本比对** — 对比上游 `RELEASE.json` 与下游 `MANIFEST.json`，识别过期文件
3. **按策略更新** — 新增文件直接复制，未定制文件直接覆盖，已定制文件三路合并
4. **更新 MANIFEST.json** — 记录新版本号、定制状态、时间戳
5. **一键脚本** — 推荐使用 `scripts/downstream-sync.sh` 自动执行上述流程

相关文件：
| 文件 | 用途 |
|------|------|
| [guide/09-downstream-sync-guide.md](./guide/09-downstream-sync-guide.md) | 完整操作指南（前提条件、操作步骤、冲突场景） |
| [scripts/downstream-sync.sh](./scripts/downstream-sync.sh) | 一键同步脚本（版本比对 + 备份 + 三路合并 + MANIFEST 更新） |

---

## 修订记录

| 版本 | 日期 | 修订内容 |
|------|------|----------|
| v1.1.0 | 2026-05-30 | 发布 v1.1.0：8 文档升版，补齐 4 遗漏文件至 RELEASE.json；修复 README 版本号同步 |
| v0.7 | 2026-05-27 | 新增 RELEASE.json 发布注册表 + scripts/ 自动化脚本；扩展非破坏性更新协议覆盖 subagent；README 补充目录结构 |
| v0.5 | 2026-04-04 | 新增 reference/ 可部署规则文件（6篇）、setup/ 工具安装指南（3篇），重写 08 为 Agent 使用指南 |
| v0.4 | 2026-04-04 | 新增 07 Repo 目录初始化指南、08 Agent 工具集成指南 |
| v0.3 | 2026-04-04 | 目录结构重构：拆分为 guide/agents/reference 三级目录，Agent 拆分为独立文件 |
| v0.2 | 2026-04-04 | 统一 Gate 编号为 1→2→3→4 |
| v0.1 | 2026-04-04 | 初始版本，规划文档结构 |
