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
  echo "--- 检查 1: RELEASE.json vs HEADER 版本号一致性（仅 Markdown HEADER 文件）---"
  while IFS=':' read -r file_path release_version; do
    file_path="${file_path#\"}"
    file_path="${file_path%\"}"
    release_version="${release_version#\"}"
    release_version="${release_version%\",}"

    # 跳过非 Markdown HEADER 版本管理的文件
    case "$file_path" in
      skills/*|reference/templates/*.example|reference/templates/*.yml|scripts/*.sh)
        continue ;;
    esac

    md_file="$repo_root/$file_path"
    if [ ! -f "$md_file" ]; then
      echo "❌ 文件不存在（RELEASE.json 记录）: $file_path"
      errors=$((errors + 1))
      continue
    fi

    header_version=$(grep -o '\*\*当前版本\*\*：v[0-9.]*' "$md_file" | head -1 | sed 's/\*\*当前版本\*\*：//' || true)
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
# 检查 3: RELEASE.json vs skills/*/SKILL.md version 一致性
# ------------------------------------------------------------------
echo ""
echo "--- 检查 3: Skill 版本一致性 ---"
if [ ! -f "$release_file" ]; then
  echo "⚠️  跳过（RELEASE.json 不存在）"
else
  while IFS= read -r file_path; do
    [ -z "$file_path" ] && continue
    case "$file_path" in
      skills/*/SKILL.md) ;;
      *) continue ;;
    esac
    release_ver=$(python3 -c "
import json
with open('$release_file') as f:
    data = json.load(f)
print(data['files'].get('$file_path', ''))
")
    md_file="$repo_root/$file_path"
    if [ ! -f "$md_file" ]; then
      echo "❌ 文件不存在: $file_path"
      errors=$((errors + 1))
      continue
    fi
    actual_ver=$(python3 -c "
with open('$md_file') as f:
    content = f.read()
parts = content.split('---', 2)
if len(parts) >= 3:
    for line in parts[1].split('\n'):
        line = line.strip()
        if line.startswith('version:'):
            v = line.split(':', 1)[1].strip().strip('\"').strip(\"'\")
            print(v)
            break
")
    if [ -z "$actual_ver" ]; then
      echo "❌ 未找到 version 字段: $file_path"
      errors=$((errors + 1))
      continue
    fi
    if [ "$actual_ver" != "$release_ver" ]; then
      echo "❌ 版本不一致: $file_path  RELEASE.json=$release_ver  SKILL.md=$actual_ver"
      errors=$((errors + 1))
    else
      echo "✅ $file_path  $release_ver"
    fi
  done < <(python3 -c "
import json
with open('$release_file') as f:
    data = json.load(f)
for path in data.get('files', {}).keys():
    print(path)
")
fi

# ------------------------------------------------------------------
# 检查 4: skills/*/SKILL.md 字段完整性
# ------------------------------------------------------------------
echo ""
echo "--- 检查 4: Skill frontmatter 完整性 ---"
missing_version=0
for skill_file in "$repo_root"/skills/*/SKILL.md; do
  [ -f "$skill_file" ] || continue
  name=$(basename "$(dirname "$skill_file")")
  has_name=false
  has_version=false
  has_desc=false
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
        "name: "*) has_name=true ;;
        "version: "*) has_version=true ;;
        "description: "*) has_desc=true ;;
      esac
    fi
  done < "$skill_file"
  missing=""
  $has_name   || missing="$missing name"
  $has_version || missing="$missing version"
  $has_desc   || missing="$missing description"
  if [ -n "$missing" ]; then
    echo "❌ $name — 缺少字段:$missing"
    errors=$((errors + 1))
    missing_version=$((missing_version + 1))
  else
    echo "✅ $name — name + version + description ✓"
  fi
done
if [ "$missing_version" -eq 0 ]; then
  echo "   所有 Skill frontmatter 完整 ✓"
fi

# ------------------------------------------------------------------
# 检查 5: RELEASE.json 中所有 files 物理存在
# ------------------------------------------------------------------
echo ""
echo "--- 检查 5: RELEASE.json 文件完整性 ---"
if [ ! -f "$release_file" ]; then
  echo "⚠️  跳过（RELEASE.json 不存在）"
else
  not_found=0
  while IFS= read -r file_path; do
    [ -z "$file_path" ] && continue
    abs_path="$repo_root/$file_path"
    if [ ! -f "$abs_path" ]; then
      echo "❌ 文件不存在: $file_path"
      errors=$((errors + 1))
      not_found=$((not_found + 1))
    fi
  done < <(python3 -c "
import json
with open('$release_file') as f:
    data = json.load(f)
for path in data.get('files', {}).keys():
    print(path)
")
  if [ "$not_found" -eq 0 ]; then
    echo "   所有文件存在 ✓"
  fi
fi

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
