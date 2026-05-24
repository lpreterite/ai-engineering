#!/usr/bin/env bash
# bump-version.sh — 批量更新 guide/*.md HEADER 版本号
#
# 用法:
#   scripts/bump-version.sh guide/01-principles.md v0.8
#   scripts/bump-version.sh guide/01-principles.md v0.8 guide/02-process.md v0.8
#
# 使用 sed 替换 HEADER 中的 `**当前版本**：旧版` → `**当前版本**：新版`
# 要求：文件必须存在，且包含 `**当前版本**` 字段

set -euo pipefail

if [ $# -eq 0 ] || [ $(( $# % 2 )) -ne 0 ]; then
  echo "用法: $0 <file> <version> [<file> <version> ...]"
  echo "示例: $0 guide/01-principles.md v0.8"
  echo "      $0 guide/01-principles.md v0.8 guide/02-process.md v0.9"
  exit 1
fi

while [ $# -ge 2 ]; do
  file="$1"
  new_version="$2"
  shift 2

  if [ ! -f "$file" ]; then
    echo "❌ 文件不存在: $file"
    exit 1
  fi

  # 提取当前版本号（只取第一个匹配，排除正文模板示例）
  current=$(grep -o '\*\*当前版本\*\*：v[0-9.]*' "$file" | head -1 | sed 's/\*\*当前版本\*\*：//' || true)
  if [ -z "$current" ]; then
    echo "❌ 未找到版本号字段: $file"
    exit 1
  fi

  # 替换版本号（兼容 macOS sed）
  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s/\*\*当前版本\*\*：$current/**当前版本**：$new_version/" "$file"
  else
    sed -i "s/\*\*当前版本\*\*：$current/**当前版本**：$new_version/" "$file"
  fi

  echo "✅ $file: $current → $new_version"
done
