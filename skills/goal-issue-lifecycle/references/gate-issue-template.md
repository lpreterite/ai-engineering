# Gate Issue 模板

> 引用：`skills/goal-issue-lifecycle/SKILL.md` 步骤 0.5 / 步骤 3 / 步骤 4

## 正文结构

```
## Gate 名称
<里程碑名称> - <Gate 名称>

## 验收项清单
- [ ] ① <验收项 1>
- [ ] ② <验收项 2>

## 本轮审核结论
- 结果：待审核 / 通过 / 打回
- 证据：<隔离审核结论、验收标准核对、会话日志摘录>
- 打回原因（若否）：<具体原因>

## 重审记录（同一 Issue 承载）
- 轮 1（日期）：rejected，原因...
- 轮 2（日期）：approved，结论...

## 关联
- 目标: #N
- 里程碑: <里程碑名称>
```

## 创建命令

```bash
gh issue create \
  --label gate --label polishing --label status:open \
  --title "[Gate] <里程碑名称> - <Gate 名称>" \
  --body-file <gate-body.md>
```

## 重审时

不创建新 Issue，在已有 Gate Issue 中追加评论记录本轮审核结论，更新状态标签（approved/rejected）。

## 标签

| 标签 | 说明 |
|------|------|
| `gate` | 类型标签 |
| `polishing` / `execution` | 阶段标签 |
| `status:open` | 已创建，待审核 |
| `status:reviewing` | 审核中 |
| `status:approved` | 通过 |
| `status:rejected` | 打回 |