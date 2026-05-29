# 打磨→执行转换

> SKILL.md 步骤 4 时加载。Gate 2 通过后将打磨阶段成果转换为可执行的开发工单。

## 核心原则

| 原则 | 说明 |
|------|------|
| 文档是拆解依据 | Gate 2 后执行工单的拆解依据是**关键文档**（PRD / Tech Spec / Design Spec），而非打磨工单 |
| Issue 只做追溯 | 执行工单 body 中可引用相关 Decision Issue 编号（`Refs: #N`）作为背景 |
| 过程与结果分离 | 打磨工单记录"过程"，关键文档记录"结果" |

## Gate 2 后拆解流程

```
Gate 2 通过
    ├─ 1. 确认关键文档已定稿（PRD-v1.0 / TECH-v1.0 / DESIGN-v1.0）
    ├─ 2. Orchestrator 读取关键文档
    ├─ 3. 依据文档中的里程碑划分、用户故事、验收标准
    │     拆解为 Feature / Task / Bug 执行工单
    └─ 4. 可选：在执行工单中引用相关的 Decision Issue #N
```

## 增量版本管理

每个版本的交付物是独立的增量文档，新版本不修改旧版本：

```
docs/
├── product/
│   ├── PRD-v1.0.md        ← v1.0 产品需求文档
│   ├── PRD-v1.1.md        ← v1.1 增量版本（独立文件）
│   └── PRD-v2.0.md
├── engineering/
│   └── ARCHITECTURE-v1.0.md
└── design/
    └── DESIGN-v1.0.md
```

## 每次迭代的完整流程

```
v1.0 打磨 → 工单 → 决策产出 → PRD-v1.0.md
→ Gate 2 通过
→ 依据 PRD-v1.0.md 拆解执行工单
→ 开发/测试/交付

v1.1 新需求 → 新打磨 → 新决策 → PRD-v1.1.md（增量）
→ Gate 2 通过
→ 依据 PRD-v1.1.md 拆解执行工单
→ 开发/测试/交付
```

## 可追溯性

执行工单创建后双向引用确保可追溯：
```
Decision #5: 选择 PostgreSQL 作为主数据库
    ↓ 执行工单（body 中标注 Refs: #5）
    Feature #8: 实现用户表数据模型
    Feature #9: 实现数据库连接池
```
