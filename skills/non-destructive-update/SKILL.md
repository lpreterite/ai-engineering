---
name: non-destructive-update
description: "非破坏性更新——MANIFEST 版本比对、四步更新协议、三路合并、回滚。触发：MANIFEST.json 存在、下游仓库同步、文件版本不一致、需要增量更新已有文件、AI 拉取上游规范后需本地应用时。"
---

# non-destructive-update — 非破坏性更新

Type: 3 (Automation & Orchestration) + 1 (Code & Development)

## 工作流

### 步骤 0：前置确认 [自由度：低]
- 确认项目根目录存在 MANIFEST.json，若不存在则初始化一个新 MANIFEST
- 确认上游源文件可用
- 确认 Git 工作区干净（避免混入未提交变更）
- → 此时加载 [references/manifest.md](references/manifest.md)

### 步骤 1：版本比对 [自由度：低]
- 读取 MANIFEST.json 中的当前版本 vs 上游最新版本
- 逐文件标记差异：`up-to-date` / `needs-update` / `conflict`
- → 此时加载 [references/version-comparison.md](references/version-comparison.md)

### 步骤 2：策略选择 [自由度：低]
- **保留**：下游定制且上游未更新 → 跳过
- **覆盖**：仅上游更新且下游未定制 → 直接覆盖
- **合并**：两者都更新 → diff3 三路合并
- → 此时加载 [references/three-way-merge.md](references/three-way-merge.md)

### 步骤 3：执行 [自由度：低]
- 按策略更新每个文件
- 自动备份原文件（`.bak.{timestamp}`）
- 更新 MANIFEST.json 版本号
- 输出变更摘要

### 步骤 4：验证与回滚 [自由度：低]
- 验证文件完整性
- 如有问题执行回滚
- → 此时加载 [references/rollback.md](references/rollback.md)


## 完成标准
- 所有文件已同步到目标版本
- MANIFEST.json 版本号已更新
- 备份文件存在（如需回滚）
- 变更摘要已记录

## 回退路径
- 合并失败 → 从 `.bak.{timestamp}` 恢复原文件 → 重试（最多 1 轮）
- 版本号格式不匹配 → 跳过该文件，标记警告
- MANIFEST.json 损坏 → 重新初始化
- 详细回滚操作 → 此时加载 [references/rollback.md](references/rollback.md)
