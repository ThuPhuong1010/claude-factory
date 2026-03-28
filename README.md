# Claude Factory

> Hiện thực hóa bất kỳ ý tưởng nào — với Claude Code làm engineering co-pilot.

Claude Factory là một project template giúp bạn đi từ ý tưởng đến solution hoàn chỉnh một cách có cấu trúc. **Không giới hạn tech stack hay loại output** — web app, CLI tool, automation workflow, extension, script, process design, hay bất cứ thứ gì. Claude sẽ chọn stack phù hợp với idea, không phải ngược lại.

---

## Có thể build gì?

| Solution Type | Ví dụ |
|--------------|-------|
| Web App | SaaS dashboard, admin panel, landing page |
| CLI Tool | File processor, code generator, dev utility |
| Automation / Workflow | n8n flow, scheduled bot, integration pipeline |
| VSCode Extension | Snippet tool, code reviewer, sidebar widget |
| Browser Extension | Page modifier, productivity tool, scraper |
| API / Service | REST API, webhook handler, microservice |
| Script / Bot | Telegram bot, data processor, scraper |
| Process Design | SOP, runbook, system design document |
| Desktop App | Electron app, system tray tool |
| *Bất cứ thứ gì khác* | Claude tự định nghĩa approach phù hợp |

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
> /variants     # Test 2-3 approaches khác nhau → chọn hướng đi
> /analyze      # Claude phân tích → chọn stack → tạo PRD + tasks
> /build        # Build từng task tự động
> /test         # Test theo loại solution
> /handoff      # Kết thúc session, bàn giao cho session sau
```

> **Không biết code?** Xem `docs/guides/quickstart-nontech.md` — hướng dẫn từng bước bằng ngôn ngữ đơn giản, không cần kiến thức kỹ thuật.

---

## Workflow

```
context/input.md (ý tưởng của bạn)
        ↓
   /variants → chọn approach
        ↓
   /analyze → xác định solution type → chọn stack → tạo tasks
        ↓
   /build → build từng task (tự động, không hỏi lại)
        ↓
   /test → test theo tier (automated / manual / scenarios)
        ↓
   /review → code review
        ↓
   /handoff → bàn giao cho session tiếp
```

### Decision Making
- Sau khi plan approved: Claude **tự quyết định mọi thứ**, không hỏi lại
- Không chắc → chọn option phổ biến, log vào `context/decisions.md`
- Cần external service → RAISE vào `docs/reports/integration-needs.md`
- Bug không fix được sau 3 lần → log `[NEEDS_HUMAN]`, chuyển task tiếp

---

## Testing — Mọi Loại Solution

Template hỗ trợ 4 tier testing để cover mọi loại output:

| Tier | Khi nào | Approach |
|------|---------|----------|
| **1** | Code chạy được, test tự động | Jest, pytest, go test... coverage > 70% |
| **2** | Cần môi trường đặc biệt (extension, desktop) | Unit tests + manual checklist |
| **3** | Không chạy trực tiếp (workflow, automation) | Test scenarios + dry-run guide |
| **4** | Documentation / process | Review checklist + walkthrough |

Xem `docs/rules/testing-strategy.md` để biết chi tiết.

---

## Project Structure

```
claude-factory/
├── .claude/
│   ├── commands/       # /analyze /build /test /variants /review ...
│   ├── rules/          # Auto-load rules theo file type
│   └── skills/         # Domain knowledge (lazy-loaded)
├── context/            # Shared context mỗi session
│   ├── input.md        # ← VIẾT Ý TƯỞNG VÀO ĐÂY
│   ├── prd.md          # Generated: Product Requirements
│   ├── techstack.md    # Generated: Stack + test tier
│   ├── tasks.md        # Generated: Task list + DoD
│   └── decisions.md    # Decisions Claude tự đưa ra
├── docs/
│   ├── guides/
│   │   ├── quickstart-nontech.md  # ← Bắt đầu tại đây nếu không biết code
│   │   └── how-to-run.md          # Generated: Hướng dẫn dùng output
│   ├── rules/
│   │   ├── universal.md        # Rules áp dụng mọi solution
│   │   ├── git-branching.md    # Branching strategy
│   │   ├── presets/            # Rules theo solution type
│   │   │   ├── web.md          # Next.js + DB migration
│   │   │   ├── cli.md
│   │   │   ├── automation.md
│   │   │   └── extension.md
│   │   └── testing-strategy.md # Testing tiers guide
│   ├── solution-types.md       # Catalog các loại solution
│   └── reports/                # integration-needs, qa-report
├── memory/             # Persistent learning
│   ├── bugs.md         # Bug patterns + fixes
│   ├── errors.md       # Error patterns
│   ├── patterns.md     # Good patterns
│   └── archive/        # Bugs đã fix > 2 versions (rotation)
├── tracklog/           # Session tracking
│   ├── active.md       # Trạng thái hiện tại
│   └── handoff.md      # Bàn giao giữa sessions
├── variants/           # Idea variant testing
├── templates/          # PRD, how-to-run, .env, setup guides
│   ├── prd.md
│   ├── how-to-run.md   # Template cho docs/guides/how-to-run.md
│   ├── .env.example    # Environment variables template
│   └── setup-github.md # Windows GitHub setup guide
├── versions/           # Version history
├── CLAUDE.md           # Instructions cho Claude (auto-loaded)
└── AGENTS.md           # Cross-agent rules
```

---

## Commands

| Command | Mô tả |
|---------|-------|
| `/variants` | Test 2-3 approaches khác nhau trước khi chọn hướng đi |
| `/analyze` | Phân tích idea → chọn stack → tạo PRD + tasks |
| `/plan` | Lập kế hoạch chi tiết cho task tiếp theo |
| `/build` | Build tự động — không hỏi lại, tự quyết định |
| `/test` | Test theo tier phù hợp với solution type |
| `/review` | Code review tất cả changed files |
| `/fix` | Fix bug (max 3 attempts, sau đó log NEEDS_HUMAN) |
| `/status` | Xem trạng thái hiện tại |
| `/handoff` | Kết thúc session + tạo handoff note |
| `/sync` | Sync context files với code hiện tại |
| `/deploy-check` | Checklist trước khi deploy |
| `/worktree` | Quản lý parallel mode — setup/sync/merge/teardown worktree cho 2 agents |

> **Tip:** Không cần command đặc biệt để hỏi Claude giải thích. Hỏi thẳng trong chat: *"Giải thích đoạn code này làm gì?"* hoặc *"Tại sao mày chọn cách này?"* — Claude sẽ giải thích bằng tiếng Việt đơn giản.

---

## Memory System

Claude tự học qua từng session — không lặp lại lỗi cũ:

```
memory/bugs.md      # Bug đã gặp + root cause + fix
memory/errors.md    # Error patterns
memory/patterns.md  # Good patterns được phát hiện
```

Claude **đọc memory trước khi code** mỗi session.

---

## Skills (Lazy-loaded)

Chỉ load khi cần, tiết kiệm context tokens:

| Skill | Load khi |
|-------|---------|
| `ant-design` | Viết React components, forms, tables |
| `nextjs-app-router` | Pages, layouts, API routes |
| `api-design` | API endpoints, REST patterns |
| `database` | Schema design, models |
| `error-handling` | Async code, API calls |
| `security` | Auth, input handling |
| `testing` | Tests, debugging |

---

## MCP Integration

Không setup mặc định — chỉ add khi cần (tốn context tokens):

```bash
claude mcp add figma                              # Figma designs
claude mcp add --transport http github <url>     # GitHub issues/PR
claude mcp add playwright                         # Browser testing
```

Xem `docs/rules/mcp.md` để biết chi tiết + quy trình RAISE.

---

## Token Budget

| Component | ~Tokens |
|-----------|---------|
| CLAUDE.md | ~1,200 |
| Skills metadata | ~350 |
| context/tasks.md | ~500 |
| tracklog/active.md | ~300 |
| memory/bugs.md | ~200 |
| 1 skill SKILL.md | ~800 |
| **Total per task** | **~3,350** |

So với load-all (~15,000+ tokens): **tiết kiệm ~78%**.

---

## Setup mới từ đầu

**Không biết code → bắt đầu tại:** `docs/guides/quickstart-nontech.md`

**Có kiến thức IT → Windows setup:** `templates/setup-github.md`
- Cài GitHub CLI trên Windows
- PowerShell syntax (`&` operator)
- Fix PATH trong Git Bash
- `bypassPermissions` config
- Windows notification hook

> ⚠️ `.claude/settings.json` dùng `bypassPermissions` — chỉ dùng local, không share file này.
> Khi distribute template: đổi `defaultMode` thành `"default"` trước. Xem `docs/rules/security.md`.

---

## License

MIT
