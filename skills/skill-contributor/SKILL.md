---
name: skill-contributor
version: v1.0
description: "贡献 skill 到上游仓库——将下游定制的 skill 通过 PR 提交到 lpreterite/ai-engineering，经 skill-optimizer 自动审查后合并。触发：用户想要将本地 skill 贡献给上游团队、定制了一个通用价值的 skill 希望共享时。"
---

# skill-contributor — 贡献 Skill 到上游

Type: 3 (Automation & Orchestration)

## 工作流

### 步骤 0：前置确认 [自由度：低]
- 确认贡献目标仓库：`lpreterite/ai-engineering`
- 确认 skill 结构完整（`SKILL.md` + `references/` 目录）
- 确认 `version: v0.1`（贡献版，merge 后上游改为正式版）
- 确认未侵犯第三方版权
- 确认用户已 Fork 上游仓库（如未 Fork → 引导用户手动 Fork）

### 步骤 1：本地校验 [自由度：低]
- 检查 SKILL.md 含 `name` + `version` + `description`
- 检查 `references/` 中所有文件路径有效
- 检查无冗余文件（README.md、CHANGELOG.md 等）
- → 此时加载 [references/validation-checklist.md](references/validation-checklist.md)

### 步骤 2：skill-optimizer 预审 [自由度：中]
- 用 skill-optimizer 的 7 维度做本地审查
- 输出审查结果给用户
- 存在差距 → 提示用户修复后再提交
- 全部通过 → 进入下一步

### 步骤 3：创建 PR [自由度：低]
- 从下游 skill 目录复制到 Fork 仓库的 `skills/<name>/`
- 更新 Fork 仓库的 `RELEASE.json` 添加 skill 条目
- 创建分支 `skills/<name>`
- 执行 `gh pr create --repo lpreterite/ai-engineering --label contribution`
- PR body 包含贡献说明和 skill-optimizer 预审结果

### 步骤 4：本地标记 [自由度：低]
- 在下游 `MANIFEST.json` 中标记 `contributed: true`
- 通知用户：`"已创建贡献 PR #N，上游 skill-optimizer CI 会自动审查"`

## 前置条件
- gh CLI 已认证，且有上游仓库 `lpreterite/ai-engineering` 的写入权限
- 用户已 Fork 上游仓库到自己的 GitHub 账号
- Fork 仓库已添加为本地 remote（如 `upstream`）
- 本地 Fork 仓库已同步到最新

## 完成标准
- PR 已创建（返回 PR URL）
- 下游 MANIFEST.json 已标记 contributed
- skill-optimizer CI 将在上游自动运行

## 回退路径
- Fork 不存在 → 引导用户通过 GitHub UI Fork → 重试
- PR 创建失败 → 检查 gh 认证 → 重试（最多 2 次）
- skill-optimizer 预审未通过 → 展示差距清单 → 建议修复后重新提交
