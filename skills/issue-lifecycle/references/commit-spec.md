# Commit 规范

> SKILL.md 步骤 5 时加载。提交代码前核验验收标准并正确引用 Issue。

## 提交前验收核验四步

每次提交前必须执行：

1. **读取验收标准**：`gh issue view <N> --json body` 获取验收标准
2. **逐一核验**：对照每一项确认已覆盖；未满足的项不得关闭
3. **勾选验收标准**：通过 `gh issue edit <N> --body-file` 将 `- [ ]` 更新为 `- [x]`
4. **确认闭环**：所有验收标准已勾选后，提交并推送

## Commit 格式

| 变更类型 | 格式 | 示例 |
|----------|------|------|
| 修复 Bug | `fix: 描述 (#N)` | `fix: 统一 .env 键名 (#1)` |
| 新功能 | `feat: 描述 (#N)` | `feat: 添加批量发布功能 (#5)` |
| 文档 | `docs: 描述 (#N)` | `docs: 更新安装说明 (#3)` |
| 重构 | `refactor: 描述 (#N)` | `refactor: 提取通用错误码 (#4)` |

## 关闭关键词

Commit 推送后 GitHub 自动关闭关联 Issue：

| 关键词 | 使用场景 | 示例 |
|--------|----------|------|
| `Close #N` | 通用关闭 | `Close #4` |
| `Fixes #N` | Bug 修复 | `Fixes #4` |
| `Resolves #N` | 功能/任务完成 | `Resolves #5` |

多条同时关闭：`Close #1, Close #4, Resolves #5`

> 仅当 commit 合并到默认分支（`main`）时自动生效。不需要手动 `gh issue close`。

## Orchestrator 执行阶段操作清单

```
□ 检查新 Issue，triage（确认 Type、标记依赖、分配）
□ 复杂 Issue 拆 Sub-issues
□ 跟踪 in_progress 进展
□ 检查 blocked issues，超 24h 升级
□ 确保 resolved Issue 被验证
□ 关闭已验证的 Issue
□ 每周同步 Issue 状态到 STATUS.md
```

## 发布前检查

```
□ 所有 P0/P1 Issue 均已关闭或已验证
□ 所有 Sub-issues 均已关闭（父 Issue 进度 100%）
□ 无 unresolved 的依赖关系
□ STATUS.md 与 Issue 状态一致
```
