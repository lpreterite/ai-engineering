# 双看板配置

> SKILL.md 步骤 2 时加载。用于 GitHub Projects 看板的视图和自动化规则配置。

## 双看板设计

创建一个 GitHub Project，配置两个独立视图：

| 视图名称 | 筛选规则 | 状态列 |
|---------|---------|--------|
| **打磨看板** | `type:Decision,Question,Risk,Review` | 待讨论(Todo) → 讨论中(Discussing) → 已决策(Decided) → 已关闭(Closed) |
| **执行看板** | `type:Feature,Bug,Task` | 待办(Todo) → 进行中(In Progress) → 待验收(Ready for Test) → 测试中(Testing) → 已验证(Verified) → 已完成(Done) |

## 推荐视图

| 视图 | 布局 | 用途 |
|------|------|------|
| 打磨看板 | Board（按状态分组） | 打磨阶段日常跟踪 |
| 执行看板 | Board（按状态分组） | 执行阶段日常跟踪 |
| 时间线 | Roadmap（按里程碑） | 交付节奏可视化 |
| 全局表格 | Table（全部字段） | 批量操作与跨阶段筛选 |

## 自动化规则

| 触发条件 | 自动动作 |
|---------|---------|
| Issue 类型为 Decision/Question/Risk/Review | 自动加入「打磨看板」视图 |
| Issue 类型为 Feature/Bug/Task | 自动加入「执行看板」视图 |
| 标签变更为 `status/discussing` | 打磨看板移入「讨论中」列 |
| 标签变更为 `status/decided` | 打磨看板移入「已决策」列 |
| 标签变更为 `status/in-progress` | 执行看板移入「进行中」列 |
| 标签变更为 `status/resolved` | 执行看板移入「待验收」列 |
| 标签变更为 `status/ready-for-test` | 执行看板移入「待验收」列 |
| 标签变更为 `status/testing` | 执行看板移入「测试中」列 |
| 标签变更为 `status/verified` | 执行看板移入「已验证」列 |
| 标签变更为 `status/closed` | 对应看板移入「已关闭」列 |
