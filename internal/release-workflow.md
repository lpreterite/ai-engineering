# 版本发布操作手册

> Release Workflow

**所属目录**：`ai-engineering/internal/`
**文档状态**：草稿
**当前版本**：v0.1
**发布日期**：2026-05-24
**来源仓库**：`lpreterite/ai-engineering`
**源文件路径**：`internal/release-workflow.md`

---

## 1. 概述

本文档定义 ai-engineering 主仓库的版本发布全流程。

---

## 2. 版本号规范

### 2.1 主仓库版本号

采用语义化版本号 `v<major>.<minor>.<patch>`：

| 位 | 触发条件 | 示例 |
|------|----------|------|
| major | 架构级变更、协议不兼容、目录结构调整 | v2.0.0 |
| minor | 新增规范文件、新增协议能力、Agent 角色变更 | v1.1.0 |
| patch | 文档修正、措辞优化、引用修复 | v1.0.1 |

### 2.2 guide/ 文件版本号

每个 `guide/*.md` 的 HEADER 中维护独立版本号 `v<major>.<minor>`：

| 级别 | 触发条件 |
|------|----------|
| minor | 新增章节、逻辑变更 |
| patch | 措辞修正、格式调整 |

> 文件版本号与主仓库版本号解耦：主仓库发 patch 时可能包含多个文件的不同级别更新。

---

## 3. 发布触发条件

满足以下任一条件时触发发版：

| 条件 | 示例 |
|------|------|
| guide/ 文件被修改 | 新增规范、更新协议 |
| agents/ 角色定义变更 | 新增角色、调整职责 |
| RELEASE.json 需要更新 | 版本号不一致 |
| directory.md 目录结构变更 | 新增/删除文件重组 |

---

## 4. 发版步骤

```
Step 1: 更新 HEADER
  ├─ 确认所有修改过的 guide/*.md HEADER 版本号已递增
  └─ 运行 scripts/validate-release.sh 校验一致性

Step 2: 更新 RELEASE.json
  ├─ 运行 scripts/bump-version.sh 批量更新
  └─ 手动确认每个文件版本号正确

Step 3: 合并到 main
  ├─ 创建 PR，关联发布 Issue
  ├─ 通过 PR 审查（按 repo-governance.md §3.1 checklist）
  └─ Squash merge 到 main

Step 4: 打 Tag
  ├─ git tag v<major>.<minor>.<patch>
  ├─ git push origin --tags
  └─ Tag message 写明变更摘要

Step 5: 创建 GitHub Release
  ├─ gh release create v<major>.<minor>.<patch> --notes "<变更说明>"
  └─ Release notes 包含：本次变更文件清单、版本号变更、破坏性变更说明

Step 6: 通知下游
  ├─ 更新 STATUS.md 的版本号
  └─ （可选）在关联项目的 Issue 中标注可升级
```

### 发版检查清单

```
□ 所有修改过的 guide/ 文件 HEADER 版本号已递增
□ scripts/validate-release.sh 通过
□ RELEASE.json 已更新
□ 交叉引用未断裂
□ reference/directory.md 已同步
□ internal/README.md 索引已同步
□ PR 已合并到 main
□ Tag 已推送
□ GitHub Release 已创建
□ STATUS.md 已更新
```

---

## 5. 紧急回滚

```bash
# 1. 回退到上一版本
git revert <current-tag>
git push origin main

# 2. 删除错误 tag
git tag -d v<bad-version>
git push origin --delete v<bad-version>

# 3. 通知下游暂缓升级
# 4. 创建修复 Issue，走正常发版流程
```

---

## 修订记录

| 版本 | 日期 | 修订内容 |
|------|------|----------|
| v0.1 | 2026-05-24 | 初始版本：版本号规范、发版步骤、回滚流程 |
