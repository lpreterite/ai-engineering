# 贡献指南与修改约束

> Development Guide & Modification Constraints

**所属目录**：`ai-engineering/internal/`
**文档状态**：草稿
**当前版本**：v0.1
**发布日期**：2026-05-24
**来源仓库**：`lpreterite/ai-engineering`
**源文件路径**：`internal/development-guide.md`

---

## 1. 概述

本文档面向修改 ai-engineering 主仓库的贡献者，定义修改 `guide/`、`agents/`、`reference/` 等目录时的约束和流程。

---

## 2. 修改 guide/ 的约束

### 2.1 通用规则

| 规则 | 说明 |
|------|------|
| 不断链 | 修改文件名/路径后，必须全局搜索旧引用并更新 |
| 更新版本号 | 每次内容变更必须递增 HEADER 中的 `当前版本` |
| 不破坏 HEADER 格式 | 保持 `**字段名**：值` 格式，AI 依赖此格式解析 |
| 新增文件 | 必须在 `reference/directory.md` 和 `RELEASE.json` 中注册 |

### 2.2 版本号更新规则

| 变更类型 | 版本号变更 | 示例 |
|----------|------------|------|
| 措辞修正、错别字 | patch: `v0.2` → `v0.3` | `v0.2` → `v0.3` |
| 新增章节/逻辑变更 | minor: `v0.2` → `v0.3` | `v0.2` → `v0.3` |
| 结构重构 | minor: `v0.2` → `v0.3` | `v0.2` → `v0.3` |

> 当前 guide/ 文件版本号使用 `v<major>.<minor>` 格式（省略 patch 位），patch 变更时递增 minor 即可。

### 2.3 新增文件流程

新增 `guide/` 文件时，执行以下 checklist：

```
□ 创建 .md 文件，按标准 HEADER 格式编写
□ 在 internal/development-guide.md 中引用（如适用）
□ 在 reference/directory.md §3.1 中注册
□ 在 RELEASE.json 的 files 中添加条目
□ 在 setup.md 的部署步骤和目录结构中添加
□ 在 guide/08-tool-integration-guide.md 的部署章节添加
□ 更新所有相关文件的交叉引用
```

### 2.4 删除文件流程

```
□ 确认无下游项目引用（非破坏性）
□ 从 reference/directory.md 中移除
□ 从 RELEASE.json 中移除
□ 从 setup.md 中移除
□ 从 guide/08-tool-integration-guide.md 中移除
□ 搜索并更新所有交叉引用
```

---

## 3. 修改 agents/ 的约束

| 规则 | 说明 |
|------|------|
| 角色接口兼容 | 不删除或重命名已有角色职责，如需变更走 deprecation 流程 |
| 新增角色 | 在 `agents/README.md` 中注册，在 `reference/directory.md` 中更新 |
| 角色文件 HEADER | 保持与 guide/ 相同的 HEADER 格式 |

---

## 4. 修改 internal/ 自身的约束

1. 修改后更新 `internal/README.md` 的索引和相关描述
2. 如果是治理规则变更，需要在 `internal/repo-governance.md` 中记录生效时间

---

## 5. 运行验证

修改完成后，运行以下验证：

```bash
# 1. 检查交叉引用
grep -rn "\.\./guide/" internal/ | grep "\.md"  # 确认路径有效

# 2. 检查 HEADER 版本号格式
grep -rn "**当前版本**" guide/*.md              # 确认格式一致

# 3. 检查 HEADER 来源元信息（Issue #6）
grep -rn "**来源仓库**" guide/*.md              # 确认所有文件已标注

# 4. 运行发版校验（如果 RELEASE.json 存在）
bash scripts/validate-release.sh
```

---

## 修订记录

| 版本 | 日期 | 修订内容 |
|------|------|----------|
| v0.1 | 2026-05-24 | 初始版本：guide/ agents/ internal/ 修改约束 |
