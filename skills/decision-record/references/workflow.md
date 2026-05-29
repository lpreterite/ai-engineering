# 决策流程

> SKILL.md 步骤 3 时加载。从检测→询问→创建→关闭的完整决策流程。

## 完整流程

```
讨论中检测到决策信号
        │
        ▼
累计超过 3 轮有效讨论？
    ├── 否 → 继续监听
    │
    └── 是 → 主动询问
        │
        ▼
人类确认创建？
    ├── 否 → 继续讨论
    │
    └── 是 → 创建 Decision Issue
        │
        ▼
1. 读取 4-decision.yml 获取字段定义
2. 按字段提取：
   - Context: 当前讨论的问题背景
   - Options: 讨论过的所有方案（标注已选和淘汰）
   - Decision: 最终决定
   - Rationale: 选择依据
   - Impact: 影响范围（文档/里程碑/架构）
3. 构造 Markdown body
4. gh issue create
5. 回复 "已创建 Decision #N"
        │
        ▼
讨论继续 → 人类确认结论已沉淀
        │
        ▼
人类手动关闭 Issue（通过 related-docs 关联最终文档）
```

## Issue body 构造示例

```
## Decision Record

**Context**:
[问题背景]

**Options Considered**:
- [方案 A]
- [方案 B] ← 已选
- [方案 C，淘汰原因]

**Decision**:
[最终决定]

**Rationale**:
[选择理由]

**Impact Scope**:
[影响范围]
```

## 注意事项

- 不要将完整聊天记录贴到 Issue 上，只做结构化摘要
- Issue 是「过程载体」，决策的最终结论应当记录到关键文档
- 3 轮以内的简单问答无需创建 Issue
- 非打磨阶段（进入执行阶段后）的决策直接在文档中记录，无需创建 Decision Issue
