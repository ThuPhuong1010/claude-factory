# Changelog — Claude Factory Template

Ghi lại mọi thay đổi của **template** theo thời gian.
Format: `[vX.Y.Z] YYYY-MM-DD — mô tả ngắn`

---

## [v0.2.0] 2026-03-29 — Skills rewrite + multi-user gaps

### Added
- `docs/guides/quickstart-nontech.md` — hướng dẫn 5 bước cho người không biết code
- `docs/rules/git-branching.md` — branching strategy: solo vs parallel mode
- `templates/how-to-run.md` — template Claude điền sau /analyze
- `templates/.env.example` — env variable template mẫu
- `docs/testing/test-scenarios.md` — skeleton cho Tier 3-4 testing
- `context/techstack.md` — file bị thiếu nhưng được reference khắp nơi
- `memory/archive/` — folder cho memory rotation

### Improved
- **7 skills rewritten** với đầy đủ Phân tích + Design sections:
  `database`, `nextjs-app-router`, `api-design`, `ant-design`,
  `error-handling`, `security`, `testing`
- `docs/rules/security.md` — thêm bypassPermissions warning + threat model
- `docs/rules/universal.md` — thêm Environment, Dependencies, Memory Rotation sections
- `docs/rules/presets/web.md` — thêm Database Migration section
- `CLAUDE.md` — thêm rule precedence + ai-app preset + git-branching reference
- `context/input.md` — thêm 6 guided fields thay vì blank comment
- `context/tasks.md` — thêm cột DoD + status transition comment
- `.claude/commands/analyze.md` — thêm ETHICAL CHECK + how-to-run generation
- `.claude/commands/build.md` — thêm checkpoint mechanism + self-review trước commit
- `.claude/commands/handoff.md` — thêm PRE-HANDOFF VERIFY checklist
- `README.md` — rewrite hoàn toàn: 12 solution types, 14 commands, multi-agent, token budget
- `.gitignore` — tạo mới (không tồn tại trước)

---

## [v0.1.0] 2026-03-01 — MVP

### Added
- 14 commands: analyze, build, test, review, fix, handoff, push, status, sync, deploy-check, plan, variants, discover, worktree
- 33 skills (lazy-loaded): covering Frontend, Backend, AI/LLM, Infra, Dev, Automation domains
- Multi-agent support via git worktree (Claude + Antigravity)
- 4-tier testing strategy
- Memory system: bugs.md, errors.md, patterns.md
- CLAUDE.md + AGENTS.md core instructions
- context/, tracklog/, templates/, docs/ structure
