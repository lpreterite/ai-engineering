# 主仓库自管理规范

> Meta-Governance for the AI Engineering Repository

**所属目录**：`ai-engineering/internal/`
**文档状态**：草稿
**当前版本**：v0.1
**发布日期**：2026-05-24
**来源仓库**：`lpreterite/ai-engineering`
**源文件路径**：`internal/README.md`

---

## 1. 概述

本目录定义 **AI 软件研发工程体系主仓库（ai-engineering）** 的自管理规范。

与 `guide/` 不同——`guide/` 面向下游目标项目，部署到 `docs/ai-engineering/`；`internal/` 仅服务本仓库的维护和治理，**不部署到下游**。

---

## 2. 文件索引

| 文件 | 功能 | 维护者 | 查阅场景 |
|------|------|--------|----------|
| [repo-governance.md](./repo-governance.md) | Issue/PR 管理、分支策略、CI 标准 | PM Agent | 日常仓库维护 |
| [release-workflow.md](./release-workflow.md) | 版本发布操作手册 | PM Agent | 每次发版前 |
| [development-guide.md](./development-guide.md) | 修改 guide/、agents/ 的约束和流程 | 贡献者 | 修改规范文件前 |

---

## 3. 使用方式

| 角色 | 应阅读的文档 |
|------|-------------|
| **PM Agent** | `repo-governance.md`（治理规则）、`release-workflow.md`（发版） |
| **贡献者** | `development-guide.md`（修改约束） |
| **Tester Agent** | `repo-governance.md` 中的 PR 审查 checklist |

---

## 4. 相关文档

| 文档 | 路径 |
|------|------|
| Issue 工作流规范 | [../guide/issue-workflow.md](../guide/issue-workflow.md) |
| 文档目录结构 | [../reference/directory.md](../reference/directory.md) |
| Agent 部署指南 | [../setup.md](../setup.md) |
| 非破坏性更新协议 | [../guide/08-tool-integration-guide.md](../guide/08-tool-integration-guide.md#6-非破坏性更新机制) |

---

## 修订记录

| 版本 | 日期 | 修订内容 |
|------|------|----------|
| v0.1 | 2026-05-24 | 初始版本：定义 internal/ 目录结构和索引 |
