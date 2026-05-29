# AI 决策记录协议

> SKILL.md 步骤 1 时加载。打磨阶段中，AI 识别决策点并创建 Decision Issue 的完整流程。

## 决策识别信号

当对话中出现以下信号时，判断是否达到决策点：
- 人类明确选择倾向（"选 X"、"用 Y"、"倾向于方案 A"）
- 讨论多个方案并排除其一（"B 不行，成本太高"）
- 确认了技术选型或设计方向（"那就用 PostgreSQL"）
- 需要外部确认的疑问

## 触发门槛

超过 **3 轮有效讨论** 后，主动询问：
> "这个讨论已经涉及到关键决策了，需要我创建一个 Decision Issue 记录吗？"

## 创建流程

人类确认后执行：

1. 读取 `.github/ISSUE_TEMPLATE/4-decision.yml` 获取字段定义
2. 按字段结构（Context / Options / Conclusion / Rationale / Impact）提取决策要素
3. 构造 Markdown body
4. 执行 `gh issue create --body "..."` 创建
5. 回复人类：`"已创建 Decision #N"`

## Issue body 示例

```
## Decision Record

**Context**:
用户表需要支持多租户隔离

**Options Considered**:
- MySQL + 应用层隔离（方案 A）
- PostgreSQL + Schema 隔离（方案 B）← 已选
- CockroachDB（方案 C，成本过高淘汰）

**Decision**:
采用 PostgreSQL + Schema 隔离方案

**Rationale**:
- PostgreSQL 原生支持 Schema 隔离
- 团队已有 PostgreSQL 经验

**Impact Scope**:
影响数据层架构、PRD 第 3.2 节、里程碑 M1
```

## 创建后处理

- Issue 保持 `open` 状态，人类确认结论已沉淀到文档后关闭
- 通过 `related-docs` 字段关联最终结果文档
- 不要将完整聊天记录贴到 Issue 上，只做结构化摘要
- 决策最终结论应当记录到关键文档（PRD / Tech Spec / Design Spec）
