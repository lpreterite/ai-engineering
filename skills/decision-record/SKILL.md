---
name: decision-record
version: v1.0
description: "打磨阶段决策记录——识别决策信号、触发门槛判断、创建 Decision Issue、关联关键文档。触发：讨论中出现技术选型/方案取舍、超过 3 轮有效讨论、人类明确表达倾向、排除某个方案时。"
---

# decision-record — 打磨阶段决策记录

Type: 5 (Reasoning & Strategic) + 3 (Automation & Orchestration)

## 工作流

### 步骤 0：前置确认 [自由度：低]
- 确认当前在打磨阶段（Gate 1-2）
- 确认讨论已涉及可记录的决策点
- → 此时加载 [references/signal-detection.md](references/signal-detection.md)

### 步骤 1：检测决策信号 [自由度：中]
- 持续监控对话中的决策信号
- 匹配信号后记录上下文

### 步骤 2：触发门槛判断 [自由度：低]
- 超过 **3 轮有效讨论** 后主动询问
- 询问句式：`"这个讨论已经涉及到关键决策了，需要我创建一个 Decision Issue 记录吗？"`

### 步骤 3：创建 Issue [自由度：低]
- 人类确认后：
  1. 读取 `.github/ISSUE_TEMPLATE/4-decision.yml` 获取字段
  2. 按 Context / Options / Conclusion / Rationale / Impact 提取要素
  3. 构造结构化 Markdown body
  4. 执行 `gh issue create --body "..."` 
  5. 回复：`"已创建 Decision #N"`
- → 此时加载 [references/workflow.md](references/workflow.md)

### 步骤 4：结论沉淀 [自由度：低]
- Issue 保持 `open` 状态
- 人类确认结论已沉淀到文档后关闭
- 更新 Issue 的 `related-docs` 字段指向最终文档

## 前置条件
- 打磨阶段 Gate 1-2
- `.github/ISSUE_TEMPLATE/4-decision.yml` 存在
- gh CLI 已认证

## 完成标准
- Decision Issue 已创建（#N）
- 结论已沉淀到关键文档（PRD/Tech Spec/Design Spec）
- Issue 的 `related-docs` 已更新

## 回退路径
- 模板读取失败 → 手动构造 body（按标准五段式）
- gh 命令失败 → 检查认证 → 重试（最多 2 次）
- 人类拒绝 → 不做记录，继续讨论
