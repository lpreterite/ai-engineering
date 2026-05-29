---
name: downstream-sync
description: "下游仓库同步上游规范——版本比对、三路合并、冲突检测、定制保护。触发：上游仓库发布新版本、MANIFEST.json 版本不一致、执行 downstream-sync.sh、CI 检测到规范文件过时时、手动触发同步命令时。"
---

# downstream-sync — 下游仓库同步

Type: 3 (Automation & Orchestration) + 1 (Code & Development)

## 工作流

### 步骤 0：前置确认 [自由度：低]
- 确认上游仓库路径和最新版本
- 读取下游项目 MANIFEST.json，比对版本号
- 确认有版本差异需要同步
- → 此时加载 [references/merge-strategy.md](references/merge-strategy.md)

### 步骤 1：版本比对 [自由度：低]
- 逐文件对比 MANIFEST 中的 `version` 与上游最新版本
- 标记差异文件：上游更新 / 下游定制 / 两者都有
- 区分三种状态：`up-to-date` / `needs-update` / `conflict`

### 步骤 2：策略选择 [自由度：低]
- 每个差异文件按以下策略执行：
  - 仅上游更新且下游未定制 → 直接覆盖
  - 下游定制且上游未更新 → 跳过
  - 两者都有更新 → 三路合并（diff3）
- → 此时加载 [references/conflict-resolution.md](references/conflict-resolution.md)

### 步骤 3：执行同步 [自由度：低]
- 自动备份被覆盖的文件（`.bak.{timestamp}`）
- 执行三路合并，或调用 `scripts/downstream-sync.sh`
- 更新 MANIFEST.json 中的版本号
- 检测冲突并输出变更摘要

### 步骤 4：验证 [自由度：低]
- 确认所有文件已同步到目标版本
- 检查冲突标记是否已全部解决
- 验证 STATUS.md 与同步后的文件一致

## 前置条件
- 上游仓库可用（Git Submodule / 本地路径 / URL）
- 下游项目存在 MANIFEST.json
- Git 已配置 user.name 和 user.email

## 完成标准
- 所有规范文件版本已更新
- 下游定制内容未被覆盖
- 冲突已解决或标记
- 变更摘要已记录

## 回退路径
- 三路合并产生冲突 → 按 `DOWNSTREAM-BEGIN/END` 标记定位 → 手动裁决 → 重试（最多 3 轮）
- 上游仓库不可用 → 跳过同步，记录警告 → 重试（最多 3 轮）
- 合并后文件损坏 → 详细恢复方案 → 此时加载 [references/recovery-scenarios.md](references/recovery-scenarios.md)
