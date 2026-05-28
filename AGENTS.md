# ai-engineering

## 语言要求
- 所有 Issue/PR 评论、沟通回复必须使用**简体中文**
- commit message 使用英文（保持与 git log 一致）
- 代码注释使用英文

## 项目简介
AI 原生软件研发工程体系，定义 AI 开发模式下的人机协作规范、阶段门控、多 Agent 角色与关键文档产出标准。

## 打磨阶段 Issue 创建指令

在打磨阶段（Gate 1 和 Gate 2 之间）的讨论中，请保持以下行为：

### 决策识别
当对话中出现以下信号时，判断是否达到决策点：
- 人类表达了明确的选择倾向（"选 X"、"用 Y"、"倾向于方案 A"）
- 讨论了多个方案并排除了其中一个（"B 不行，成本太高"）
- 确认了技术选型或设计方向（"那就用 PostgreSQL"）
- 需要外部确认的疑问（"这个问题需要确认一下"）

### 触发门槛
超过 **3 轮有效讨论** 后，主动询问：
> "这个讨论已经涉及到关键决策了，需要我创建一个 Decision Issue 记录吗？"

### 创建流程
人类确认后执行：
1. 读取 `.github/ISSUE_TEMPLATE/4-decision.yml` 获取字段定义
2. 按字段结构（Context / Options / Conclusion / Rationale / Impact）提取本次讨论中的决策要素
3. 构造 Markdown body，通过 `gh issue create --body` 创建
4. Issue 保持 `open` 状态，不自动关闭
5. 回复人类："已创建 Decision #N"

### 注意事项
- 不要将完整聊天记录贴到 Issue 上，只做结构化摘要（背景、方案、结论、依据）
- Issue 是「过程载体」，决策的最终结论应当记录到关键文档（PRD / Tech Spec / Design Spec）
- 3 轮以内的简单问答无需创建 Issue
