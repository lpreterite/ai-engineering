# 打磨族生命周期

> SKILL.md 步骤 0 时加载。用于确认打磨阶段 Issue 的创建和生命周期管理。

## Issue 类型

| 类型 | 说明 | 使用场景 |
|------|------|----------|
| **Decision** | 关键决策记录 | 技术选型、方案取舍、设计决策 |
| **Question** | 待确认疑问 | 需讨论澄清的需求/技术/设计问题 |
| **Risk** | 风险项 | 已识别的项目风险 |
| **Review** | 审查发现 | Gate 1/Gate 2 验收中发现的改进项 |

## 生命周期

```
open → discussing → decided → closed
  ↑         ↓
   └── reopened（有新信息时）
```

| 阶段 | 操作者 | 说明 |
|------|--------|------|
| **open** | 创建者/AI | 记录问题/决策/疑问的初始描述 |
| **discussing** | 所有人 | 在 Issue 评论区或通过 Agent 交流讨论 |
| **decided** | AI/人类 | 达成结论，记录最终结论和依据；人类确认后关闭 |
| **closed** | 人类/AI | 结论已沉淀到关键文档（PRD/Tech Spec/Design Spec），关闭归档 |

## 状态标签

| 标签 | 说明 |
|------|------|
| `status/open` | 已创建，待开始讨论 |
| `status/discussing` | 正在讨论中 |
| `status/decided` | 已达成结论，待沉淀到关键文档 |
| `status/closed` | 已关闭 |

## 打磨工单创建时机

| 角色 | 时机 | 创建类型 |
|------|------|----------|
| 人类/AI | 讨论中产生决策点（3 轮以上） | Decision |
| 人类/AI | 涉及待确认事项 | Question |
| PO Agent | 需求分析中发现风险 | Risk |
| Orchestrator | Gate 1/Gate 2 审查发现问题 | Review |

## 核心原则

- Issue 记录**讨论过程**，关键文档记录**最终结论**
- 所有打磨工单在 Gate 2 通过前关闭
- 结论已沉淀到文档后，在 Issue 的 `related-docs` 字段标注
