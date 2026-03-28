# AGENTS.md — Cross-Tool Context

Nhiều agent có thể làm việc song song trên cùng project. File này định nghĩa cơ chế phối hợp.

---

## TRƯỚC KHI LÀM GÌ — ĐỌC THEO THỨ TỰ NÀY:
1. `tracklog/active.md` → ai đang làm gì, file nào đang bị lock
2. `tracklog/handoff.md` → agent trước bàn giao gì
3. `context/tasks.md` → task list + status
4. `context/techstack.md` → tech stack của project
5. `memory/bugs.md` → tránh lỗi đã biết

## TRƯỚC KHI DỪNG — GHI LẠI:
1. Xóa lock trong `tracklog/active.md` (LOCKED FILES section)
2. Update task status trong `context/tasks.md`
3. Bug mới → `memory/bugs.md`
4. Commit local (KHÔNG push — chờ user confirm)

---

## FILE OWNERSHIP — Zone mặc định cho Web App

Mỗi project có thể override trong `context/techstack.md`.

| Zone | Owner | Files |
|------|-------|-------|
| **Backend** | Claude Code | `src/app/api/**`, `src/services/**`, `src/lib/**`, `*.test.*`, scripts |
| **Frontend** | Antigravity | `src/components/**`, `src/app/(routes)/**`, `src/styles/**` |
| **Shared** | Cả hai — cần sync | `src/types/**`, `src/stores/**`, `src/hooks/**` |
| **Config** | Ai cần thì edit — check lock trước | `*.config.*`, `.env.*`, `package.json` |

**Nguyên tắc cứng:**
- KHÔNG edit file ngoài zone của mình khi không có handoff
- Shared files: ghi `tracklog/active.md` trước khi edit, xóa sau khi commit
- Config files: check `LOCKED FILES` trong `active.md` trước khi edit

---

## LOCK MECHANISM — tracklog/active.md

Khi bắt đầu edit file shared/config, ghi vào section `LOCKED FILES`:

```
## LOCKED FILES
- src/types/user.ts → Claude Code (2026-03-29 08:30)
- package.json → Antigravity (2026-03-29 08:35)
```

Nếu file bạn cần đã bị lock → **DỪNG**. Làm task khác, hoặc đợi lock được xóa.
Sau khi commit → xóa dòng lock của mình.

---

## BRANCH STRATEGY — Cho features phức tạp

Khi task cần cả 2 agents edit chung zone:

```bash
# Claude tạo branch riêng
git checkout -b agent/claude/feature-name

# Antigravity tạo branch riêng
git checkout -b agent/antigravity/feature-name

# Merge vào main sau khi xong
git checkout main
git merge agent/claude/feature-name
git merge agent/antigravity/feature-name
```

---

## CONFLICT RESOLUTION

Nếu git conflict xảy ra:
1. **Đừng force resolve** — báo user
2. Kiểm tra `tracklog/active.md` xem ai đang edit gì
3. Giữ thay đổi của cả 2 nếu có thể (merge manual)
4. Nếu không resolve được → log `[NEEDS_HUMAN]` trong `tracklog/active.md`

---

## COMMIT FORMAT

```
type(agent/scope): description

Examples:
feat(claude/api): add user authentication endpoint
feat(antigravity/ui): add login form component
fix(claude/db): fix connection pool leak
```

---

## TEST PARALLEL WORK

Xem `docs/testing/parallel-work-test.md` để chạy test scenario chứng minh parallel work hoạt động.
