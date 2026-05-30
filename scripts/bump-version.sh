#!/usr/bin/env bash
# bump-version.sh — 版本号管理与同步
#
# 用法:
#   scripts/bump-version.sh <file> <version>          # 更新单个文件版本号
#   scripts/bump-version.sh --sync                    # 全量扫描 -> 同步 RELEASE.json
#
# --sync 模式:
#   1. 读取 RELEASE.json 的 files 列表
#   2. 逐一读取各文件的当前实际版本号
#   3. 用实际版本号覆盖更新 RELEASE.json
#   4. 更新时间戳

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
RELEASE_FILE="$REPO_ROOT/RELEASE.json"

# ─── 模式 1：逐文件手动 bump（原有行为）────────────────────
if [ $# -eq 0 ] || [ "$1" != "--sync" ]; then
  if [ $# -eq 0 ]; then
    echo "用法: $0 <file> <version> [<file> <version> ...]"
    echo "      $0 --sync"
    exit 1
  fi
  if [ $# -eq 0 ] || [ $(( $# % 2 )) -ne 0 ]; then
    echo "用法: $0 <file> <version> [<file> <version> ...]"
    echo "      $0 --sync"
    exit 1
  fi

  while [ $# -ge 2 ]; do
    file="$1"
    new_version="$2"
    shift 2
    file="$REPO_ROOT/$file"
    if [ ! -f "$file" ]; then
      echo "❌ 文件不存在: $file"
      exit 1
    fi
    current=$(grep -o '\*\*当前版本\*\*：v[0-9.]*' "$file" | head -1 | sed 's/\*\*当前版本\*\*：//' || true)
    if [ -z "$current" ]; then
      echo "❌ 未找到版本号字段: $file"
      exit 1
    fi
    escaped_current=$(printf '%s\n' "$current" | sed 's/[.[\*^$()+?{|]/\\&/g')
    if [[ "$OSTYPE" == "darwin"* ]]; then
      sed -i '' "s/\*\*当前版本\*\*：$escaped_current/**当前版本**：$new_version/" "$file"
    else
      sed -i "s/\*\*当前版本\*\*：$escaped_current/**当前版本**：$new_version/" "$file"
    fi
    echo "✅ $(basename "$file"): $current → $new_version"
  done
  exit 0
fi

# ─── 模式 2：--sync 全量扫描 ─────────────────────────────
echo "=== bump-version.sh --sync ==="

if [ ! -f "$RELEASE_FILE" ]; then
  echo "❌ RELEASE.json 不存在"
  exit 1
fi

# 读取 files 列表
files=$(python3 -c "
import json
with open('$RELEASE_FILE') as f:
    data = json.load(f)
for path in data.get('files', {}).keys():
    print(path)
")

updated=0
unchanged=0
skipped=0
errors=0

# 从 YAML frontmatter 提取 version（纯文本，不依赖 yaml 模块）
extract_yaml_version() {
  local f="$1"
  local version=""
  in_frontmatter=false
  while IFS= read -r line; do
    if [ "$line" = "---" ]; then
      if [ "$in_frontmatter" = true ]; then
        break
      fi
      in_frontmatter=true
      continue
    fi
    if [ "$in_frontmatter" = true ]; then
      case "$line" in
        "version: "*)
          version="${line#version: }"
          # 去掉引号
          version="${version#\"}"
          version="${version%\"}"
          version="${version#\'}"
          version="${version%\'}"
          echo "$version"
          return 0
          ;;
      esac
    fi
  done < "$f"
  return 1
}

# 从 Markdown HEADER 提取版本号
extract_md_header_version() {
  grep -m1 '\*\*当前版本\*\*：v[0-9.]*' "$1" 2>/dev/null | sed 's/\*\*当前版本\*\*：//' || true
}

# 判断文件是否含 YAML frontmatter
has_yaml_frontmatter() {
  head -1 "$1" 2>/dev/null | grep -q '^---$'
}

# 判断文件是否含 Markdown HEADER 版本号
has_md_header() {
  grep -q '\*\*当前版本\*\*：v[0-9.]*' "$1" 2>/dev/null
}

# 暂存新的 files 数据
tmpfile=$(mktemp /tmp/bump-version.XXXXXX)
RELEASE_JSON="$RELEASE_FILE" TMPFILE="$tmpfile" python3 -c "
import json, os
with open(os.environ['RELEASE_JSON']) as f:
    data = json.load(f)
with open(os.environ['TMPFILE'], 'w') as f:
    json.dump(data, f)
"

while IFS= read -r file_path; do
  [ -z "$file_path" ] && continue
  abs_path="$REPO_ROOT/$file_path"
  recorded_version=$(FILE_PATH="$file_path" TMPFILE="$tmpfile" python3 -c "
import json, os
with open(os.environ['TMPFILE']) as f:
    data = json.load(f)
print(data['files'].get(os.environ['FILE_PATH'], 'unknown'))
")

  # 文件不存在
  if [ ! -f "$abs_path" ]; then
    echo "⚠️  文件不存在: $file_path"
    errors=$((errors + 1))
    continue
  fi

  actual_version=""

  # 提取实际版本号
  if has_yaml_frontmatter "$abs_path"; then
    actual_version=$(extract_yaml_version "$abs_path" 2>/dev/null || true)
  fi

  if [ -z "$actual_version" ] && has_md_header "$abs_path"; then
    actual_version=$(extract_md_header_version "$abs_path")
  fi

  # 无版本标记的文件（.yml, .sh, .example 等）
  if [ -z "$actual_version" ]; then
    # 保持 RELEASE.json 中的记录不变
    echo "   ⏭️  $file_path → $recorded_version（无版本标记，保持记录）"
    skipped=$((skipped + 1))
    continue
  fi

  # 比对
  if [ "$actual_version" != "$recorded_version" ]; then
    FILE_PATH="$file_path" ACTUAL_VER="$actual_version" TMPFILE="$tmpfile" python3 -c "
import json, os
with open(os.environ['TMPFILE']) as f:
    data = json.load(f)
data['files'][os.environ['FILE_PATH']] = os.environ['ACTUAL_VER']
with open(os.environ['TMPFILE'], 'w') as f:
    json.dump(data, f)
"
    echo "   🔄 $file_path: $recorded_version → $actual_version"
    updated=$((updated + 1))
  else
    echo "   ✅ $file_path: $actual_version（一致）"
    unchanged=$((unchanged + 1))
  fi
done <<< "$files"

# 更新时间戳
TMPFILE="$tmpfile" python3 -c "
import json, os
from datetime import datetime, timezone
with open(os.environ['TMPFILE']) as f:
    data = json.load(f)
data['released_at'] = datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ')
with open(os.environ['TMPFILE'], 'w') as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
print('✅ 时间戳已更新')
"

# 写回 RELEASE.json
cp "$tmpfile" "$RELEASE_FILE"
rm -f "$tmpfile"

echo ""
echo "=== 汇总 ==="
echo "   已更新: $updated"
echo "   一致:   $unchanged"
echo "   跳过:   $skipped"
echo "   错误:   $errors"
echo ""

if [ "$errors" -gt 0 ]; then
  echo "⚠️  存在 $errors 个错误，请处理"
  exit 1
fi
echo "✅ RELEASE.json 已同步"
