#!/usr/bin/env bash
# validate-release.sh — 发版前校验
#
# 确保:
#   1. RELEASE.json 中记录的版本号与 guide/*.md HEADER 版本号一致
#   2. 所有 guide/*.md 都有来源元信息（来源仓库 + 源文件路径）
#
# 用法:
#   scripts/validate-release.sh
#
# 返回值:
#   0 — 全部通过
#   1 — 存在不一致

set -euo pipefail

errors=0
repo_root="$(cd "$(dirname "$0")/.." && pwd)"
release_file="$repo_root/RELEASE.json"

echo "=== 发版前校验 ==="

# ------------------------------------------------------------------
# 检查 1: RELEASE.json 是否存在
# ------------------------------------------------------------------
if [ ! -f "$release_file" ]; then
  echo "⚠️  跳过 RELEASE.json 校验（文件不存在）"
else
  echo ""
  echo "--- 检查 1: RELEASE.json vs HEADER 版本号一致性 ---"
  while IFS=':' read -r file_path release_version; do
    file_path="${file_path#\"}"
    file_path="${file_path%\"}"
    release_version="${release_version#\"}"
    release_version="${release_version%\",}"

    # 从 guide/ 目录定位实际文件
    md_file="$repo_root/$file_path"
    if [ ! -f "$md_file" ]; then
      echo "❌ 文件不存在（RELEASE.json 记录）: $file_path"
      errors=$((errors + 1))
      continue
    fi

    # 提取 HEADER 版本号
    header_version=$(grep -oP '(?<=\*\*当前版本\*\*：)v[\d.]+' "$md_file" || true)
    if [ -z "$header_version" ]; then
      echo "❌ 未找到版本号: $file_path"
      errors=$((errors + 1))
      continue
    fi

    if [ "$header_version" != "$release_version" ]; then
      echo "❌ 版本不一致: $file_path  RELEASE.json=$release_version  HEADER=$header_version"
      errors=$((errors + 1))
    else
      echo "✅ $file_path  RELEASE.json=$release_version  HEADER=$header_version"
    fi
  done < <(python3 -c "
import json, sys
with open('$release_file') as f:
    data = json.load(f)
for path, ver in data.get('files', {}).items():
    print(f'{path}:{ver}')
")
fi

# ------------------------------------------------------------------
# 检查 2: 所有 guide/*.md 是否有来源元信息
# ------------------------------------------------------------------
echo ""
echo "--- 检查 2: 来源元信息完整性 ---"
for md_file in "$repo_root"/guide/*.md; do
  filename=$(basename "$md_file")

  if grep -q '\*\*来源仓库\*\*' "$md_file"; then
    echo "✅ $filename — 来源仓库 ✓"
  else
    echo "❌ $filename — 缺少「来源仓库」"
    errors=$((errors + 1))
  fi

  if grep -q '\*\*源文件路径\*\*' "$md_file"; then
    echo "✅ $filename — 源文件路径 ✓"
  else
    echo "❌ $filename — 缺少「源文件路径」"
    errors=$((errors + 1))
  fi
done

# ------------------------------------------------------------------
# 汇总
# ------------------------------------------------------------------
echo ""
if [ "$errors" -eq 0 ]; then
  echo "🎉 全部通过，可以发版！"
else
  echo "❌ 发现 $errors 个错误，请修复后重试。"
fi

exit "$errors"
