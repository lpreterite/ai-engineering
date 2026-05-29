# MANIFEST 注册表

> SKILL.md 步骤 0 时加载。MANIFEST.json 格式和初始化说明。

## MANIFEST.json 格式

```json
{
  "checklists.md": {
    "source": "guide/04-checklists.md",
    "version": "v1.0",
    "customized": false,
    "updated": "2026-05-28"
  },
  "collaboration.md": {
    "source": "guide/03-collaboration.md",
    "version": "v0.2",
    "customized": true,
    "customized_reason": "增加了微信通知集成章节",
    "updated": "2026-05-20"
  }
}
```

## 字段说明

| 字段 | 必填 | 说明 |
|------|------|------|
| `source` | 是 | 上游源文件路径 |
| `version` | 是 | 当前同步到的版本号 |
| `customized` | 是 | 下游是否有定制内容 |
| `customized_reason` | 否 | 定制原因（customized=true 时建议填写） |
| `updated` | 否 | 最后更新时间 |

## 初始化

首次使用时，为项目中的 ai-engineering 规范文件创建 MANIFEST：

```bash
# 读取当前文件 HEADER 中的版本号
# 生成 MANIFEST.json 注册表
```

## 三层体系

| 层 | 说明 |
|----|------|
| 第一层：规范文件 | 实际内容文件（guide/*.md） |
| 第二层：MANIFEST 注册表 | 版本信息 + 定制标记 |
| 第三层：备份 | `.bak.{timestamp}` 回滚用 |