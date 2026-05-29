---
name: doc-lifecycle
version: v1.0
description: "文档全生命周期管理——创建、评审、发布、维护、归档。触发：创建新文档、更新已有文档、Gate 验收需要文档评审、里程碑完成需更新 STATUS.md、项目结束需归档时。"
---

# doc-lifecycle — 文档全生命周期管理

Type: 3 (Automation & Orchestration) + 2 (Data & Information Management)

## 工作流

### 步骤 0：前置确认 [自由度：低]
- 确认文档类型：规范文档、状态文档、设计文档、技术文档
- 确认所属目录：`docs/product/`、`docs/engineering/`、`docs/design/`、`docs/project-management/`
- → 此时加载 [references/naming-convention.md](references/naming-convention.md)

### 步骤 1：创建与起草 [自由度：中]
- 按对应模板创建文档，填写初始内容
- 文件头包含元信息（状态、版本、日期）
- 更新索引文件中的链接

### 步骤 2：评审 [自由度：低]
- 提交干系人评审
- 评审维度：完整性、准确性、一致性、可执行性
- 不通过则返回修改，通过则发布
- → 此时加载 [references/lifecycle-flow.md](references/lifecycle-flow.md)

### 步骤 3：发布 [自由度：低]
- 状态从"草稿"改为"已发布"
- 若为新版本：独立增量文件，不修改旧版本
- 更新修订记录

### 步骤 4：维护 [自由度：中]
- 根据触发条件更新文档
- 每次更新记录变更日志
- 同步触发词自动检测并更新相关文档
- → 此时加载 [references/version-management.md](references/version-management.md)

### 步骤 5：归档 [自由度：低]
- 满足归档条件时执行：项目结束/阶段结束/文档过时
- 状态改为"已归档"，移至 `docs/archive/`
- 更新索引链接

## 前置条件
- 文档目录结构已初始化（`docs/product/`, `docs/engineering/`, `docs/design/`）
- 文件头模板就绪

## 完成标准
- 文档状态正确（草稿/已发布/已归档）
- 修订记录已更新
- 索引文件中的链接有效
- STATUS.md 与文档状态一致

## 回退路径
- 评审不通过 → 返回修改 → 重新提交评审（最多 3 次）
- 版本冲突 → 按增量版本规则创建新文件
- 文档链接断裂 → 自动检测后通知修复
