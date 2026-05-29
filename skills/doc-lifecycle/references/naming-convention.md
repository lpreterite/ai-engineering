# 命名规范

> SKILL.md 步骤 0 时加载。文档和目录的命名规则。

## 目录命名

| 类型 | 规范 | 示例 |
|------|------|------|
| 目录 | kebab-case | `project-tasks/`, `product/` |
| 文档 | kebab-case | `status.md`, `task-list.md` |
| 图片/资源 | kebab-case | `logo-dark.png`, `icon-home.svg` |

## 文件头模板

所有文档开头包含以下元信息：

```markdown
# 文档标题

> 简短描述

**所属目录**：`xxx/`
**文档状态**：草稿 | 评审中 | 已发布 | 已归档
**当前版本**：v0.1
**发布日期**：YYYY-MM-DD
**最后更新**：YYYY-MM-DD

---
```

## 文档权限矩阵

| 文档 | 读取权限 | 写入权限 |
|------|----------|----------|
| ai-engineering/* | 公开 | Orchestrator, 人类 |
| STATUS.md | 公开 | Orchestrator |
| product/PRD.md | 团队 | PO Agent, Product Owner |
| project-tasks/W*/ | 团队 | Orchestrator |
