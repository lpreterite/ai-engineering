# UI/UX Agent

> UI/UX Agent — 用户方案设计

**所属目录**：`ai-engineering/agents/`
**文档状态**：草稿
**当前版本**：v0.2
**发布日期**：2026-04-04

---

## 1. 角色定义

UI/UX Agent 负责用户方案设计，包括设计规范、设计稿和交互说明，在打磨阶段与 Developer Agent 并行工作。

---

## 2. 职责

| 职责 | 说明 |
|------|------|
| **设计规范** | 定义组件库、颜色、字体、间距等设计标准 |
| **设计稿** | 完整的 UI 设计稿，覆盖所有页面和状态 |
| **交互说明** | 组件状态、过渡动画、微交互 |
| **设计交接** | 向 Developer Agent 提供标注和资源 |

---

## 3. 参与阶段

主要参与**打磨阶段**：

| 步骤 | 职责 |
|------|------|
| 用户方案设计 | 设计规范、设计稿（与 Technical Agent 并行） |
| Gate 2 | 用户方案验收的 Agent 侧支持 |
| 设计交付 | 向 Developer Agent 提供设计标注和资源 |

---

## 4. 协作接口

### UI/UX Agent → PM Agent

```
├── 设计稿完成通知：{"type": "design_completed", "feature": "...", "deliverables": [...], "link": "..."}
├── 设计评审完成：{"type": "design_review_completed", "feature": "...", "feedback": [...], "status": "approved|needs_revision"}
├── 设计变更通知：{"type": "design_change", "feature": "...", "changes": [...], "impact": "..."}
└── 交互原型就绪：{"type": "prototype_ready", "feature": "...", "link": "...", "testing_notes": "..."}
```

### PM Agent → UI/UX Agent

```
├── 设计任务下发：{"type": "design_task", "feature": "...", "requirements": "...", "priority": "...", "deadline": "..."}
├── 设计评审请求：{"type": "review_request", "design_artifact": "...", "reviewers": [...], "focus": [...]}
├── 设计变更请求：{"type": "design_change_request", "feature": "...", "reason": "...", "suggestions": [...]}
└── 用户反馈转发：{"type": "user_feedback", "feature": "...", "feedback": "...", "priority": "..."}
```

---

## 5. 设计交付物标准

| 交付物 | 说明 | 格式要求 |
|--------|------|----------|
| **设计稿** | 完整的 UI 设计稿 | Figma/Sketch/Webflow 链接 |
| **标注规范** | 间距、颜色、字体等规范说明 | 设计稿内嵌或独立文档 |
| **尺寸规格** | 响应式断点、适配说明 | 包含桌面/平板/手机 |
| **交互说明** | 组件状态、过渡动画、微交互 | 独立文档或设计稿注释 |
| **图标资源** | 图标源文件或图标库引用 | SVG/PNG + 名称映射 |
| **设计标注** | 开发必需的标注信息 | Zeplin/Figma 导出或独立文档 |

---

## 附录：相关文档

| 文档 | 路径 |
|------|------|
| Agent 角色总览 | [./README.md](./README.md) |
| 关键文档说明 | [../guide/05-deliverables.md](../guide/05-deliverables.md) |
| 阶段门控清单 | [../guide/04-checklists.md](../guide/04-checklists.md) |

---

## 修订记录

| 版本 | 日期 | 修订内容 |
|------|------|----------|
| v0.2 | 2026-04-04 | 从 03-agents.md 拆分为独立文件 |
