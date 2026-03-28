# Claude Factory

> Từ ý tưởng → solution hoàn chỉnh — với Claude Code làm engineering co-pilot.

Claude Factory là project template giúp bạn build **bất kỳ loại software nào** một cách có cấu trúc. Không bị lock vào tech stack cụ thể — Claude phân tích ý tưởng, chọn stack phù hợp, tự build và test. Bạn chỉ cần mô tả vấn đề muốn giải quyết.

---

## Có thể build gì?

| Solution Type | Ví dụ cụ thể |
|--------------|-------------|
| **Web App / SaaS** | Dashboard, admin panel, landing page, CRM |
| **AI / LLM App** | Chatbot, AI writing tool, document Q&A, image analyzer |
| **CLI Tool** | File processor, code generator, dev utility, data converter |
| **Automation / Workflow** | n8n flow, scheduled bot, integration pipeline, email automation |
| **API / Service** | REST API, webhook handler, microservice, scraper |
| **Script / Bot** | Telegram bot, data processor, report generator |
| **VSCode Extension** | Snippet tool, code reviewer, sidebar widget |
| **Browser Extension** | Page modifier, productivity tool, content injector |
| **Desktop App** | Electron app, system tray tool, file manager |
| **Mobile App** | React Native app, Expo project |
| **Process / Docs** | SOP, runbook, system design, technical documentation |
| **Bất cứ thứ gì khác** | Claude tự định nghĩa approach phù hợp |

---

## Quick Start

```bash
# 1. Clone template
git clone https://github.com/ThuPhuong1010/claude-factory
cd claude-factory

# 2. Mở Claude Code
claude

# 3. Viết idea vào context/input.md
# 4. Bắt đầu
> /analyze      # Phân tích idea → propose solutions → tạo PRD + tasks
> /build        # Build từng task tự động, không hỏi lại
> /test         # Test theo loại solution
> /handoff      # Kết thúc session, bàn giao cho session sau
```

> **Không biết code?** Xem [`docs/guides/quickstart-nontech.md`](docs/guides/quickstart-nontech.md) — hướng dẫn 5 bước bằng ngôn ngữ đơn giản.

---

## Workflow

```
context/input.md  (mô tả ý tưởng)
       ↓
  /variants  → so sánh 2-3 approaches khác nhau
       ↓
  /analyze   → DISCOVER → PROPOSE solutions → GENERATE plan + PRD + tasks
       ↓
  /build     → autonomous loop: code → test → fix → commit (không hỏi lại)
       ↓
  /test      → 4-tier testing phù hợp với solution type
       ↓
  /review    → code review + design checklist
       ↓
  /handoff   → verify clean state → bàn giao cho session tiếp
```

**Sau khi plan approved:** Claude tự quyết định mọi thứ — không hỏi lại.
- Uncertain? → Chọn option phổ biến, log vào `context/decisions.md`
- Cần external service? → RAISE vào `docs/reports/integration-needs.md`
- Bug không fix được sau 3 lần? → Log `[NEEDS_HUMAN]`, chuyển task tiếp

---

## Commands (14)

| Command | Mô tả |
|---------|-------|
| `/variants` | So sánh 2-3 approaches trước khi chọn hướng đi |
| `/analyze` | Phân tích idea → propose solutions → tạo PRD + tasks + how-to-run |
| `/plan` | Lập kế hoạch chi tiết cho task tiếp theo |
| `/build` | Build tự động — không hỏi lại, self-review trước mỗi commit |
| `/test` | Test theo tier phù hợp với solution type |
| `/review` | Code review + design checklist |
| `/fix` | Fix bug (max 3 attempts → log NEEDS_HUMAN) |
| `/status` | Xem trạng thái session hiện tại |
| `/handoff` | Kết thúc session — verify clean state + tạo handoff note |
| `/sync` | Sync context files với code hiện tại |
| `/deploy-check` | Pre-deployment checklist |
| `/push` | Kiểm tra commits chưa push → push sau khi confirm |
| `/discover` | Làm rõ ý tưởng mơ hồ qua câu hỏi có cấu trúc |
| `/worktree` | Parallel mode: setup/sync/merge/teardown worktree cho 2 agents |

> **Tip:** Hỏi thẳng trong chat để Claude giải thích: *"Tại sao mày chọn cách này?"*, *"Giải thích đoạn code này cho tao hiểu"* — Claude trả lời bằng tiếng Việt.

---

## Testing — 4 Tiers

| Tier | Khi nào | Cách test |
|------|---------|----------|
| **1** | Code có thể chạy tự động | Jest / pytest / go test — coverage > 70% |
| **2** | Cần môi trường đặc biệt | Unit tests + manual checklist |
| **3** | Không chạy trực tiếp (workflow, n8n) | Test scenarios + dry-run guide |
| **4** | Documentation / process | Review checklist + walkthrough |

---

## Skills (36 — lazy-loaded)

Chỉ load khi cần, tiết kiệm context. Mỗi skill = domain knowledge pack:

| Nhóm | Skills |
|------|--------|
| **Frontend** | `ant-design`, `nextjs-app-router`, `state-management`, `i18n` |
| **Backend** | `api-design`, `database`, `orm`, `auth`, `real-time`, `search` |
| **AI/LLM** | `llm-integration` |
| **Infrastructure** | `docker`, `ci-cd`, `monitoring`, `file-storage` |
| **Payments & Comms** | `payment`, `email` |
| **Solution-specific** | `browser-extension`, `vscode-extension`, `desktop-app`, `mobile-app` |
| **Data** | `spreadsheet`, `document-generation`, `data-visualization`, `presentations` |
| **Dev** | `error-handling`, `security`, `testing`, `python-scripting` |
| **Automation** | `workflow-automation`, `cron-scheduler` |
| **Utilities** | `context-ingestion` (PDF, docx, audio → context) |

---

## Memory System

Claude tự học qua từng session — không lặp lại lỗi cũ:

```
memory/bugs.md       # Bug đã gặp → root cause + fix + prevention
memory/errors.md     # Error patterns (Wrong vs Right)
memory/patterns.md   # Good patterns được validate
memory/archive/      # Bugs cũ đã fix > 2 versions (rotation)
```

Claude **đọc memory trước khi code** mỗi session. Sau 20+ entries → auto-archive entries cũ.

---

## Multi-Agent Support

Hỗ trợ 2 AI agents làm việc song song trên cùng repo (Claude + Antigravity):

```bash
/worktree setup      # Tạo worktree riêng cho agent thứ 2
/worktree sync       # Xem diff giữa 2 agents
/worktree merge      # Merge work của 2 agents
/worktree teardown   # Kết thúc parallel mode
```

- File ownership zones rõ ràng (Backend / Frontend / Shared)
- Lock mechanism tránh conflict
- Auto-detect signal cần parallel mode khi session start

---

## Project Structure

```
claude-factory/
├── .claude/
│   ├── commands/        # 14 commands (analyze, build, test, worktree...)
│   ├── rules/           # Auto-load theo file type (ts, tsx, api, test...)
│   └── skills/          # 36 domain knowledge packs (lazy-loaded)
├── context/             # Shared context mỗi session
│   ├── input.md         # ← VIẾT Ý TƯỞNG VÀO ĐÂY
│   ├── techstack.md     # Generated: Stack + testing tier
│   ├── tasks.md         # Generated: Task list + DoD
│   ├── prd.md           # Generated: Product Requirements
│   ├── architecture.md  # Generated: Cấu trúc + diagram
│   └── decisions.md     # ADR: decisions Claude tự đưa ra
├── docs/
│   ├── guides/
│   │   ├── quickstart-nontech.md  # ← Bắt đầu đây nếu không biết code
│   │   └── how-to-run.md          # Generated: Hướng dẫn dùng output
│   ├── rules/
│   │   ├── universal.md           # Rules áp dụng mọi solution
│   │   ├── git-branching.md       # Branching strategy
│   │   ├── security.md            # Security + bypassPermissions warning
│   │   └── presets/               # Rules theo solution type
│   │       ├── web.md             # Next.js + DB migration
│   │       ├── ai-app.md          # LLM app + cost control + prompt safety
│   │       ├── cli.md
│   │       ├── automation.md
│   │       └── extension.md
│   ├── testing/
│   │   └── test-scenarios.md      # Template cho Tier 3-4 testing
│   └── reports/                   # integration-needs, qa-report
├── memory/              # Persistent learning (cross-session)
├── tracklog/            # Session state + handoff notes
├── templates/           # PRD, how-to-run, .env.example, setup-github
├── variants/            # Approach variant comparison
├── versions/            # Version history
├── .gitignore           # Covers Node, Python, mobile, extension artifacts
├── CLAUDE.md            # Auto-loaded instructions cho Claude
└── AGENTS.md            # Multi-agent coordination rules
```

---

## Token Budget

| Component | ~Tokens |
|-----------|---------|
| CLAUDE.md | ~1,500 |
| Skills metadata | ~500 |
| context/tasks.md | ~500 |
| tracklog/active.md | ~300 |
| memory/bugs.md | ~200 |
| 1 skill SKILL.md | ~800 |
| **Total per task** | **~3,800** |

So với load-all 36 skills (~20,000+ tokens): **tiết kiệm ~80%** nhờ lazy-loading.

---

## MCP Integration

Không setup mặc định — chỉ add khi cần (mỗi server tốn ~100-200 tokens):

```bash
claude mcp add figma                              # Figma designs
claude mcp add --transport http github <url>      # GitHub issues/PR
claude mcp add playwright                          # Browser testing
claude mcp add postgres                            # Query database
```

RAISE trong `docs/reports/integration-needs.md` trước khi add. Xem `docs/rules/mcp.md`.

---

## Setup

**Không biết code →** [`docs/guides/quickstart-nontech.md`](docs/guides/quickstart-nontech.md)

**Windows setup (GitHub CLI, hooks) →** [`templates/setup-github.md`](templates/setup-github.md)

> ⚠️ `.claude/settings.json` dùng `bypassPermissions` — chỉ dùng local, **không commit/share** file này khi distribute template. Đổi `defaultMode` thành `"default"` trước. Xem [`docs/rules/security.md`](docs/rules/security.md).

---

## License

MIT
