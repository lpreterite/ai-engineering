# 提交流验清单与 PR 模板

> SKILL.md 步骤 1 时加载。技能提交前的完整性校验和 PR 描述模板。

## 提交前校验清单

```
□ SKILL.md 以 YAML frontmatter 开头（---）
□ frontmatter 包含 name 字段
□ frontmatter 包含 version 字段（贡献版统一 v0.1）
□ frontmatter 包含 description 字段（含 5+ 触发词）
□ SKILL.md 正文 ≤ 80 行
□ 引用文件按步骤标注「→ 此时加载」
□ 每个步骤标注 [自由度：高/中/低]
□ 有独立的前置条件章节
□ 有独立的完成标准章节
□ 有独立的回退路径章节（含重试上限）
□ 无冗余文件（README.md、INSTALLATION.md 等）
□ 无解释 Agent 已知概念的内容
□ references/ 中所有文件路径在 SKILL.md 中被引用
```

## PR body 模板

```
## Skill Contribution: {skill-name}

### Type

{Type 1-5} ({核心特征描述})

### Description

{按照 SKILL.md description 原文}

### 预审结果

本地已通过 skill-optimizer 7 维度审查：

| 维度 | 判定 |
|------|------|
| Description | ✅/❌ |
| 长度 | ✅/❌ |
| 渐进式披露 | ✅/❌ |
| 自由度分层 | ✅/❌ |
| 前置/后置 | ✅/❌ |
| 回退路径 | ✅/❌ |
| 反模式 | ✅/❌ |

### 提交者

{下游项目名称}
