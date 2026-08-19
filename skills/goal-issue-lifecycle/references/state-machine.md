# 状态机与标签映射

> 引用：`skills/goal-issue-lifecycle/SKILL.md` 工作流全程

## 单一状态机（跨两阶段）

```
                   打磨阶段                                  执行阶段
draft ──提交门禁──► reviewing ──通过──► approved ──登记计划──► planned
  ▲                   │                                               │
  │                   │ 不通过（打回）                       开始执行  ▼
  │◄── rejected ◄─────┘                                        in-progress
                                                                     │
                                                      ┌──── 遇到阻塞 ─┤
                                                      ▼              │
                                                   blocked ──解除──►─┤
                                                                     │
                                                                     ▼
                                                            所有阻塞项清零 ──► done
```

## 标签映射

### Goal Issue 状态标签

| 状态 | 标签 | 阶段 | 说明 |
|------|------|------|------|
| draft | `polishing, status:draft` | 打磨 | 初始态，产出物在草稿隔离区 |
| reviewing | `polishing, status:reviewing` | 打磨 | 已提交门禁，隔离审核中 |
| approved | `polishing, status:approved` | 打磨→执行 | 门禁通过，可进入执行 |
| rejected | `polishing, status:rejected` | 打磨 | 打回，返工后重审 |
| planned | `execution, status:planned` | 执行 | 已登记计划 |
| in-progress | `execution, status:in-progress` | 执行 | 执行中 |
| blocked | `execution, status:blocked` | 执行 | 被阻塞，解除后回 in-progress |
| done | `execution, status:done` | 完成 | 阻塞项清零 |

### Task Issue 状态标签

| 状态 | 标签 | 说明 |
|------|------|------|
| in-progress | `execution, status:in-progress` | 正在处理 |
| blocked | `execution, status:blocked` | 被阻塞，原因记录在 Task 评论 |
| done | `execution, status:done` | 完成，QA 验证通过 |

### 阶段标签

| 标签 | 说明 |
|------|------|
| `goal` | Goal Issue 类型 |
| `polishing` | 打磨阶段 |
| `execution` | 执行阶段 |
| `task` | Task Issue 类型 |