---
name: feedback-collector
version: v1.0
description: "过程管理卡点上报——Agent 被人类反复矫正流程规范时，捕获上下文、询问确认、创建上游 Issue。触发：Agent 连续 3 次被人类矫正过程管理类问题（如 Gate 推进、Issue 生命周期、角色分工、文档规范、移交协议、通道隔离），且确认是上游标准/skill/role prompt 缺陷时。"
---

# feedback-collector — 过程管理卡点上报

Type: 5 (Reasoning & Strategic) + 3 (Automation & Orchestration)

## 工作流

### 步骤 0：分类确认 [自由度：低]
- 确认矫正类型是否属于**过程管理类**：
  - Gate 推进逻辑、Issue 生命周期、角色分工、文档规范、移交协议、通道隔离
- 排除非上报类型：代码实现、技术选型、UI 细节、业务逻辑、工具用法
- 排除假阳性：人类教学场景（首次使用新技能的正常学习曲线）
- 确认同一类问题已出现 ≥ 3 次

### 步骤 1：捕获上下文 [自由度：中]
- 记录涉及 Skill、Agent 角色、上游标准文件及版本号
- 记录矫正次数、人类反馈原文
- 记录当前使用的 AI 模型（通过环境变量或会话信息获取）
- → 此时加载 [references/context-template.md](references/context-template.md)

### 步骤 2：询问确认 [自由度：低]
- "这个过程规则反复出问题，可能需要改进上游标准。需要我创建一个 Issue 反馈给 ai-engineering 团队吗？"

### 步骤 3：创建 Issue [自由度：低]
- 人类确认后执行 `gh issue create --repo lpreterite/ai-engineering`
- → 此时加载 [references/report-template.md](references/report-template.md)

### 步骤 4：本地标记 [自由度：低]
- 写入下游 `MANIFEST.json` 的 `feedback` 字段（记录已上报，防重复）
- 标记后 7 天内同一问题不再重复上报

## 前置条件
- gh CLI 已认证且有 `lpreterite/ai-engineering` 仓库的写入权限
- 下游项目根目录存在 MANIFEST.json

## 完成标准
- Issue 已创建（返回 Issue URL）
- 本地 MANIFEST.json 已标记上报记录
- 回复人类：`"已创建 Friction Report #N"`

## 回退路径
- GitHub 无法访问 → 写入 `.opencode/feedback-pending.json`，下次联机时重试（最多 3 次）
- 人类拒绝 → 不做记录，继续工作
- 7 天内同一问题 → 跳过，提示"已于 X 天前上报"
