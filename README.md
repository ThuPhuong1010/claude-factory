# Claude Factory

> AI-powered SDLC template — build Next.js apps with Claude Code as your engineering co-pilot.

Claude Factory là một project template được thiết kế để tối ưu hóa workflow khi dùng **Claude Code** để build ứng dụng web. Thay vì gõ lệnh tự do, bạn có một hệ thống có cấu trúc: commands, skills, rules, memory, tracking — giúp Claude làm việc nhất quán và hiệu quả hơn qua từng session.

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Next.js 15 (App Router) |
| UI | Ant Design 5.x |
| Language | TypeScript (strict) |
| State | Zustand + TanStack Query |
| Forms | Ant Design Form + Zod validation |
| Testing | Jest + React Testing Library |
| Linting | ESLint + Prettier |

---

## Quick Start

```bash
# 1. Clone & install
git clone https://github.com/<your-username>/claude-factory
cd claude-factory
npm install

# 2. Chạy dev server
npm run dev

# 3. Mở Claude Code
claude

# 4. Bắt đầu với idea của bạn
> /variants   # Test nhiều approach trước khi chọn
> /analyze    # Phân tích idea → tạo PRD + tasks
> /build      # Build từng task
> /review     # Review code
> /test       # Chạy tests
> /handoff    # Kết thúc session, bàn giao cho session sau
```

---

## Project Structure

```
claude-factory/
├── .claude/
│   ├── commands/          # Slash commands (/analyze, /build, /variants, ...)
│   ├── rules/             # Auto-load rules theo file type
│   └── skills/            # Domain knowledge (ant-design, nextjs, testing, ...)
├── context/               # Shared context cho Claude mỗi session
│   ├── input.md           # Ý tưởng / yêu cầu của bạn
│   ├── prd.md             # Product Requirements Document (generated)
│   ├── tasks.md           # Task list (generated + updated)
│   └── decisions.md       # Decisions Claude tự đưa ra
├── docs/
│   └── rules/             # Quy tắc chi tiết (design, security, architecture, ...)
├── memory/                # Persistent learning across sessions
│   ├── bugs.md            # Bug patterns + fixes
│   ├── errors.md          # Error patterns
│   └── patterns.md        # Good patterns found
├── tracklog/              # Session tracking
│   ├── active.md          # Trạng thái hiện tại
│   └── handoff.md         # Bàn giao giữa sessions
├── variants/              # Idea variant testing
│   ├── current.md         # Variant đang được chọn
│   └── comparison.md      # Bảng so sánh (generated)
├── templates/             # PRD, task templates
├── project/               # Code output (Next.js app)
│   └── src/
│       ├── app/           # Next.js App Router pages
│       ├── components/    # Shared components
│       ├── hooks/         # Custom hooks
│       ├── lib/           # Utilities
│       ├── services/      # API services
│       ├── stores/        # Zustand stores
│       └── types/         # TypeScript types
├── CLAUDE.md              # Main instructions cho Claude (auto-loaded)
└── AGENTS.md              # Cross-tool agent rules
```

---

## Commands

| Command | Mô tả |
|---------|-------|
| `/variants` | Test 2-3 approaches khác nhau cho cùng idea |
| `/analyze` | Phân tích idea → tạo PRD, tasks, architecture |
| `/plan` | Lập kế hoạch chi tiết cho task |
| `/build` | Build task tiếp theo trong tasks.md |
| `/review` | Code review tất cả changed files |
| `/test` | Chạy tests + báo cáo coverage |
| `/fix` | Fix bug đang gặp phải |
| `/status` | Xem trạng thái hiện tại của project |
| `/handoff` | Kết thúc session, tạo handoff note |
| `/sync` | Sync context files với code hiện tại |
| `/deploy-check` | Kiểm tra trước khi deploy |

---

## Workflow

### Bắt đầu project mới

```
1. Viết idea vào context/input.md
2. Chạy /variants → chọn approach
3. Chạy /analyze → Claude tạo PRD + tasks
4. Chạy /build → Claude build từng task
5. Mỗi task xong: /review → /test → commit
6. Cuối session: /handoff
```

### Session tiếp theo

```
1. Claude tự đọc: CLAUDE.md + tracklog/active.md + context/tasks.md
2. Tìm task TODO tiếp theo
3. Đọc memory/bugs.md để tránh lỗi cũ
4. Tiếp tục build
```

### Decision Making

- Sau khi plan approved: Claude **tự quyết định**, không hỏi lại
- Không chắc → chọn option phổ biến nhất, log vào `context/decisions.md`
- Cần external service → RAISE vào `docs/reports/integration-needs.md`
- Bug không fix được sau 3 lần → log `[NEEDS_HUMAN]`, chuyển task tiếp

---

## Rules (Auto-loaded)

Claude Code tự động load rules theo context:

| File | Trigger |
|------|---------|
| `.claude/rules/ts.md` | `*.ts` files |
| `.claude/rules/tsx-components.md` | `*.tsx` files |
| `.claude/rules/api-routes.md` | `src/app/api/` files |
| `.claude/rules/test-files.md` | `*.test.*` files |
| `.claude/rules/design.md` | UI component files |

---

## Skills

Domain knowledge được lazy-load khi cần:

| Skill | Trigger |
|-------|---------|
| `ant-design` | React components, forms, tables, layout |
| `nextjs-app-router` | Pages, layouts, API routes |
| `api-design` | API endpoints, REST patterns |
| `database` | Schema design, models |
| `error-handling` | Async code, API calls |
| `security` | Auth, input handling |
| `testing` | Tests, debugging |

---

## Design System

**Ant Design 5.x** là design system duy nhất. Không dùng MUI, Chakra, hay custom components.

Key rules:
- Mọi page phải có: **loading** (Skeleton) + **empty** (Empty) + **error** (Result) states
- Colors dùng Ant Design tokens qua `ConfigProvider` — không hardcode hex
- Responsive với Ant Grid `<Row gutter><Col xs={24} md={12}>`
- Dark mode qua Ant Design algorithm switch

---

## Memory System

Claude tự học qua từng session:

```
memory/bugs.md      # Bug đã gặp + cách fix → tránh lặp lại
memory/errors.md    # Error patterns
memory/patterns.md  # Good patterns được phát hiện
```

Claude **đọc memory trước khi code** mỗi session.

---

## MCP Integration

MCP servers không được setup mặc định (tốn context tokens). Chỉ add khi cần:

```bash
claude mcp add figma                              # Figma designs
claude mcp add --transport http github <url>     # GitHub integration
claude mcp add playwright                         # Browser testing
```

Xem `docs/rules/mcp.md` để biết thêm chi tiết.

---

## Token Budget

| Component | Tokens |
|-----------|--------|
| CLAUDE.md (always loaded) | ~1,500 |
| Skill metadata (7 skills) | ~350 |
| **Baseline per session** | **~1,850** |
| + context/tasks.md | ~500 |
| + tracklog/active.md | ~300 |
| + memory/bugs.md | ~200 |
| + 1 skill SKILL.md | ~800 |
| **Total per task** | **~3,850** |

So với load-all approach (~15,000+ tokens), tiết kiệm ~75%.

---

## Scripts

```bash
npm run dev       # Next.js dev server
npm run build     # Production build
npm test          # Jest tests
npm run lint      # ESLint
```

---

## Contributing

1. Fork repo
2. Tạo branch: `git checkout -b feature/your-feature`
3. Commit: `type(scope): description`
4. Push + tạo PR

---

## License

MIT
