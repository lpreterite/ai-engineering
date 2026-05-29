# 合并策略

> SKILL.md 步骤 1 时加载。版本比对和三路合并策略选择。

## MANIFEST.json 格式

```json
{
  "checklists.md": {
    "source": "guide/04-checklists.md",
    "version": "v1.0",
    "customized": true,
    "customized_reason": "增加了安全审查检查项"
  },
  "principles.md": {
    "source": "guide/01-principles.md",
    "version": "v0.8",
    "customized": false
  }
}
```

## 版本比对逻辑

| 字段 | 说明 |
|------|------|
| `source` | 上游源文件路径 |
| `version` | 当前同步的版本号 |
| `customized` | 下游是否有定制 |
| `customized_reason` | 定制原因说明 |

## 三路合并策略

```
仅上游更新（下游未定制）：直接覆盖
    ↓
下游定制（上游未更新）：跳过
    ↓
两者都更新：diff3 三路合并
    ├── 无冲突 → 自动合并成功
    └── 有冲突 → 产生冲突标记 → 人工裁决
```

## 版本对比规则

- v0.8 < v1.0（主版本递增）
- v1.0 < v1.1（次版本递增）
- v1.0 == v1.0（版本相等，无需更新）

## 同步后验证

验证清单：
```
□ 所有文件版本已更新到目标版本
□ 下游定制内容完整
□ 无未解决的冲突标记
□ MANIFEST.json 版本号已更新
□ 变更摘要已输出
```