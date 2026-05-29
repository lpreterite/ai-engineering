---
name: prd-templates
description: "PRD 文档模板——用户故事、验收标准、线路图、原型图说明。触发：需要写 PRD、需求分析、Gate 1 验收准备、打磨阶段创建需求文档时。"
---

# prd-templates — PRD 文档模板

Type: 2 (Data & Information Management)

## 工作流

### 步骤 1：确认范围 [自由度：中]
- 确认 PRD 覆盖的功能范围和用户群体
- 确认目标版本号（v1.0/v1.1 等）
- 收集上游材料（用户反馈、竞品分析、技术约束）

### 步骤 2：选择模板 [自由度：低]
- 按产品类型选择 PRD 结构
- → 此时加载 [references/prd-example.md](references/prd-example.md)

### 步骤 3：填充内容 [自由度：高]
- 按模板结构逐节填充
- 用户故事从用户视角描述
- 验收标准可测试、无歧义
- → 此时加载 [references/user-story-template.md](references/user-story-template.md)

## 模板结构

```
# {项目名} PRD v{版本}

## 1. 概述
- 背景与动机
- 目标用户
- 成功指标

## 2. Goals / Non-Goals
- 必须做的（Must Have）
- 应该做的（Should Have）
- 可以做的（Could Have）
- 不做（Won't Have）

## 3. 用户故事
- 核心场景列表

## 4. 用户线路图
- 主要使用路径
- 路径间跳转关系

## 5. 验收标准
- 功能验收标准
- 性能指标

## 6. 原型图说明
- 页面列表
- 交互流程
```

## 回退路径
- 需求材料不足 → 标记待补充项，通知 PO 补全（最多重试 2 轮）
- 模板部分章节不适用 → 标记为"不适用"后跳过

## 前置条件
- 需求来源已确认（用户反馈/竞品分析/技术驱动）
- 项目目标版本已确定

## 完成标准
- 模板中所有必填章节已填写
- 用户故事覆盖核心功能
- 验收标准可测试
