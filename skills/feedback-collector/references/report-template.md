# Issue 报告模板

> SKILL.md 步骤 3 时加载。创建上游 Issue 的 body 结构。

## 创建命令

```bash
gh issue create \
  --repo lpreterite/ai-engineering \
  --title "[Friction]: 简短描述问题" \
  --body "$(cat report-body.md)" \
  --label "friction"
```

## Issue body 格式

```
## 卡点报告 (Friction Report)

### 环境信息

- **下游项目**：{项目名称}
- **AI 模型**：{模型标识}
- **矫正次数**：{N} 次

### 问题定位

- **涉及 Skill**：`skills/<name>/SKILL.md` v{X.X}
- **涉及 Agent**：{角色名}
- **涉及标准**：`guide/<name>.md` / `agents/<name>.md`

### 问题描述

{描述 Agent 的行为与人类的期望差距}

### 矫正记录摘要

```
{第 1 次：人类说了什么}
{第 2 次：人类说了什么}
{第 3 次：人类说了什么}
```

### 预期修正

{建议上游如何改进标准/skill/role prompt 以避免该问题}

### 影响范围

[确定] 该问题影响多个项目 / [可能] 仅当前项目
```

## 标签规则

| 场景 | 标签 |
|------|------|
| 通用流程问题 | `friction` |
| Skill 逻辑缺陷 | `friction` + `area:skill` + skill 名 |
| Role prompt 缺陷 | `friction` + `area:agent` + agent 名 |
| Guide 标准不清晰 | `friction` + `area:guide` + 文件名 |
