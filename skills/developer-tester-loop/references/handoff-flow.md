# 移交流程

> SKILL.md 步骤 1 时加载。Developer→Tester 完整移交的详细规则。

## 强制移交规则

| 规则 | 说明 |
|------|------|
| 状态锁定 | Issue 设为 `ready-for-test` 后，Developer 不可再修改关联代码 |
| 上下文传递 | 移交方提供：Issue 编号 + 验收标准原文 + 自测结果摘要 + 相关文件列表 |
| 不接受部分移交 | 一个 Issue 的所有验收标准必须全部 resolve 后才能移交 |

## 移交清单

Developer 完成以下检查后方可请求移交：

```
□ 1. 代码编写完成
□ 2. 代码审查通过
□ 3. 单元测试通过
□ 4. 集成测试通过（如适用）
□ 5. 功能测试通过
□ 6. 文档已更新
□ 7. 决策结果已更新到关键文档
□ 8. 验收标准已逐项勾选
□ 9. 自测结果证据已记录
```

## 状态转换操作

```
 Developer (gh issue edit)           Orchestrator
      set status/resolved         set status/ready-for-test
            │                             │
            ▼                             ▼
      [自测通过] ─────→ [等待移交] ─────→ [待测试]
                                          │
                                          ▼
                                    Tester 认领
                                    set status/testing
```

## 移交消息格式

```
移交 Issue #N: [标题]

验收标准:
- [x] 标准1（已自测通过）
- [x] 标准2（已自测通过）

自测结果: 单元测试通过/集成测试通过
关联文件: src/xxx.ts, tests/xxx.test.ts
变更记录: git log --oneline 的最后 3 条 commit
```

## Bug Issue 创建

Tester 发现问题后，由 Orchestrator 代为创建 Bug Issue：
1. 标题：`BUG-NNN: 简短描述`
2. Issue body 包含：环境、步骤、预期、实际、证据
3. 引用父 Issue 编号
4. 设优先级（P0/P1/P2）
5. 分配对应 Developer
