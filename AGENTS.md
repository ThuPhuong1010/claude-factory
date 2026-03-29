# AGENTS.md — Cross-Tool Context

---

## CHECK MODE TRƯỚC KHI LÀM GÌ

Đọc `tracklog/active.md` → tìm dòng `PARALLEL MODE`:

```
PARALLEL MODE: OFF  → single agent, workflow bình thường
PARALLEL MODE: ON   → 2 agents đang chạy, đọc phần Multi-Agent bên dưới
```

---

## SINGLE AGENT MODE (mặc định)

Không cần làm gì đặc biệt. Workflow bình thường:

1. `tracklog/active.md` → trạng thái hiện tại
2. `tracklog/handoff.md` → agent trước bàn giao gì (nếu có)
3. `context/tasks.md` → task list
4. `context/techstack.md` → tech stack
5. `memory/bugs.md` → lỗi đã biết

**Trước khi dừng:**
1. Update `context/tasks.md` status
2. Bug mới → `memory/bugs.md`
3. Commit local (không tự push)

---

## MULTI-AGENT MODE (chỉ khi `PARALLEL MODE: ON`)

Kích hoạt khi user chạy `/worktree setup`. Tắt khi user chạy `/worktree teardown`.

### Worktree Layout

```
[project]/                  ← Claude Code làm ở đây (main branch)
[project]-antigravity/      ← Antigravity làm ở đây (agent/antigravity branch)
```

Cả hai thư mục dùng chung `.git` — commit của ai cũng visible cho agent kia.

### File Ownership Zones

Mỗi project override trong `context/techstack.md` nếu cần.

| Zone | Owner | Paths |
|------|-------|-------|
| Backend / Logic | Claude Code | `src/app/api/**`, `src/services/**`, `src/lib/**`, `*.test.*`, scripts |
| Frontend / UI | Antigravity | `src/components/**`, `src/app/(pages)/**`, `src/styles/**` |
| Shared | Cả hai — lock trước khi edit | `src/types/**`, `src/stores/**`, `src/hooks/**` |
| Config | Cả hai — lock trước khi edit | `*.config.*`, `package.json`, `.env.*` |

**Nguyên tắc:**
- Chỉ edit file trong zone của mình
- Shared/Config: ghi lock vào `tracklog/active.md` trước, xóa sau khi commit
- Đọc lock list trước khi edit bất kỳ shared file nào

### Lock Mechanism

```markdown
## LOCKED FILES          ← section trong tracklog/active.md
- src/types/user.ts → Claude Code (2026-03-29 08:30)
- package.json → Antigravity (2026-03-29 08:35)
```

File đang bị lock → **làm task khác, không edit**.

### Sync & Merge

```
/worktree sync    → xem diff giữa 2 branches (không merge)
/worktree merge   → merge antigravity → main (hỏi confirm trước)
```

### Commit Format (multi-agent)

```
feat(claude/api): add authentication
feat(antigravity/ui): add login form
fix(claude/db): fix connection pool
```

### Conflict Resolution

1. Không force resolve — báo user
2. Check `tracklog/active.md` xem ai đang edit gì
3. Merge manual nếu có thể giữ cả 2 thay đổi
4. Không resolve được → log `[NEEDS_HUMAN]`

---

## CÁC COMMANDS LIÊN QUAN

| Command | Khi nào dùng |
|---------|-------------|
| `/worktree setup` | Bật parallel mode, tạo worktree cho Antigravity |
| `/worktree sync` | Xem diff hiện tại giữa 2 agents |
| `/worktree merge` | Merge và đóng feature |
| `/worktree teardown` | Tắt parallel mode, xóa worktree |

