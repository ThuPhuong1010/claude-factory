# Changelog — Claude Factory Template

Ghi lại mọi thay đổi của **template** theo thời gian.
Format: `[vX.Y.Z] YYYY-MM-DD — mô tả ngắn`

---

## [v0.5.0] 2026-03-29 — Advanced structure gaps: presets, dependency check, upgrade path

### Added
- **5 new presets** (CLAUDE.md now maps all 10 solution types):
  - `api-service.md` — REST API, Microservice, Webhook (response format, versioning, rate limit)
  - `desktop-app.md` — Electron/Tauri (IPC security, main/renderer separation, auto-updater)
  - `mobile-app.md` — React Native/Expo (SafeAreaView, platform differences, EAS build)
  - `script-bot.md` — Telegram/Discord/Slack bot, scheduled job (idempotency, process manager)
  - `process-docs.md` — SOP/Runbook/System design (document quality rules, SOP/Runbook format)
- `templates/architecture.md` — template cho context/architecture.md (Mermaid diagram, component breakdown, data flow)
- `/upgrade` command (#16) — sync template improvements vào project đang dùng, safe merge strategy

### Improved
- `/build`: thêm dependency blocking check (skip task nếu dependency chưa DONE)
- `/build`: thêm memory update trigger sau mỗi task (patterns.md, errors.md)
- `/review`: Design Checklist → solution-type-aware (Web/Desktop/Mobile/CLI/API/Bot/Automation/Extension)
- `/research`: thêm caching mechanism — save vào docs/reports/research-{slug}.md, reuse nếu < 30 ngày
- `/analyze` PHASE 3: dùng templates/architecture.md khi tạo context/architecture.md
- `CLAUDE.md`: cập nhật preset mapping đầy đủ 10 solution types
- `AGENTS.md`: xóa broken reference đến file đã bị xóa (run-parallel-test.sh)
- `README.md`: 15→16 commands, token budget cập nhật (~4,500/task), project structure cập nhật

---

## [v0.4.0] 2026-03-29 — Proactive solution recommendation + real-time research

### Added
- `/research` command (command #15) — research real-time: tools, pricing, best practices
  - WebSearch tự động với 3-5 queries bao phủ landscape + pricing + gotchas
  - Output: options table, per-option detail, recommendation by use case, sources
  - Suggest next steps sau research (compare deeper / generate setup guide / /analyze)

### Improved
- `/analyze` PHASE 2: thêm Solution Spectrum (Level 0-4) evaluation trước khi propose
  - Level 0: Existing SaaS/tool | Level 1: Configure/integrate | Level 2: No-code
  - Level 3: Light script | Level 4: Full custom build
  - WebSearch verify tools + pricing trước khi recommend
  - Không mặc định Level 4. Recommend level thấp nhất giải quyết được
  - Solution template có thêm: Level, Chi phí ước tính
- `/variants`: thêm no-code/low-code dimension bắt buộc xem xét
  - Approach template có thêm: Build level, Chi phí ước tính
  - WebSearch landscape trước khi brainstorm
  - Bảng so sánh có thêm: Build level, Chi phí

---

## [v0.3.0] 2026-03-29 — Report generation skills

### Added
- `report-generation` skill — pipeline tổng hợp: data → chart → docx/pdf/pptx
  - Python (python-docx + Matplotlib + Mermaid API) + Node (Puppeteer + Chart.js)
  - Cleanup temp files, naming convention, Mermaid via API không cần install

### Improved
- `data-visualization` — rewrite hoàn toàn: pivot sang Mermaid + Matplotlib + Plotly
  - Mermaid diagrams (flowchart, sequence, ER, Gantt) + export CLI + API
  - Matplotlib data charts export PNG cho nhúng vào document
  - Recharts giữ lại cho web UI use case
- `document-generation` — thêm Phân tích, Design flow, Common Mistakes
- `presentations` — thêm Phân tích, python-pptx chart embed, Marp với Mermaid

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
