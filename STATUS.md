# AI 软件研发工程体系｜状态卡

> **Last Updated**：2026-04-04
> **Index**：[README](./README.md)

---

## 概览

**AI 软件研发工程体系** — 定义 AI 原生开发模式下的人机协作规范

**当前阶段**：文档设计完成

---

## 文档进度

### 研发规范（guide/）

| 文档 | 状态 | 路径 |
|------|------|------|
| AI软件研发原理 | ✅ 完成 | [guide/01-principles.md](./guide/01-principles.md) |
| AI软件研发流程说明 | ✅ 完成 | [guide/02-process.md](./guide/02-process.md) |
| 人机协作协议 | ✅ 完成 | [guide/03-collaboration.md](./guide/03-collaboration.md) |
| 阶段门控清单 | ✅ 完成 | [guide/04-checklists.md](./guide/04-checklists.md) |
| 关键文档说明 | ✅ 完成 | [guide/05-deliverables.md](./guide/05-deliverables.md) |
| 文档管理规范 | ✅ 完成 | [guide/06-document-management.md](./guide/06-document-management.md) |
| Repo 目录初始化指南 | ✅ 完成 | [guide/07-repo-directory-guide.md](./guide/07-repo-directory-guide.md) |
| Agent 工具集成指南 | ✅ 完成 | [guide/08-tool-integration-guide.md](./guide/08-tool-integration-guide.md) |

### Agent 角色定义（agents/）

| 文档 | 状态 | 路径 |
|------|------|------|
| 角色总览 | ✅ 完成 | [agents/README.md](./agents/README.md) |
| PM Agent | ✅ 完成 | [agents/pm-agent.md](./agents/pm-agent.md) |
| PO Agent | ✅ 完成 | [agents/po-agent.md](./agents/po-agent.md) |
| UI/UX Agent | ✅ 完成 | [agents/uiux-agent.md](./agents/uiux-agent.md) |
| Developer Agent | ✅ 完成 | [agents/developer-agent.md](./agents/developer-agent.md) |
| Tester Agent | ✅ 完成 | [agents/tester-agent.md](./agents/tester-agent.md) |

### 参考资料（reference/）

| 文档 | 状态 | 路径 |
|------|------|------|
| **Agent 执行入口** | ✅ 完成 | [reference/setup.md](./reference/setup.md) |
| 文档目录结构 | ✅ 完成 | [reference/directory.md](./reference/directory.md) |

### 工具安装指南（guide/setup/）

| 文档 | 状态 | 路径 |
|------|------|------|
| Claude Code 安装指南 | ✅ 完成 | [guide/setup/claude-code.md](./guide/setup/claude-code.md) |
| OpenCode 安装指南 | ✅ 完成 | [guide/setup/opencode.md](./guide/setup/opencode.md) |
| Codex CLI 安装指南 | ✅ 完成 | [guide/setup/codex.md](./guide/setup/codex.md) |

---

## 里程碑

- [x] 完成文档拆分设计（8 篇）
- [x] 创建目录结构
- [x] 创建 README.md 和 STATUS.md
- [x] 创建各文档内容（01-05）
- [x] 创建各文档内容（06-08）
- [x] 目录结构重构（guide/agents/reference）
- [x] Agent 角色拆分为独立文件
- [x] 新增 07 Repo 目录初始化指南
- [x] 新增 08 Agent 工具集成指南
- [x] 新增 reference/ 可部署规则文件（6篇）
- [x] 新增 setup/ 工具安装指南（3篇）
- [x] 重写 08 为 Agent 使用指南
- [x] 重写 reference/directory.md 更新目录结构
- [x] 新增 reference/setup.md 作为 Agent 执行入口
- [ ] 人工评审

---

## 阻塞项

暂无

---

## 最近更新

```
2026-04-04 新增 reference/ 可部署规则文件（6篇）、setup/ 工具安装指南（3篇）
2026-04-04 重写 08 为 Agent 使用指南，重写 reference/directory.md
2026-04-04 目录结构重构：拆分为 guide/agents/reference 三级目录
2026-04-04 Agent 角色从单文件拆分为 5 个独立角色文件
2026-04-04 更新所有交叉引用路径
2026-04-04 新增 07 Repo 目录初始化指南、08 Agent 工具集成指南
```
