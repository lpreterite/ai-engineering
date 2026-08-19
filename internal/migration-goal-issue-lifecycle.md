# Migration: goal-issue-lifecycle Dual-Phase Process

> 2026-08-19
> This document records the breaking changes introduced by the `goal-issue-lifecycle` skill and
> provides migration paths for downstream projects.

## Deprecated & Removed

### Removed Issue Templates (4 files)

| File | Replacement |
|------|-------------|
| `4-decision.yml` | Decision records → **Goal Issue comment** (see `comment-protocol.md`) |
| `5-question.yml` | Open questions → **Goal Issue body `Dependencies/Open Questions`** field |
| `6-risk.yml` | Risks → **treated as dependencies or scope items** |
| `7-review.yml` | Review results → **Goal Issue comment** (see `comment-protocol.md`) |

**Migration**: If you have existing Decision/Question/Risk/Review Issues, close them and
copy the structured summary into the relevant Goal Issue's comments.

### Removed Skills (3 directories)

| Skill | Replacement |
|-------|-------------|
| `issue-lifecycle` | `goal-issue-lifecycle` — unified dual-phase lifecycle |
| `stage-gate` | `goal-issue-lifecycle` — gate review is now PO-driven (see §6 of landing plan) |
| `decision-record` | `goal-issue-lifecycle` — decisions are recorded as Goal Issue comments |

**Migration**: If your AGENTS.md or agents/*.md reference these skills, update them to
reference `goal-issue-lifecycle` instead.

## Changed

### AGENTS.md

The "打磨阶段 Issue 创建指令" section has been rewritten as "Goal Issue 生命周期指令":
- Decision Issue creation → Goal Issue comment recording
- Human-led dialogue pattern (identify → ask → confirm → execute → report)

### agents/*.md

Role definitions now reference `goal-issue-lifecycle` instead of the removed skills.

## New

| Item | Location |
|------|----------|
| `0-goal.yml` | `.github/ISSUE_TEMPLATE/0-goal.yml` |
| `goal-issue-lifecycle` skill | `skills/goal-issue-lifecycle/` |
| `.gitignore` entry | `.ai-engineering/` |

## Working-State Directories

The dual-phase process introduces two working-state directories under `.ai-engineering/`:
- `.ai-engineering/drafts/` — draft output isolation (not committed)
- `.ai-engineering/gate/` — gate/audit file bridge (not committed)

Both are covered by the `.gitignore` entry. No action required for downstream projects.